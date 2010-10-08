Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab0JHRd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:33:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:53383 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200Ab0JHRdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:33:52 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [RFC PATCH 11/11] ppc: add dynamic dma window support
Date: Fri,  8 Oct 2010 10:33:12 -0700
Message-Id: <1286559192-10898-12-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
References: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If firmware allows us to map all of a partition's memory for DMA on a
particular bridge, create a 1:1 mapping of that memory. Add hooks for
dealing with hotplug events. Dyanmic DMA windows can use larger than the
default page size, and we use the largest one possible.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |  319 +++++++++++++++++++++++++++++++-
 1 files changed, 315 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 451d2d1..23ca0d1 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -33,6 +33,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/crash_dump.h>
+#include <linux/memory.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -45,6 +46,7 @@
 #include <asm/tce.h>
 #include <asm/ppc-pci.h>
 #include <asm/udbg.h>
+#include <asm/mmzone.h>
 
 #include "plpar_wrappers.h"
 
@@ -278,10 +280,19 @@ struct dynamic_dma_window_prop {
 	__be32	window_shift;	/* ilog2(tce_window_size) */
 };
 
+struct direct_window {
+	struct device_node *device;
+	const struct dynamic_dma_window_prop *prop;
+	struct list_head list;
+};
+static LIST_HEAD(direct_window_list);
+static DEFINE_SPINLOCK(direct_window_list_lock);
+#define DIRECT64_PROPNAME "linux,direct64-ddr-window-info"
+
 static int tce_clearrange_multi_pSeriesLP(unsigned long start_pfn,
-					unsigned long num_pfn, void *arg)
+					unsigned long num_pfn, const void *arg)
 {
-	struct dynamic_dma_window_prop *maprange = arg;
+	const struct dynamic_dma_window_prop *maprange = arg;
 	int rc;
 	u64 tce_size, num_tce, dma_offset;
 	u32 tce_shift;
@@ -305,9 +316,9 @@ static int tce_clearrange_multi_pSeriesLP(unsigned long start_pfn,
 }
 
 static int tce_setrange_multi_pSeriesLP(unsigned long start_pfn,
-					unsigned long num_pfn, void *arg)
+					unsigned long num_pfn, const void *arg)
 {
-	struct dynamic_dma_window_prop *maprange = arg;
+	const struct dynamic_dma_window_prop *maprange = arg;
 	u64 *tcep, tce_size, num_tce, dma_offset, next, proto_tce;
 	u32 tce_shift;
 	long rc = 0;
@@ -368,6 +379,12 @@ static int tce_setrange_multi_pSeriesLP(unsigned long start_pfn,
 	return rc;
 }
 
+static int tce_setrange_multi_pSeriesLP_walk(unsigned long start_pfn,
+					unsigned long num_pfn, void *arg)
+{
+	return tce_setrange_multi_pSeriesLP(start_pfn, num_pfn, arg);
+}
+
 #ifdef CONFIG_PCI
 static void iommu_table_setparms(struct pci_controller *phb,
 				 struct device_node *dn,
@@ -553,6 +570,246 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
 		       pci_name(dev));
 }
 
