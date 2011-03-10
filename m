Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1CJV64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:58:56 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:58660
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752858Ab1CJV6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:58:54 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 11/21] Staging: hv: Make vmbus driver a platform pci driver
Date: Thu, 10 Mar 2011 14:08:32 -0800
Message-Id: <1299794912-1233-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make vmbus driver a platform pci driver. This is
in preparation to cleaning up irq allocation for this
driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   63 +++++++++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 8b9394a..e4855ac 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -43,6 +43,8 @@
 
 static struct device *root_dev; /* Root device */
 
+struct pci_dev *hv_pci_dev;
+
 /* Main vmbus driver data structure */
 struct vmbus_driver_context {
 
@@ -887,36 +889,24 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	}
 }
 
-static struct dmi_system_id __initdata microsoft_hv_dmi_table[] = {
-	{
-		.ident = "Hyper-V",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
-			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
-		},
-	},
-	{ },
-};
-MODULE_DEVICE_TABLE(dmi, microsoft_hv_dmi_table);
 
-static int __init vmbus_init(void)
+
+static int __devinit hv_pci_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
 {
-	DPRINT_INFO(VMBUS_DRV,
-		"Vmbus initializing.... current log level 0x%x (%x,%x)",
-		vmbus_loglevel, HIWORD(vmbus_loglevel), LOWORD(vmbus_loglevel));
-	/* Todo: it is used for loglevel, to be ported to new kernel. */
+	int err;
 
-	if (!dmi_check_system(microsoft_hv_dmi_table))
-		return -ENODEV;
+	hv_pci_dev = pdev;
 
-	return vmbus_bus_init();
-}
+	err = pci_enable_device(pdev);
+	if (err)
+		return err;
 
-static void __exit vmbus_exit(void)
-{
-	vmbus_bus_exit();
-	/* Todo: it is used for loglevel, to be ported to new kernel. */
+	err = vmbus_bus_init();
+	if (err)
+		pci_disable_device(pdev);
+
+	return err;
 }
 
 /*
@@ -931,10 +921,29 @@ static const struct pci_device_id microsoft_hv_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, microsoft_hv_pci_table);
 
+static struct pci_driver platform_driver = {
+	.name =           "hv-platform-pci",
+	.probe =          hv_pci_probe,
+	.id_table =       microsoft_hv_pci_table,
+};
+
+static int __init hv_pci_init(void)
+{
+	return pci_register_driver(&platform_driver);
+}
+
+static void __exit hv_pci_exit(void)
+{
+	vmbus_bus_exit();
+	pci_unregister_driver(&platform_driver);
+}
+
+
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
 module_param(vmbus_irq, int, S_IRUGO);
 module_param(vmbus_loglevel, int, S_IRUGO);
 
-module_init(vmbus_init);
-module_exit(vmbus_exit);
+module_init(hv_pci_init);
+module_exit(hv_pci_exit);
-- 
1.5.5.6

