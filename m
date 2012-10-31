Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935765Ab2JaRrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:47:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759490Ab2JaRpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:45:32 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC EDAC/GHES 1/3] ghes: Be a good citzen with EDAC
Date: Wed, 31 Oct 2012 15:44:53 -0200
Message-Id: <e5c85a309f58b260c8ec0a2c6eff9a6d66b4c7e3.1351705248.git.mchehab@redhat.com>
In-Reply-To: <cover.1351705248.git.mchehab@redhat.com>
References: <cover.1351705248.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register itself at EDAC MC core, in order to avoid other
drivers to get it.

The edac core will warrant that just one driver will be used,
so the first one to register will be the one that will be
reporting the hardware errors.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/acpi/apei/Kconfig  |  1 +
 drivers/acpi/apei/Makefile |  2 ++
 drivers/acpi/apei/ghes.c   | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/edac.h       |  4 +++
 4 files changed, 84 insertions(+)

diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index f0c1ce9..a9c8088 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -12,6 +12,7 @@ config ACPI_APEI
 config ACPI_APEI_GHES
 	bool "APEI Generic Hardware Error Source"
 	depends on ACPI_APEI && X86
+	depends on !(EDAC_MM_EDAC=m)
 	select ACPI_HED
 	select IRQ_WORK
 	select GENERIC_ALLOCATOR
diff --git a/drivers/acpi/apei/Makefile b/drivers/acpi/apei/Makefile
index d1d1bc0..ee7d80f 100644
--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -4,3 +4,5 @@ obj-$(CONFIG_ACPI_APEI_EINJ)	+= einj.o
 obj-$(CONFIG_ACPI_APEI_ERST_DEBUG) += erst-dbg.o
 
 apei-y := apei-base.o hest.o cper.o erst.o
+
+ccflags-y += -I$(srctree)/drivers/edac
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 1599566..9466d36 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -48,6 +48,9 @@
 #include <linux/genalloc.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/edac.h>
+#include <edac_core.h>
+
 #include <acpi/apei.h>
 #include <acpi/hed.h>
 #include <asm/mce.h>
@@ -105,6 +108,8 @@ struct ghes {
 		struct timer_list timer;
 		unsigned int irq;
 	};
+
+	struct mem_ctl_info *mci;
 };
 
 struct ghes_estatus_node {
@@ -901,6 +906,71 @@ static unsigned long ghes_esource_prealloc_size(
 	return prealloc_size;
 }
 
+static int __devinit ghes_edac_register(struct ghes *ghes, struct device *dev)
+{
+#ifdef CONFIG_EDAC_MM_EDAC
+	int rc;
+	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[1];
+	struct csrow_info *csrow;
+	struct dimm_info *dimm;
+
+	layers[0].type = EDAC_MC_LAYER_ALL_MEM;
+	layers[0].size = 0;
+	layers[0].is_virt_csrow = true;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, 0);
+	if (!mci) {
+		pr_info(GHES_PFX "Can't allocate memory for EDAC data\n");
+		return -ENOMEM;
+	}
+
+	mci->pvt_info = ghes;
+	mci->pdev = dev;
+
+#if 0
+	mci->mtype_cap = MEM_FLAG_RDDR | MEM_FLAG_DDR;
+	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
+	mci->edac_cap = EDAC_FLAG_SECDED;
+	mci->mod_name = EDAC_MOD_STR;
+	mci->mod_ver = MV64x60_REVISION;
+	mci->ctl_name = mv64x60_ctl_name;
+#endif
+	csrow = mci->csrows[0];
+	dimm = csrow->channels[0]->dimm;
+
+	/* FIXME: FAKE DATA */
+	dimm->nr_pages = 1000;
+	dimm->grain = 128;
+	dimm->mtype = MEM_UNKNOWN;
+	dimm->dtype = DEV_UNKNOWN;
+	dimm->edac_mode = EDAC_SECDED;
+
+	rc = edac_mc_add_mc(mci, THIS_MODULE);
+	if (rc < 0) {
+		pr_info(GHES_PFX "Can't register at EDAC core\n");
+		edac_mc_free(mci);
+
+		return -ENODEV;
+	}
+
+	ghes->mci = mci;
+#endif
+	return 0;
+}
+
+static void __devexit ghes_edac_unregister(struct ghes *ghes)
+{
+	struct mem_ctl_info *mci = ghes->mci;
+
+#ifdef CONFIG_EDAC_MM_EDAC
+	if (!mci)
+		return;
+
+	edac_mc_del_mc(mci->pdev);
+	edac_mc_free(mci);
+#endif
+}
+
 static int __devinit ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
@@ -985,6 +1055,10 @@ static int __devinit ghes_probe(struct platform_device *ghes_dev)
 	}
 	platform_set_drvdata(ghes_dev, ghes);
 
+	rc = ghes_edac_register(ghes, &ghes_dev->dev);
+	if (rc < 0)
+		goto err;
+
 	return 0;
 err:
 	if (ghes) {
@@ -1038,6 +1112,9 @@ static int __devexit ghes_remove(struct platform_device *ghes_dev)
 	}
 
 	ghes_fini(ghes);
+
+	ghes_edac_unregister(ghes);
+
 	kfree(ghes);
 
 	platform_set_drvdata(ghes_dev, NULL);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index aeddb3f..1e9d19b 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -375,6 +375,9 @@ enum scrub_type {
  * @EDAC_MC_LAYER_CHANNEL:	memory layer is named "channel"
  * @EDAC_MC_LAYER_SLOT:		memory layer is named "slot"
  * @EDAC_MC_LAYER_CHIP_SELECT:	memory layer is named "chip select"
+ * @EDAC_MC_LAYER_UNKNOWN:	memory layout is unknown. All memory is mapped
+ *				as a single memory area. This is used when
+ *				retrieving errors from apei/ghes driver.
  *
  * This enum is used by the drivers to tell edac_mc_sysfs what name should
  * be used when describing a memory stick location.
@@ -384,6 +387,7 @@ enum edac_mc_layer_type {
 	EDAC_MC_LAYER_CHANNEL,
 	EDAC_MC_LAYER_SLOT,
 	EDAC_MC_LAYER_CHIP_SELECT,
+	EDAC_MC_LAYER_ALL_MEM,
 };
 
 /**
-- 
1.7.11.7

