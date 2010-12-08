Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab0LHBqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:46:17 -0500
Received: from kroah.org ([198.145.64.141]:48732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab0LHBAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:12 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:29 2010
Message-Id: <20101208005729.329684843@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [080/289] NFS: Dont SIGBUS if nfs_vm_page_mkwrite races with a cache invalidation
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit bc4866b6e0b44f8ea0df22a16e5927714beb4983 upstream.

In the case where we lock the page, and then find out that the page has
been thrown out of the page cache, we should just return VM_FAULT_NOPAGE.
This is what block_page_mkwrite() does in these situations.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -551,7 +551,7 @@ static int nfs_vm_page_mkwrite(struct vm
 	struct file *filp = vma->vm_file;
 	struct dentry *dentry = filp->f_path.dentry;
 	unsigned pagelen;
-	int ret = -EINVAL;
+	int ret = VM_FAULT_NOPAGE;
 	struct address_space *mapping;
 
 	dfprintk(PAGECACHE, "NFS: vm_page_mkwrite(%s/%s(%ld), offset %lld)\n",
@@ -567,21 +567,20 @@ static int nfs_vm_page_mkwrite(struct vm
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


