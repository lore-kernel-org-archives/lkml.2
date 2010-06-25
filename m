Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0FYTP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563Ab0FYTGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:06:04 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 07/38] whiteout: Set S_OPAQUE inode flag when creating directories
Date: Fri, 25 Jun 2010 12:04:57 -0700
Message-Id: <1277492728-11446-8-git-send-email-vaurora@redhat.com>
In-Reply-To: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
References: <1277492728-11446-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

In case of an union directory we don't want that the directories on lower
layers of the union "show through". So to prevent that the contents of
underlying directories magically shows up after a mkdir() we set the S_OPAQUE
flag if directories are created where a whiteout existed before.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c         |   11 ++++++++++-
 include/linux/fs.h |    3 +++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 2c723e2..8c67636 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2107,6 +2107,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, int, mode, unsigned, dev)
 int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	int error = may_create(dir, dentry);
+	int opaque = 0;
 
 	if (error)
 		return error;
@@ -2119,9 +2120,17 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (error)
 		return error;
 
+	if (d_is_whiteout(dentry))
+		opaque = 1;
+
 	error = dir->i_op->mkdir(dir, dentry, mode);
-	if (!error)
+	if (!error) {
 		fsnotify_mkdir(dir, dentry);
+		if (opaque) {
+			dentry->d_inode->i_flags |= S_OPAQUE;
+			mark_inode_dirty(dentry->d_inode);
+		}
+	}
 	return error;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7afdbd4..e9aa650 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -236,6 +236,7 @@ struct inodes_stat_t {
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_OPAQUE	1024	/* Directory is opaque */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -271,6 +272,8 @@ struct inodes_stat_t {
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
 
+#define IS_OPAQUE(inode)	((inode)->i_flags & S_OPAQUE)
+
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
 
-- 
1.6.3.3

