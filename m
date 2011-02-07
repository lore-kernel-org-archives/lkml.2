Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1BGOAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:00:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab1BGOAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:00:35 -0500
From: Jan Kara <jack@suse.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] debugfs: Fix filesystem reference counting on debugfs_remove() failure
Date: Mon,  7 Feb 2011 15:00:27 +0100
Message-Id: <1297087227-11480-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __debugfs_remove() fails (because simple_rmdir() fails e.g. when a
directory is not empty), we must not decrement use count of the filesystem
as nothing was in fact deleted.

This fixes use after free caused by debugfs in some cases.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/debugfs/inode.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 37a8ca7..8ddc59a 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -310,7 +310,7 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_symlink);
 
-static void __debugfs_remove(struct dentry *dentry, struct dentry *parent)
+static int __debugfs_remove(struct dentry *dentry, struct dentry *parent)
 {
 	int ret = 0;
 
@@ -333,6 +333,7 @@ static void __debugfs_remove(struct dentry *dentry, struct dentry *parent)
 			dput(dentry);
 		}
 	}
+	return ret;
 }
 
 /**
@@ -351,7 +352,8 @@ static void __debugfs_remove(struct dentry *dentry, struct dentry *parent)
 void debugfs_remove(struct dentry *dentry)
 {
 	struct dentry *parent;
-	
+	int ret;
+
 	if (!dentry)
 		return;
 
@@ -360,9 +362,10 @@ void debugfs_remove(struct dentry *dentry)
 		return;
 
 	mutex_lock(&parent->d_inode->i_mutex);
-	__debugfs_remove(dentry, parent);
+	ret = __debugfs_remove(dentry, parent);
 	mutex_unlock(&parent->d_inode->i_mutex);
-	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+	if (!ret)
+		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 }
 EXPORT_SYMBOL_GPL(debugfs_remove);
 
-- 
1.7.1

