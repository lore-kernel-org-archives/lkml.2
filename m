Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2DIMoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:44:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33138 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2DIMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:44:07 -0400
Message-ID: <1333975435.29217.30.camel@mop>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
From: Kay Sievers <kay@vrfy.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Mon, 09 Apr 2012 14:43:55 +0200
In-Reply-To: <4D2D856B-AE62-49D6-9ABE-5238E8B23A6C@mit.edu>
References: <4F80892A.7050104@zytor.com> <4F81D5C4.9000503@openvz.org>
	 <20120408231841.42e28867@pyramind.ukuu.org.uk> <4F8210A5.7000900@zytor.com>
	 <20120408234641.788f8426@pyramind.ukuu.org.uk> <4F821524.9090702@zytor.com>
	 <4D2D856B-AE62-49D6-9ABE-5238E8B23A6C@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.3.91 (3.3.91-1.fc17)
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 23:15 -0400, Theodore Tso wrote:
> On Apr 8, 2012, at 6:45 PM, H. Peter Anvin wrote:
> 
> > On 04/08/2012 03:46 PM, Alan Cox wrote:
> >>> What if it turns out we can make udev/devtmpfs make this happen
> >>> transparently (which it sounds like it might be possible)?  Would you be
> >>> okay with removing the "implicit bind mount" property of the current
> >>> devpts then?
> >> 
> >> Once we get to the point where it "just works" I'm quite happy for that
> >> to happen unless it turns out there's any large code size/performance
> >> hits in having the feature always on. I don't see any.
> >> 
> > 
> > No, it's actually the other way around... it lets us take some pretty
> > nice shortcuts.
> 
> If it requires making changes to udev, can we place make sure have
> a decent amount of time before we remove code from the kernel? 
> I really hate it when people break userspace for the convenience
> of kernel programmers.   As I recall Linus had something to say
> about that….

As mentioned earlier, udev is not involved at all here. It's all in the
kernel these days; all device nodes are created by the kernel and not by
udev.

The one that is in the way here is created by kernel code, and udev will
never gain options or support instructions to delete kernel-created
nodes. We refuse to teach udev stupid tricks to work around the kernel's
idea of new features and options.

The entire idea of legacy vs. non-legacy for devpts is kind of broken to
begin with. Requiring to delete kernel-created device nodes and
replacing them with symlinks, like mentioned in the devpts
documentation, should never be a job for userspace; it needs to be done
properly inside the kernel.

Today, userspace should not be required to fiddle around with such
stuff, it just mounts the filesystem like it always did, and nothing
else. I does not want to know about any new options in such category,
which can work on specific kernels only, and will cause too much trouble
to support in the end.

The following patch is just to clean up the confusion about userspace
and the unfortunate idea of legacy vs. non-legacy mount options. It is
nowhere ready to merge, but it should make is pretty clear, that
userspace should be left alone here, and it's a job for the kernel only.

Cheers,
Kay

# ls -l /dev
crw------- 1 root root     10,   1 Apr  9 14:21 psaux
lrwxrwxrwx 1 root root           8 Apr  9 14:20 ptmx -> pts/ptmx
drwxr-xr-x 2 root root           0 Apr  9 14:21 pts
crw-rw-rw- 1 root root      1,   8 Apr  9 14:21 random

# ls -l /dev/pts
total 0
crw--w---- 1 root tty 136, 0 Apr  9 14:22 0
crw--w---- 1 kay  tty 136, 1 Apr  9 14:22 1
crw-rw-rw- 1 root tty   5, 2 Apr  9 14:22 ptmx

