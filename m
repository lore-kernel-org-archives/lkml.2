Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816Ab1C3WCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:02:49 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43183 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269Ab1C3WB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:01:58 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Sage Weil <sage@newdream.net>
Subject: [PATCH 6/7] libfs: drop unneeded dentry_unhash
Date: Wed, 30 Mar 2011 15:09:27 -0700
Message-Id: <1301522968-4382-7-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1301522968-4382-1-git-send-email-sage@newdream.net>
References: <1301522968-4382-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no libfs issues with dangling references to empty directories.
Replace dentry_unhash() calls with shrink_dcache_parent().

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/libfs.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 91a3710..65aa858 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -311,8 +311,7 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry)
 	if (!simple_empty(dentry))
 		return -ENOTEMPTY;
 
-	dentry_unhash(dentry);
-
+	shrink_dcache_parent(dentry);
 	drop_nlink(dentry->d_inode);
 	simple_unlink(dir, dentry);
 	drop_nlink(dir);
@@ -325,8 +324,8 @@ int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *inode = old_dentry->d_inode;
 	int they_are_dirs = S_ISDIR(old_dentry->d_inode->i_mode);
 
-	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
-		dentry_unhash(new_dentry);
+	if (new_dentry->d_inode && they_are_dirs)
+		shrink_dcache_parent(new_dentry);
 
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
-- 
1.7.0

