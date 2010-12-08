Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab0LHBnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:43:03 -0500
Received: from kroah.org ([198.145.64.141]:48792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab0LHBA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:28 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:30 2010
Message-Id: <20101208005730.641509513@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [093/289] reiserfs: dont acquire lock recursively in reiserfs_acl_chmod
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 fs/reiserfs/xattr_acl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
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


