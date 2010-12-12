Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0LMAWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:22:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44878 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab0LLXpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:53 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: fweisbec@gmail.com, pzawora@gmail.com, jeffm@suse.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [54/223] reiserfs: don't acquire lock recursively in reiserfs_acl_chmod
Message-Id: <20101212234551.C561DB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Frederic Weisbecker <fweisbec@gmail.com>

commit 238af8751f64a75f8b638193353b1c31ea32e738 upstream.

reiserfs_acl_chmod() can be called by reiserfs_set_attr() and then take
the reiserfs lock a second time.  Thereafter it may call journal_begin()
that definitely requires the lock not to be nested in order to release
it before taking the journal mutex because the reiserfs lock depends on
the journal mutex already.

So, aviod nesting the lock in reiserfs_acl_chmod().

Reported-by: Pawel Zawora <pzawora@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Pawel Zawora <pzawora@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/reiserfs/xattr_acl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux/fs/reiserfs/xattr_acl.c
===================================================================
--- linux.orig/fs/reiserfs/xattr_acl.c
+++ linux/fs/reiserfs/xattr_acl.c
@@ -472,7 +472,9 @@ int reiserfs_acl_chmod(struct inode *ino
 		struct reiserfs_transaction_handle th;
 		size_t size = reiserfs_xattr_nblocks(inode,
 					     reiserfs_acl_size(clone->a_count));
-		reiserfs_write_lock(inode->i_sb);
+		int depth;
+
+		depth = reiserfs_write_lock_once(inode->i_sb);
 		error = journal_begin(&th, inode->i_sb, size * 2);
 		if (!error) {
 			int error2;
@@ -482,7 +484,7 @@ int reiserfs_acl_chmod(struct inode *ino
 			if (error2)
 				error = error2;
 		}
-		reiserfs_write_unlock(inode->i_sb);
+		reiserfs_write_unlock_once(inode->i_sb, depth);
 	}
 	posix_acl_release(clone);
 	return error;
