Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2BUSKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:10:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab2BUSHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:07:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/73] VFS: Basic fallthru definitions [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>,
        David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 17:59:32 +0000
Message-ID: <20120221175932.25235.24382.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

Define the fallthru dcache flag and file system op.  Mask out the
DCACHE_FALLTHRU flag on dentry creation.

Actual users and changes to lookup come in later patches.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/vfs.txt |    6 ++++++
 fs/dcache.c                       |    2 +-
 include/linux/dcache.h            |    7 +++++++
 include/linux/fs.h                |    2 ++
 4 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 8575c5b..6d9c108 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -350,6 +350,7 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
+	int (*fallthru) (struct inode *, struct dentry *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*readlink) (struct dentry *, char __user *,int);
@@ -421,6 +422,11 @@ otherwise noted.
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
index 60af7b1..b1ce8d1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1311,7 +1311,7 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	spin_lock(&dentry->d_lock);
 	if (inode) {
-		dentry->d_flags &= ~DCACHE_WHITEOUT;
+		dentry->d_flags &= ~(DCACHE_WHITEOUT | DCACHE_FALLTHRU);
 		if (unlikely(IS_AUTOMOUNT(inode)))
 			dentry->d_flags |= DCACHE_NEED_AUTOMOUNT;
 		list_add(&dentry->d_alias, &inode->i_dentry);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index f22f530..cc0181b 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -213,6 +213,8 @@ struct dentry_operations {
 #define DCACHE_FSNOTIFY_PARENT_WATCHED 0x4000
      /* Parent inode is watched by some fsnotify listener */
 
+#define DCACHE_FALLTHRU		0x8000	/* Continue lookup below an opaque dir */
+
 #define DCACHE_MOUNTED		0x10000	/* is a mountpoint */
 #define DCACHE_NEED_AUTOMOUNT	0x20000	/* handle automount on this dir */
 #define DCACHE_MANAGE_TRANSIT	0x40000	/* manage transit from this dirent */
@@ -420,6 +422,11 @@ static inline int d_is_whiteout(struct dentry *dentry)
 	return dentry->d_flags & DCACHE_WHITEOUT;
 }
 
+static inline int d_is_fallthru(struct dentry *dentry)
+{
+	return dentry->d_flags & DCACHE_FALLTHRU;
+}
+
 static inline bool d_mountpoint(struct dentry *dentry)
 {
 	return dentry->d_flags & DCACHE_MOUNTED;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1e4ae06..b5e6658 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -211,6 +211,7 @@ struct inodes_stat_t {
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
 #define MS_WHITEOUT	(1<<25) /* FS supports whiteout filetype */
+#define MS_FALLTHRU	(1<<26) /* FS supports fallthru filetype */
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
@@ -1653,6 +1654,7 @@ struct inode_operations {
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,umode_t,dev_t);
 	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
+	int (*fallthru) (struct inode *, struct dentry *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	void (*truncate) (struct inode *);

