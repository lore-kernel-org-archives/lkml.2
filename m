Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab1F2PwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:52:24 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:17703 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab1F2PwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:52:21 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org,
        hans-christian.egtvedt@atmel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@avr32linux.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 1/2] MMC: PM: add suspend/resume in atmel-mci
Date: Wed, 29 Jun 2011 18:54:19 +0200
Message-Id: <1ef60c032bc39531302c1603bfcb841d2d437ccc.1309366360.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take care of slots while going to suspend state.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mmc/host/atmel-mci.c |   51 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index aa8039f..c414ebe 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1878,8 +1878,59 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int atmci_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	struct atmel_mci *host = platform_get_drvdata(pdev);
+	struct atmel_mci_slot *slot;
+	int i, ret;
+
+	 for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
+		slot = host->slot[i];
+		if (!slot)
+			continue;
+		ret = mmc_suspend_host(slot->mmc);
+		if (ret < 0) {
+			while (--i >= 0) {
+				slot = host->slot[i];
+				if (slot)
+					mmc_resume_host(host->slot[i]->mmc);
+			}
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int atmci_resume(struct platform_device *pdev)
+{
+	struct atmel_mci *host = platform_get_drvdata(pdev);
+	struct atmel_mci_slot *slot;
+	int i, ret;
+
+	for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
+		slot = host->slot[i];
+		if (!slot)
+			continue;
+		ret = mmc_resume_host(slot->mmc);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+#else
+#define atmci_suspend	NULL
+#define atmci_resume	NULL
+#endif
+
+
+
 static struct platform_driver atmci_driver = {
 	.remove		= __exit_p(atmci_remove),
+	.suspend	= atmci_suspend,
+	.resume		= atmci_resume,
 	.driver		= {
 		.name		= "atmel_mci",
 	},
-- 
1.7.3

