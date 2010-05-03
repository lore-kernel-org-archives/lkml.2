Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab0ECXUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:20:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab0ECXNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:13:43 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@suse.de>,
       Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 20/39] union-mount: Drive the union cache via dcache
Date: Mon,  3 May 2010 16:12:19 -0700
Message-Id: <1272928358-20854-21-git-send-email-vaurora@redhat.com>
In-Reply-To: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

If a dentry is removed from dentry cache because its usage count drops to
zero, the references to the underlying layer of the unions the dentry is in
are dropped too. Therefore the union cache is driven by the dentry cache.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/dcache.c            |   13 +++++++++++
 fs/union.c             |   56 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |    8 ++++++
 include/linux/mount.h  |    2 +-
 include/linux/union.h  |    4 +++
 5 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 7b47f53..322c1f7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/union.h>
 #include <linux/fsnotify.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -175,6 +176,8 @@ static struct dentry *d_kill(struct dentry *dentry)
 	dentry_stat.nr_dentry--;	/* For d_free, below */
 	/*drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
+	/* If the dentry was in an union delete them */
+	shrink_d_unions(dentry);
 	if (IS_ROOT(dentry))
 		parent = NULL;
 	else
@@ -696,6 +699,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 					iput(inode);
 			}
 
+			shrink_d_unions(dentry);
 			d_free(dentry);
 
 			/* finished when we fall off the top of the tree,
@@ -1535,7 +1539,9 @@ void d_delete(struct dentry * dentry)
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (atomic_read(&dentry->d_count) == 1) {
+		__d_drop_unions(dentry);
 		dentry_iput(dentry);
+		shrink_d_unions(dentry);
 		fsnotify_nameremove(dentry, isdir);
 		return;
 	}
@@ -1546,6 +1552,13 @@ void d_delete(struct dentry * dentry)
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
+	/*
+	 * Remove any associated unions.  While someone still has this
+	 * directory open (ref count > 0), we could not have deleted
+	 * it unless it was empty, and therefore has no references to
+	 * directories below it.  So we don't need the unions.
+	 */
+	shrink_d_unions(dentry);
 	fsnotify_nameremove(dentry, isdir);
 }
 EXPORT_SYMBOL(d_delete);
diff --git a/fs/union.c b/fs/union.c
index 4377cf4..eb664e6 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -14,6 +14,7 @@
 
 #include <linux/bootmem.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/hash.h>
 #include <linux/fs.h>
@@ -235,6 +236,8 @@ int append_to_union(struct path *upper, struct path *lower)
 		union_put(new);
 		return 0;
 	}
+	list_add(&new->u_unions, &upper->dentry->d_unions);
+	lower->dentry->d_union_lower_count++;
 	__union_hash(new);
 	spin_unlock(&union_lock);
 	return 0;
@@ -287,3 +290,56 @@ int union_down_one(struct vfsmount **mnt, struct dentry **dentry)
 	}
 	return 0;
 }
+
+/**
+ * __d_drop_unions  -  remove all this dentry's unions from the union hash table
+ *
+ * @dentry - topmost dentry in the union stack to remove
+ *
+ * This must be called after unhashing a dentry. This is called with
+ * dcache_lock held and unhashes all the unions this dentry is
+ * attached to.
+ */
+void __d_drop_unions(struct dentry *dentry)
+{
+	struct union_dir *this, *next;
+
+	spin_lock(&union_lock);
+	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions)
+		__union_unhash(this);
+	spin_unlock(&union_lock);
+}
+EXPORT_SYMBOL_GPL(__d_drop_unions);
+
+/*
+ * This must be called after __d_drop_unions() without holding any
+ * locks.  Note: The dentry might still be reachable via a lookup but
+ * at that time it already a negative dentry. Otherwise it would be
+ * unhashed. The union_dir structure itself is still reachable through
+ * mnt->mnt_unions (which we protect against with union_lock).
+ *
+ * We were worried about a recursive dput() call through:
+ *
+ * dput()->d_kill()->shrink_d_unions()->union_put()->dput()
+ *
+ * But this path can only be reached if the dentry is unhashed when we
+ * enter the first dput(), and it can only be unhashed if it was
+ * rmdir()'d, and d_delete() calls shrink_d_unions() for us.
+ */
+void shrink_d_unions(struct dentry *dentry)
+{
+	struct union_dir *this, *next;
+
+repeat:
+	spin_lock(&union_lock);
+	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions) {
+		BUG_ON(!hlist_unhashed(&this->u_hash));
+		BUG_ON(!hlist_unhashed(&this->u_rhash));
+		list_del(&this->u_unions);
+		this->u_lower.dentry->d_union_lower_count--;
+		spin_unlock(&union_lock);
+		union_put(this);
+		goto repeat;
+	}
+	spin_unlock(&union_lock);
+}
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 1745881..31656e9 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -223,12 +223,20 @@ extern seqlock_t rename_lock;
  * __d_drop requires dentry->d_lock.
  */
 
+#ifdef CONFIG_UNION_MOUNT
+extern void __d_drop_unions(struct dentry *);
+#endif
+
 static inline void __d_drop(struct dentry *dentry)
 {
 	if (!(dentry->d_flags & DCACHE_UNHASHED)) {
 		dentry->d_flags |= DCACHE_UNHASHED;
 		hlist_del_rcu(&dentry->d_hash);
 	}
+#ifdef CONFIG_UNION_MOUNT
+	/* remove dentry from the union hashtable */
+	__d_drop_unions(dentry);
+#endif
 }
 
 static inline void d_drop(struct dentry *dentry)
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 0517114..13a3818 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -65,7 +65,7 @@ struct vfsmount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 #ifdef CONFIG_UNION_MOUNT
-	struct list_head mnt_unions;	/* list of union_mount structures */
+	struct list_head mnt_unions;	/* list of union_dir structures */
 #endif
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	int mnt_id;			/* mount identifier */
diff --git a/include/linux/union.h b/include/linux/union.h
index d66beb7..70b2adb 100644
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -41,12 +41,16 @@ struct union_dir {
 
 extern int append_to_union(struct path *, struct path*);
 extern int union_down_one(struct vfsmount **, struct dentry **);
+extern void __d_drop_unions(struct dentry *);
+extern void shrink_d_unions(struct dentry *);
 
 #else /* CONFIG_UNION_MOUNT */
 
 #define IS_MNT_UNION(x)			(0)
 #define append_to_union(x, y)		({ BUG(); (0); })
 #define union_down_one(x, y)		({ (0); })
+#define __d_drop_unions(x)		do { } while (0)
+#define shrink_d_unions(x)		do { } while (0)
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.3.3

