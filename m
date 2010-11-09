Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0KIMsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:48:01 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:56555 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab0KIMsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:48:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOrQ2Ex5LcZK/2dsb2JhbACiHnK/OoVKBA
Date: Tue, 9 Nov 2010 23:47:57 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 2/6] fs: icache avoid RCU freeing for pseudo fs
Message-ID: <20101109124757.GC11477@amd>
References: <20101109124610.GB11477@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109124610.GB11477@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filesystems that don't put inode on any RCU list or reachable by rcu-walk
dentries do not need to RCU free their inodes.

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
--- linux-2.6.orig/net/socket.c	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/net/socket.c	2010-11-09 22:11:10.000000000 +1100
@@ -262,20 +262,21 @@ static struct inode *sock_alloc_inode(st
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
--- linux-2.6.orig/fs/inode.c	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-11-09 22:11:10.000000000 +1100
@@ -255,6 +255,12 @@ static struct inode *alloc_inode(struct
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
--- linux-2.6.orig/fs/pipe.c	2010-11-09 22:11:00.000000000 +1100
+++ linux-2.6/fs/pipe.c	2010-11-09 22:11:10.000000000 +1100
@@ -1241,6 +1241,10 @@ long pipe_fcntl(struct file *file, unsig
 	return ret;
 }
 
+static const struct super_operations pipefs_ops = {
+	.destroy_inode = free_inode_nonrcu,
+};
+
 /*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
@@ -1250,7 +1254,7 @@ long pipe_fcntl(struct file *file, unsig
 static struct dentry *pipefs_mount(struct file_system_type *fs_type,
 			 int flags, const char *dev_name, void *data)
 {
-	return mount_pseudo(fs_type, "pipe:", NULL, PIPEFS_MAGIC);
+	return mount_pseudo(fs_type, "pipe:", &pipefs_ops, PIPEFS_MAGIC);
 }
 
 static struct file_system_type pipe_fs_type = {
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/include/linux/fs.h	2010-11-09 22:11:10.000000000 +1100
@@ -2233,6 +2233,7 @@ extern void iget_failed(struct inode *);
 extern void end_writeback(struct inode *);
 extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
+extern void free_inode_nonrcu(struct inode *inode);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);
 
Index: linux-2.6/include/linux/net.h
===================================================================
--- linux-2.6.orig/include/linux/net.h	2010-11-09 22:11:10.000000000 +1100
+++ linux-2.6/include/linux/net.h	2010-11-09 22:11:10.000000000 +1100
@@ -120,6 +120,7 @@ enum sock_shutdown_cmd {
 struct socket_wq {
 	wait_queue_head_t	wait;
 	struct fasync_struct	*fasync_list;
+	struct rcu_head		rcu;
 } ____cacheline_aligned_in_smp;
 
 /**
