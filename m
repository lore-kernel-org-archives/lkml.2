Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0JSEBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:01:22 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28444 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933353Ab0JSD4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034657.367147759@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:34 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 18/35] fs: avoid inode RCU freeing for pseudo fs
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-rcu-reduce.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pseudo filesystems that don't put inode on RCU list or reachable by
rcu-walk dentries do not need to RCU free their inodes.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c          |    6 ++++++
 fs/pipe.c           |    6 +++++-
 include/linux/fs.h  |    1 +
 include/linux/net.h |    1 +
 net/socket.c        |   17 +++++++++--------
 5 files changed, 22 insertions(+), 9 deletions(-)

Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/net/socket.c	2010-10-19 14:19:22.000000000 +1100
@@ -262,20 +262,21 @@
 }
 
 
-static void sock_free_rcu(struct rcu_head *head)
+
+static void wq_free_rcu(struct rcu_head *head)
 {
-	struct inode *inode = container_of(head, struct inode, i_rcu);
-	struct socket_alloc *ei = container_of(inode, struct socket_alloc,
-								vfs_inode);
+	struct socket_wq *wq = container_of(head, struct socket_wq, rcu);
 
-	kfree(ei->socket.wq);
-	INIT_LIST_HEAD(&inode->i_dentry);
-	kmem_cache_free(sock_inode_cachep, ei);
+	kfree(wq);
 }
 
 static void sock_destroy_inode(struct inode *inode)
 {
-	call_rcu(&inode->i_rcu, sock_free_rcu);
+	struct socket_alloc *ei;
+
+	ei = container_of(inode, struct socket_alloc, vfs_inode);
+	call_rcu(&ei->socket.wq->rcu, wq_free_rcu);
+	kmem_cache_free(sock_inode_cachep, ei);
 }
 
 static void init_once(void *foo)
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:25.000000000 +1100
@@ -263,6 +263,12 @@
 	return inode;
 }
 
+void free_inode_nonrcu(struct inode *inode)
+{
+	kmem_cache_free(inode_cachep, inode);
+}
+EXPORT_SYMBOL(free_inode_nonrcu);
+
 void __destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2010-10-19 14:17:18.000000000 +1100
+++ linux-2.6/fs/pipe.c	2010-10-19 14:19:22.000000000 +1100
@@ -1239,6 +1239,10 @@
 	return ret;
 }
 
+static const struct super_operations pipefs_ops = {
+	.destroy_inode = free_inode_nonrcu,
+};
+
 /*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
@@ -1249,7 +1253,7 @@
 			 int flags, const char *dev_name, void *data,
 			 struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "pipe:", NULL, PIPEFS_MAGIC, mnt);
+	return get_sb_pseudo(fs_type, "pipe:", &pipefs_ops, PIPEFS_MAGIC, mnt);
 }
 
 static struct file_system_type pipe_fs_type = {
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:24.000000000 +1100
@@ -2196,6 +2196,7 @@
 extern void destroy_inode(struct inode *);
 extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
+extern void free_inode_nonrcu(struct inode *inode);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);
 
Index: linux-2.6/include/linux/net.h
===================================================================
--- linux-2.6.orig/include/linux/net.h	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/include/linux/net.h	2010-10-19 14:18:59.000000000 +1100
@@ -120,6 +120,7 @@
 struct socket_wq {
 	wait_queue_head_t	wait;
 	struct fasync_struct	*fasync_list;
+	struct rcu_head		rcu;
 } ____cacheline_aligned_in_smp;
 
 /**


