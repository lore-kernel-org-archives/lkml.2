Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2ABRXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 12:23:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59898 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2ABRW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 12:22:59 -0500
Subject: [PATCH 1/2] tty: move pty count limiting into devpts
To: Greg Kroah-Hartman <gregkh@suse.de>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 02 Jan 2012 21:22:54 +0400
Message-ID: <20120102172254.11535.2653.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's move this stuff to the better place, where we can account pty right in
tty-indexes managing code.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 drivers/tty/pty.c |   63 -----------------------------------------------------
 fs/devpts/inode.c |   53 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 64 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d2bf3c1..33f7e18 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -21,7 +21,6 @@
 #include <linux/major.h>
 #include <linux/mm.h>
 #include <linux/init.h>
-#include <linux/sysctl.h>
 #include <linux/device.h>
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
@@ -439,66 +438,9 @@ static inline void legacy_pty_init(void) { }
 
 /* Unix98 devices */
 #ifdef CONFIG_UNIX98_PTYS
-/*
- * sysctl support for setting limits on the number of Unix98 ptys allocated.
- * Otherwise one can eat up all kernel memory by opening /dev/ptmx repeatedly.
- */
-int pty_limit = NR_UNIX98_PTY_DEFAULT;
-static int pty_limit_min;
-static int pty_limit_max = NR_UNIX98_PTY_MAX;
-static int tty_count;
-static int pty_count;
-
-static inline void pty_inc_count(void)
-{
-	pty_count = (++tty_count) / 2;
-}
-
-static inline void pty_dec_count(void)
-{
-	pty_count = (--tty_count) / 2;
-}
 
 static struct cdev ptmx_cdev;
 
-static struct ctl_table pty_table[] = {
-	{
-		.procname	= "max",
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.data		= &pty_limit,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &pty_limit_min,
-		.extra2		= &pty_limit_max,
-	}, {
-		.procname	= "nr",
-		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.data		= &pty_count,
-		.proc_handler	= proc_dointvec,
-	}, 
-	{}
-};
-
-static struct ctl_table pty_kern_table[] = {
-	{
-		.procname	= "pty",
-		.mode		= 0555,
-		.child		= pty_table,
-	},
-	{}
-};
-
-static struct ctl_table pty_root_table[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= pty_kern_table,
-	},
-	{}
-};
-
-
 static int pty_unix98_ioctl(struct tty_struct *tty,
 			    unsigned int cmd, unsigned long arg)
 {
@@ -598,8 +540,6 @@ static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 	 */
 	tty_driver_kref_get(driver);
 	tty->count++;
-	pty_inc_count(); /* tty */
-	pty_inc_count(); /* tty->link */
 	return 0;
 err_free_mem:
 	deinitialize_tty_struct(o_tty);
@@ -613,7 +553,6 @@ err_free_tty:
 
 static void pty_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
 {
-	pty_dec_count();
 }
 
 static const struct tty_operations ptm_unix98_ops = {
@@ -768,8 +707,6 @@ static void __init unix98_pty_init(void)
 	if (tty_register_driver(pts_driver))
 		panic("Couldn't register Unix98 pts driver");
 
-	register_sysctl_table(pty_root_table);
-
 	/* Now create the /dev/ptmx special device */
 	tty_default_fops(&ptmx_fops);
 	ptmx_fops.open = ptmx_open;
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index d5d5297..dd37e85 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -36,7 +36,52 @@
 #define DEVPTS_DEFAULT_PTMX_MODE 0000
 #define PTMX_MINOR	2
 
-extern int pty_limit;			/* Config limit on Unix98 ptys */
+/*
+ * sysctl support for setting limits on the number of Unix98 ptys allocated.
+ * Otherwise one can eat up all kernel memory by opening /dev/ptmx repeatedly.
+ */
+static int pty_limit = NR_UNIX98_PTY_DEFAULT;
+static int pty_limit_min;
+static int pty_limit_max = NR_UNIX98_PTY_MAX;
+static int pty_count;
+
+static struct ctl_table pty_table[] = {
+	{
+		.procname	= "max",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.data		= &pty_limit,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &pty_limit_min,
+		.extra2		= &pty_limit_max,
+	}, {
+		.procname	= "nr",
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.data		= &pty_count,
+		.proc_handler	= proc_dointvec,
+	},
+	{}
+};
+
+static struct ctl_table pty_kern_table[] = {
+	{
+		.procname	= "pty",
+		.mode		= 0555,
+		.child		= pty_table,
+	},
+	{}
+};
+
+static struct ctl_table pty_root_table[] = {
+	{
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= pty_kern_table,
+	},
+	{}
+};
+
 static DEFINE_MUTEX(allocated_ptys_lock);
 
 static struct vfsmount *devpts_mnt;
@@ -453,6 +498,7 @@ retry:
 		mutex_unlock(&allocated_ptys_lock);
 		return -EIO;
 	}
+	pty_count++;
 	mutex_unlock(&allocated_ptys_lock);
 	return index;
 }
@@ -464,6 +510,7 @@ void devpts_kill_index(struct inode *ptmx_inode, int idx)
 
 	mutex_lock(&allocated_ptys_lock);
 	ida_remove(&fsi->allocated_ptys, idx);
+	pty_count--;
 	mutex_unlock(&allocated_ptys_lock);
 }
 
@@ -560,11 +607,15 @@ void devpts_pty_kill(struct tty_struct *tty)
 static int __init init_devpts_fs(void)
 {
 	int err = register_filesystem(&devpts_fs_type);
+	struct ctl_table_header *table;
+
 	if (!err) {
+		table = register_sysctl_table(pty_root_table);
 		devpts_mnt = kern_mount(&devpts_fs_type);
 		if (IS_ERR(devpts_mnt)) {
 			err = PTR_ERR(devpts_mnt);
 			unregister_filesystem(&devpts_fs_type);
+			unregister_sysctl_table(table);
 		}
 	}
 	return err;

