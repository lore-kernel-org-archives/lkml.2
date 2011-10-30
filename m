Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab1J3GH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 02:07:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47056 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1J3GH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 02:07:26 -0400
Date: Sun, 30 Oct 2011 14:21:22 +0800
From: JiSheng Zhang <jszhang3@gmail.com>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ahci_platform: add suspend & resume support
Message-ID: <20111030142122.560216e2@ustc>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: JiSheng Zhang <jszhang3@gmail.com>
---
 drivers/ata/ahci_platform.c |   54 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index c03277d..60ff9eb 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -202,12 +202,66 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int ahci_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl;
+
+	if (mesg.event & PM_EVENT_SLEEP) {
+		/* AHCI spec rev1.1 section 8.3.3:
+		 * Software must disable interrupts prior to requesting a
+		 * transition of the HBA to D3 state.
+		 */
+		ctl = readl(mmio + HOST_CTL);
+		ctl &= ~HOST_IRQ_EN;
+		writel(ctl, mmio + HOST_CTL);
+		readl(mmio + HOST_CTL); /* flush */
+	}
+
+	return ata_host_suspend(host, mesg);
+}
+
+static int ahci_resume(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ahci_platform_data *pdata = dev->platform_data;
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	int rc;
+
+	if (pdata && pdata->init) {
+		rc = pdata->init(dev, hpriv->mmio);
+		if (rc)
+			return rc;
+	}
+
+	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
+		rc = ahci_reset_controller(host);
+		if (rc)
+			return rc;
+
+		ahci_init_controller(host);
+	}
+
+	ata_host_resume(host);
+
+	return 0;
+}
+#endif
+
 static struct platform_driver ahci_driver = {
 	.remove = __devexit_p(ahci_remove),
 	.driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
 	},
+#ifdef CONFIG_PM
+	.suspend = ahci_suspend,
+	.resume = ahci_resume,
+#endif
 	.id_table	= ahci_devtype,
 };
 
-- 
1.7.6.3

