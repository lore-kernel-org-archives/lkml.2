Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0FXDYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:24:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab0FXDQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:16:00 -0400
Message-Id: <20100624030732.063083045@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:52 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 40/52] fs: dcache improve scalability of pseudo filesystems
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-scale-pseudo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of how much we possibly try to scale dcache, there is likely
always going to be some fundamental contention when adding or removing children
under the same parent. Pseudo filesystems do not seem need to have connected
dentries because by definition they are disconnected.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/anon_inodes.c |    4 +++-
 fs/pipe.c        |    5 +++--
 net/socket.c     |    5 +++--
 3 files changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6/net/socket.c
===================================================================
--- linux-2.6.orig/net/socket.c
+++ linux-2.6/net/socket.c
@@ -371,7 +371,7 @@ static int sock_alloc_file(struct socket
 	if (unlikely(fd < 0))
 		return fd;
 
-	path.dentry = d_alloc(sock_mnt->mnt_sb->s_root, &name);
+	path.dentry = d_alloc_pseudo(sock_mnt->mnt_sb, &name);
 	if (unlikely(!path.dentry)) {
 		put_unused_fd(fd);
 		return -ENOMEM;
Index: linux-2.6/fs/anon_inodes.c
===================================================================
--- linux-2.6.orig/fs/anon_inodes.c
+++ linux-2.6/fs/anon_inodes.c
@@ -104,7 +104,7 @@ struct file *anon_inode_getfile(const ch
 	this.name = name;
 	this.len = strlen(name);
 	this.hash = 0;
-	path.dentry = d_alloc(anon_inode_mnt->mnt_sb->s_root, &this);
+	path.dentry = d_alloc_pseudo(anon_inode_mnt->mnt_sb, &this);
 	if (!path.dentry)
 		goto err_module;
 
Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c
+++ linux-2.6/fs/pipe.c
@@ -997,7 +997,7 @@ struct file *create_write_pipe(int flags
 		goto err;
 
 	err = -ENOMEM;
-	path.dentry = d_alloc(pipe_mnt->mnt_sb->s_root, &name);
+	path.dentry = d_alloc_pseudo(pipe_mnt->mnt_sb, &name);
 	if (!path.dentry)
 		goto err_inode;
 	path.mnt = mntget(pipe_mnt);
Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -1255,6 +1255,18 @@ struct dentry *d_alloc(struct dentry * p
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
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -225,6 +225,7 @@ extern void d_delete(struct dentry *);
 
 /* allocate/de-allocate */
 extern struct dentry * d_alloc(struct dentry *, const struct qstr *);
+extern struct dentry * d_alloc_pseudo(struct super_block *, const struct qstr *);
 extern struct dentry * d_splice_alias(struct inode *, struct dentry *);
 extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
 extern struct dentry * d_obtain_alias(struct inode *);