+/*
+ * If the PE supports dynamic dma windows, and there is space for a table
+ * that can map all pages in a linear offset, then setup such a table,
+ * and record the dma-offset in the struct device.
+ *
+ * dev: the pci device we are checking
+ * pdn: the parent pe node with the ibm,dma_window property
+ * Future: also check if we can remap the base window for our base page size
+ */
+static void check_ddr_windowLP(struct pci_dev *dev, struct device_node *pdn)
+{
+	int len, ret;
+	u32 query[4], create[3], cfg_addr;
+	int page_shift;
+	u64 dma_addr, buid, max_addr;
+	struct pci_dn *pcidn;
+	const u32 *uninitialized_var(ddr_avail);
+	struct direct_window *window;
+	struct property *uninitialized_var(win64);
+	struct dynamic_dma_window_prop *ddwprop;
+	const struct dynamic_dma_window_prop *direct64;
+
+	spin_lock(&direct_window_list_lock);
+
+	/* check if we already created a window */
+	list_for_each_entry(window, &direct_window_list, list) {
+		if (window->device == pdn) {
+			direct64 = window->prop;
+			goto set_device;
+		}
+	}
+	/* check if we kexec'd with a window */
+	direct64 = of_get_property(pdn, DIRECT64_PROPNAME, &len);
+	if (direct64)
+		goto create_window_listent;
+
+	ddr_avail = of_get_property(pdn, "ibm,ddw-applicable", &len);
+
+	if (!ddr_avail || len < 4 * sizeof(u32))
+		return;
+	/*
+	 * the ibm,ddw-applicable property holds the tokens for:
+	 * ibm,query-pe-dma-window
+	 * ibm,create-pe-dma-window
+	 * ibm,remove-pe-dma-window
+	 * for the given node in that order.
+	 *
+	 * Query if there is a second window of size to map the
+	 * whole partition.  Query returns number of windows, largest
+	 * block assigned to PE (partition endpoint), and two bitmasks
+	 * of page sizes: supported and supported for migrate-dma.
+	 */
+
+	/*
+	 * Get the config address and phb build of the PE window.
+	 * Rely on eeh to retrieve this for us.
+	 * Retrieve them from the node with the dma window property.
+	 */
+	pcidn = PCI_DN(pdn);
+	cfg_addr = pcidn->eeh_config_addr;
+	if (pcidn->eeh_pe_config_addr)
+		cfg_addr = pcidn->eeh_pe_config_addr;
+	buid = pcidn->phb->buid;
+	ret = rtas_call(ddr_avail[0], 3, 5, &query[0],
+		  cfg_addr, BUID_HI(buid), BUID_LO(buid));
+	if (ret != 0) {
+		dev_info(&dev->dev, "ibm,query-pe-dma-windows(%x) %x %x %x"
+			" returned %d\n", ddr_avail[0], cfg_addr, BUID_HI(buid),
+			BUID_LO(buid), ret);
+		goto out_unlock;
+	}
+
+	if (!query[0]) {
+		/*
+		 * no additional windows are available for this device.
+		 * We might be able to reallocate the existing window,
+		 * trading in for a larger page size.
+		 */
+		dev_dbg(&dev->dev, "no free dynamic windows");
+		goto out_unlock;
+	}
+	if (query[2] & 4) {
+		page_shift = 24; /* 16MB */
+	} else if (query[2] & 2) {
+		page_shift = 16; /* 64kB */
+	} else if (query[2] & 1) {
+		page_shift = 12; /* 4kB */
+	} else {
+		dev_dbg(&dev->dev, "no supported direct page size in mask %x",
+			  query[2]);
+		goto out_unlock;
+	}
+	/* verify the window * number of ptes will map the partition */
+	/* check largest block * page size > max memory hotplug addr */
+	max_addr = memory_hotplug_max();
+	if (query[1] < (max_addr >> page_shift)) {
+		dev_dbg(&dev->dev, "can't map partiton max 0x%llx with %u "
+			  "%llu-sized pages\n", max_addr,  query[1],
+			  1ULL << page_shift);
+		goto out_unlock;
+	}
+	len = order_base_2(max_addr);
+	win64 = kzalloc(sizeof(struct property), GFP_KERNEL);
+	if (!win64) {
+		dev_info(&dev->dev,
+			"couldn't allocate property for 64bit dma window\n");
+		goto out_unlock;
+	}
+	win64->name = kstrdup(DIRECT64_PROPNAME, GFP_KERNEL);
+	win64->value = ddwprop = kmalloc(sizeof(*ddwprop), GFP_KERNEL);
+	if (!win64->name || !win64->value) {
+		dev_info(&dev->dev,
+			"couldn't allocate property name and value\n");
+		goto out_free_prop;
+	}
+	do {
+		/* extra outputs are LIOBN and dma-addr (hi, lo) */
+		ret = rtas_call(ddr_avail[1], 7, 4, &create[0], cfg_addr,
+				BUID_HI(buid), BUID_LO(buid), len, page_shift);
+	} while(rtas_busy_delay(ret));
+	if (ret) {
+		dev_info(&dev->dev,
+			"failed to create direct window: rtas returned %d"
+			" to ibm,create-pe-dma-window(%x) %x %x %x %x %x\n",
+			ret, ddr_avail[1], cfg_addr, BUID_HI(buid),
+			BUID_LO(buid), len, page_shift);
+		goto out_free_prop;
+	}
+
+	*ddwprop = (struct dynamic_dma_window_prop) {
+		.liobn = cpu_to_be32(create[0]),
+		.dma_base = {cpu_to_be32(create[1]), cpu_to_be32(create[2])},
+		.tce_shift = cpu_to_be32(page_shift),
+		.window_shift = cpu_to_be32(len)
+	};
+
+	dev_dbg(&dev->dev, "created tce table LIOBN 0x%x for %s\n",
+		  create[0], pdn->full_name);
+
+	ret = walk_system_ram_range(0, memblock_end_of_DRAM() >> PAGE_SHIFT,
+			win64->value, tce_setrange_multi_pSeriesLP_walk);
+	if (ret) {
+		dev_info(&dev->dev, "failed to map direct window for %s\n",
+			 pdn->full_name);
+
+		goto out_clear_window;
+	}
+
+	ret = prom_add_property(pdn, win64);
+	if (ret) {
+		pr_err("%s: unable to add dma window property: %d",
+			 pdn->full_name, ret);
+		goto out_clear_window;
+	}
+
+	direct64 = ddwprop;
+
+create_window_listent:
+	window = kzalloc(sizeof(*window), GFP_KERNEL);
+	if (!window)
+		goto out_clear_window;
+	window->device = pdn;
+	window->prop = direct64;
+	list_add(&window->list, &direct_window_list);
+
+set_device:
+	dma_addr = of_read_number(&direct64->dma_base[0], 2);
+	set_dma_offset(&dev->dev, dma_addr);
+	set_dma_ops(&dev->dev, &dma_choose64_ops);
+
+	dev_dbg(&dev->dev, "Can use direct dma at %s (offset %llx)\n",
+		pdn->full_name, dma_addr);
+
+out_unlock:
+	spin_unlock(&direct_window_list_lock);
+	return;
+
+out_clear_window:
+	ret = tce_clearrange_multi_pSeriesLP(0,
+		memblock_end_of_DRAM() >> PAGE_SHIFT, win64->value);
+	if (ret)
+		dev_info(&dev->dev,
+			"failed to clear partial window for %s\n",
+			 pdn->full_name);
+
+	ret = rtas_call(ddr_avail[2], 1, 1, NULL, direct64->liobn);
+	if (ret) {
+		dev_info(&dev->dev,
+			"failed to remove direct window: rtas returned "
+			"%d to ibm,remove-pe-dma-window(%x) %x\n",
+			ret, ddr_avail[2], direct64->liobn);
+	}
+
+out_free_prop:
+	kfree(win64->name);
+	kfree(win64->value);
+	kfree(win64);
+
+	goto out_unlock;
+}
+
+#if 1 //def CLEAN_WINDOW_ON_REMOVE
+static void remove_ddr_windowLP(struct device_node *np)
+{
+	struct dynamic_dma_window_prop *dwp;
+	struct property *win64;
+	const u32 *ddr_avail;
+	int len, ret;
+
+	ddr_avail = of_get_property(np, "ibm,ddw-applicable", &len);
+
+	win64 = of_find_property(np, DIRECT64_PROPNAME, NULL);
+
+	if (!win64 || !ddr_avail || len < 4 * sizeof(u32))
+		return;
+
+	dwp = win64->value;
+
+	/* clear the whole window, note the arg is in kernel pages */
+	ret = tce_clearrange_multi_pSeriesLP(0,
+		1ULL << (dwp->window_shift - PAGE_SHIFT), dwp);
+	if (ret)
+		pr_warning("%s failed to clear tces in window.\n",
+			 np->full_name);
+
+	ret = rtas_call(ddr_avail[2], 1, 1, NULL, dwp->liobn);
+	if (ret)
+		pr_warning("%s: failed to remove direct window: rtas returned "
+			"%d to ibm,remove-pe-dma-window(%x) %x\n",
+			np->full_name, ret, ddr_avail[2], dwp->liobn);
+
+	ret = prom_remove_property(np, win64);
+	if (ret)
+		pr_warning("%s: failed to remove direct window property (%i)\n",
+			np->full_name, ret);
+}
+#else
+static void remove_ddr_windowLP(struct device_node *np) {}
+#endif
+
 static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 {
 	struct device_node *pdn, *dn;
@@ -598,6 +855,7 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 	}
 
 	set_iommu_table_base(&dev->dev, pci->iommu_table);
