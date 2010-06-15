Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab0FOSte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:49:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758383Ab0FOSlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:41:53 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 13/38] fallthru: Basic fallthru definitions
Date: Tue, 15 Jun 2010 11:39:43 -0700
Message-Id: <1276627208-17242-14-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
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
 include/linux/dcache.h            |    6 ++++++
 include/linux/fs.h                |    1 +
 4 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 8846b4f..29f3476 100644
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
index 3b0e525..b76f9e4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -993,7 +993,7 @@ EXPORT_SYMBOL(d_alloc_name);
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	if (inode) {
-		dentry->d_flags &= ~DCACHE_WHITEOUT;
+		dentry->d_flags &= ~(DCACHE_WHITEOUT|DCACHE_FALLTHRU);
 		list_add(&dentry->d_alias, &inode->i_dentry);
 	}
 	dentry->d_inode = inode;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 630baef..01d6011 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -184,6 +184,7 @@ d_iput:		no		no		no       yes
 
 #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
 #define DCACHE_WHITEOUT		0x0080	/* This negative dentry is a whiteout */
+#define DCACHE_FALLTHRU		0x0100	/* Keep looking in the file system below */
 
 #define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0080 /* Parent inode is watched by some fsnotify listener */
 
@@ -378,6 +379,11 @@ static inline int d_is_whiteout(struct dentry *dentry)
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
index e9aa650..b59cd7b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1532,6 +1532,7 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
 	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
+	int (*fallthru) (struct inode *, struct dentry *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*readlink) (struct dentry *, char __user *,int);
-- 
1.6.3.3

