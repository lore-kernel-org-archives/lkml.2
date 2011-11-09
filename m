Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291Ab1KJDXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:23:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934270Ab1KJDXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:23:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:08 2011
Message-Id: <20111109212708.059637008@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [076/262] Revert "NFS: Ensure that writeback_single_inode() calls write_inode() when syncing"
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 59b7c05fffba030e5d9e72324691e2f99aa69b79 upstream.

This reverts commit b80c3cb628f0ebc241b02e38dd028969fb8026a2.

The reverted commit was rendered obsolete by a VFS fix: commit
5547e8aac6f71505d621a612de2fca0dd988b439 (writeback: Update dirty flags in
two steps). We now no longer need to worry about writeback_single_inode()
missing our marking the inode for COMMIT in 'do_writepages()' call.

Reverting this patch, fixes a performance regression in which the inode
would continuously get queued to the dirty list, causing the writeback
code to unnecessarily try to send a COMMIT.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -428,7 +428,6 @@ static void
 nfs_mark_request_dirty(struct nfs_page *req)
 {
 	__set_page_dirty_nobuffers(req->wb_page);
-	__mark_inode_dirty(req->wb_page->mapping->host, I_DIRTY_DATASYNC);
 }
 
 #if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
@@ -762,6 +761,8 @@ int nfs_updatepage(struct file *file, st
 	status = nfs_writepage_setup(ctx, page, offset, count);
 	if (status < 0)
 		nfs_set_pageerror(page);
+	else
+		__set_page_dirty_nobuffers(page);
 
 	dprintk("NFS:       nfs_updatepage returns %d (isize %lld)\n",
 			status, (long long)i_size_read(inode));


