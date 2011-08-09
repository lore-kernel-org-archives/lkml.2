Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046Ab1HIA4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 20:56:46 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:57901 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758Ab1HIA4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 20:56:45 -0400
Subject: [PATCH] autofs4: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        autofs@linux.kernel.org, Ian Kent <raven@themaw.net>
In-Reply-To: <CA+55aFz1aoSMLHwD1BrNpGO95k+_PYqFG0fySNMh6dT5JVGJuQ@mail.gmail.com>
References: <20110808151038.17366.38130.stgit@warthog.procyon.org.uk>
	 <CA+55aFz1aoSMLHwD1BrNpGO95k+_PYqFG0fySNMh6dT5JVGJuQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:56:42 -0700
Message-ID: <1312851402.1643.30.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard logging forms.  All logging entries are
not prefixed with "autofs4:" via pr_fmt.

Convert printks without KERN_<LEVEL> to pr_info and pr_err.

Convert AUTOFS_WARN and AUTOFS_ERROR to pr_warn and pr_err.
Use a specific pr_fmt to add __func__ and pid to the single
source file where AUTOFS_<LEVEL> were used.  Add newlines
to these converted printks as well.

Convert DPRINTK uses to pr_debug.
Add newlines to pr_debug uses.  Remove __func__
and pid as these can be added by using dynamic_debug
controls '+f' and '+t' and respectivly.

Coalesce long formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/autofs4/autofs_i.h  |   12 ------------
 fs/autofs4/dev-ioctl.c |   27 +++++++++++++--------------
 fs/autofs4/expire.c    |   41 ++++++++++++++++++++++-------------------
 fs/autofs4/inode.c     |   19 ++++++++++---------
 fs/autofs4/root.c      |   48 +++++++++++++++++++++++++-----------------------
 fs/autofs4/waitq.c     |   23 +++++++++++++----------
 6 files changed, 83 insertions(+), 87 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 326dc08..8082505 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -39,18 +39,6 @@
 
 /* #define DEBUG */
 
