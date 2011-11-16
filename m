Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1KPU2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 15:28:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52070 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab1KPU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 15:28:09 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Brian Norris <computersforpeace@gmail.com>, <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kevin Cernekee <cernekee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [PATCH] ahci: platform support for suspend/resume
Date: Wed, 16 Nov 2011 12:27:59 -0800
Message-Id: <1321475279-29930-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform hooks for custom suspend() and resume() functions. The
generic suspend/resume code in drivers/ata/ahci_platform.c is adapted
from the PCI version in drivers/ata/ahci.c.

Note that in order to suspend, we require that both suspend() and
resume() functions be supplied.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
Based on:
    git://github.com/jgarzik/libata-dev.git ALL

 drivers/ata/ahci_platform.c   |   72 +++++++++++++++++++++++++++++++++++++++++
 include/linux/ahci_platform.h |    2 +
 2 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index ec55595..98bf5e9 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -202,6 +202,75 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int ahci_suspend(struct device *dev)
+{
+	struct ahci_platform_data *pdata = dev_get_platdata(dev);
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl;
+	int rc;
+
+	/* Does platform support suspend/resume? */
+	if (!pdata->suspend || !pdata->resume)
+		return -EINVAL;
+
+	if (hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
+		dev_err(dev, "firmware update required for suspend/resume\n");
+		return -EIO;
+	}
+
+	/*
+	 * AHCI spec rev1.1 section 8.3.3:
+	 * Software must disable interrupts prior to requesting a
+	 * transition of the HBA to D3 state.
+	 */
+	ctl = readl(mmio + HOST_CTL);
+	ctl &= ~HOST_IRQ_EN;
+	writel(ctl, mmio + HOST_CTL);
+	readl(mmio + HOST_CTL); /* flush */
+
+	rc = ata_host_suspend(host, PMSG_SUSPEND);
+	if (rc)
+		return rc;
+
+	return pdata->suspend(dev);
+}
+
+static int ahci_resume(struct device *dev)
+{
+	struct ahci_platform_data *pdata = dev->platform_data;
+	struct ata_host *host = dev_get_drvdata(dev);
+	int rc;
+
+	/* Does platform support suspend/resume? */
+	if (!pdata->resume)
+		return -EINVAL;
+
+	rc = pdata->resume(dev);
+	if (rc)
+		return rc;
+
+	if (dev->power.power_state.event == PM_EVENT_SUSPEND) {
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
+
+static struct dev_pm_ops ahci_pm_ops = {
+	.suspend		= &ahci_suspend,
+	.resume			= &ahci_resume,
+};
+#endif
+
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "calxeda,hb-ahci", },
 	{},
@@ -214,6 +283,9 @@ static struct platform_driver ahci_driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
 		.of_match_table = ahci_of_match,
+#ifdef CONFIG_PM
+		.pm = &ahci_pm_ops,
+#endif
 	},
 	.id_table	= ahci_devtype,
 };
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
index be3d9a7..73a2500 100644
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -23,6 +23,8 @@ struct ata_port_info;
 struct ahci_platform_data {
 	int (*init)(struct device *dev, void __iomem *addr);
 	void (*exit)(struct device *dev);
+	int (*suspend)(struct device *dev);
+	int (*resume)(struct device *dev);
 	const struct ata_port_info *ata_port_info;
 	unsigned int force_port_map;
 	unsigned int mask_port_map;
-- 
1.7.5.4

