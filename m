Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1JaNGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 09:06:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56535 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab1JaNGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 09:06:38 -0400
Date: Mon, 31 Oct 2011 21:20:57 +0800
From: JiSheng Zhang <jszhang3@gmail.com>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, avorontsov@mvista.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/2] ahci_platform: add suspend & resume support
Message-ID: <20111031212057.155e9ecb@ustc>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: JiSheng Zhang <jszhang3@gmail.com>
---
 drivers/ata/ahci_platform.c |   52 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 45edba9..b8ffc02 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -202,11 +202,63 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int ahci_suspend(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl;
+
+	/* AHCI spec rev1.1 section 8.3.3:
+	 * Software must disable interrupts prior to requesting a
+	 * transition of the HBA to D3 state.
+	 */
+	ctl = readl(mmio + HOST_CTL);
+	ctl &= ~HOST_IRQ_EN;
+	writel(ctl, mmio + HOST_CTL);
+	readl(mmio + HOST_CTL); /* flush */
+
+	return ata_host_suspend(host, PMSG_SUSPEND);
+}
+
+static int ahci_resume(struct device *dev)
+{
+	struct ahci_platform_data *pdata = dev_get_platdata(dev);
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
+	rc = ahci_reset_controller(host);
+	if (rc)
+		return rc;
+
+	ahci_init_controller(host);
+	ata_host_resume(host);
+
+	return 0;
+}
+
+static const struct dev_pm_ops ahci_pm_ops = {
+	.suspend	= ahci_suspend,
+	.resume		= ahci_resume,
+};
+#endif
+
 static struct platform_driver ahci_driver = {
 	.remove = __devexit_p(ahci_remove),
 	.driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &ahci_pm_ops,
+#endif
 	},
 	.id_table	= ahci_devtype,
 };
-- 
1.7.6.3

