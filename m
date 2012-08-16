Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2HPP73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:59:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3250 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab2HPPz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:55:58 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336363200"; 
   d="scan'208";a="205388545"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <tim@xen.org>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 25/25] [HACK] xen/arm: implement xen_remap_domain_mfn_range
Date: Thu, 16 Aug 2012 16:36:17 +0100
Message-ID: <1345131377-14713-25-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>

Do not apply!

This is a simple, hacky implementation of xen_remap_domain_mfn_range,
using XENMAPSPACE_gmfn_foreign.

It should use same interface as hybrid x86.


Changes in v2:

- retain binary compatibility in xen_add_to_physmap: use a union.

Changes in v3:

- do not use an anonymous union.


Signed-off-by: Ian Campbell <Ian.Campbell@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c       |   79 +++++++++++++++++++++++++++++++++++++++-
 drivers/xen/privcmd.c          |   16 +++++----
 drivers/xen/xenfs/super.c      |    7 ++++
 include/xen/interface/memory.h |   15 ++++++--
 4 files changed, 105 insertions(+), 12 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 3348d90..4616412 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -16,6 +16,10 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
+#include <linux/mm.h>
+#include <linux/ioport.h>
+
+#include <asm/pgtable.h>
 
 struct start_info _xen_start_info;
 struct start_info *xen_start_info = &_xen_start_info;
@@ -38,12 +42,85 @@ EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
 
 static __read_mostly int xen_events_irq = -1;
 
+#define FOREIGN_MAP_BUFFER 0x90000000UL
+#define FOREIGN_MAP_BUFFER_SIZE 0x10000000UL
+struct resource foreign_map_resource = {
+	.start = FOREIGN_MAP_BUFFER,
+	.end = FOREIGN_MAP_BUFFER + FOREIGN_MAP_BUFFER_SIZE,
+	.name = "Xen foreign map buffer",
+	.flags = 0,
+};
+
+static unsigned long foreign_map_buffer_pfn = FOREIGN_MAP_BUFFER >> PAGE_SHIFT;
+
+struct remap_data {
+	struct mm_struct *mm;
+	unsigned long mfn;
+	pgprot_t prot;
+};
+
+static int remap_area_mfn_pte_fn(pte_t *ptep, pgtable_t token,
+				 unsigned long addr, void *data)
+{
+	struct remap_data *rmd = data;
+	pte_t pte = pfn_pte(rmd->mfn, rmd->prot);
+
+	if (rmd->mfn < 0x90010)
+		pr_crit("%s: ptep %p addr %#lx => %#x / %#lx\n",
+		       __func__, ptep, addr, pte_val(pte), rmd->mfn);
+
+	set_pte_at(rmd->mm, addr, ptep, pte);
+
+	rmd->mfn++;
+	return 0;
+}
+
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
 			       unsigned long mfn, int nr,
 			       pgprot_t prot, unsigned domid)
 {
-	return -ENOSYS;
+	int i, rc = 0;
+	struct remap_data rmd = {
+		.mm = vma->vm_mm,
+		.prot = prot,
+	};
+	struct xen_add_to_physmap xatp = {
+		.domid = DOMID_SELF,
+		.space = XENMAPSPACE_gmfn_foreign,
+
+		.u.foreign_domid = domid,
+	};
+
+	if (foreign_map_buffer_pfn + nr > ((FOREIGN_MAP_BUFFER +
+					FOREIGN_MAP_BUFFER_SIZE)>>PAGE_SHIFT)) {
+		pr_crit("RAM out of foreign map buffers...\n");
+		return -EBUSY;
+	}
+
+	for (i = 0; i < nr; i++) {
+		xatp.idx = mfn + i;
+		xatp.gpfn = foreign_map_buffer_pfn + i;
+		rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
+		if (rc != 0) {
+			pr_crit("foreign map add_to_physmap failed, err=%d\n", rc);
+			goto out;
+		}
+	}
+
+	rmd.mfn = foreign_map_buffer_pfn;
+	rc = apply_to_page_range(vma->vm_mm,
+				 addr,
+				 (unsigned long)nr << PAGE_SHIFT,
+				 remap_area_mfn_pte_fn, &rmd);
+	if (rc != 0) {
+		pr_crit("apply_to_page_range failed rc=%d\n", rc);
+		goto out;
+	}
+
+	foreign_map_buffer_pfn += nr;
+out:
+	return rc;
 }
 EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
 
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 85226cb..3e15c22 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -20,6 +20,8 @@
 #include <linux/pagemap.h>
 #include <linux/seq_file.h>
 #include <linux/miscdevice.h>
