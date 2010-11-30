Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0K3VJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:09:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39748 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0K3VJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:09:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ixUfzemwYcnVR4T2n7KCxJxuqa1Yqof7rAmlHxr9e4McAkYiSGFeIFP+gKTv3lj3HK
         VgQMNDPD6iP3ShhZcMsCfat+hJ+jTd30K8uIwj/f3mW7rgGZrFc8h5sMPQ5ulHHIJWck
         BCM1X13R8TRMSZm7qcHJCRjsgL79+4EXxqxL0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>, "2.6.32.x" <stable@kernel.org>
Subject: [PATCH] reiserfs: Don't acquire lock recursively in reiserfs_acl_chmod
Date: Tue, 30 Nov 2010 22:09:09 +0100
Message-Id: <1291151349-12760-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_acl_chmod() can be called by reiserfs_set_attr() and then
take the reiserfs lock a second time. Thereafter it may call
journal_begin() that definetly requires the lock not to be nested
in order to release it before taking the journal mutex because
the reiserfs lock depends on the journal mutex already.

So, prevent from nesting the lock in reiserfs_acl_chmod().

Reported-by: Pawel Zawora <pzawora@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Pawel Zawora <pzawora@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: 2.6.32.x <stable@kernel.org>
---
 fs/reiserfs/xattr_acl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index 536d697..90d2fcb 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -472,7 +472,9 @@ int reiserfs_acl_chmod(struct inode *inode)
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
@@ -482,7 +484,7 @@ int reiserfs_acl_chmod(struct inode *inode)
 			if (error2)
 				error = error2;
 		}
-		reiserfs_write_unlock(inode->i_sb);
+		reiserfs_write_unlock_once(inode->i_sb, depth);
 	}
 	posix_acl_release(clone);
 	return error;
-- 
1.7.3.2

