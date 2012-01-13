Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab2AMRHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 12:07:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57437 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536Ab2AMRHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 12:07:05 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, htejun@gmail.com,
        david.henningsson@canonical.com, smcnam@gmail.com,
        gmane@colin.guthr.ie, jamescaldwell1@gmail.com,
        s.maddox@lantizia.me.uk, mszeredi@suse.cz
Subject: [PATCH 2/2] cuse: implement memory mapping
Date: Fri, 13 Jan 2012 18:06:39 +0100
Message-Id: <1326474399-27278-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1326474399-27278-1-git-send-email-miklos@szeredi.hu>
References: <1326474399-27278-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

This implements memory mapping of char devices.

Unlike memory maps for regular files this needs to allow more than one
mapping to be associated with an open device.

Tha mapping is identified by a 64bit map ID.  This is used in place of
the node ID in the STORE and RETRIEVE notifications.

Original patch by Tejun Heo.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/cuse.c       |  420 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/fuse/dev.c        |    2 +
 fs/fuse/fuse_i.h     |    7 +
 fs/fuse/inode.c      |    1 +
 include/linux/fuse.h |   25 +++
 5 files changed, 454 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 53df9fe..fc75f01 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -48,6 +48,8 @@
 #include <linux/spinlock.h>
 #include <linux/stat.h>
 #include <linux/module.h>
+#include <linux/mman.h>
+#include <linux/pagemap.h>
 
 #include "fuse_i.h"
 
@@ -174,6 +176,419 @@ static long cuse_file_compat_ioctl(struct file *file, unsigned int cmd,
 	return fuse_do_ioctl(file, cmd, arg, flags);
 }
 