+#include <linux/resource.h>
+#include <linux/ioport.h>
 
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
@@ -196,9 +198,6 @@ static long privcmd_ioctl_mmap(void __user *udata)
 	LIST_HEAD(pagelist);
 	struct mmap_mfn_state state;
 
-	if (!xen_initial_domain())
-		return -EPERM;
-
 	if (copy_from_user(&mmapcmd, udata, sizeof(mmapcmd)))
 		return -EFAULT;
 
@@ -286,9 +285,6 @@ static long privcmd_ioctl_mmap_batch(void __user *udata)
 	LIST_HEAD(pagelist);
 	struct mmap_batch_state state;
 
-	if (!xen_initial_domain())
-		return -EPERM;
-
 	if (copy_from_user(&m, udata, sizeof(m)))
 		return -EFAULT;
 
@@ -365,6 +361,11 @@ static long privcmd_ioctl(struct file *file,
 	return ret;
 }
 
+static void privcmd_close(struct vm_area_struct *vma)
+{
+	/* TODO: unmap VMA */
+}
+
 static int privcmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	printk(KERN_DEBUG "privcmd_fault: vma=%p %lx-%lx, pgoff=%lx, uv=%p\n",
@@ -375,7 +376,8 @@ static int privcmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 }
 
 static struct vm_operations_struct privcmd_vm_ops = {
-	.fault = privcmd_fault
+	.fault = privcmd_fault,
+	.close = privcmd_close,
 };
 
 static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index a84b53c..edbe22f 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/magic.h>
+#include <linux/ioport.h>
 
 #include <xen/xen.h>
 
@@ -80,6 +81,8 @@ static const struct file_operations capabilities_file_ops = {
 	.llseek = default_llseek,
 };
 
+extern struct resource foreign_map_resource;
+
 static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	static struct tree_descr xenfs_files[] = {
@@ -100,6 +103,10 @@ static int xenfs_fill_super(struct super_block *sb, void *data, int silent)
 				  &xsd_kva_file_ops, NULL, S_IRUSR|S_IWUSR);
 		xenfs_create_file(sb, sb->s_root, "xsd_port",
 				  &xsd_port_file_ops, NULL, S_IRUSR|S_IWUSR);
+		rc = request_resource(&iomem_resource, &foreign_map_resource);
+		if (rc < 0)
+			pr_crit("failed to register foreign map resource\n");
+		rc = 0; /* ignore */
 	}
 
 	return rc;
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index b66d04c..99c5052 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -163,12 +163,19 @@ struct xen_add_to_physmap {
     /* Which domain to change the mapping for. */
     domid_t domid;
 
-    /* Number of pages to go through for gmfn_range */
-    uint16_t    size;
+    union {
+        /* Number of pages to go through for gmfn_range */
+        uint16_t    size;
+        /* IFF gmfn_foreign */
+        domid_t foreign_domid;
+    } u;
 
     /* Source mapping space. */
-#define XENMAPSPACE_shared_info 0 /* shared info page */
-#define XENMAPSPACE_grant_table 1 /* grant table page */
+#define XENMAPSPACE_shared_info  0 /* shared info page */
+#define XENMAPSPACE_grant_table  1 /* grant table page */
+#define XENMAPSPACE_gmfn         2 /* GMFN */
+#define XENMAPSPACE_gmfn_range   3 /* GMFN range */
+#define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another guest */
     unsigned int space;
 
     /* Index into source mapping space. */
-- 
1.7.2.5