---
 drivers/base/devtmpfs.c |   60 ++++++++++++++++++++++++-
 drivers/tty/Kconfig     |   11 ----
 drivers/tty/pty.c       |    3 -
 fs/devpts/inode.c       |  112 +++++++-----------------------------------------
 include/linux/device.h  |    2 
 5 files changed, 76 insertions(+), 112 deletions(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -40,6 +40,7 @@ static struct req {
 	struct completion done;
 	int err;
 	const char *name;
+	const char *target;
 	umode_t mode;	/* 0 => delete */
 	struct device *dev;
 } *requests;
@@ -84,7 +85,7 @@ int devtmpfs_create_node(struct device *
 	if (!thread)
 		return 0;
 
-	req.mode = 0;
+	memset(&req, 0, sizeof(struct req));
 	req.name = device_get_devnode(dev, &req.mode, &tmp);
 	if (!req.name)
 		return -ENOMEM;
@@ -113,6 +114,31 @@ int devtmpfs_create_node(struct device *
 	return req.err;
 }
 
+int devtmpfs_create_link(const char *name, const char *target)
+{
+	struct req req;
+
+	if (!thread)
+		return 0;
+
+	memset(&req, 0, sizeof(struct req));
+	req.mode = 0666;
+	req.name = name;
+	req.target = target;
+
+	init_completion(&req.done);
+
+	spin_lock(&req_lock);
+	req.next = requests;
+	requests = &req;
+	spin_unlock(&req_lock);
+
+	wake_up_process(thread);
+	wait_for_completion(&req.done);
+
+	return req.err;
+}
+
 int devtmpfs_delete_node(struct device *dev)
 {
 	const char *tmp = NULL;
@@ -121,11 +147,11 @@ int devtmpfs_delete_node(struct device *
 	if (!thread)
 		return 0;
 
+	memset(&req, 0, sizeof(struct req));
 	req.name = device_get_devnode(dev, NULL, &tmp);
 	if (!req.name)
 		return -ENOMEM;
 
-	req.mode = 0;
 	req.dev = dev;
 
 	init_completion(&req.done);
@@ -225,6 +251,28 @@ static int handle_create(const char *nod
 	return err;
 }
 
+static int handle_create_link(const char *name, const char *target)
+{
+	struct dentry *dentry;
+	struct path path;
+	int err;
+
+	dentry = kern_path_create(AT_FDCWD, name, &path, 0);
+	if (dentry == ERR_PTR(-ENOENT)) {
+		create_path(name);
+		dentry = kern_path_create(AT_FDCWD, name, &path, 0);
+	}
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	err = vfs_symlink(path.dentry->d_inode, dentry, target);
+	dput(dentry);
+
+	mutex_unlock(&path.dentry->d_inode->i_mutex);
+	path_put(&path);
+	return err;
+}
+
 static int dev_rmdir(const char *name)
 {
 	struct nameidata nd;
@@ -378,8 +426,11 @@ int devtmpfs_mount(const char *mntdir)
 
 static DECLARE_COMPLETION(setup_done);
 
-static int handle(const char *name, umode_t mode, struct device *dev)
+static int handle(const char *name, umode_t mode,
+		  struct device *dev, const char *target)
 {
+	if (target)
+		return handle_create_link(name, target);
 	if (mode)
 		return handle_create(name, mode, dev);
 	else
@@ -407,7 +458,8 @@ static int devtmpfsd(void *p)
 			spin_unlock(&req_lock);
 			while (req) {
 				struct req *next = req->next;
-				req->err = handle(req->name, req->mode, req->dev);
+				req->err = handle(req->name, req->mode,
+						  req->dev, req->target);
 				complete(&req->done);
 				req = next;
 			}
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -109,17 +109,6 @@ config UNIX98_PTYS
 	  All modern Linux systems use the Unix98 ptys.  Say Y unless
 	  you're on an embedded system and want to conserve memory.
 
-config DEVPTS_MULTIPLE_INSTANCES
-	bool "Support multiple instances of devpts"
-	depends on UNIX98_PTYS
-	default n
-	---help---
-	  Enable support for multiple instances of devpts filesystem.
-	  If you want to have isolated PTY namespaces (eg: in containers),
-	  say Y here.  Otherwise, say N. If enabled, each mount of devpts
-	  filesystem with the '-o newinstance' option will create an
-	  independent PTY namespace.
-
 config LEGACY_PTYS
 	bool "Legacy (BSD) PTY support"
 	default y
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -706,7 +706,7 @@ static void __init unix98_pty_init(void)
 	if (tty_register_driver(pts_driver))
 		panic("Couldn't register Unix98 pts driver");
 
-	/* Now create the /dev/ptmx special device */
+	/* Hook up the ptmx cdev which lives inside the devpts filesystem */
 	tty_default_fops(&ptmx_fops);
 	ptmx_fops.open = ptmx_open;
 
@@ -714,7 +714,6 @@ static void __init unix98_pty_init(void)
 	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 2), 1, "/dev/ptmx") < 0)
 		panic("Couldn't register /dev/ptmx driver\n");
-	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 2), NULL, "ptmx");
 }
 
 #else
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -26,15 +26,9 @@
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
 
