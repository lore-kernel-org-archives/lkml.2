Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1HLIak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:30:40 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:59267 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1HLIac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:30:32 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Vijaya Kumar Kilari <vijay.kilari@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 20/23] mfd/db5500-prcmu: implement EPOD handling
Date: Fri, 12 Aug 2011 10:30:18 +0200
Message-ID: <1313137818-31246-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vijaya Kumar Kilari <vijay.kilari@stericsson.com>

This implements accessor functions for handling the EPOD,
i.e. voltage domain switches controlled by the DB5500
PRCMU, a prerequisite for implementing the voltage domain
regulators.

Signed-off-by: Vijaya Kumar Kilari <vijay.kilari@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db5500-prcmu.c       |   82 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/dbx500-prcmu.h |    2 +-
 2 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index 60bfda2..b7cd655 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -997,6 +997,88 @@ static void ack_dbb_wakeup(void)
 	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
 }
 
+int db5500_prcmu_set_epod(u16 epod, u8 epod_state)
+{
+	int r = 0;
+	bool ram_retention = false;
+
+	/* check argument */
+	BUG_ON(epod < DB5500_EPOD_ID_BASE);
+	BUG_ON(epod_state > EPOD_STATE_ON);
+	BUG_ON((epod - DB5500_EPOD_ID_BASE) >= DB5500_NUM_EPOD_ID);
+
+	if (epod == DB5500_EPOD_ID_ESRAM12)
+		ram_retention = true;
+
+	/* check argument */
+	BUG_ON(epod_state == EPOD_STATE_RAMRET && !ram_retention);
+
+	/* get lock */
+	mutex_lock(&mb2_transfer.lock);
+
+	/* wait for mailbox */
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(2))
+		cpu_relax();
+
+	/* Retention is allowed only for ESRAM12 */
+	if (epod  == DB5500_EPOD_ID_ESRAM12) {
+		switch (epod_state) {
+		case EPOD_STATE_ON:
+			mb2_transfer.req.epod_st[epod - DB5500_EPOD_ID_BASE] =
+				EPOD_OOR_ON;
+			break;
+		case EPOD_STATE_OFF:
+			mb2_transfer.req.epod_st[epod - DB5500_EPOD_ID_BASE] =
+				EPOD_OOR_OFF;
+			break;
+		case EPOD_STATE_RAMRET:
+			mb2_transfer.req.epod_st[epod - DB5500_EPOD_ID_BASE] =
+				EPOD_OOR_RET;
+			break;
+		default:
+			r = -EINVAL;
+			goto unlock_and_return;
+			break;
+		}
+	} else {
+		if (epod_state == EPOD_STATE_ON)
+			mb2_transfer.req.epod_st[epod - DB5500_EPOD_ID_BASE] =
+				EPOD_ON;
+		else if (epod_state == EPOD_STATE_OFF)
+			mb2_transfer.req.epod_st[epod - DB5500_EPOD_ID_BASE] =
+				EPOD_OFF;
+		else {
+			r = -EINVAL;
+			goto unlock_and_return;
+		}
+	}
+	/* fill in mailbox */
+	writeb((epod - DB5500_EPOD_ID_BASE), PRCM_REQ_MB2_EPOD_CLIENT);
+	writeb(mb2_transfer.req.epod_st[epod - DB5500_EPOD_ID_BASE],
+		PRCM_REQ_MB2_EPOD_STATE);
+
+	writeb(MB2H_EPOD_REQUEST, PRCM_REQ_MB2_HEADER);
+
+	writel(MBOX_BIT(2), PRCM_MBOX_CPU_SET);
+
+	if (!wait_for_completion_timeout(&mb2_transfer.work,
+		msecs_to_jiffies(500))) {
+		pr_err("prcmu: set_epod() failed.\n"
+			"prcmu: Please check your firmware version.\n");
+		r = -EIO;
+		WARN(1, "Failed to set epod");
+		goto unlock_and_return;
+	}
+
+	if (mb2_transfer.ack.status != RC_SUCCESS ||
+		mb2_transfer.ack.header != MB2H_EPOD_REQUEST)
+		r = -EIO;
+
+unlock_and_return:
+	mutex_unlock(&mb2_transfer.lock);
+	return r;
+}
+
 static inline void print_unknown_header_warning(u8 n, u8 header)
 {
 	pr_warning("prcmu: Unknown message header (%d) in mailbox %d.\n",
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index 78258c4..6c7584d 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -240,7 +240,7 @@ static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
 static inline int prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
 	if (machine_is_u5500())
-		return -EINVAL;
+		return db5500_prcmu_set_epod(epod_id, epod_state);
 	else
 		return db8500_prcmu_set_epod(epod_id, epod_state);
 }
-- 
1.7.3.2

