Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1JFEyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 00:54:37 -0400
Received: from cobra.newdream.net ([66.33.216.30]:55755 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1JFEyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 00:54:35 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: hch@infradead.org, ceph-devel@vger.kernel.org, rwheeler@redhat.com,
        linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH] vfs: add d_prune dentry operation
Date: Wed,  5 Oct 2011 21:26:10 -0700
Message-Id: <1317875170-9349-2-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1317875170-9349-1-git-send-email-sage@newdream.net>
References: <1317875170-9349-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a d_prune dentry operation that is called by the VFS prior to
pruning (i.e. unhashing and killing) a hashed dentry from the dcache.  This
will be used by Ceph to maintain a flag indicating whether the complete
contents of a directory are contained in the dcache, allowing it to satisfy
lookups and readdir without addition server communication.

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
index fbdcbca..84e1756 100644
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
1.7.2.5

