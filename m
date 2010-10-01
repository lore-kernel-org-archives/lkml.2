Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab0JASfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:35:08 -0400
Received: from mx2.netapp.com ([216.240.18.37]:38563 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab0JASfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:35:07 -0400
X-IronPort-AV: E=Sophos;i="4.57,267,1283756400"; 
   d="scan'208";a="461498497"
Subject: Re: Odd NFS related SIGBUS (& possible fix)
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <npiggin@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
In-Reply-To: <1285956768.30373.39.camel@heimdal.trondhjem.org>
References: <1285734825.14081.87.camel@pasglop>
	 <1285956768.30373.39.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Fri, 01 Oct 2010 14:35:04 -0400
Message-ID: <1285958104.30373.41.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-OriginalArrivalTime: 01 Oct 2010 18:35:06.0831 (UTC) FILETIME=[5EC7F5F0:01CB6197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 14:12 -0400, Trond Myklebust wrote:
> However, it looks to me as if the right thing to do when the
> page->mapping has changed would be to do the same thing as
> block_page_mkwrite(), and just return VM_FAULT_NOPAGE so that the VM can
> retry the fault.
> IMO: We should only SIGBUS if the calls to nfs_flush_incompatible()
> and/or nfs_updatepage() fail.
> 
> Cheers
>   Trond

IOW: Something like the following patch.

Cheers
  Trond

---------------------------------------------------------------------------
NFS: Don't SIGBUS if nfs_vm_page_mkwrite races with a cache invalidation

From: Trond Myklebust <Trond.Myklebust@netapp.com>

In the case where we lock the page, and then find out that the page has
been thrown out of the page cache, we should just return VM_FAULT_NOPAGE.
This is what block_page_mkwrite() does in these situations.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/file.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)


diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 05bf3c0..6d95e24 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -551,7 +551,7 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct file *filp = vma->vm_file;
 	struct dentry *dentry = filp->f_path.dentry;
 	unsigned pagelen;
-	int ret = -EINVAL;
+	int ret = VM_FAULT_NOPAGE;
 	struct address_space *mapping;
 
 	dfprintk(PAGECACHE, "NFS: vm_page_mkwrite(%s/%s(%ld), offset %lld)\n",
@@ -567,21 +567,20 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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