+struct fuse_dmmap_region {
+	u64 mapid;
+	u64 size;
+	pgoff_t nr_pages;
+	struct page **pages;
+	struct list_head list;
+	atomic_t ref;
+};
+
+/*
+ * fuse_dmmap_vm represents the result of a single mmap() call, which
+ * can be shared by multiple client vmas created by forking.
+ */
+struct fuse_dmmap_vm {
+	atomic_t open_count;
+	struct fuse_dmmap_region *region;
+};
+
+static void fuse_dmmap_region_put(struct fuse_conn *fc,
+				  struct fuse_dmmap_region *fdr)
+{
+	if (atomic_dec_and_lock(&fdr->ref, &fc->lock)) {
+		pgoff_t idx;
+
+		list_del(&fdr->list);
+		spin_unlock(&fc->lock);
+
+		for (idx = 0; idx < fdr->nr_pages; idx++)
+			if (fdr->pages[idx])
+				put_page(fdr->pages[idx]);
+
+		kfree(fdr->pages);
+		kfree(fdr);
+	}
+}
+
+static void fuse_dmmap_vm_open(struct vm_area_struct *vma)
+{
+	struct fuse_dmmap_vm *fdvm = vma->vm_private_data;
+
+	/* vma copied */
+	atomic_inc(&fdvm->open_count);
+}
+
+static void fuse_dmmap_vm_close(struct vm_area_struct *vma)
+{
+	struct fuse_dmmap_vm *fdvm = vma->vm_private_data;
+	struct fuse_file *ff = vma->vm_file->private_data;
+	struct fuse_conn *fc = ff->fc;
+	struct fuse_req *req;
+	struct fuse_munmap_in *inarg;
+
+	if (!atomic_dec_and_test(&fdvm->open_count))
+		return;
+	/*
+	 * Notify server that the mmap region has been unmapped.
+	 * Failing this might lead to resource leak in server, don't
+	 * fail.
+	 */
+	req = fuse_get_req_nofail(fc, vma->vm_file);
+	inarg = &req->misc.munmap_in;
+
+	inarg->fh = ff->fh;
+	inarg->mapid = fdvm->region->mapid;
+	inarg->size = fdvm->region->size;
+
+	req->in.h.opcode = FUSE_MUNMAP;
+	req->in.h.nodeid = ff->nodeid;
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(*inarg);
+	req->in.args[0].value = inarg;
+
+	fuse_request_send(fc, req);
+	fuse_dmmap_region_put(fc, fdvm->region);
+	kfree(fdvm);
+}
+
+static struct page *fuse_dmmap_find_or_create_page(struct fuse_conn *fc,
+					   struct fuse_dmmap_region *fdr,
+					   pgoff_t index)
+{
+	struct page *new_page = NULL;
+	struct page *page;
+
+	BUG_ON(index >= fdr->nr_pages);
+
+	spin_lock(&fc->lock);
+	page = fdr->pages[index];
+	if (!page) {
+		spin_unlock(&fc->lock);
+		/* need to allocate and install a new page */
+		new_page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
+		if (!new_page)
+			return NULL;
+
+		/* try to install, check whether someone else already did it */
+		spin_lock(&fc->lock);
+		page = fdr->pages[index];
+		if (!page) {
+			page = fdr->pages[index] = new_page;
+			new_page = NULL;
+		}
+	}
+	get_page(page);
+	spin_unlock(&fc->lock);
+
+	if (new_page)
+		put_page(new_page);
+
+	return page;
+}
+
+static int fuse_dmmap_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct fuse_dmmap_vm *fdvm = vma->vm_private_data;
+	struct fuse_dmmap_region *fdr = fdvm->region;
+	struct fuse_file *ff = vma->vm_file->private_data;
+	struct fuse_conn *fc = ff->fc;
+
+	if (vmf->pgoff >= fdr->nr_pages)
+		return VM_FAULT_SIGBUS;
+
+	vmf->page = fuse_dmmap_find_or_create_page(fc, fdr, vmf->pgoff);
+	if (!vmf->page)
+		return VM_FAULT_OOM;
+
+	return 0;
+}
+
+static const struct vm_operations_struct fuse_dmmap_vm_ops = {
+	.open		= fuse_dmmap_vm_open,
+	.close		= fuse_dmmap_vm_close,
+	.fault		= fuse_dmmap_vm_fault,
+};
+
+static struct fuse_dmmap_region *fuse_dmmap_find_locked(struct fuse_conn *fc,
+							u64 mapid)
+{
+	struct fuse_dmmap_region *curr;
+	struct fuse_dmmap_region *fdr = NULL;
+
+	list_for_each_entry(curr, &fc->dmmap_list, list) {
+		if (curr->mapid == mapid) {
+			fdr = curr;
+			atomic_inc(&fdr->ref);
+			break;
+		}
+	}
+
+	return fdr;
+}
+
+static struct fuse_dmmap_region *fuse_dmmap_find(struct fuse_conn *fc,
+						 u64 mapid)
+{
+	struct fuse_dmmap_region *fdr;
+
+	spin_lock(&fc->lock);
+	fdr = fuse_dmmap_find_locked(fc, mapid);
+	spin_unlock(&fc->lock);
+
+	return fdr;
+}
+
+static struct fuse_dmmap_region *fuse_dmmap_get(struct fuse_conn *fc,
+						u64 mapid, u64 size)
+{
+	struct fuse_dmmap_region *fdr;
+	pgoff_t nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
+	if ((loff_t) (nr_pages << PAGE_SHIFT) < size)
+		return ERR_PTR(-EIO);
+
+	fdr = fuse_dmmap_find(fc, mapid);
+	if (fdr) {
+		if (fdr->size != size) {
+			fuse_dmmap_region_put(fc, fdr);
+			return ERR_PTR(-EIO);
+		}
+	} else {
+		struct fuse_dmmap_region *tmp;
+
+		fdr = kzalloc(sizeof(struct fuse_dmmap_region), GFP_KERNEL);
+		if (!fdr)
+			return ERR_PTR(-ENOMEM);
+
+		atomic_set(&fdr->ref, 1);
+		fdr->mapid = mapid;
+		fdr->size = size;
+		fdr->nr_pages = nr_pages;
+
+		fdr->pages = kzalloc(sizeof(struct page *) * nr_pages,
+				     GFP_KERNEL);
+		if (!fdr->pages) {
+			kfree(fdr);
+			return ERR_PTR(-ENOMEM);
+		}
+
+		spin_lock(&fc->lock);
+		tmp = fuse_dmmap_find_locked(fc, mapid);
+		if (tmp) {
+			kfree(fdr->pages);
+			kfree(fdr);
+			fdr = tmp;
+		} else {
+			list_add(&fdr->list, &fc->dmmap_list);
+		}
+		spin_unlock(&fc->lock);
+	}
+
+	return fdr;
+}
+
+static int cuse_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
+	struct fuse_dmmap_vm *fdvm;
+	struct fuse_dmmap_region *fdr;
+	struct fuse_req *req = NULL;
+	struct fuse_mmap_in inarg;
+	struct fuse_mmap_out outarg;
+	int err;
+
+	if (fc->no_dmmap)
+		return -ENOSYS;
+
+	req = fuse_get_req(fc);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	/* ask server whether this mmap is okay and what the offset should be */
+	memset(&inarg, 0, sizeof(inarg));
+	inarg.fh = ff->fh;
+	inarg.addr = vma->vm_start;
+	inarg.len = vma->vm_end - vma->vm_start;
+	inarg.prot = ((vma->vm_flags & VM_READ) ? PROT_READ : 0) |
+		     ((vma->vm_flags & VM_WRITE) ? PROT_WRITE : 0) |
+		     ((vma->vm_flags & VM_EXEC) ? PROT_EXEC : 0);
+	inarg.flags = ((vma->vm_flags & VM_GROWSDOWN) ? MAP_GROWSDOWN : 0) |
+		      ((vma->vm_flags & VM_DENYWRITE) ? MAP_DENYWRITE : 0) |
+		      ((vma->vm_flags & VM_EXECUTABLE) ? MAP_EXECUTABLE : 0) |
+		      ((vma->vm_flags & VM_LOCKED) ? MAP_LOCKED : 0);
+	inarg.offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
+
+	req->in.h.opcode = FUSE_MMAP;
+	req->in.h.nodeid = ff->nodeid;
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(inarg);
+	req->in.args[0].value = &inarg;
+	req->out.numargs = 1;
+	req->out.args[0].size = sizeof(outarg);
+	req->out.args[0].value = &outarg;
+
+	fuse_request_send(fc, req);
+	err = req->out.h.error;
+	if (err) {
+		if (err == -ENOSYS)
+			fc->no_dmmap = 1;
+		goto free_req;
+	}
+
+	fdr = fuse_dmmap_get(fc, outarg.mapid, outarg.size);
+	err = PTR_ERR(fdr);
+	if (IS_ERR(fdr))
+		goto free_req;
+
+	err = -ENOMEM;
+	fdvm = kzalloc(sizeof(*fdvm), GFP_KERNEL);
+	if (!fdvm) {
+		fuse_dmmap_region_put(fc, fdr);
+		goto free_req;
+	}
+	atomic_set(&fdvm->open_count, 1);
+	fdvm->region = fdr;
+
+	vma->vm_ops = &fuse_dmmap_vm_ops;
+	vma->vm_private_data = fdvm;
+	vma->vm_flags |= VM_DONTEXPAND;		/* disallow expansion for now */
+	err = 0;
+
+free_req:
+	fuse_put_request(fc, req);
+	return err;
+}
+
+static int fuse_notify_store_to_dmmap(struct fuse_conn *fc,
+				      struct fuse_copy_state *cs,
+				      u64 nodeid, u32 size, u64 pos)
+{
+	struct fuse_dmmap_region *fdr;
+	pgoff_t index;
+	unsigned int off;
+	int err;
+
+	fdr = fuse_dmmap_find(fc, nodeid);
+	if (!fdr)
+		return -ENOENT;
+
+	index = pos >> PAGE_SHIFT;
+	off = pos & ~PAGE_MASK;
+	if (pos > fdr->size)
+		size = 0;
+	else if (size > fdr->size - pos)
+		size = fdr->size - pos;
+
+	while (size) {
+		struct page *page;
+		unsigned int this_num;
+
+		err = -ENOMEM;
+		page = fuse_dmmap_find_or_create_page(fc, fdr, index);
+		if (!page)
+			goto out_iput;
+
+		this_num = min_t(unsigned, size, PAGE_SIZE - off);
+		err = fuse_copy_page(cs, &page, off, this_num, 0);
+		put_page(page);
+
+		if (err)
+			goto out_iput;
+
+		size -= this_num;
+		off = 0;
+		index++;
+	}
+
+	err = 0;
+
+out_iput:
+	fuse_dmmap_region_put(fc, fdr);
+
+	return err;
+}
+
+static void fuse_retrieve_dmmap_end(struct fuse_conn *fc, struct fuse_req *req)
+{
+	release_pages(req->pages, req->num_pages, 0);
+}
+
+static int fuse_notify_retrieve_from_dmmap(struct fuse_conn *fc,
+				struct fuse_notify_retrieve_out *outarg)
+{
+	struct fuse_dmmap_region *fdr;
+	struct fuse_req *req;
+	pgoff_t index;
+	unsigned int num;
+	unsigned int offset;
+	size_t total_len = 0;
+	int err;
+
+	fdr = fuse_dmmap_find(fc, outarg->nodeid);
+	if (!fdr)
+		return -ENOENT;
+
+	req = fuse_get_req(fc);
+	err = PTR_ERR(req);
+	if (IS_ERR(req))
+		goto out_put_region;
+
+	offset = outarg->offset & ~PAGE_MASK;
+
+	req->in.h.opcode = FUSE_NOTIFY_REPLY;
+	req->in.h.nodeid = outarg->nodeid;
+	req->in.numargs = 2;
+	req->in.argpages = 1;
+	req->page_offset = offset;
+	req->end = fuse_retrieve_dmmap_end;
+
+	index = outarg->offset >> PAGE_SHIFT;
+	num = outarg->size;
+	if (outarg->offset > fdr->size)
+		num = 0;
+	else if (outarg->offset + num > fdr->size)
+		num = fdr->size - outarg->offset;
+
+	while (num && req->num_pages < FUSE_MAX_PAGES_PER_REQ) {
+		struct page *page;
+		unsigned int this_num;
+
+		BUG_ON(index >= fdr->nr_pages);
+		spin_lock(&fc->lock);
+		page = fdr->pages[index];
+		if (!page)
+			page = ZERO_PAGE(0);
+		get_page(page);
+		spin_unlock(&fc->lock);
+
+		this_num = min_t(unsigned, num, PAGE_SIZE - offset);
+		req->pages[req->num_pages] = page;
+		req->num_pages++;
+
+		num -= this_num;
+		total_len += this_num;
+		index++;
+	}
+	req->misc.retrieve_in.offset = outarg->offset;
+	req->misc.retrieve_in.size = total_len;
+	req->in.args[0].size = sizeof(req->misc.retrieve_in);
+	req->in.args[0].value = &req->misc.retrieve_in;
+	req->in.args[1].size = total_len;
+
+	err = fuse_request_send_notify_reply(fc, req, outarg->notify_unique);
+	if (err)
+		fuse_retrieve_dmmap_end(fc, req);
+
+out_put_region:
+	fuse_dmmap_region_put(fc, fdr);
+
+	return err;
+}
+
+
 static const struct file_operations cuse_frontend_fops = {
 	.owner			= THIS_MODULE,
 	.read			= cuse_read,
@@ -183,7 +598,8 @@ static const struct file_operations cuse_frontend_fops = {
 	.unlocked_ioctl		= cuse_file_ioctl,
 	.compat_ioctl		= cuse_file_compat_ioctl,
 	.poll			= fuse_file_poll,
-	.llseek		= noop_llseek,
+	.llseek			= noop_llseek,
+	.mmap			= cuse_mmap,
 };
 
 
@@ -463,6 +879,8 @@ static void cuse_fc_release(struct fuse_conn *fc)
 
 static const struct fuse_conn_operations cuse_ops = {
 	.release = cuse_fc_release,
+	.notify_store = fuse_notify_store_to_dmmap,
+	.notify_retrieve = fuse_notify_retrieve_from_dmmap,
 };
 
 /**
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index f1f5994..e1b7a06 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -480,6 +480,7 @@ int fuse_request_send_notify_reply(struct fuse_conn *fc,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(fuse_request_send_notify_reply);
 
 /*
  * Called under fc->lock
@@ -850,6 +851,7 @@ int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
 		flush_dcache_page(page);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(fuse_copy_page);
 
 /* Copy pages in the request to/from userspace buffer */
 static int fuse_copy_pages(struct fuse_copy_state *cs, unsigned nbytes,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 9542f5b..c878fa9 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -285,6 +285,7 @@ struct fuse_req {
 		} write;
 		struct fuse_notify_retrieve_in retrieve_in;
 		struct fuse_lk_in lk_in;
+		struct fuse_munmap_in munmap_in;
 	} misc;
 
 	/** page vector */
@@ -484,6 +485,9 @@ struct fuse_conn {
 	/** Is poll not implemented by fs? */
 	unsigned no_poll:1;
 
+	/** Is direct mmap not implemente by fs? */
+	unsigned no_dmmap:1;
+
 	/** Do multi-page cached writes */
 	unsigned big_writes:1;
 
@@ -532,6 +536,9 @@ struct fuse_conn {
 	/** Read/write semaphore to hold when accessing sb. */
 	struct rw_semaphore killsb;
 
+	/** List of direct mmaps (currently CUSE only) */
+	struct list_head dmmap_list;
+
 	/** Operations that fuse and cuse can implement differently */
 	const struct fuse_conn_operations *ops;
 };
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 4bf887f..7ffb64a 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -542,6 +542,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	fc->blocked = 1;
 	fc->attr_version = 1;
 	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
+	INIT_LIST_HEAD(&fc->dmmap_list);
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 8ba2c94..bc18853 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -54,6 +54,7 @@
  * 7.18
  *  - add FUSE_IOCTL_DIR flag
  *  - add FUSE_NOTIFY_DELETE
+ *  - add FUSE_MMAP and FUSE_MUNMAP
  */
 
 #ifndef _LINUX_FUSE_H
@@ -278,6 +279,8 @@ enum fuse_opcode {
 	FUSE_POLL          = 40,
 	FUSE_NOTIFY_REPLY  = 41,
 	FUSE_BATCH_FORGET  = 42,
+	FUSE_MMAP          = 43,
+	FUSE_MUNMAP        = 44,
 
 	/* CUSE specific operations */
 	CUSE_INIT          = 4096,
@@ -571,6 +574,28 @@ struct fuse_notify_poll_wakeup_out {
 	__u64	kh;
 };
 
+struct fuse_mmap_in {
+	__u64	fh;
+	__u64	addr;
+	__u64	len;
+	__u32	prot;
+	__u32	flags;
+	__u64	offset;
+};
+
+struct fuse_mmap_out {
+	__u64	mapid;		/* Mmap ID, same namespace as Inode ID */
+	__u64	size;		/* Size of memory region */
+	__u64	reserved;
+};
+
+struct fuse_munmap_in {
+	__u64	fh;
+	__u64	mapid;
+	__u64	size;		/* Size of memory region */
+	__u64	reserved;
+};
+
 struct fuse_in_header {
 	__u32	len;
 	__u32	opcode;
-- 
1.7.7

