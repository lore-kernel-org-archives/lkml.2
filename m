Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2IQUaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:30:05 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53330 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2IQUaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:30:00 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        Trond.Myklebust@netapp.com
Subject: [PATCH 2/2] vfs: dcache: use DCACHE_DENTRY_KILLED instead of DCACHE_DISCONNECTED in d_kill()
References: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu>
Date: Mon, 17 Sep 2012 22:31:38 +0200
In-Reply-To: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Mon, 17 Sep 2012 22:23:30 +0200")
Message-ID: <87txuwz905.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

IBM reported a soft lockup after applying the fix for the rename_lock deadlock.
Commit c83ce989 ("VFS: Fix the nfs sillyrename regression in kernel 2.6.38") was
found to be the culprit.

The nfs sillyrename fix used DCACHE_DISCONNECTED to indicate that the dentry was
killed.  This flag can be set on non-killed dentries too, which results in
infinite retries when trying to traverse the dentry tree.

This patch introduces a separate flag: DCACHE_DENTRY_KILLED, which is only set
in d_kill() and makes try_to_ascend() test only this flag.

IBM reported successful test results with this patch.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: stable@vger.kernel.org
---
 fs/dcache.c            |    4 ++--
 include/linux/dcache.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2012-09-17 20:04:07.000000000 +0200
+++ linux-2.6/fs/dcache.c	2012-09-17 20:04:21.000000000 +0200
@@ -389,7 +389,7 @@ static struct dentry *d_kill(struct dent
 	 * Inform try_to_ascend() that we are no longer attached to the
 	 * dentry tree
 	 */
-	dentry->d_flags |= DCACHE_DISCONNECTED;
+	dentry->d_flags |= DCACHE_DENTRY_KILLED;
 	if (parent)
 		spin_unlock(&parent->d_lock);
 	dentry_iput(dentry);
@@ -1048,7 +1048,7 @@ static struct dentry *try_to_ascend(stru
 	 * or deletion
 	 */
 	if (new != old->d_parent ||
-		 (old->d_flags & DCACHE_DISCONNECTED) ||
+		 (old->d_flags & DCACHE_DENTRY_KILLED) ||
 		 (!locked && read_seqretry(&rename_lock, seq))) {
 		spin_unlock(&new->d_lock);
 		new = NULL;
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2012-09-17 19:56:19.000000000 +0200
+++ linux-2.6/include/linux/dcache.h	2012-09-17 20:04:21.000000000 +0200
@@ -206,6 +206,8 @@ struct dentry_operations {
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
+#define DCACHE_DENTRY_KILLED	0x100000
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(struct dentry *dentry)
