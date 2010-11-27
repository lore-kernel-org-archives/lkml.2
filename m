Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0K0K1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:27:14 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:26161 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab0K0K1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:27:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIph
Message-Id: <7caf3d3b7217dc0111b7d1c920fd60151faf0ac7.1290852960.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:16 +1100
Subject: [PATCH 46/46] fs: improve scalability of pseudo filesystems
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of how much we possibly try to scale dcache, there is likely
always going to be some fundamental contention when adding or removing children
under the same parent. Pseudo filesystems do not seem need to have connected
dentries because by definition they are disconnected.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/anon_inodes.c       |    2 +-
 fs/dcache.c            |   12 ++++++++++++
 fs/pipe.c              |    2 +-
 include/linux/dcache.h |    1 +
 net/socket.c           |    2 +-
 5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index aca8806..9d92b33 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -102,7 +102,7 @@ struct file *anon_inode_getfile(const char *name,
 	this.name = name;
 	this.len = strlen(name);
 	this.hash = 0;
-	path.dentry = d_alloc(anon_inode_mnt->mnt_sb->s_root, &this);
+	path.dentry = d_alloc_pseudo(anon_inode_mnt->mnt_sb, &this);
 	if (!path.dentry)
 		goto err_module;
 
diff --git a/fs/dcache.c b/fs/dcache.c
index 809ec46..59f25b7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1276,6 +1276,18 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 }
 EXPORT_SYMBOL(d_alloc);
 
+struct dentry *d_alloc_pseudo(struct super_block *sb, const struct qstr *name)
+{
+	struct dentry *dentry = d_alloc(NULL, name);
+	if (dentry) {
+		dentry->d_sb = sb;
+		dentry->d_parent = dentry;
+		dentry->d_flags |= DCACHE_DISCONNECTED;
+	}
+	return dentry;
+}
+EXPORT_SYMBOL(d_alloc_pseudo);
+
 struct dentry *d_alloc_name(struct dentry *parent, const char *name)
 {
 	struct qstr q;
diff --git a/fs/pipe.c b/fs/pipe.c
index e964d09..ebe9143 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -999,7 +999,7 @@ struct file *create_write_pipe(int flags)
 		goto err;
 
 	err = -ENOMEM;
-	path.dentry = d_alloc(pipe_mnt->mnt_sb->s_root, &name);
+	path.dentry = d_alloc_pseudo(pipe_mnt->mnt_sb, &name);
 	if (!path.dentry)
 		goto err_inode;
 	path.mnt = mntget(pipe_mnt);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 8ff803b..0cf2cb9 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -229,6 +229,7 @@ extern void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op
 
 /* allocate/de-allocate */
 extern struct dentry * d_alloc(struct dentry *, const struct qstr *);
+extern struct dentry * d_alloc_pseudo(struct super_block *, const struct qstr *);
 extern struct dentry * d_splice_alias(struct inode *, struct dentry *);
 extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
 extern struct dentry * d_obtain_alias(struct inode *);
diff --git a/net/socket.c b/net/socket.c
index 2d8b4c8..17d9aae 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -361,7 +361,7 @@ static int sock_alloc_file(struct socket *sock, struct file **f, int flags)
 	if (unlikely(fd < 0))
 		return fd;
 
-	path.dentry = d_alloc(sock_mnt->mnt_sb->s_root, &name);
+	path.dentry = d_alloc_pseudo(sock_mnt->mnt_sb, &name);
 	if (unlikely(!path.dentry)) {
 		put_unused_fd(fd);
 		return -ENOMEM;
-- 
1.7.1

