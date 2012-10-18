Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2JRUaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:30:10 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56789 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2JRU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:26:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 02/21] TTY: devpts, return created inode from devpts_pty_new
Date: Thu, 18 Oct 2012 22:26:28 +0200
Message-Id: <1350592007-9216-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal is to stop setting and using tty->driver_data in devpts code.
It should be used solely by the driver's code, pty in this case.

For the cleanup of layering, we will need the inode created in
devpts_pty_new to be stored into slave's driver_data. So we convert
devpts_pty_new to return the inode or an ERR_PTR-encoded error in case
of failure.

The move of 'inode = new_inode(sb);' from declarators to the code is
only cosmetical, but it makes the code easier to read.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c         |  7 +++++--
 fs/devpts/inode.c         | 12 ++++++------
 include/linux/devpts_fs.h |  8 ++++----
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 65f7671..9985b45 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -614,6 +614,7 @@ static const struct tty_operations pty_unix98_ops = {
 static int ptmx_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty;
+	struct inode *slave_inode;
 	int retval;
 	int index;
 
@@ -650,9 +651,11 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	tty_add_file(tty, filp);
 
-	retval = devpts_pty_new(inode, tty->link);
-	if (retval)
+	slave_inode = devpts_pty_new(inode, tty->link);
+	if (IS_ERR(slave_inode)) {
+		retval = PTR_ERR(slave_inode);
 		goto err_release;
+	}
 
 	retval = ptm_driver->ops->open(tty, filp);
 	if (retval)
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 4796580..ec3bab7 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -545,7 +545,7 @@ void devpts_kill_index(struct inode *ptmx_inode, int idx)
 	mutex_unlock(&allocated_ptys_lock);
 }
 
-int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
+struct inode *devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 {
 	/* tty layer puts index from devpts_new_index() in here */
 	int number = tty->index;
@@ -553,19 +553,19 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 	dev_t device = MKDEV(driver->major, driver->minor_start+number);
 	struct dentry *dentry;
 	struct super_block *sb = pts_sb_from_inode(ptmx_inode);
-	struct inode *inode = new_inode(sb);
+	struct inode *inode;
 	struct dentry *root = sb->s_root;
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 	struct pts_mount_opts *opts = &fsi->mount_opts;
-	int ret = 0;
 	char s[12];
 
 	/* We're supposed to be given the slave end of a pty */
 	BUG_ON(driver->type != TTY_DRIVER_TYPE_PTY);
 	BUG_ON(driver->subtype != PTY_TYPE_SLAVE);
 
+	inode = new_inode(sb);
 	if (!inode)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	inode->i_ino = number + 3;
 	inode->i_uid = opts->setuid ? opts->uid : current_fsuid();
@@ -585,12 +585,12 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 		fsnotify_create(root->d_inode, dentry);
 	} else {
 		iput(inode);
-		ret = -ENOMEM;
+		inode = ERR_PTR(-ENOMEM);
 	}
 
 	mutex_unlock(&root->d_inode->i_mutex);
 
-	return ret;
+	return inode;
 }
 
 void *devpts_get_priv(struct inode *pts_inode)
diff --git a/include/linux/devpts_fs.h b/include/linux/devpts_fs.h
index de635a5..4ca846f 100644
--- a/include/linux/devpts_fs.h
+++ b/include/linux/devpts_fs.h
@@ -20,7 +20,7 @@
 int devpts_new_index(struct inode *ptmx_inode);
 void devpts_kill_index(struct inode *ptmx_inode, int idx);
 /* mknod in devpts */
-int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty);
+struct inode *devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty);
 /* get private structure */
 void *devpts_get_priv(struct inode *pts_inode);
 /* unlink */
@@ -31,10 +31,10 @@ void devpts_pty_kill(struct tty_struct *tty);
 /* Dummy stubs in the no-pty case */
 static inline int devpts_new_index(struct inode *ptmx_inode) { return -EINVAL; }
 static inline void devpts_kill_index(struct inode *ptmx_inode, int idx) { }
-static inline int devpts_pty_new(struct inode *ptmx_inode,
-				struct tty_struct *tty)
+static inline struct inode *devpts_pty_new(struct inode *ptmx_inode,
+		struct tty_struct *tty)
 {
-	return -EINVAL;
+	return ERR_PTR(-EINVAL);
 }
 static inline void *devpts_get_priv(struct inode *pts_inode)
 {
-- 
1.7.12.3


