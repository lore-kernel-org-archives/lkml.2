Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0E0OLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:11:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38669 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0E0OLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:11:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Lj5xdodinBjuRudnQqEkNLP9pbWLDBPk4hYMGfCoTcxg02ejOQBl16romygwPQwamn
         uidEM7HFkuSO4mkhKVBynOguTDVy9ckrbqP8IFNHTUzECsz5t+DCCKMtRNxhZv9uX58a
         KIeTZJDfoQ40rboewZwm7BJYb8EaqfipW4hi8=
From: Changli Gao <xiaosuo@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] pipe: export size and blocks via system call fstat(2)
Date: Thu, 27 May 2010 22:09:51 +0800
Message-Id: <1274969391-3006-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export size and blocks via system call fstat(2)

pipe or fifo doesn't support fstat(2). This patch makes it possible to check the
amount of data buffered in a pipe or fifo, and the pages used to store this
data via fstat(2).

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/inode.c         |    5 +++--
 fs/pipe.c          |   51 ++++++++++++++++++++++++++++++++++++++++-----------
 include/linux/fs.h |    1 +
 3 files changed, 44 insertions(+), 13 deletions(-)
diff --git a/fs/inode.c b/fs/inode.c
index 258ec22..850ff89 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1598,9 +1598,10 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
 	} else if (S_ISBLK(mode)) {
 		inode->i_fop = &def_blk_fops;
 		inode->i_rdev = rdev;
-	} else if (S_ISFIFO(mode))
+	} else if (S_ISFIFO(mode)) {
+		inode->i_op = &pipe_iops;
 		inode->i_fop = &def_fifo_fops;
-	else if (S_ISSOCK(mode))
+	} else if (S_ISSOCK(mode))
 		inode->i_fop = &bad_sock_fops;
 	else
 		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
diff --git a/fs/pipe.c b/fs/pipe.c
index 37ba29f..3961fcf 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -625,25 +625,33 @@ bad_pipe_w(struct file *filp, const char __user *buf, size_t count,
 	return -EBADF;
 }
 
-static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int __pipe_get_size(struct inode *inode)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct pipe_inode_info *pipe;
 	int count, buf, nrbufs;
 
+	pipe = inode->i_pipe;
+	count = 0;
+	buf = pipe->curbuf;
+	nrbufs = pipe->nrbufs;
+	while (--nrbufs >= 0) {
+		count += pipe->bufs[buf].len;
+		buf = (buf+1) & (PIPE_BUFFERS-1);
+	}
+
+	return count;
+}
+
+static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	int count;
+
 	switch (cmd) {
 		case FIONREAD:
 			mutex_lock(&inode->i_mutex);
-			pipe = inode->i_pipe;
-			count = 0;
-			buf = pipe->curbuf;
-			nrbufs = pipe->nrbufs;
-			while (--nrbufs >= 0) {
-				count += pipe->bufs[buf].len;
-				buf = (buf+1) & (PIPE_BUFFERS-1);
-			}
+			count = __pipe_get_size(inode);
 			mutex_unlock(&inode->i_mutex);
-
 			return put_user(count, (int __user *)arg);
 		default:
 			return -EINVAL;
@@ -934,6 +942,7 @@ static struct inode * get_pipe_inode(void)
 	inode->i_pipe = pipe;
 
 	pipe->readers = pipe->writers = 1;
+	inode->i_op = &pipe_iops;
 	inode->i_fop = &rdwr_pipefifo_fops;
 
 	/*
@@ -1112,6 +1121,26 @@ static struct file_system_type pipe_fs_type = {
 	.kill_sb	= kill_anon_super,
 };
 
+static int pipe_getattr(struct vfsmount *mnt, struct dentry *dentry,
+			struct kstat *stat)
+{
+	struct inode *inode = dentry->d_inode;
+
+	generic_fillattr(inode, stat);
+	mutex_lock(&inode->i_mutex);
+	if (inode->i_pipe) {
+		stat->blocks = inode->i_pipe->nrbufs * (PAGE_SIZE / 512);
+		stat->size = __pipe_get_size(inode);
+	}
+	mutex_unlock(&inode->i_mutex);
+
+	return 0;
+}
+
+const struct inode_operations pipe_iops = {
+	.getattr	= pipe_getattr,
+};
+
 static int __init init_pipe_fs(void)
 {
 	int err = register_filesystem(&pipe_fs_type);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index eb86433..89103b9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1973,6 +1973,7 @@ extern const struct file_operations def_blk_fops;
 extern const struct file_operations def_chr_fops;
 extern const struct file_operations bad_sock_fops;
 extern const struct file_operations def_fifo_fops;
+extern const struct inode_operations pipe_iops;
 #ifdef CONFIG_BLOCK
 extern int ioctl_by_bdev(struct block_device *, unsigned, unsigned long);
 extern int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
