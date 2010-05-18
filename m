Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab0ERSrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:47:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34939 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab0ERSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:47:08 -0400
Date: Tue, 18 May 2010 11:46:53 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] Add support for Westmere to i7core_edac driver
Message-ID: <20100518184653.GA6511@lucy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Westmere to i7core_edac driver

This adds new PCI IDs for the Westmere's memory controller
devices and modifies the i7core_edac driver to be able to
probe both Nehalem and Westmere processors.

This applies to git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git linux_next

Signed-off-by: Vernon Mauery <vernux@us.ibm.com>


diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 3e2b537..a005f84 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -206,6 +206,11 @@ struct pci_id_descr {
   	int			optional;
   };

+struct pci_id_table {
+	struct pci_id_descr *descr;
+	int                  n_devs;
+};
+
   struct i7core_dev {
   	struct list_head	list;
   	u8			socket;
@@ -262,7 +267,7 @@ static DEFINE_MUTEX(i7core_edac_lock);
   	.func = (function),			\
   	.dev_id = (device_id)

-struct pci_id_descr pci_dev_descr_i7core[] = {
+struct pci_id_descr pci_dev_descr_i7core_nehalem[] = {
   		/* Memory controller */
   	{ PCI_DESCR(3, 0, PCI_DEVICE_ID_INTEL_I7_MCR)     },
   	{ PCI_DESCR(3, 1, PCI_DEVICE_ID_INTEL_I7_MC_TAD)  },
@@ -321,6 +326,44 @@ struct pci_id_descr pci_dev_descr_lynnfield[] = {
   	{ PCI_DESCR( 0, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE)     },
   };

+struct pci_id_descr pci_dev_descr_i7core_westmere[] = {
+		/* Memory controller */
+	{ PCI_DESCR(3, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_MCR_REV2)     },
+	{ PCI_DESCR(3, 1, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_TAD_REV2)  },
+			/* Exists only for RDIMM */
+	{ PCI_DESCR(3, 2, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_RAS_REV2), .optional = 1  },
+	{ PCI_DESCR(3, 4, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_TEST_REV2) },
+
+		/* Channel 0 */
+	{ PCI_DESCR(4, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH0_CTRL_REV2) },
+	{ PCI_DESCR(4, 1, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH0_ADDR_REV2) },
+	{ PCI_DESCR(4, 2, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH0_RANK_REV2) },
+	{ PCI_DESCR(4, 3, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH0_TC_REV2)   },
+
+		/* Channel 1 */
+	{ PCI_DESCR(5, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_CTRL_REV2) },
+	{ PCI_DESCR(5, 1, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_ADDR_REV2) },
+	{ PCI_DESCR(5, 2, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_RANK_REV2) },
+	{ PCI_DESCR(5, 3, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_TC_REV2)   },
+
+		/* Channel 2 */
+	{ PCI_DESCR(6, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_CTRL_REV2) },
+	{ PCI_DESCR(6, 1, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_ADDR_REV2) },
+	{ PCI_DESCR(6, 2, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_RANK_REV2) },
+	{ PCI_DESCR(6, 3, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_TC_REV2)   },
+
+		/* Generic Non-core registers */
+	{ PCI_DESCR(0, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_REV2)  },
+
+};
+
+#define PCI_ID_TABLE_ENTRY(A) { A, ARRAY_SIZE(A) }
+struct pci_id_table pci_dev_table[] = {
+	PCI_ID_TABLE_ENTRY(pci_dev_descr_i7core_nehalem),
+	PCI_ID_TABLE_ENTRY(pci_dev_descr_lynnfield),
+	PCI_ID_TABLE_ENTRY(pci_dev_descr_i7core_westmere),
+};
+
   /*
    *	pci_device_id	table for which devices we are looking for
    */
@@ -1170,7 +1213,7 @@ static void i7core_put_all_devices(void)
   		i7core_put_devices(i7core_dev);
   }

-static void __init i7core_xeon_pci_fixup(int dev_id)
+static void i7core_xeon_pci_fixup(struct pci_id_table *table)
   {
   	struct pci_dev *pdev = NULL;
   	int i;
@@ -1179,10 +1222,13 @@ static void __init i7core_xeon_pci_fixup(int dev_id)
   	 * aren't announced by acpi. So, we need to use a legacy scan probing
   	 * to detect them
   	 */
-	pdev = pci_get_device(PCI_VENDOR_ID_INTEL, dev_id, NULL);
-	if (unlikely(!pdev)) {
-		for (i = 0; i < MAX_SOCKET_BUSES; i++)
-			pcibios_scan_specific_bus(255-i);
+	while (table && table->descr) {
+		pdev = pci_get_device(PCI_VENDOR_ID_INTEL, table->descr[0].dev_id, NULL);
+		if (unlikely(!pdev)) {
+			for (i = 0; i < MAX_SOCKET_BUSES; i++)
+				pcibios_scan_specific_bus(255-i);
+		}
+		table++;
   	}
   }

@@ -1213,15 +1259,10 @@ int i7core_get_onedevice(struct pci_dev **prev, int devno,
   		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
   				      PCI_DEVICE_ID_INTEL_I7_NONCORE_ALT, *prev);

-	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE && !pdev) {
+	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE && !pdev)
   		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
   				      PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_ALT,
   				      *prev);
-		if (!pdev)
-			pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-					      PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_REV2,
-					      *prev);
-	}

   	if (!pdev) {
   		if (*prev) {
@@ -1232,6 +1273,9 @@ int i7core_get_onedevice(struct pci_dev **prev, int devno,
   		if (dev_descr->optional)
   			return 0;

+		if (devno == 0)
+			return -ENODEV;
+
   		i7core_printk(KERN_ERR,
   			"Device not found: dev %02x.%d PCI ID %04x:%04x\n",
   			dev_descr->dev, dev_descr->func,
@@ -1307,21 +1351,30 @@ int i7core_get_onedevice(struct pci_dev **prev, int devno,
   	return 0;
   }

-static int i7core_get_devices(struct pci_id_descr dev_descr[], unsigned n_devs)
+static int i7core_get_devices(struct pci_id_table *table)
   {
   	int i, rc;
   	struct pci_dev *pdev = NULL;
-
-	for (i = 0; i < n_devs; i++) {
-		pdev = NULL;
-		do {
-			rc = i7core_get_onedevice(&pdev, i, &dev_descr[i],
-						  n_devs);
-			if (rc < 0) {
-				i7core_put_all_devices();
-				return -ENODEV;
-			}
-		} while (pdev);
+	struct pci_id_descr *dev_descr;
+
+	while (table && table->descr) {
+		dev_descr = table->descr;
+		for (i = 0; i < table->n_devs; i++) {
+			pdev = NULL;
+			do {
+				rc = i7core_get_onedevice(&pdev, i, &dev_descr[i],
+							  table->n_devs);
+				if (rc < 0) {
+					if (i == 0) {
+						i = table->n_devs;
+						break;
+					}
+					i7core_put_all_devices();
+					return -ENODEV;
+				}
+			} while (pdev);
+		}
+		table++;
   	}

   	return 0;
@@ -1884,18 +1937,7 @@ static int __devinit i7core_probe(struct pci_dev *pdev,
   	/* get the pci devices we want to reserve for our use */
   	mutex_lock(&i7core_edac_lock);

-	if (pdev->device == PCI_DEVICE_ID_INTEL_LYNNFIELD_QPI_LINK0) {
-		printk(KERN_INFO "i7core_edac: detected a "
-				 "Lynnfield processor\n");
-		rc = i7core_get_devices(pci_dev_descr_lynnfield,
-					ARRAY_SIZE(pci_dev_descr_lynnfield));
-	} else {
-		printk(KERN_INFO "i7core_edac: detected a "
-				 "Nehalem/Nehalem-EP processor\n");
-		rc = i7core_get_devices(pci_dev_descr_i7core,
-					ARRAY_SIZE(pci_dev_descr_i7core));
-	}
-
+	rc = i7core_get_devices(pci_dev_table);
   	if (unlikely(rc < 0))
   		goto fail0;

@@ -1994,7 +2036,7 @@ static int __init i7core_init(void)
   	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
   	opstate_init();

-	i7core_xeon_pci_fixup(pci_dev_descr_i7core[0].dev_id);
+	i7core_xeon_pci_fixup(pci_dev_table);

   	pci_rc = pci_register_driver(&i7core_driver);

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 46d76e9..413fab7 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2567,6 +2567,22 @@
   #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_ADDR 0x2ca9
   #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_RANK 0x2caa
   #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_TC   0x2cab
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MCR_REV2          0x2d98
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_TAD_REV2       0x2d99
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_RAS_REV2       0x2d9a
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_TEST_REV2      0x2d9c
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH0_CTRL_REV2  0x2da0
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH0_ADDR_REV2  0x2da1
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH0_RANK_REV2  0x2da2
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH0_TC_REV2    0x2da3
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_CTRL_REV2  0x2da8
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_ADDR_REV2  0x2da9
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_RANK_REV2  0x2daa
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH1_TC_REV2    0x2dab
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_CTRL_REV2  0x2db0
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_ADDR_REV2  0x2db1
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_RANK_REV2  0x2db2
+#define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_TC_REV2    0x2db3
   #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
   #define PCI_DEVICE_ID_INTEL_IOAT_TBG4	0x3429
   #define PCI_DEVICE_ID_INTEL_IOAT_TBG5	0x342a

