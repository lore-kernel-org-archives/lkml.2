Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1LBSnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:43:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:54496 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab1LBSnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:43:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,285,1320652800"; 
   d="scan'208";a="81618678"
From: Andi Kleen <andi@firstfloor.org>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fengguang.wu@intel.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] VFS: Add event counting to dcache
Date: Fri,  2 Dec 2011 10:43:27 -0800
Message-Id: <1322851407-17182-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
References: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Most self respecting subsystems -- like networking or MM -- have
own counter infrastructure these days. This is useful to understand
the behaviour of a running system. Counters are low enough
overhead that they can be always enabled.

This patch adds event counts to the dcache.

Instead of developing an own counter infrastructure for the VFS
I'm using generic counters implemented in debugfs.

Since we had problems with this recently I instrumented the dcache
RCU code. This is rather tricky code which is difficult to tune,
and some indication on why aborts happen is quite useful.

I'm especially interested in feedback on the placement of the event counters.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/namei.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5008f01..bfbe36a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -33,10 +33,22 @@
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
 #include <linux/posix_acl.h>
+#include <linux/debugfs.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
 
+const char dname[] = "vfs/dcache";
+DEFINE_DEBUGFS_COUNTER(dcache_rcu_root_changed_abort, dname);
+DEFINE_DEBUGFS_COUNTER(dcache_rcu_dir_changed_abort, dname);
+DEFINE_DEBUGFS_COUNTER(dcache_rcu_entry_changed_abort, dname);
+DEFINE_DEBUGFS_COUNTER(dcache_rcu_permission_abort, dname);
+DEFINE_DEBUGFS_COUNTER(dcache_rcu_revalidate_abort, dname);
+DEFINE_DEBUGFS_COUNTER(dcache_ref_walks, dname);
+DEFINE_DEBUGFS_COUNTER(dcache_rcu_walks, dname);
+DEFINE_DEBUGFS_COUNTER(dcache_reval_walks, dname);
+
+
 /* [Feb-1997 T. Schoebel-Theuer]
  * Fundamental changes in the pathname lookup mechanisms (namei)
  * were necessary because of omirr.  The reason is that omirr needs
@@ -430,20 +442,26 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 		want_root = 1;
 		spin_lock(&fs->lock);
 		if (nd->root.mnt != fs->root.mnt ||
-				nd->root.dentry != fs->root.dentry)
+		    nd->root.dentry != fs->root.dentry) {
+			debugfs_counter_inc(dcache_rcu_root_changed_abort);
 			goto err_root;
+		}
 	}
 	spin_lock(&parent->d_lock);
 	if (!dentry) {
-		if (!__d_rcu_to_refcount(parent, nd->seq))
+		if (!__d_rcu_to_refcount(parent, nd->seq)) {
+			debugfs_counter_inc(dcache_rcu_dir_changed_abort);
 			goto err_parent;
+		}
 		BUG_ON(nd->inode != parent->d_inode);
 	} else {
 		if (dentry->d_parent != parent)
 			goto err_parent;
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-		if (!__d_rcu_to_refcount(dentry, nd->seq))
+		if (!__d_rcu_to_refcount(dentry, nd->seq)) {
+			debugfs_counter_inc(dcache_rcu_entry_changed_abort);
 			goto err_child;
+		}
 		/*
 		 * If the sequence check on the child dentry passed, then
 		 * the child has not been removed from its parent. This
@@ -474,6 +492,7 @@ err_parent:
 err_root:
 	if (want_root)
 		spin_unlock(&fs->lock);
+	debugfs_counter_inc(dcache_rcu_root_changed_abort);
 	return -ECHILD;
 }
 
@@ -522,6 +541,7 @@ static int complete_walk(struct nameidata *nd)
 			spin_unlock(&dentry->d_lock);
 			rcu_read_unlock();
 			br_read_unlock(vfsmount_lock);
+			debugfs_counter_inc(dcache_rcu_entry_changed_abort);
 			return -ECHILD;
 		}
 		BUG_ON(nd->inode != dentry->d_inode);
@@ -960,6 +980,7 @@ failed:
 		nd->root.mnt = NULL;
 	rcu_read_unlock();
 	br_read_unlock(vfsmount_lock);
+	debugfs_counter_inc(dcache_rcu_entry_changed_abort);
 	return -ECHILD;
 }
 
@@ -1132,8 +1153,10 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 			goto unlazy;
 
 		/* Memory barrier in read_seqcount_begin of child is enough */
-		if (__read_seqcount_retry(&parent->d_seq, nd->seq))
+		if (__read_seqcount_retry(&parent->d_seq, nd->seq)) {
+			debugfs_counter_inc(dcache_rcu_dir_changed_abort);
 			return -ECHILD;
+		}
 		nd->seq = seq;
 
 		if (unlikely(dentry->d_flags & DCACHE_OP_REVALIDATE)) {
@@ -1141,6 +1164,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 			if (unlikely(status <= 0)) {
 				if (status != -ECHILD)
 					need_reval = 0;
+				debugfs_counter_inc(dcache_rcu_revalidate_abort);
 				goto unlazy;
 			}
 		}
@@ -1226,6 +1250,7 @@ static inline int may_lookup(struct nameidata *nd)
 		int err = inode_permission(nd->inode, MAY_EXEC|MAY_NOT_BLOCK);
 		if (err != -ECHILD)
 			return err;
+		debugfs_counter_inc(dcache_rcu_permission_abort);
 		if (unlazy_walk(nd, NULL))
 			return -ECHILD;
 	}
@@ -1643,10 +1668,15 @@ static int do_path_lookup(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
 {
 	int retval = path_lookupat(dfd, name, flags | LOOKUP_RCU, nd);
-	if (unlikely(retval == -ECHILD))
+	debugfs_counter_inc(dcache_rcu_walks);
+	if (unlikely(retval == -ECHILD)) {
+		debugfs_counter_inc(dcache_ref_walks);
 		retval = path_lookupat(dfd, name, flags, nd);
-	if (unlikely(retval == -ESTALE))
+	}
+	if (unlikely(retval == -ESTALE)) {
+		debugfs_counter_inc(dcache_reval_walks);
 		retval = path_lookupat(dfd, name, flags | LOOKUP_REVAL, nd);
+	}
 
 	if (likely(!retval)) {
 		if (unlikely(!audit_dummy_context())) {
-- 
1.7.4.4

