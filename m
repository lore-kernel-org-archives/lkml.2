Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0LMAYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:24:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44819 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab0LLXpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:44 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: Trond.Myklebust@netapp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [43/223] NFS: Don't SIGBUS if nfs_vm_page_mkwrite races with a cache invalidation
Message-Id: <20101212234540.26060B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit bc4866b6e0b44f8ea0df22a16e5927714beb4983 upstream.

In the case where we lock the page, and then find out that the page has
been thrown out of the page cache, we should just return VM_FAULT_NOPAGE.
This is what block_page_mkwrite() does in these situations.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/file.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: linux/fs/nfs/file.c
===================================================================
--- linux.orig/fs/nfs/file.c
+++ linux/fs/nfs/file.c
@@ -560,7 +560,7 @@ static int nfs_vm_page_mkwrite(struct vm
 	struct file *filp = vma->vm_file;
 	struct dentry *dentry = filp->f_path.dentry;
 	unsigned pagelen;
-	int ret = -EINVAL;
+	int ret = VM_FAULT_NOPAGE;
 	struct address_space *mapping;
 
 	dfprintk(PAGECACHE, "NFS: vm_page_mkwrite(%s/%s(%ld), offset %lld)\n",
@@ -576,21 +576,20 @@ static int nfs_vm_page_mkwrite(struct vm
 	if (mapping != dentry->d_inode->i_mapping)
 		goto out_unlock;
 
-	ret = 0;
 	pagelen = nfs_page_length(page);
 	if (pagelen == 0)
 		goto out_unlock;
 
-	ret = nfs_flush_incompatible(filp, page);
-	if (ret != 0)
-		goto out_unlock;
+	ret = VM_FAULT_LOCKED;
+	if (nfs_flush_incompatible(filp, page) == 0 &&
+	    nfs_updatepage(filp, page, 0, pagelen) == 0)
+		goto out;
 
-	ret = nfs_updatepage(filp, page, 0, pagelen);
+	ret = VM_FAULT_SIGBUS;
 out_unlock:
-	if (!ret)
-		return VM_FAULT_LOCKED;
 	unlock_page(page);
-	return VM_FAULT_SIGBUS;
+out:
+	return ret;
 }
 
 static const struct vm_operations_struct nfs_file_vm_ops = {
