Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1F3MnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:43:09 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:10412 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1F3MnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:43:04 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org,
        hans-christian.egtvedt@atmel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@avr32linux.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH V2] MMC: PM: add suspend/resume in atmel-mci
Date: Thu, 30 Jun 2011 15:49:41 +0200
Message-Id: <1309441781-11012-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <201106292339.12402.rjw@sisk.pl>
References: <201106292339.12402.rjw@sisk.pl>
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
V2: move to pm_ops

 drivers/mmc/host/atmel-mci.c |   47 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index aa8039f..058f1842 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1878,10 +1878,57 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int atmci_suspend(struct device *dev)
+{
+	struct atmel_mci *host = dev_get_drvdata(dev);
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
+static int atmci_resume(struct device *dev)
+{
+	struct atmel_mci *host = dev_get_drvdata(dev);
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
+#endif
+static SIMPLE_DEV_PM_OPS(atmci_pm, atmci_suspend, atmci_resume);
+
+
 static struct platform_driver atmci_driver = {
 	.remove		= __exit_p(atmci_remove),
 	.driver		= {
 		.name		= "atmel_mci",
+		.pm		= &atmci_pm,
 	},
 };
 
-- 
1.7.3