-#define DEVPTS_DEFAULT_MODE 0600
-/*
- * ptmx is a new node in /dev/pts and will be unused in legacy (single-
- * instance) mode. To prevent surprises in user space, set permissions of
- * ptmx to 0. Use 'chmod' or remount with '-o ptmxmode' to set meaningful
- * permissions.
- */
-#define DEVPTS_DEFAULT_PTMX_MODE 0000
-#define PTMX_MINOR	2
+#define DEVPTS_DEFAULT_MODE		0600
+#define DEVPTS_DEFAULT_PTMX_MODE	0666
+#define PTMX_MINOR			2
 
 /*
  * sysctl support for setting limits on the number of Unix98 ptys allocated.
@@ -102,24 +96,19 @@ struct pts_mount_opts {
 	gid_t   gid;
 	umode_t mode;
 	umode_t ptmxmode;
-	int newinstance;
 	int max;
 };
 
 enum {
-	Opt_uid, Opt_gid, Opt_mode, Opt_ptmxmode, Opt_newinstance,  Opt_max,
-	Opt_err
+	Opt_uid, Opt_gid, Opt_mode, Opt_ptmxmode, Opt_max, Opt_err
 };
 
 static const match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_mode, "mode=%o"},
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	{Opt_ptmxmode, "ptmxmode=%o"},
-	{Opt_newinstance, "newinstance"},
 	{Opt_max, "max=%d"},
-#endif
 	{Opt_err, NULL}
 };
 
@@ -136,10 +125,8 @@ static inline struct pts_fs_info *DEVPTS
 
 static inline struct super_block *pts_sb_from_inode(struct inode *inode)
 {
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	if (inode->i_sb->s_magic == DEVPTS_SUPER_MAGIC)
 		return inode->i_sb;
-#endif
 	return devpts_mnt->mnt_sb;
 }
 
@@ -149,9 +136,7 @@ static inline struct super_block *pts_sb
 /*
  * parse_mount_options():
  * 	Set @opts to mount options specified in @data. If an option is not
- * 	specified in @data, set it to its default value. The exception is
- * 	'newinstance' option which can only be set/cleared on a mount (i.e.
- * 	cannot be changed during remount).
+ * 	specified in @data, set it to its default value.\
  *
  * Note: @data may be NULL (in which case all options are set to default).
  */
