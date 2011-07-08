Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1GHVHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:07:18 -0400
Received: from cobra.newdream.net ([66.33.216.30]:35924 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1GHVHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:07:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=h1T6FFNnEh4rsgIBtgswrVSrz2ggbV636xq3Fmd4eY9YPA0r
	WBnlq5dPCmg32ayDIP5mblEfd74UXbgzb5oXC6dQS/Pb5U7b79bssZMUhES4IVmC
	bucL0ZX2Ny6Qow5CsZTaUq80uE0FwFTagDYG6gCCDgIFEQZUvGTqiiPgIIU=
Date: Fri, 8 Jul 2011 14:10:25 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: add d_prune dentry operation
Message-ID: <Pine.LNX.4.64.1107081409160.1326@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a d_prune dentry operation that is called by the VFS prior to 
pruning (i.e. unhashing and killing) a hashed dentry from the dcache. This 
allows the file system to maintain visibility into the contents and 
consistency of the dcache:

 - dentry eviction/pruning now calls into the fs
 - any modifications (unlink, rename, create, etc.) are protected by 
   i_mutex and call into the fs

This will be used by Ceph to maintain a flag indicating whether the 
complete contents of a directory are contained in the dcache, allowing it 
to satisfy lookups and readdir with cached results without additional 
server communication.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 Documentation/filesystems/Locking |    1 +
 fs/dcache.c                       |    8 ++++++++
 include/linux/dcache.h            |    3 +++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 57d827d..b3fa7c8 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -29,6 +29,7 @@ d_hash		no		no		no		maybe
 d_compare:	yes		no		no		maybe
 d_delete:	no		yes		no		no
 d_release:	no		no		yes		no
+d_prune:        no              yes             no              no
 d_iput:		no		no		yes		no
 d_dname:	no		no		no		no
 d_automount:	no		no		yes		no
diff --git a/fs/dcache.c b/fs/dcache.c
index 37f72ee..74d1a30 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -673,6 +673,8 @@ static void try_prune_one_dentry(struct dentry *dentry)
 			spin_unlock(&dentry->d_lock);
 			return;
 		}
+		if (dentry->d_flags & DCACHE_OP_PRUNE)
+			dentry->d_op->d_prune(dentry);
 		dentry = dentry_kill(dentry, 1);
 	}
 }
@@ -879,6 +881,8 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 
 	/* detach this root from the system */
 	spin_lock(&dentry->d_lock);
+	if (dentry->d_flags & DCACHE_OP_PRUNE)
+		dentry->d_op->d_prune(dentry);
 	dentry_lru_del(dentry);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -895,6 +899,8 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 					    d_u.d_child) {
 				spin_lock_nested(&loop->d_lock,
 						DENTRY_D_LOCK_NESTED);
+				if (dentry->d_flags & DCACHE_OP_PRUNE)
+					dentry->d_op->d_prune(dentry);
 				dentry_lru_del(loop);
 				__d_drop(loop);
 				spin_unlock(&loop->d_lock);
@@ -1363,6 +1369,8 @@ void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
 		dentry->d_flags |= DCACHE_OP_REVALIDATE;
 	if (op->d_delete)
 		dentry->d_flags |= DCACHE_OP_DELETE;
+	if (op->d_prune)
+		dentry->d_flags |= DCACHE_OP_PRUNE;
 
 }
 EXPORT_SYMBOL(d_set_d_op);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 19d90a5..681f46f 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -165,6 +165,7 @@ struct dentry_operations {
 			unsigned int, const char *, const struct qstr *);
 	int (*d_delete)(const struct dentry *);
 	void (*d_release)(struct dentry *);
+	void (*d_prune)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *, char *, int);
 	struct vfsmount *(*d_automount)(struct path *);
@@ -219,6 +220,8 @@ struct dentry_operations {
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
+#define DCACHE_OP_PRUNE         0x80000
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(struct dentry *dentry)
-- 
1.7.0

