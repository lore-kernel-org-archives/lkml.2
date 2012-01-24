Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2AXCnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:43:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab2AXCnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:43:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:26 2012
Message-Id: <20120124023926.039890456@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josef Bacik <josef@redhat.com>,
        Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        NeilBrown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [024/129] NFS - fix recent breakage to NFS error handling.
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1795
Lines: 54

From: NeilBrown <neilb@suse.de>

commit 2edb6bc3852c681c0d948245bd55108dc6407604 upstream.

	From c6d615d2b97fe305cbf123a8751ced859dca1d5e Mon Sep 17 00:00:00 2001
	From: NeilBrown <neilb@suse.de>
	Date: Wed, 16 Nov 2011 09:39:05 +1100
	Subject: NFS - fix recent breakage to NFS error handling.

commit 02c24a82187d5a628c68edfe71ae60dc135cd178 made a small and
presumably unintended change to write error handling in NFS.

Previously an error from filemap_write_and_wait_range would only be of
interest if nfs_file_fsync did not return an error.  After this commit,
an error from filemap_write_and_wait_range would mean that (the rest of)
nfs_file_fsync would not even be called.

This means that:
 1/ you are more likely to see EIO than e.g. EDQUOT or ENOSPC.
 2/ NFS_CONTEXT_ERROR_WRITE remains set for longer so more writes are
    synchronous.

This patch restores previous behaviour.

Cc: Josef Bacik <josef@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -272,13 +272,13 @@ nfs_file_fsync(struct file *file, loff_t
 			datasync);
 
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (ret)
-		return ret;
 	mutex_lock(&inode->i_mutex);
 
 	nfs_inc_stats(inode, NFSIOS_VFSFSYNC);
 	have_error = test_and_clear_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 	status = nfs_commit_inode(inode, FLUSH_SYNC);
+	if (status >= 0 && ret < 0)
+		status = ret;
 	have_error |= test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 	if (have_error)
 		ret = xchg(&ctx->error, 0);


