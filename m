Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab2HPQWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:22:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49929 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab2HPQWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:22:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/6] xen/apic/xenbus/swiotlb/pcifront/grant/tmem: Make functions or variables static.
Date: Thu, 16 Aug 2012 12:12:35 -0400
Message-Id: <1345133558-23341-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
References: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for those functions/variables to be visible. Make them
static and also fix the compile warnings of this sort:

drivers/xen/<some file>.c: warning: symbol '<blah>' was not declared. Should it be static?

Some of them just require including the header file that
declares the functions.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/apic.c                     |    3 ++-
 arch/x86/xen/enlighten.c                |    2 ++
 arch/x86/xen/pci-swiotlb-xen.c          |    2 ++
 arch/x86/xen/platform-pci-unplug.c      |    1 +
 drivers/pci/xen-pcifront.c              |    2 +-
 drivers/xen/gntdev.c                    |    2 +-
 drivers/xen/grant-table.c               |   13 ++++++-------
 drivers/xen/swiotlb-xen.c               |    2 +-
 drivers/xen/tmem.c                      |    1 +
 drivers/xen/xenbus/xenbus_dev_backend.c |    2 +-
 drivers/xen/xenbus/xenbus_probe.c       |    4 ++--
 11 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index ec57bd3..7005ced 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -6,8 +6,9 @@
 
 #include <xen/xen.h>
 #include <xen/interface/physdev.h>
+#include "xen-ops.h"
 
-unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
+static unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
 {
 	struct physdev_apic apic_op;
 	int ret;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index acf906c..2c36e6e 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -81,6 +81,8 @@
 #include "smp.h"
 #include "multicalls.h"
 
+#include <xen/events.h>
+
 EXPORT_SYMBOL_GPL(hypercall_page);
 
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index 1667602..db4db14 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -13,6 +13,8 @@
 #include <asm/dma.h>
 #endif
 #include <linux/export.h>
+
+#include <asm/xen/swiotlb-xen.h>
 int xen_swiotlb __read_mostly;
 
 static struct dma_map_ops xen_swiotlb_dma_ops = {
diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
index ffcf261..0a78524 100644
--- a/arch/x86/xen/platform-pci-unplug.c
+++ b/arch/x86/xen/platform-pci-unplug.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 
 #include <xen/platform_pci.h>
+#include "xen-ops.h"
 
 #define XEN_PLATFORM_ERR_MAGIC -1
 #define XEN_PLATFORM_ERR_PROTOCOL -2
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index ca92801..ebd1ddb 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -237,7 +237,7 @@ static int pcifront_bus_write(struct pci_bus *bus, unsigned int devfn,
 	return errno_to_pcibios_err(do_pci_op(pdev, &op));
 }
 
-struct pci_ops pcifront_bus_ops = {
+static struct pci_ops pcifront_bus_ops = {
 	.read = pcifront_bus_read,
 	.write = pcifront_bus_write,
 };
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 1ffd03b..163b7e9 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -445,7 +445,7 @@ static void mn_release(struct mmu_notifier *mn,
 	spin_unlock(&priv->lock);
 }
 
-struct mmu_notifier_ops gntdev_mmu_ops = {
+static struct mmu_notifier_ops gntdev_mmu_ops = {
 	.release                = mn_release,
 	.invalidate_page        = mn_invl_page,
 	.invalidate_range_start = mn_invl_range_start,
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 0bfc1ef..4061943 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -285,10 +285,9 @@ int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 }
 EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
 
-void gnttab_update_subpage_entry_v2(grant_ref_t ref, domid_t domid,
-				    unsigned long frame, int flags,
-				    unsigned page_off,
-				    unsigned length)
+static void gnttab_update_subpage_entry_v2(grant_ref_t ref, domid_t domid,
+					   unsigned long frame, int flags,
+					   unsigned page_off, unsigned length)
 {
 	gnttab_shared.v2[ref].sub_page.frame = frame;
 	gnttab_shared.v2[ref].sub_page.page_off = page_off;
@@ -345,9 +344,9 @@ bool gnttab_subpage_grants_available(void)
 }
 EXPORT_SYMBOL_GPL(gnttab_subpage_grants_available);
 
-void gnttab_update_trans_entry_v2(grant_ref_t ref, domid_t domid,
-				  int flags, domid_t trans_domid,
-				  grant_ref_t trans_gref)
+static void gnttab_update_trans_entry_v2(grant_ref_t ref, domid_t domid,
+					 int flags, domid_t trans_domid,
+					 grant_ref_t trans_gref)
 {
 	gnttab_shared.v2[ref].transitive.trans_domid = trans_domid;
 	gnttab_shared.v2[ref].transitive.gref = trans_gref;
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 09e25a6..307a908 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -52,7 +52,7 @@ static unsigned long xen_io_tlb_nslabs;
  * Quick lookup value of the bus address of the IOTLB.
  */
 
-u64 start_dma_addr;
+static u64 start_dma_addr;
 
 static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
 {
diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index 89f264c..144564e 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -21,6 +21,7 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/page.h>
 #include <asm/xen/hypervisor.h>
+#include <xen/tmem.h>
 
 #define TMEM_CONTROL               0
 #define TMEM_NEW_POOL              1
diff --git a/drivers/xen/xenbus/xenbus_dev_backend.c b/drivers/xen/xenbus/xenbus_dev_backend.c
index be738c4..d730008 100644
--- a/drivers/xen/xenbus/xenbus_dev_backend.c
+++ b/drivers/xen/xenbus/xenbus_dev_backend.c
@@ -107,7 +107,7 @@ static int xenbus_backend_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-const struct file_operations xenbus_backend_fops = {
+static const struct file_operations xenbus_backend_fops = {
 	.open = xenbus_backend_open,
 	.mmap = xenbus_backend_mmap,
 	.unlocked_ioctl = xenbus_backend_ioctl,
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index b793723..91d3d654 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -324,8 +324,8 @@ static int cmp_dev(struct device *dev, void *data)
 	return 0;
 }
 
-struct xenbus_device *xenbus_device_find(const char *nodename,
-					 struct bus_type *bus)
+static struct xenbus_device *xenbus_device_find(const char *nodename,
+						struct bus_type *bus)
 {
 	struct xb_find_info info = { .dev = NULL, .nodename = nodename };
 
-- 
1.7.7.6

