Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1CPVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:25:57 -0400
Received: from kroah.org ([198.145.64.141]:42673 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab1CPVMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/50] debugfs: Fix filesystem reference counting on debugfs_remove() failure
Date: Wed, 16 Mar 2011 14:11:07 -0700
Message-Id: <1300309888-5028-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

When __debugfs_remove() fails (because simple_rmdir() fails e.g. when a
directory is not empty), we must not decrement use count of the filesystem
as nothing was in fact deleted.

This fixes use after free caused by debugfs in some cases.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/inode.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index d38c88f..e7a7a2f 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -307,7 +307,7 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_symlink);
 
-static void __debugfs_remove(struct dentry *dentry, struct dentry *parent)
+static int __debugfs_remove(struct dentry *dentry, struct dentry *parent)
 {
 	int ret = 0;
 
@@ -330,6 +330,7 @@ static void __debugfs_remove(struct dentry *dentry, struct dentry *parent)
 			dput(dentry);
 		}
 	}
+	return ret;
 }
 
 /**
@@ -348,7 +349,8 @@ static void __debugfs_remove(struct dentry *dentry, struct dentry *parent)
 void debugfs_remove(struct dentry *dentry)
 {
 	struct dentry *parent;
-	
+	int ret;
+
 	if (!dentry)
 		return;
 
@@ -357,9 +359,10 @@ void debugfs_remove(struct dentry *dentry)
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
1.7.4.1