+	check_ddr_windowLP(dev, pdn);
 }
 #else  /* CONFIG_PCI */
 #define pci_dma_bus_setup_pSeries	NULL
@@ -605,16 +863,68 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 #define pci_dma_dev_setup_pSeriesLP	NULL
 #endif /* !CONFIG_PCI */
 
+static int iommu_mem_notifier(struct notifier_block *nb, unsigned long action,
+		void *data)
+{
+	struct direct_window *window;
+	struct memory_notify *arg = data;
+	int ret = 0;
+
+	switch (action) {
+	case MEM_GOING_ONLINE:
+		spin_lock(&direct_window_list_lock);
+		list_for_each_entry(window, &direct_window_list, list) {
+			ret |= tce_setrange_multi_pSeriesLP(arg->start_pfn,
+					arg->nr_pages, window->prop);
+			/* XXX log error */
+		}
+		spin_unlock(&direct_window_list_lock);
+		break;
+	case MEM_CANCEL_ONLINE:
+	case MEM_OFFLINE:
+		spin_lock(&direct_window_list_lock);
+		list_for_each_entry(window, &direct_window_list, list) {
+			ret |= tce_clearrange_multi_pSeriesLP(arg->start_pfn,
+					arg->nr_pages, window->prop);
+			/* XXX log error */
+		}
+		spin_unlock(&direct_window_list_lock);
+		break;
+	default:
+		break;
+	}
+	if (ret && action != MEM_CANCEL_ONLINE)
+		return NOTIFY_BAD;
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block iommu_mem_nb = {
+	.notifier_call = iommu_mem_notifier,
+};
+
 static int iommu_reconfig_notifier(struct notifier_block *nb, unsigned long action, void *node)
 {
 	int err = NOTIFY_OK;
 	struct device_node *np = node;
 	struct pci_dn *pci = PCI_DN(np);
+	struct direct_window *window;
 
 	switch (action) {
 	case PSERIES_RECONFIG_REMOVE:
 		if (pci && pci->iommu_table)
 			iommu_free_table(pci->iommu_table, np->full_name);
+
+		spin_lock(&direct_window_list_lock);
+		list_for_each_entry(window, &direct_window_list, list) {
+			if (window->device == np) {
+				list_del(&window->list);
+				break;
+			}
+		}
+		spin_unlock(&direct_window_list_lock);
+
+		remove_ddr_windowLP(np);
 		break;
 	default:
 		err = NOTIFY_DONE;
@@ -653,6 +963,7 @@ void iommu_init_early_pSeries(void)
 
 
 	pSeries_reconfig_notifier_register(&iommu_reconfig_nb);
+	register_memory_notifier(&iommu_mem_nb);
 
 	set_pci_dma_ops(&dma_iommu_ops);
 }
-- 
1.7.1

