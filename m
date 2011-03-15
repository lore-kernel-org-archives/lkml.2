Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab1COVxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:53:54 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:51028
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758695Ab1COVxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:53:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 01/12] Staging: hv: Make vmbus driver a  pci driver
Date: Tue, 15 Mar 2011 15:03:32 -0700
Message-Id: <1300226624-27004-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1300226527-26933-1-git-send-email-kys@microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make vmbus driver a pci driver. This is
in preparation to cleaning up the root device
management as well as the  irq allocation for this
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
index b473f46..1ef2f0f 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -40,6 +40,8 @@
 #define VMBUS_IRQ		0x5
 #define VMBUS_IRQ_VECTOR	IRQ5_VECTOR
 
+struct pci_dev *hv_pci_dev;
+
 /* Main vmbus driver data structure */
 struct vmbus_driver_context {
 
@@ -977,36 +979,24 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
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
@@ -1021,10 +1011,29 @@ static const struct pci_device_id microsoft_hv_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, microsoft_hv_pci_table);
 
+static struct pci_driver hv_bus_driver = {
+	.name =           "hv_bus",
+	.probe =          hv_pci_probe,
+	.id_table =       microsoft_hv_pci_table,
+};
+
+static int __init hv_pci_init(void)
+{
+	return pci_register_driver(&hv_bus_driver);
+}
+
+static void __exit hv_pci_exit(void)
+{
+	vmbus_bus_exit();
+	pci_unregister_driver(&hv_bus_driver);
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

