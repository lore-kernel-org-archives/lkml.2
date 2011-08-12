Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1HLI2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:28:44 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:54302 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661Ab1HLI2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:28:39 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/23] mfd/db8500-prcmu: hwacc power state accessor
Date: Fri, 12 Aug 2011 10:28:25 +0200
Message-ID: <1313137705-30815-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

This implements the accessor function for hardware accelerator
power state settings.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |  126 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index af36999..28a6090 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1081,6 +1081,132 @@ static int request_pll(u8 clock, bool enable)
 }
 
 /**
+ * prcmu_set_hwacc - set the power state of a h/w accelerator
+ * @hwacc_dev: The hardware accelerator (enum hw_acc_dev).
+ * @state: The new power state (enum hw_acc_state).
+ *
+ * This function sets the power state of a hardware accelerator.
+ * This function should not be called from interrupt context.
+ *
+ * NOTE! Deprecated, to be removed when all users switched over to use the
+ * regulator framework API.
+ */
+int prcmu_set_hwacc(u16 hwacc_dev, u8 state)
+{
+	int r = 0;
+	bool ram_retention = false;
+	bool enable, enable_ret;
+
+	/* check argument */
+	BUG_ON(hwacc_dev >= NUM_HW_ACC);
+
+	/* get state of switches */
+	enable = hwacc_enabled[hwacc_dev];
+	enable_ret = hwacc_ret_enabled[hwacc_dev];
+
+	/* set flag if retention is possible */
+	switch (hwacc_dev) {
+	case HW_ACC_SVAMMDSP:
+	case HW_ACC_SIAMMDSP:
+	case HW_ACC_ESRAM1:
+	case HW_ACC_ESRAM2:
+	case HW_ACC_ESRAM3:
+	case HW_ACC_ESRAM4:
+		ram_retention = true;
+		break;
+	}
+
+	/* check argument */
+	BUG_ON(state > HW_ON);
+	BUG_ON(state == HW_OFF_RAMRET && !ram_retention);
+
+	/* modify enable flags */
+	switch (state) {
+	case HW_OFF:
+		enable_ret = false;
+		enable = false;
+		break;
+	case HW_ON:
+		enable = true;
+		break;
+	case HW_OFF_RAMRET:
+		enable_ret = true;
+		enable = false;
+		break;
+	}
+
+	/* get regulator (lazy) */
+	if (hwacc_regulator[hwacc_dev] == NULL) {
+		hwacc_regulator[hwacc_dev] = regulator_get(NULL,
+			hwacc_regulator_name[hwacc_dev]);
+		if (IS_ERR(hwacc_regulator[hwacc_dev])) {
+			pr_err("prcmu: failed to get supply %s\n",
+				hwacc_regulator_name[hwacc_dev]);
+			r = PTR_ERR(hwacc_regulator[hwacc_dev]);
+			goto out;
+		}
+	}
+
+	if (ram_retention) {
+		if (hwacc_ret_regulator[hwacc_dev] == NULL) {
+			hwacc_ret_regulator[hwacc_dev] = regulator_get(NULL,
+				hwacc_ret_regulator_name[hwacc_dev]);
+			if (IS_ERR(hwacc_ret_regulator[hwacc_dev])) {
+				pr_err("prcmu: failed to get supply %s\n",
+					hwacc_ret_regulator_name[hwacc_dev]);
+				r = PTR_ERR(hwacc_ret_regulator[hwacc_dev]);
+				goto out;
+			}
+		}
+	}
+
+	/* set regulators */
+	if (ram_retention) {
+		if (enable_ret && !hwacc_ret_enabled[hwacc_dev]) {
+			r = regulator_enable(hwacc_ret_regulator[hwacc_dev]);
+			if (r < 0) {
+				pr_err("prcmu_set_hwacc: ret enable failed\n");
+				goto out;
+			}
+			hwacc_ret_enabled[hwacc_dev] = true;
+		}
+	}
+
+	if (enable && !hwacc_enabled[hwacc_dev]) {
+		r = regulator_enable(hwacc_regulator[hwacc_dev]);
+		if (r < 0) {
+			pr_err("prcmu_set_hwacc: enable failed\n");
+			goto out;
+		}
+		hwacc_enabled[hwacc_dev] = true;
+	}
+
+	if (!enable && hwacc_enabled[hwacc_dev]) {
+		r = regulator_disable(hwacc_regulator[hwacc_dev]);
+		if (r < 0) {
+			pr_err("prcmu_set_hwacc: disable failed\n");
+			goto out;
+		}
+		hwacc_enabled[hwacc_dev] = false;
+	}
+
+	if (ram_retention) {
+		if (!enable_ret && hwacc_ret_enabled[hwacc_dev]) {
+			r = regulator_disable(hwacc_ret_regulator[hwacc_dev]);
+			if (r < 0) {
+				pr_err("prcmu_set_hwacc: ret disable failed\n");
+				goto out;
+			}
+			hwacc_ret_enabled[hwacc_dev] = false;
+		}
+	}
+
+out:
+	return r;
+}
+EXPORT_SYMBOL(prcmu_set_hwacc);
+
+/**
  * db8500_prcmu_set_epod - set the state of a EPOD (power domain)
  * @epod_id: The EPOD to set
  * @epod_state: The new EPOD state
-- 
1.7.3.2