@@ -167,10 +152,6 @@ static int parse_mount_options(char *dat
 	opts->ptmxmode = DEVPTS_DEFAULT_PTMX_MODE;
 	opts->max     = NR_UNIX98_PTY_MAX;
 
-	/* newinstance makes sense only on initial mount */
-	if (op == PARSE_MOUNT)
-		opts->newinstance = 0;
-
 	while ((p = strsep(&data, ",")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
 		int token;
@@ -198,24 +179,17 @@ static int parse_mount_options(char *dat
 				return -EINVAL;
 			opts->mode = option & S_IALLUGO;
 			break;
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 		case Opt_ptmxmode:
 			if (match_octal(&args[0], &option))
 				return -EINVAL;
 			opts->ptmxmode = option & S_IALLUGO;
 			break;
-		case Opt_newinstance:
-			/* newinstance makes sense only on initial mount */
-			if (op == PARSE_MOUNT)
-				opts->newinstance = 1;
-			break;
 		case Opt_max:
 			if (match_int(&args[0], &option) ||
 			    option < 0 || option > NR_UNIX98_PTY_MAX)
 				return -EINVAL;
 			opts->max = option;
 			break;
-#endif
 		default:
 			printk(KERN_ERR "devpts: called with bogus options\n");
 			return -EINVAL;
@@ -225,7 +199,6 @@ static int parse_mount_options(char *dat
 	return 0;
 }
 
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 static int mknod_ptmx(struct super_block *sb)
 {
 	int mode;
@@ -260,6 +233,8 @@ static int mknod_ptmx(struct super_block
 		goto out;
 	}
 
+	if (opts->setgid)
+		inode->i_gid = opts->gid;
 	inode->i_ino = 2;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 
@@ -283,12 +258,6 @@ static void update_ptmx_mode(struct pts_
 		inode->i_mode = S_IFCHR|fsi->mount_opts.ptmxmode;
 	}
 }
-#else
-static inline void update_ptmx_mode(struct pts_fs_info *fsi)
-{
-       return;
-}
-#endif
 
 static int devpts_remount(struct super_block *sb, int *flags, char *data)
 {
@@ -319,11 +288,9 @@ static int devpts_show_options(struct se
 	if (opts->setgid)
 		seq_printf(seq, ",gid=%u", opts->gid);
 	seq_printf(seq, ",mode=%03o", opts->mode);
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	seq_printf(seq, ",ptmxmode=%03o", opts->ptmxmode);
 	if (opts->max < NR_UNIX98_PTY_MAX)
 		seq_printf(seq, ",max=%d", opts->max);
-#endif
 
 	return 0;
 }
@@ -384,43 +351,8 @@ fail:
 	return -ENOMEM;
 }
 
-#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
-static int compare_init_pts_sb(struct super_block *s, void *p)
-{
-	if (devpts_mnt)
-		return devpts_mnt->mnt_sb == s;
-	return 0;
-}
-
-/*
- * devpts_mount()
- *
- *     If the '-o newinstance' mount option was specified, mount a new
- *     (private) instance of devpts.  PTYs created in this instance are
- *     independent of the PTYs in other devpts instances.
- *
- *     If the '-o newinstance' option was not specified, mount/remount the
- *     initial kernel mount of devpts.  This type of mount gives the
- *     legacy, single-instance semantics.
- *
- *     The 'newinstance' option is needed to support multiple namespace
- *     semantics in devpts while preserving backward compatibility of the
- *     current 'single-namespace' semantics. i.e all mounts of devpts
- *     without the 'newinstance' mount option should bind to the initial
- *     kernel mount, like mount_single().
- *
- *     Mounts with 'newinstance' option create a new, private namespace.
- *
- *     NOTE:
- *
- *     For single-mount semantics, devpts cannot use mount_single(),
- *     because mount_single()/sget() find and use the super-block from
- *     the most recent mount of devpts. But that recent mount may be a
- *     'newinstance' mount and mount_single() would pick the newinstance
- *     super-block instead of the initial super-block.
- */
 static struct dentry *devpts_mount(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data)
+				   int flags, const char *dev_name, void *data)
 {
 	int error;
 	struct pts_mount_opts opts;
@@ -430,10 +362,7 @@ static struct dentry *devpts_mount(struc
 	if (error)
 		return ERR_PTR(error);
 
-	if (opts.newinstance)
-		s = sget(fs_type, NULL, set_anon_super, NULL);
-	else
-		s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
+	s = sget(fs_type, NULL, set_anon_super, NULL);
 
 	if (IS_ERR(s))
 		return ERR_CAST(s);
@@ -459,18 +388,6 @@ out_undo_sget:
 	return ERR_PTR(error);
 }
 
-#else
-/*
- * This supports only the legacy single-instance semantics (no
- * multiple-instance semantics)
- */
-static struct dentry *devpts_mount(struct file_system_type *fs_type, int flags,
-		const char *dev_name, void *data)
-{
-	return mount_single(fs_type, flags, data, devpts_fill_super);
-}
-#endif
-
 static void devpts_kill_sb(struct super_block *sb)
 {
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
@@ -502,8 +419,7 @@ retry:
 		return -ENOMEM;
 
 	mutex_lock(&allocated_ptys_lock);
-	if (pty_count >= pty_limit -
-			(fsi->mount_opts.newinstance ? pty_reserve : 0)) {
+	if (pty_count >= pty_limit - pty_reserve) {
 		mutex_unlock(&allocated_ptys_lock);
 		return -ENOSPC;
 	}
@@ -629,9 +545,15 @@ void devpts_pty_kill(struct tty_struct *
 
 static int __init init_devpts_fs(void)
 {
-	int err = register_filesystem(&devpts_fs_type);
+	int err;
 	struct ctl_table_header *table;
 
+	err = devtmpfs_create_link("ptmx", "pts/ptmx");
+	if (err)
+		return err;
+
+	err = register_filesystem(&devpts_fs_type);
+
 	if (!err) {
 		table = register_sysctl_table(pty_root_table);
 		devpts_mnt = kern_mount(&devpts_fs_type);
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -858,10 +858,12 @@ extern void put_device(struct device *de
 extern void wait_for_device_probe(void);
 
 #ifdef CONFIG_DEVTMPFS
+extern int devtmpfs_create_link(const char *name, const char *target);
 extern int devtmpfs_create_node(struct device *dev);
 extern int devtmpfs_delete_node(struct device *dev);
 extern int devtmpfs_mount(const char *mntdir);
 #else
+static int devtmpfs_create_link(const char *name, const char *target) { return 0; }
 static inline int devtmpfs_create_node(struct device *dev) { return 0; }
 static inline int devtmpfs_delete_node(struct device *dev) { return 0; }
 static inline int devtmpfs_mount(const char *mountpoint) { return 0; }


