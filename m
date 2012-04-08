Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2DHRPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 13:15:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38653 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab2DHRP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 13:15:29 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 1/2] PCI,x86: introduce new MMCFG interfaces to support PCI host bridge hotplug
Date: Mon,  9 Apr 2012 01:12:08 +0800
Message-Id: <1333905129-8776-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333905129-8776-1-git-send-email-jiang.liu@huawei.com>
References: <1333905129-8776-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <20120406115948.3536e6c8.izumi.taku@jp.fujitsu.com>
References: <20120406115948.3536e6c8.izumi.taku@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two new interfaces, pci_mmconfig_insert() and
pci_mmconfig_delete(), to support PCI host bridge hotplug on x86 platforms.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/x86/include/asm/pci_x86.h |    4 +
 arch/x86/pci/mmconfig-shared.c |  186 +++++++++++++++++++++++++++++++---------
 arch/x86/pci/mmconfig_32.c     |   28 ++++++-
 arch/x86/pci/mmconfig_64.c     |   35 +++++++-
 4 files changed, 206 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index b3a5317..ba8570c 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -135,6 +135,10 @@ struct pci_mmcfg_region {
 
 extern int __init pci_mmcfg_arch_init(void);
 extern void __init pci_mmcfg_arch_free(void);
+extern int __devinit pci_mmcfg_arch_map(struct pci_mmcfg_region *cfg);
+extern void __devinit pci_mmcfg_arch_unmap(struct pci_mmcfg_region *cfg);
+extern int __devinit pci_mmconfig_insert(int seg, int start, int end, u64 addr);
+extern int __devinit pci_mmconfig_delete(int seg, int start, int end, u64 addr);
 extern struct pci_mmcfg_region *pci_mmconfig_lookup(int segment, int bus);
 
 extern struct list_head pci_mmcfg_list;
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 301e325..dda9470 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -17,6 +17,8 @@
 #include <linux/bitmap.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/rculist.h>
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
 #include <asm/acpi.h>
@@ -45,24 +47,25 @@ static __init void free_all_mmcfg(void)
 		pci_mmconfig_remove(cfg);
 }
 
