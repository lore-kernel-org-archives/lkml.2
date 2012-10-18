Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2JRUcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:32:00 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56792 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2JRU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:26:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 01/21] TTY: devpts, don't care about TTY in devpts_get_tty
Date: Thu, 18 Oct 2012 22:26:27 +0200
Message-Id: <1350592007-9216-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal is to stop setting and using tty->driver_data in devpts code.
It should be used solely by the driver's code, pty in this case.

First, here we remove TTY from devpts_get_tty and rename it to
devpts_get_priv. Note we do not remove type safety, we just shift the
[implicit] (void *) cast one layer up.

index was unused in devpts_get_tty, so remove that from the prototype
too.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c         | 2 +-
 fs/devpts/inode.c         | 9 ++++-----
 include/linux/devpts_fs.h | 7 +++----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index a82b399..65f7671 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -547,7 +547,7 @@ static struct tty_struct *pts_unix98_lookup(struct tty_driver *driver,
 	struct tty_struct *tty;
 
 	mutex_lock(&devpts_mutex);
-	tty = devpts_get_tty(pts_inode, idx);
+	tty = devpts_get_priv(pts_inode);
 	mutex_unlock(&devpts_mutex);
 	/* Master must be open before slave */
 	if (!tty)
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 14afbab..4796580 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -593,10 +593,10 @@ int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty)
 	return ret;
 }
 
-struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number)
+void *devpts_get_priv(struct inode *pts_inode)
 {
 	struct dentry *dentry;
-	struct tty_struct *tty;
+	void *priv = NULL;
 
 	BUG_ON(pts_inode->i_rdev == MKDEV(TTYAUX_MAJOR, PTMX_MINOR));
 
@@ -605,13 +605,12 @@ struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number)
 	if (!dentry)
 		return NULL;
 
-	tty = NULL;
 	if (pts_inode->i_sb->s_magic == DEVPTS_SUPER_MAGIC)
-		tty = (struct tty_struct *)pts_inode->i_private;
+		priv = pts_inode->i_private;
 
 	dput(dentry);
 
-	return tty;
+	return priv;
 }
 
 void devpts_pty_kill(struct tty_struct *tty)
diff --git a/include/linux/devpts_fs.h b/include/linux/devpts_fs.h
index 5ce0e5f..de635a5 100644
--- a/include/linux/devpts_fs.h
+++ b/include/linux/devpts_fs.h
@@ -21,8 +21,8 @@ int devpts_new_index(struct inode *ptmx_inode);
 void devpts_kill_index(struct inode *ptmx_inode, int idx);
 /* mknod in devpts */
 int devpts_pty_new(struct inode *ptmx_inode, struct tty_struct *tty);
-/* get tty structure */
-struct tty_struct *devpts_get_tty(struct inode *pts_inode, int number);
+/* get private structure */
+void *devpts_get_priv(struct inode *pts_inode);
 /* unlink */
 void devpts_pty_kill(struct tty_struct *tty);
 
@@ -36,8 +36,7 @@ static inline int devpts_pty_new(struct inode *ptmx_inode,
 {
 	return -EINVAL;
 }
-static inline struct tty_struct *devpts_get_tty(struct inode *pts_inode,
-		int number)
+static inline void *devpts_get_priv(struct inode *pts_inode)
 {
 	return NULL;
 }
-- 
1.7.12.3


