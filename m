Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1LTGot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 01:44:49 -0500
Received: from 206-223-182-18.beanfield.net ([206.223.182.18]:38089 "EHLO
	dev.gridcentric.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1LTGoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 01:44:16 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Dec 2011 01:44:16 EST
From: Adin Scannell <adin@scannell.ca>
To: xen-devel@lists.xensource.com
Cc: konrad@darnok.org, andres@gridcentric.ca, adin@gridcentric.com,
        olaf@aepfle.de, JBeulich@suse.com, linux-kernel@vger.kernel.org,
        Adin Scannell <adin@scannell.ca>
Subject: [PATCH 3/3] Port of mmap_batch_v2 to support paging in Xen
Date: Tue, 20 Dec 2011 01:36:53 -0500
Message-Id: <1324363013-11031-4-git-send-email-adin@scannell.ca>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1324363013-11031-1-git-send-email-adin@scannell.ca>
References: <1324363013-11031-1-git-send-email-adin@scannell.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This wasn't ported from any patch, but was rewritten based on the XCP 2.6.32
tree.  The code structure is significantly different and this patch mirrors the
existing Linux code.

An important reason to add the V2 interface is to support foreign mappings
(i.e.  qemu-dm) of paged-out pages.  The kernel generally has to do nothing
beyond implementing this ioctl in order to provide this support.  The V2
interface is needed only to pass back full error codes from the mmu_update()'s.
Xen and libxc have a mutual understanding that when you receive an ENOENT error
code, you back off and try again. The libxc code will already retry mappings
when an ENOENT is returned.

The only exception to the above case is backend drivers using grant operations.
To support paging, these drivers must appropriately retry grant operations when
they receive an EAGAIN error code.  This is implemented in a separate patch.

Signed-off-by: Adin Scannell <adin@scannell.ca>
---
 drivers/xen/privcmd.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/xen/privcmd.h |   10 +++++
 2 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 161681f..dd77d5c 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -251,6 +251,15 @@ struct mmap_batch_state {
 	xen_pfn_t __user *user;
 };
 
+struct mmap_batch_v2_state {
+	domid_t domain;
+	unsigned long va;
+	struct vm_area_struct *vma;
+	unsigned long paged_out;
+
+	int __user *err;
+};
+
 static int mmap_batch_fn(void *data, void *state)
 {
 	xen_pfn_t *mfnp = data;
@@ -268,6 +277,22 @@ static int mmap_batch_fn(void *data, void *state)
 	return 0;
 }
 
+static int mmap_batch_v2_fn(void *data, void *state)
+{
+	xen_pfn_t *mfnp = data;
+	struct mmap_batch_v2_state *st = state;
+
+	BUG_ON(st == NULL || st->vma == NULL);
+
+	int rc = xen_remap_domain_mfn_range(st->vma, st->va & PAGE_MASK, *mfnp,
+				       1, st->vma->vm_page_prot, st->domain);
+	if (rc == -ENOENT)
+		st->paged_out++;
+	st->va += PAGE_SIZE;
+
+	return put_user(rc, st->err++);
+}
+
 static int mmap_return_errors(void *data, void *state)
 {
 	xen_pfn_t *mfnp = data;
@@ -340,6 +365,67 @@ out:
 	return ret;
 }
 
+static long privcmd_ioctl_mmap_batch_v2(void __user *udata)
+{
+	int ret;
+	struct privcmd_mmapbatch_v2 m;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = NULL;
+	unsigned long nr_pages;
+	LIST_HEAD(pagelist);
+	struct mmap_batch_v2_state state;
+
+	if (!xen_initial_domain())
+		return -EPERM;
+
+	if (copy_from_user(&m, udata, sizeof(m)))
+		return -EFAULT;
+
+	nr_pages = m.num;
+	if ((m.num <= 0) || (nr_pages > (ULONG_MAX >> PAGE_SHIFT)))
+		return -EINVAL;
+
+	ret = gather_array(&pagelist, m.num, sizeof(xen_pfn_t),
+			   m.arr);
+
+	if (ret || list_empty(&pagelist))
+		goto out;
+
+	down_write(&mm->mmap_sem);
+
+	vma = find_vma(mm, m.addr);
+	ret = -EINVAL;
+	/* We allow multiple shots here, because this interface
+	 * is used by libxc and mappings for specific pages will
+	 * be retried when pages are paged-out (ENOENT). */
+	if (!vma ||
+	    vma->vm_ops != &privcmd_vm_ops ||
+	    (m.addr < vma->vm_start) ||
+	    ((m.addr + (nr_pages << PAGE_SHIFT)) > vma->vm_end)) {
+		up_write(&mm->mmap_sem);
+		goto out;
+	}
+
+	state.domain = m.dom;
+	state.vma = vma;
+	state.va = m.addr;
+	state.err = m.err;
+	state.paged_out = 0;
+
+	up_write(&mm->mmap_sem);
+
+	ret = traverse_pages(m.num, sizeof(xen_pfn_t),
+			     &pagelist, mmap_batch_v2_fn, &state);
+
+out:
+	free_page_list(&pagelist);
+
+	if ((ret == 0) && (state.paged_out > 0))
+		return -ENOENT;
+	else
+		return ret;
+}
+
 static long privcmd_ioctl(struct file *file,
 			  unsigned int cmd, unsigned long data)
 {
@@ -359,6 +445,10 @@ static long privcmd_ioctl(struct file *file,
 		ret = privcmd_ioctl_mmap_batch(udata);
 		break;
 
+	case IOCTL_PRIVCMD_MMAPBATCH_V2:
+		ret = privcmd_ioctl_mmap_batch_v2(udata);
+		break;
+
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/xen/privcmd.h b/include/xen/privcmd.h
index 17857fb..39b92b1 100644
--- a/include/xen/privcmd.h
+++ b/include/xen/privcmd.h
@@ -62,6 +62,14 @@ struct privcmd_mmapbatch {
 	xen_pfn_t __user *arr; /* array of mfns - top nibble set on err */
 };
 
+struct privcmd_mmapbatch_v2 {
+	int num;          /* number of pages to populate */
+	domid_t dom;      /* target domain */
+	__u64 addr;       /* virtual address */
+	const xen_pfn_t __user *arr; /* array of mfns */
+	int __user *err;  /* array of error codes */
+};
+
 /*
  * @cmd: IOCTL_PRIVCMD_HYPERCALL
  * @arg: &privcmd_hypercall_t
@@ -73,5 +81,7 @@ struct privcmd_mmapbatch {
 	_IOC(_IOC_NONE, 'P', 2, sizeof(struct privcmd_mmap))
 #define IOCTL_PRIVCMD_MMAPBATCH					\
 	_IOC(_IOC_NONE, 'P', 3, sizeof(struct privcmd_mmapbatch))
+#define IOCTL_PRIVCMD_MMAPBATCH_V2				\
+	_IOC(_IOC_NONE, 'P', 4, sizeof(struct privcmd_mmapbatch_v2))
 
 #endif /* __LINUX_PUBLIC_PRIVCMD_H__ */
-- 
1.6.2.5