-static __init void list_add_sorted(struct pci_mmcfg_region *new)
+static __devinit void list_add_sorted(struct pci_mmcfg_region *new)
 {
 	struct pci_mmcfg_region *cfg;
 
 	/* keep list sorted by segment and starting bus number */
-	list_for_each_entry(cfg, &pci_mmcfg_list, list) {
+	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {
 		if (cfg->segment > new->segment ||
 		    (cfg->segment == new->segment &&
 		     cfg->start_bus >= new->start_bus)) {
-			list_add_tail(&new->list, &cfg->list);
+			list_add_tail_rcu(&new->list, &cfg->list);
 			return;
 		}
 	}
-	list_add_tail(&new->list, &pci_mmcfg_list);
+	list_add_tail_rcu(&new->list, &pci_mmcfg_list);
 }
 
-static __init struct pci_mmcfg_region *pci_mmconfig_add(int segment, int start,
-							int end, u64 addr)
+static __devinit struct pci_mmcfg_region *pci_mmconfig_alloc(int segment,
+							     int start,
+							     int end, u64 addr)
 {
 	struct pci_mmcfg_region *new;
 	struct resource *res;
@@ -79,8 +82,6 @@ static __init struct pci_mmcfg_region *pci_mmconfig_add(int segment, int start,
 	new->start_bus = start;
 	new->end_bus = end;
 
-	list_add_sorted(new);
-
 	res = &new->res;
 	res->start = addr + PCI_MMCFG_BUS_OFFSET(start);
 	res->end = addr + PCI_MMCFG_BUS_OFFSET(end + 1) - 1;
@@ -96,11 +97,23 @@ static __init struct pci_mmcfg_region *pci_mmconfig_add(int segment, int start,
 	return new;
 }
 
+static __init struct pci_mmcfg_region *pci_mmconfig_add(int segment, int start,
+							int end, u64 addr)
+{
+	struct pci_mmcfg_region *new;
+
+	new = pci_mmconfig_alloc(segment, start, end, addr);
+	if (new)
+		list_add_sorted(new);
+
+	return new;
+}
+
 struct pci_mmcfg_region *pci_mmconfig_lookup(int segment, int bus)
 {
 	struct pci_mmcfg_region *cfg;
 
-	list_for_each_entry(cfg, &pci_mmcfg_list, list)
+	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list)
 		if (cfg->segment == segment &&
 		    cfg->start_bus <= bus && bus <= cfg->end_bus)
 			return cfg;
@@ -364,8 +377,8 @@ static void __init pci_mmcfg_insert_resources(void)
 	pci_mmcfg_resources_inserted = 1;
 }
 
-static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
-					      void *data)
+static acpi_status __devinit check_mcfg_resource(struct acpi_resource *res,
+						 void *data)
 {
 	struct resource *mcfg_res = data;
 	struct acpi_resource_address64 address;
@@ -401,8 +414,8 @@ static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
 	return AE_OK;
 }
 
-static acpi_status __init find_mboard_resource(acpi_handle handle, u32 lvl,
-		void *context, void **rv)
+static acpi_status __devinit find_mboard_resource(acpi_handle handle, u32 lvl,
+						  void *context, void **rv)
 {
 	struct resource *mcfg_res = context;
 
@@ -415,7 +428,7 @@ static acpi_status __init find_mboard_resource(acpi_handle handle, u32 lvl,
 	return AE_OK;
 }
 
-static int __init is_acpi_reserved(u64 start, u64 end, unsigned not_used)
+static int __devinit is_acpi_reserved(u64 start, u64 end, unsigned not_used)
 {
 	struct resource mcfg_res;
 
@@ -434,8 +447,9 @@ static int __init is_acpi_reserved(u64 start, u64 end, unsigned not_used)
 
 typedef int (*check_reserved_t)(u64 start, u64 end, unsigned type);
 
-static int __init is_mmconf_reserved(check_reserved_t is_reserved,
-				    struct pci_mmcfg_region *cfg, int with_e820)
+static int __devinit is_mmconf_reserved(check_reserved_t is_reserved,
+					struct pci_mmcfg_region *cfg,
+					int with_e820)
 {
 	u64 addr = cfg->res.start;
 	u64 size = resource_size(&cfg->res);
@@ -474,39 +488,38 @@ static int __init is_mmconf_reserved(check_reserved_t is_reserved,
 	return valid;
 }
 
+static int __devinit pci_mmcfg_check_reserved(struct pci_mmcfg_region *cfg,
+					      int early)
+{
+	if (!early && !acpi_disabled) {
+		if (is_mmconf_reserved(is_acpi_reserved, cfg, 0))
+			return 1;
+		else
+			printk(KERN_ERR FW_BUG PREFIX
+			       "MMCONFIG at %pR not reserved in "
+			       "ACPI motherboard resources\n",
+			       &cfg->res);
+	}
+
+	/* Don't try to do this check unless configuration
+	   type 1 is available. how about type 2 ?*/
+	if (raw_pci_ops)
+		return is_mmconf_reserved(e820_all_mapped, cfg, 1);
+
+	return 0;
+}
+
 static void __init pci_mmcfg_reject_broken(int early)
 {
 	struct pci_mmcfg_region *cfg;
 
 	list_for_each_entry(cfg, &pci_mmcfg_list, list) {
-		int valid = 0;
-
-		if (!early && !acpi_disabled) {
-			valid = is_mmconf_reserved(is_acpi_reserved, cfg, 0);
-
-			if (valid)
-				continue;
-			else
-				printk(KERN_ERR FW_BUG PREFIX
-				       "MMCONFIG at %pR not reserved in "
-				       "ACPI motherboard resources\n",
-				       &cfg->res);
+		if (pci_mmcfg_check_reserved(cfg, early) == 0) {
+			printk(KERN_INFO PREFIX "not using MMCONFIG\n");
+			free_all_mmcfg();
+			return;
 		}
-
-		/* Don't try to do this check unless configuration
-		   type 1 is available. how about type 2 ?*/
-		if (raw_pci_ops)
-			valid = is_mmconf_reserved(e820_all_mapped, cfg, 1);
-
-		if (!valid)
-			goto reject;
 	}
-
-	return;
-
-reject:
-	printk(KERN_INFO PREFIX "not using MMCONFIG\n");
-	free_all_mmcfg();
 }
 
 static int __initdata known_bridge;
@@ -665,3 +678,92 @@ static int __init pci_mmcfg_late_insert_resources(void)
  * with other system resources.
  */
 late_initcall(pci_mmcfg_late_insert_resources);
+
+static DEFINE_MUTEX(pci_mmcfg_lock);
+
+/* Add MMCFG information for hot-added host bridges at runtime */
+int __devinit pci_mmconfig_insert(int segment, int start, int end, u64 addr)
+{
+	int rc;
+	struct pci_mmcfg_region *cfg = NULL;
+
+	if (addr == 0 || segment < 0 || segment > USHRT_MAX ||
+	    start < 0 || start > 255 || end < start || end > 255)
+		return -EINVAL;
+
+	mutex_lock(&pci_mmcfg_lock);
+	cfg = pci_mmconfig_lookup(segment, start);
+	if (cfg) {
+		if (cfg->start_bus == start && cfg->end_bus == end &&
+		    cfg->address == addr) {
+			rc = -EEXIST;
+		} else {
+			rc = -EINVAL;
+			printk(KERN_WARNING PREFIX
+			       "MMCONFIG for domain %04x [bus %02x-%02x] "
+			       "conflicts with domain %04x [bus %02x-%02x]\n",
+			       segment, start, end,
+			       cfg->segment, cfg->start_bus, cfg->end_bus);
+		}
+		goto out;
+	}
+
+	cfg = pci_mmconfig_alloc(segment, start, end, addr);
+	if (cfg == NULL) {
+		rc = -ENOMEM;
+	} else if (!pci_mmcfg_check_reserved(cfg, 0)) {
+		rc = -EINVAL;
+		printk(KERN_WARNING PREFIX
+		       "MMCONFIG for domain %04x [bus %02x-%02x] "
+		       "isn't reserved\n", segment, start, end);
+	} else if (insert_resource(&iomem_resource, &cfg->res)) {
+		rc = -EBUSY;
+		printk(KERN_WARNING PREFIX
+		       "failed to insert resource for domain "
+		       "%04x [bus %02x-%02x]\n", segment, start, end);
+	} else if (pci_mmcfg_arch_map(cfg)) {
+		rc = -EBUSY;
+		printk(KERN_WARNING PREFIX
+		       "failed to map resource for domain "
+		       "%04x [bus %02x-%02x]\n", segment, start, end);
+	} else {
+		list_add_sorted(cfg);
+		cfg = NULL;
+		rc = 0;
+	}
+
+	if (cfg) {
+		if (cfg->res.parent)
+			release_resource(&cfg->res);
+		kfree(cfg);
+	}
+
+out:
+	mutex_unlock(&pci_mmcfg_lock);
+
+	return rc;
+}
+
+/* Delete MMCFG information at runtime */
+int __devinit pci_mmconfig_delete(int segment, int start, int end, u64 addr)
+{
+	struct pci_mmcfg_region *cfg;
+
+	mutex_lock(&pci_mmcfg_lock);
+	list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {
+		if (cfg->segment == segment && cfg->start_bus == start &&
+		    cfg->end_bus == end && cfg->address == addr) {
+			list_del_rcu(&cfg->list);
+			synchronize_rcu();
+			pci_mmcfg_arch_unmap(cfg);
+			if (cfg->res.parent)
+				release_resource(&cfg->res);
+			mutex_unlock(&pci_mmcfg_lock);
+			kfree(cfg);
+			return 0;
+		}
+	}
+	mutex_unlock(&pci_mmcfg_lock);
+
+	return -ENOENT;
+}
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 5372e86..c2756de 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -11,6 +11,7 @@
 
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <linux/rcupdate.h>
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
 #include <acpi/acpi.h>
@@ -60,9 +61,12 @@ err:		*value = -1;
 		return -EINVAL;
 	}
 
+	rcu_read_lock();
 	base = get_base_addr(seg, bus, devfn);
-	if (!base)
+	if (!base) {
+		rcu_read_unlock();
 		goto err;
+	}
 
 	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
@@ -80,6 +84,7 @@ err:		*value = -1;
 		break;
 	}
 	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -93,9 +98,12 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	if ((bus > 255) || (devfn > 255) || (reg > 4095))
 		return -EINVAL;
 
+	rcu_read_lock();
 	base = get_base_addr(seg, bus, devfn);
-	if (!base)
+	if (!base) {
+		rcu_read_unlock();
 		return -EINVAL;
+	}
 
 	raw_spin_lock_irqsave(&pci_config_lock, flags);
 
@@ -113,6 +121,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 		break;
 	}
 	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -132,3 +141,18 @@ int __init pci_mmcfg_arch_init(void)
 void __init pci_mmcfg_arch_free(void)
 {
 }
+
+int __devinit pci_mmcfg_arch_map(struct pci_mmcfg_region *cfg)
+{
+	return 0;
+}
+
+void __devinit pci_mmcfg_arch_unmap(struct pci_mmcfg_region *cfg)
+{
+	unsigned long flags;
+
+	/* Invalidate the cached mmcfg map entry. */
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
+	mmcfg_last_accessed_device = 0;
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
+}
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index 915a493..6822dd6 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/bitmap.h>
+#include <linux/rcupdate.h>
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
 
@@ -34,9 +35,12 @@ err:		*value = -1;
 		return -EINVAL;
 	}
 
+	rcu_read_lock();
 	addr = pci_dev_base(seg, bus, devfn);
-	if (!addr)
+	if (!addr) {
+		rcu_read_unlock();
 		goto err;
+	}
 
 	switch (len) {
 	case 1:
@@ -49,6 +53,7 @@ err:		*value = -1;
 		*value = mmio_config_readl(addr + reg);
 		break;
 	}
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -62,9 +67,12 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
 		return -EINVAL;
 
+	rcu_read_lock();
 	addr = pci_dev_base(seg, bus, devfn);
-	if (!addr)
+	if (!addr) {
+		rcu_read_unlock();
 		return -EINVAL;
+	}
 
 	switch (len) {
 	case 1:
@@ -77,6 +85,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 		mmio_config_writel(addr + reg, value);
 		break;
 	}
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -86,7 +95,7 @@ static const struct pci_raw_ops pci_mmcfg = {
 	.write =	pci_mmcfg_write,
 };
 
-static void __iomem * __init mcfg_ioremap(struct pci_mmcfg_region *cfg)
+static void __iomem * __devinit mcfg_ioremap(struct pci_mmcfg_region *cfg)
 {
 	void __iomem *addr;
 	u64 start, size;
@@ -129,3 +138,23 @@ void __init pci_mmcfg_arch_free(void)
 		}
 	}
 }
+
+int __devinit pci_mmcfg_arch_map(struct pci_mmcfg_region *cfg)
+{
+	cfg->virt = mcfg_ioremap(cfg);
+	if (!cfg->virt) {
+		printk(KERN_ERR PREFIX "can't map MMCONFIG at %pR\n",
+		       &cfg->res);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void __devinit pci_mmcfg_arch_unmap(struct pci_mmcfg_region *cfg)
+{
+	if (cfg && cfg->virt) {
+		iounmap(cfg->virt + PCI_MMCFG_BUS_OFFSET(cfg->start_bus));
+		cfg->virt = NULL;
+	}
+}
-- 
1.7.5.4

