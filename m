Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1GFIYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:24:10 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:54549 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1GFIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:24:07 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org,
        hans-christian.egtvedt@atmel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@avr32linux.org, balbi@ti.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH V4] MMC: PM: add suspend/resume in atmel-mci
Date: Wed,  6 Jul 2011 11:31:36 +0200
Message-Id: <1309944696-6415-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <4E11B57B.4040000@atmel.com>
References: <4E11B57B.4040000@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take care of slots while going to suspend state.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
V4: make CONFIG_PM logic work even if not selected
V3: take care of each slot SUSPENDED state
    (adding a status bit in the slot "flags")
V2: move to pm_ops


 drivers/mmc/host/atmel-mci.c |   63 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index aa8039f..fa8cae1 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -203,6 +203,7 @@ struct atmel_mci_slot {
 #define ATMCI_CARD_PRESENT	0
 #define ATMCI_CARD_NEED_INIT	1
 #define ATMCI_SHUTDOWN		2
+#define ATMCI_SUSPENDED		3
 
 	int			detect_pin;
 	int			wp_pin;
@@ -1878,10 +1879,72 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int atmci_suspend(struct device *dev)
+{
+	struct atmel_mci *host = dev_get_drvdata(dev);
+	int i;
+
+	 for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
+		struct atmel_mci_slot *slot = host->slot[i];
+		int ret;
+
+		if (!slot)
+			continue;
+		ret = mmc_suspend_host(slot->mmc);
+		if (ret < 0) {
+			while (--i >= 0) {
+				slot = host->slot[i];
+				if (slot
+				&& test_bit(ATMCI_SUSPENDED, &slot->flags)) {
+					mmc_resume_host(host->slot[i]->mmc);
+					clear_bit(ATMCI_SUSPENDED, &slot->flags);
+				}
+			}
+			return ret;
+		} else {
+			set_bit(ATMCI_SUSPENDED, &slot->flags);
+		}
+	}
+
+	return 0;
+}
+
+static int atmci_resume(struct device *dev)
+{
+	struct atmel_mci *host = dev_get_drvdata(dev);
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
+		struct atmel_mci_slot *slot = host->slot[i];
+		int err;
+
+		slot = host->slot[i];
+		if (!slot)
+			continue;
+		if (!test_bit(ATMCI_SUSPENDED, &slot->flags))
+			continue;
+		err = mmc_resume_host(slot->mmc);
+		if (err < 0)
+			ret = err;
+		else
+			clear_bit(ATMCI_SUSPENDED, &slot->flags);
+	}
+
+	return ret;
+}
+static SIMPLE_DEV_PM_OPS(atmci_pm, atmci_suspend, atmci_resume);
+#define ATMCI_PM_OPS	(&atmci_pm)
+#else
+#define ATMCI_PM_OPS	NULL
+#endif
+
 static struct platform_driver atmci_driver = {
 	.remove		= __exit_p(atmci_remove),
 	.driver		= {
 		.name		= "atmel_mci",
+		.pm		= ATMCI_PM_OPS,
 	},
 };
 
-- 
1.7.3

