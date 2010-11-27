Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0K0K03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:26:29 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34786 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763Ab0K0K0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <9e0a32be39239f3ee2f4ea340ba83db5f03bee68.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:01 +1100
Subject: [PATCH 31/46] fs: avoid inode RCU freeing for pseudo fs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
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

diff --git a/fs/inode.c b/fs/inode.c
index 26a8ac1..853e0c6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -255,6 +255,12 @@ static struct inode *alloc_inode(struct super_block *sb)
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
diff --git a/fs/pipe.c b/fs/pipe.c
index a8012a9..4ae1d76 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1241,6 +1241,10 @@ out:
 	return ret;
 }
 
+static const struct super_operations pipefs_ops = {
+	.destroy_inode = free_inode_nonrcu,
+};
+
 /*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
@@ -1250,7 +1254,7 @@ out:
 static struct dentry *pipefs_mount(struct file_system_type *fs_type,
 			 int flags, const char *dev_name, void *data)
 {
-	return mount_pseudo(fs_type, "pipe:", NULL, PIPEFS_MAGIC);
+	return mount_pseudo(fs_type, "pipe:", &pipefs_ops, PIPEFS_MAGIC);
 }
 
 static struct file_system_type pipe_fs_type = {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 280d11c..03937b7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2232,6 +2232,7 @@ extern void iget_failed(struct inode *);
 extern void end_writeback(struct inode *);
 extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
+extern void free_inode_nonrcu(struct inode *inode);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);
 
diff --git a/include/linux/net.h b/include/linux/net.h
index 06bde49..16faa13 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -120,6 +120,7 @@ enum sock_shutdown_cmd {
 struct socket_wq {
 	wait_queue_head_t	wait;
 	struct fasync_struct	*fasync_list;
+	struct rcu_head		rcu;
 } ____cacheline_aligned_in_smp;
 
 /**
diff --git a/net/socket.c b/net/socket.c
index d2504c6..425da53 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -262,20 +262,21 @@ static struct inode *sock_alloc_inode(struct super_block *sb)
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
-- 
1.7.1