-#define DPRINTK(fmt, ...)				\
-	pr_debug("pid %d: %s: " fmt "\n",		\
-		current->pid, __func__, ##__VA_ARGS__)
-
-#define AUTOFS_WARN(fmt, ...)				\
-	printk(KERN_WARNING "pid %d: %s: " fmt "\n",	\
-		current->pid, __func__, ##__VA_ARGS__)
-
-#define AUTOFS_ERROR(fmt, ...)				\
-	printk(KERN_ERR "pid %d: %s: " fmt "\n",	\
-		current->pid, __func__, ##__VA_ARGS__)
-
 /* Unified info structure.  This is pointed to by both the dentry and
    inode structures.  Each file in the filesystem has an instance of this
    structure.  It holds a reference to the dentry, so dentries are never
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 509fe1e..456ddeb 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -7,6 +7,8 @@
  * option, any later version, incorporated herein by reference.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s:pid %d: " fmt, __func__, current->pid
+
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/miscdevice.h>
@@ -74,11 +76,10 @@ static int check_dev_ioctl_version(int cmd, struct autofs_dev_ioctl *param)
 
 	if ((AUTOFS_DEV_IOCTL_VERSION_MAJOR != param->ver_major) ||
 	    (AUTOFS_DEV_IOCTL_VERSION_MINOR < param->ver_minor)) {
-		AUTOFS_WARN("ioctl control interface version mismatch: "
-		     "kernel(%u.%u), user(%u.%u), cmd(%d)",
-		     AUTOFS_DEV_IOCTL_VERSION_MAJOR,
-		     AUTOFS_DEV_IOCTL_VERSION_MINOR,
-		     param->ver_major, param->ver_minor, cmd);
+		pr_warn("ioctl control interface version mismatch: kernel(%u.%u), user(%u.%u), cmd(%d)\n",
+			AUTOFS_DEV_IOCTL_VERSION_MAJOR,
+			AUTOFS_DEV_IOCTL_VERSION_MINOR,
+			param->ver_major, param->ver_minor, cmd);
 		err = -EINVAL;
 	}
 
@@ -122,24 +123,22 @@ static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
 
 	err = check_dev_ioctl_version(cmd, param);
 	if (err) {
-		AUTOFS_WARN("invalid device control module version "
-		     "supplied for cmd(0x%08x)", cmd);
+		pr_warn("invalid device control module version supplied for cmd(0x%08x)\n",
+			cmd);
 		goto out;
 	}
 
 	if (param->size > sizeof(*param)) {
 		err = invalid_str(param->path, param->size - sizeof(*param));
 		if (err) {
-			AUTOFS_WARN(
-			  "path string terminator missing for cmd(0x%08x)",
-			  cmd);
+			pr_warn("path string terminator missing for cmd(0x%08x)\n",
+				cmd);
 			goto out;
 		}
 
 		err = check_name(param->path);
 		if (err) {
-			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
-				    cmd);
+			pr_warn("invalid path supplied for cmd(0x%08x)\n", cmd);
 			goto out;
 		}
 	}
@@ -649,7 +648,7 @@ static int _autofs_dev_ioctl(unsigned int command, struct autofs_dev_ioctl __use
 
 	fn = lookup_dev_ioctl(cmd);
 	if (!fn) {
-		AUTOFS_WARN("unknown command 0x%08x", command);
+		pr_warn("unknown command 0x%08x\n", command);
 		return -ENOTTY;
 	}
 
@@ -747,7 +746,7 @@ int autofs_dev_ioctl_init(void)
 
 	r = misc_register(&_autofs_dev_ioctl_misc);
 	if (r) {
-		AUTOFS_ERROR("misc_register failed for control device");
+		pr_err("misc_register failed for control device\n");
 		return r;
 	}
 
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 450f529..b7a4e3d 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -12,6 +12,8 @@
  *
  * ------------------------------------------------------------------------- */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "autofs_i.h"
 
 static unsigned long now;
@@ -47,8 +49,8 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 	struct path path = {.mnt = mnt, .dentry = dentry};
 	int status = 1;
 
-	DPRINTK("dentry %p %.*s",
-		dentry, (int)dentry->d_name.len, dentry->d_name.name);
+	pr_debug("dentry %p %.*s\n",
+		 dentry, (int)dentry->d_name.len, dentry->d_name.name);
 
 	path_get(&path);
 
@@ -81,7 +83,7 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 
 	status = 0;
 done:
-	DPRINTK("returning = %d", status);
+	pr_debug("returning = %d\n", status);
 	path_put(&path);
 	return status;
 }
@@ -210,8 +212,8 @@ static int autofs4_direct_busy(struct vfsmount *mnt,
 				unsigned long timeout,
 				int do_now)
 {
-	DPRINTK("top %p %.*s",
-		top, (int) top->d_name.len, top->d_name.name);
+	pr_debug("top %p %.*s\n",
+		 top, (int) top->d_name.len, top->d_name.name);
 
 	/* If it's busy update the expiry counters */
 	if (!may_umount_tree(mnt)) {
@@ -239,8 +241,8 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 	struct autofs_info *top_ino = autofs4_dentry_ino(top);
 	struct dentry *p;
 
-	DPRINTK("top %p %.*s",
-		top, (int)top->d_name.len, top->d_name.name);
+	pr_debug("top %p %.*s\n",
+		 top, (int)top->d_name.len, top->d_name.name);
 
 	/* Negative dentry - give up */
 	if (!simple_positive(top))
@@ -248,8 +250,8 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 
 	p = NULL;
 	while ((p = get_next_positive_dentry(p, top))) {
-		DPRINTK("dentry %p %.*s",
-			p, (int) p->d_name.len, p->d_name.name);
+		pr_debug("dentry %p %.*s\n",
+			 p, (int) p->d_name.len, p->d_name.name);
 
 		/*
 		 * Is someone visiting anywhere in the subtree ?
@@ -301,13 +303,13 @@ static struct dentry *autofs4_check_leaves(struct vfsmount *mnt,
 {
 	struct dentry *p;
 
-	DPRINTK("parent %p %.*s",
-		parent, (int)parent->d_name.len, parent->d_name.name);
+	pr_debug("parent %p %.*s\n",
+		 parent, (int)parent->d_name.len, parent->d_name.name);
 
 	p = NULL;
 	while ((p = get_next_positive_dentry(p, parent))) {
-		DPRINTK("dentry %p %.*s",
-			p, (int) p->d_name.len, p->d_name.name);
+		pr_debug("dentry %p %.*s\n",
+			 p, (int) p->d_name.len, p->d_name.name);
 
 		if (d_mountpoint(p)) {
 			/* Can we umount this guy */
@@ -399,8 +401,9 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		 *	   offset (autofs-5.0+).
 		 */
 		if (d_mountpoint(dentry)) {
-			DPRINTK("checking mountpoint %p %.*s",
-				dentry, (int)dentry->d_name.len, dentry->d_name.name);
+			pr_debug("checking mountpoint %p %.*s\n",
+				 dentry, (int)dentry->d_name.len,
+				 dentry->d_name.name);
 
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 2;
@@ -455,8 +458,8 @@ next:
 	return NULL;
 
 found:
-	DPRINTK("returning %p %.*s",
-		expired, (int)expired->d_name.len, expired->d_name.name);
+	pr_debug("returning %p %.*s\n",
+		 expired, (int)expired->d_name.len, expired->d_name.name);
 	ino = autofs4_dentry_ino(expired);
 	ino->flags |= AUTOFS_INF_EXPIRING;
 	init_completion(&ino->expire_complete);
@@ -482,13 +485,13 @@ int autofs4_expire_wait(struct dentry *dentry)
 	if (ino->flags & AUTOFS_INF_EXPIRING) {
 		spin_unlock(&sbi->fs_lock);
 
-		DPRINTK("waiting for expire %p name=%.*s",
+		pr_debug("waiting for expire %p name=%.*s\n",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 
 		status = autofs4_wait(sbi, dentry, NFY_NONE);
 		wait_for_completion(&ino->expire_complete);
 
-		DPRINTK("expire done status=%d", status);
+		pr_debug("expire done status=%d\n", status);
 
 		if (d_unhashed(dentry))
 			return -EAGAIN;
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 180fa24..fdba022 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -11,6 +11,8 @@
  *
  * ------------------------------------------------------------------------- */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/file.h>
@@ -66,7 +68,7 @@ void autofs4_kill_sb(struct super_block *sb)
 	kfree(sbi);
 
 out_kill_sb:
-	DPRINTK("shutting down");
+	pr_debug("shutting down\n");
 	kill_litter_super(sb);
 }
 
@@ -209,7 +211,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
-	DPRINTK("starting up, sbi = %p",sbi);
+	pr_debug("starting up, sbi = %p\n", sbi);
 
 	s->s_fs_info = sbi;
 	sbi->magic = AUTOFS_SBI_MAGIC;
@@ -258,7 +260,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
 				&sbi->oz_pgrp, &sbi->type, &sbi->min_proto,
 				&sbi->max_proto)) {
-		printk("autofs: called with bogus options\n");
+		pr_info("called with bogus options\n");
 		goto fail_dput;
 	}
 
@@ -271,8 +273,7 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	/* Couldn't this be tested earlier? */
 	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
 	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
-		printk("autofs: kernel does not match daemon version "
-		       "daemon (%d, %d) kernel (%d, %d)\n",
+		pr_info("kernel does not match daemon version daemon (%d, %d) kernel (%d, %d)\n",
 			sbi->min_proto, sbi->max_proto,
 			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
 		goto fail_dput;
@@ -285,11 +286,11 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 		sbi->version = sbi->max_proto;
 	sbi->sub_version = AUTOFS_PROTO_SUBVERSION;
 
-	DPRINTK("pipe fd = %d, pgrp = %u", pipefd, sbi->oz_pgrp);
+	pr_debug("pipe fd = %d, pgrp = %u\n", pipefd, sbi->oz_pgrp);
 	pipe = fget(pipefd);
 	
 	if (!pipe) {
-		printk("autofs: could not open pipe file descriptor\n");
+		pr_info("could not open pipe file descriptor\n");
 		goto fail_dput;
 	}
 	if (!pipe->f_op || !pipe->f_op->write)
@@ -308,14 +309,14 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	 * Failure ... clean up.
 	 */
 fail_fput:
-	printk("autofs: pipe file descriptor does not contain proper ops\n");
+	pr_info("pipe file descriptor does not contain proper ops\n");
 	fput(pipe);
 	/* fall through */
 fail_dput:
 	dput(root);
 	goto fail_free;
 fail_iput:
-	printk("autofs: get root dentry failed\n");
+	pr_info("get root dentry failed\n");
 	iput(root_inode);
 fail_ino:
 	kfree(ino);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index f55ae23..a887866 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -12,6 +12,8 @@
  *
  * ------------------------------------------------------------------------- */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/stat.h>
@@ -108,8 +110,8 @@ static int autofs4_dir_open(struct inode *inode, struct file *file)
 	struct dentry *dentry = file->f_path.dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 
-	DPRINTK("file=%p dentry=%p %.*s",
-		file, dentry, dentry->d_name.len, dentry->d_name.name);
+	pr_debug("file=%p dentry=%p %.*s\n",
+		 file, dentry, dentry->d_name.len, dentry->d_name.name);
 
 	if (autofs4_oz_mode(sbi))
 		goto out;
@@ -142,7 +144,7 @@ static void autofs4_dentry_release(struct dentry *de)
 	struct autofs_info *ino = autofs4_dentry_ino(de);
 	struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
 
-	DPRINTK("releasing %p", de);
+	pr_debug("releasing %p\n", de);
 
 	if (!ino)
 		return;
@@ -270,10 +272,10 @@ static int autofs4_mount_wait(struct dentry *dentry)
 	int status = 0;
 
 	if (ino->flags & AUTOFS_INF_PENDING) {
-		DPRINTK("waiting for mount name=%.*s",
-			dentry->d_name.len, dentry->d_name.name);
+		pr_debug("waiting for mount name=%.*s\n",
+			 dentry->d_name.len, dentry->d_name.name);
 		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
-		DPRINTK("mount wait done status=%d", status);
+		pr_debug("mount wait done status=%d\n", status);
 	}
 	ino->last_used = jiffies;
 	return status;
@@ -329,8 +331,8 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int status;
 
-	DPRINTK("dentry=%p %.*s",
-		dentry, dentry->d_name.len, dentry->d_name.name);
+	pr_debug("dentry=%p %.*s\n",
+		 dentry, dentry->d_name.len, dentry->d_name.name);
 
 	/* The daemon never triggers a mount. */
 	if (autofs4_oz_mode(sbi))
@@ -431,8 +433,8 @@ int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 
-	DPRINTK("dentry=%p %.*s",
-		dentry, dentry->d_name.len, dentry->d_name.name);
+	pr_debug("dentry=%p %.*s\n",
+		 dentry, dentry->d_name.len, dentry->d_name.name);
 
 	/* The daemon never waits. */
 	if (autofs4_oz_mode(sbi)) {
@@ -464,7 +466,7 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 	struct autofs_info *ino;
 	struct dentry *active;
 
-	DPRINTK("name = %.*s", dentry->d_name.len, dentry->d_name.name);
+	pr_debug("name = %.*s\n", dentry->d_name.len, dentry->d_name.name);
 
 	/* File name too long to exist */
 	if (dentry->d_name.len > NAME_MAX)
@@ -472,9 +474,9 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 
 	sbi = autofs4_sbi(dir->i_sb);
 
-	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
-		current->pid, task_pgrp_nr(current), sbi->catatonic,
-		autofs4_oz_mode(sbi));
+	pr_debug("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d\n",
+		 current->pid, task_pgrp_nr(current), sbi->catatonic,
+		 autofs4_oz_mode(sbi));
 
 	active = autofs4_lookup_active(dentry);
 	if (active) {
@@ -518,8 +520,8 @@ static int autofs4_dir_symlink(struct inode *dir,
 	size_t size = strlen(symname);
 	char *cp;
 
-	DPRINTK("%s <- %.*s", symname,
-		dentry->d_name.len, dentry->d_name.name);
+	pr_debug("%s <- %.*s\n",
+		 symname, dentry->d_name.len, dentry->d_name.name);
 
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
@@ -663,8 +665,8 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 	
-	DPRINTK("dentry %p, removing %.*s",
-		dentry, dentry->d_name.len, dentry->d_name.name);
+	pr_debug("dentry %p, removing %.*s\n",
+		 dentry, dentry->d_name.len, dentry->d_name.name);
 
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
@@ -709,8 +711,8 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
 
-	DPRINTK("dentry %p, creating %.*s",
-		dentry, dentry->d_name.len, dentry->d_name.name);
+	pr_debug("dentry %p, creating %.*s\n",
+		 dentry, dentry->d_name.len, dentry->d_name.name);
 
 	BUG_ON(!ino);
 
@@ -798,7 +800,7 @@ static inline int autofs4_ask_umount(struct vfsmount *mnt, int __user *p)
 	if (may_umount(mnt))
 		status = 1;
 
-	DPRINTK("returning %d", status);
+	pr_debug("returning %d\n", status);
 
 	status = put_user(status, p);
 
@@ -826,8 +828,8 @@ static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 	struct autofs_sb_info *sbi = autofs4_sbi(inode->i_sb);
 	void __user *p = (void __user *)arg;
 
-	DPRINTK("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u",
-		cmd,arg,sbi,task_pgrp_nr(current));
+	pr_debug("cmd = 0x%08x, arg = 0x%08lx, sbi = %p, pgrp = %u\n",
+		 cmd, arg, sbi, task_pgrp_nr(current));
 
 	if (_IOC_TYPE(cmd) != _IOC_TYPE(AUTOFS_IOC_FIRST) ||
 	     _IOC_NR(cmd) - _IOC_NR(AUTOFS_IOC_FIRST) >= AUTOFS_IOC_COUNT)
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index e1fbdee..37cb49b 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -11,6 +11,8 @@
  *
  * ------------------------------------------------------------------------- */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/signal.h>
@@ -34,7 +36,7 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
 		return;
 	}
 
-	DPRINTK("entering catatonic mode");
+	pr_debug("entering catatonic mode\n");
 
 	sbi->catatonic = 1;
 	wq = sbi->queues;
@@ -103,8 +105,9 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 	struct file *pipe = NULL;
 	size_t pktsz;
 
-	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
-		(unsigned long) wq->wait_queue_token, wq->name.len, wq->name.name, type);
+	pr_debug("wait id = 0x%08lx, name = %.*s, type=%d\n",
+		(unsigned long)wq->wait_queue_token,
+		 wq->name.len, wq->name.name, type);
 
 	memset(&pkt,0,sizeof pkt); /* For security reasons */
 
@@ -162,7 +165,7 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 		break;
 	}
 	default:
-		printk("autofs4_notify_daemon: bad type %d!\n", type);
+		pr_err("%s: bad type %d!\n", __func__, type);
 		return;
 	}
 
@@ -437,9 +440,9 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 					autofs_ptype_expire_indirect;
 		}
 
-		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
-			(unsigned long) wq->wait_queue_token, wq->name.len,
-			wq->name.name, notify);
+		pr_debug("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
+			 (unsigned long)wq->wait_queue_token, wq->name.len,
+			 wq->name.name, notify);
 
 		/* autofs4_notify_daemon() may block */
 		autofs4_notify_daemon(sbi, wq, type);
@@ -447,8 +450,8 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		wq->wait_ctr++;
 		mutex_unlock(&sbi->wq_mutex);
 		kfree(qstr.name);
-		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
-			(unsigned long) wq->wait_queue_token, wq->name.len,
+		pr_debug("existing wait id = 0x%08lx, name = %.*s, nfy=%d\n",
+			 (unsigned long)wq->wait_queue_token, wq->name.len,
 			wq->name.name, notify);
 	}
 
@@ -474,7 +477,7 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		recalc_sigpending();
 		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 	} else {
-		DPRINTK("skipped sleeping");
+		pr_debug("skipped sleeping\n");
 	}
 
 	status = wq->status;
-- 
1.7.6.405.gc1be0



