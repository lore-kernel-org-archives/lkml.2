Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211Ab0HFWn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:43:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762178Ab0HFWg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:36:26 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 13/38] fallthru: Basic fallthru definitions
Date: Fri,  6 Aug 2010 15:34:59 -0700
Message-Id: <1281134124-17041-14-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the fallthru dcache flag and file system op.  Mask out the
DCACHE_FALLTHRU flag on dentry creation.  Actual users and changes to
lookup come in later patches.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 Documentation/filesystems/vfs.txt |    6 ++++++
 fs/dcache.c                       |    2 +-
 include/linux/dcache.h            |    7 +++++++
 include/linux/fs.h                |    2 ++
 4 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 964e0fc..bbaefa9 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -320,6 +320,7 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
 	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
+	int (*fallthru) (struct inode *, struct dentry *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*readlink) (struct dentry *, char __user *,int);
@@ -390,6 +391,11 @@ otherwise noted.
         second is the dentry for the whiteout itself.  This method
         must unlink() or rmdir() the original entry if it exists.
 
+  fallthru: called by the readdir(2) system call on a layered file
+        system.  Only required if you want to support fallthrus.
+        Fallthrus are place-holders for directory entries visible from
+        a lower level file system.
+
   rename: called by the rename(2) system call to rename the object to
 	have the parent and name given by the second inode and dentry.
 
diff --git a/fs/dcache.c b/fs/dcache.c
index 79b9f6a..249d077 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -992,7 +992,7 @@ EXPORT_SYMBOL(d_alloc_name);
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	if (inode) {
-		dentry->d_flags &= ~DCACHE_WHITEOUT;
+		dentry->d_flags &= ~(DCACHE_WHITEOUT|DCACHE_FALLTHRU);
 		list_add(&dentry->d_alias, &inode->i_dentry);
 	}
 	dentry->d_inode = inode;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 7d650a2..0904716 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -190,6 +190,8 @@ d_iput:		no		no		no       yes
 
 #define DCACHE_WHITEOUT		0x0200	/* Stop lookup in a unioned file system */
 
+#define DCACHE_FALLTHRU		0x0400	/* Continue lookup below an opaque dir */
+
 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
 
@@ -379,6 +381,11 @@ static inline int d_is_whiteout(struct dentry *dentry)
 	return (dentry->d_flags & DCACHE_WHITEOUT);
 }
 
+static inline int d_is_fallthru(struct dentry *dentry)
+{
+	return (dentry->d_flags & DCACHE_FALLTHRU);
+}
+
 static inline struct dentry *dget_parent(struct dentry *dentry)
 {
 	struct dentry *ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1dbe156..71ee74e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -210,6 +210,7 @@ struct inodes_stat_t {
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
 #define MS_WHITEOUT	(1<<25) /* FS supports whiteout filetype */
+#define MS_FALLTHRU	(1<<26) /* FS supports fallthru filetype */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
@@ -1534,6 +1535,7 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
 	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
+	int (*fallthru) (struct inode *, struct dentry *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*readlink) (struct dentry *, char __user *,int);
-- 
1.6.3.3

