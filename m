Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab2JTBbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:31:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18154 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab2JTBaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:30:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        mukesh.rathor@oracle.com, Ian.Campbell@citrix.com,
        stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/6] xen/pvh: /dev/xen/privcmd changes.
Date: Fri, 19 Oct 2012 21:18:02 -0400
Message-Id: <1350695882-12820-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

PVH only supports the batch interface. To map a foreign page to a process,
the PFN must be allocated and PVH path uses ballooning for that purpose.

The returned PFN is then mapped to the foreign page.
xen_unmap_domain_mfn_range() is introduced to unmap these pages via the
privcmd close call.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
[v1: Fix up privcmd_close]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/privcmd.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index b612267..b9d0898 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -33,11 +33,14 @@
 #include <xen/features.h>
 #include <xen/page.h>
 #include <xen/xen-ops.h>
+#include <xen/balloon.h>
 
 #include "privcmd.h"
 
 MODULE_LICENSE("GPL");
 
+#define PRIV_VMA_LOCKED ((void *)1)
+
 #ifndef HAVE_ARCH_PRIVCMD_MMAP
 static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma);
 #endif
@@ -199,6 +202,10 @@ static long privcmd_ioctl_mmap(void __user *udata)
 	if (!xen_initial_domain())
 		return -EPERM;
 
+	/* We only support privcmd_ioctl_mmap_batch for auto translated. */
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return -ENOSYS;
+
 	if (copy_from_user(&mmapcmd, udata, sizeof(mmapcmd)))
 		return -EFAULT;
 
@@ -246,6 +253,7 @@ struct mmap_batch_state {
 	domid_t domain;
 	unsigned long va;
 	struct vm_area_struct *vma;
+	int index;
 	/* A tristate:
 	 *      0 for no errors
 	 *      1 if at least one error has happened (and no
@@ -260,15 +268,24 @@ struct mmap_batch_state {
 	xen_pfn_t __user *user_mfn;
 };
 
+/* auto translated dom0 note: if domU being created is PV, then mfn is
+ * mfn(addr on bus). If it's auto xlated, then mfn is pfn (input to HAP).
+ */
 static int mmap_batch_fn(void *data, void *state)
 {
 	xen_pfn_t *mfnp = data;
 	struct mmap_batch_state *st = state;
+	struct vm_area_struct *vma = st->vma;
+	struct page **pages = vma->vm_private_data;
+	struct page *cur_page = NULL;
 	int ret;
 
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		cur_page = pages[st->index++];
+
 	ret = xen_remap_domain_mfn_range(st->vma, st->va & PAGE_MASK, *mfnp, 1,
 					 st->vma->vm_page_prot, st->domain,
-					 NULL);
+					 &cur_page);
 
 	/* Store error code for second pass. */
 	*(st->err++) = ret;
@@ -304,6 +321,32 @@ static int mmap_return_errors_v1(void *data, void *state)
 	return __put_user(*mfnp, st->user_mfn++);
 }
 
+/* Allocate pfns that are then mapped with gmfns from foreign domid. Update
+ * the vma with the page info to use later.
+ * Returns: 0 if success, otherwise -errno
+ */
+static int alloc_empty_pages(struct vm_area_struct *vma, int numpgs)
+{
+	int rc;
+	struct page **pages;
+
+	pages = kcalloc(numpgs, sizeof(pages[0]), GFP_KERNEL);
+	if (pages == NULL)
+		return -ENOMEM;
+
+	rc = alloc_xenballooned_pages(numpgs, pages, 0);
+	if (rc != 0) {
+		pr_warn("%s Could not alloc %d pfns rc:%d\n", __func__,
+			numpgs, rc);
+		kfree(pages);
+		return -ENOMEM;
+	}
+	BUG_ON(vma->vm_private_data != PRIV_VMA_LOCKED);
+	vma->vm_private_data = pages;
+
+	return 0;
+}
+
 static struct vm_operations_struct privcmd_vm_ops;
 
 static long privcmd_ioctl_mmap_batch(void __user *udata, int version)
@@ -371,10 +414,18 @@ static long privcmd_ioctl_mmap_batch(void __user *udata, int version)
 		up_write(&mm->mmap_sem);
 		goto out;
 	}
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		ret = alloc_empty_pages(vma, m.num);
+		if (ret < 0) {
+			up_write(&mm->mmap_sem);
+			goto out;
+		}
+	}
 
 	state.domain        = m.dom;
 	state.vma           = vma;
 	state.va            = m.addr;
+	state.index         = 0;
 	state.global_error  = 0;
 	state.err           = err_array;
 
@@ -439,6 +490,19 @@ static long privcmd_ioctl(struct file *file,
 	return ret;
 }
 
+static void privcmd_close(struct vm_area_struct *vma)
+{
+	struct page **pages = vma->vm_private_data;
+	int numpgs = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+
+	if (!xen_feature(XENFEAT_auto_translated_physmap || !numpgs || !pages))
+		return;
+
+	xen_unmap_domain_mfn_range(vma, numpgs, pages);
+	free_xenballooned_pages(numpgs, pages);
+	kfree(pages);
+}
+
 static int privcmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	printk(KERN_DEBUG "privcmd_fault: vma=%p %lx-%lx, pgoff=%lx, uv=%p\n",
@@ -449,6 +513,7 @@ static int privcmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 }
 
 static struct vm_operations_struct privcmd_vm_ops = {
+	.close = privcmd_close,
 	.fault = privcmd_fault
 };
 
@@ -466,7 +531,7 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
 
 static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma)
 {
-	return (xchg(&vma->vm_private_data, (void *)1) == NULL);
+	return !cmpxchg(&vma->vm_private_data, NULL, PRIV_VMA_LOCKED);
 }
 
 const struct file_operations xen_privcmd_fops = {
-- 
1.7.7.6

