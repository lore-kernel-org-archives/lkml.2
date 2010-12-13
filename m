Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0LMSQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:16:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:24279 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab0LMSQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:16:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,336,1288594800"; 
   d="scan'208";a="867688167"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        "Borislav Petkov" <bp@alien8.de>, "David Miller" <davem@davemloft.net>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Jim Keniston" <jkenisto@linux.vnet.ibm.com>,
        "Kyungmin Park" <kmpark@infradead.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [concept & "good taste" review] persistent store
Date: Mon, 13 Dec 2010 10:16:05 -0800
Message-Id: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

At the Plumbers conference I chatted to Thomas and Peter about this idea,
and got some positive feedback - so I implemented a prototype which has
gone through three revisions on LKML.  I've been pounding out the obvious
stupidities that people have pointed out to me (thanks alphabetically to
Alan, Andrew, Boris, Peter and Ying), so now the code is now converging
on some kind of final version ... it's time to check whether it's getting
close to something useful, or whether I've been drinking too much of the
cool-aid.

So before I embark on another round of code nit-picking, I'd like to
get answers to the bigger questions:

  Do we want/need this in Linux at all?

  Is the overall approach OK, or do I need do this some other way?



The basic idea:
--------------

Most X86 server class systems that are less than a couple of years old
include a small amount of persistent storage - AFAIK this is a WHQL
requirement to get a Windows Server 2008 sticker.  The interface to this
storage is via ACPI, which isn't really suitable for a generic interface
since many other architectures are not lucky enough to have ACPI :-) But
they may have persistent storage that they would like to use (David Miller
said he'd be able to use this on sparc64 and Jim Keniston thought he
could adapt some NVRAM code he has for powerpc to use this framework).

I'm using a file system interface to make persistent storage visible
to users.  A filesystem seems to be a logical way to do this because we
have one or more "blobs" of data from each crash. The X86 ACPI-ERST store on
my test machine can take almost 8 Kbytes per "record" - which is usually
plenty to see the panic, stack trace, and several lines leading up to it.

Since I think everyone who has persistent store will want to save the
console log - I made the generic part register with "kmsg_dump_register()"
to save & show "dmesg" information. But I would like to also use this
for unrecoverable machine check information - other people may find
interesting ways to use this too.

Early versions used /sys - which turned out to have issues as there was
no way to hook "unlink(2)" on the files - useful as a way to signal that
the data could be erased from the persistent store, so a new filesystem
"pstore" born using ramfs infrastructure (as suggested to me by Peter).

To the user it looks like this:

$ ls -l /dev/pstore
total 8
-r--r--r-- 1 root root 7896 Dec  3 10:56 dmesg-erst-5546531799825383425


Filenames show the "type" of the data ("dmesg" is console log) as well
as which persistent storage device the data came from, and a unique
device specific identifier (which for ERST is a 64-bit number which
should never be re-used - blame the UEFI spec) ... although the file
names may be a bit unwieldy - they are going to be consistent from one
boot to the next - so if you don't erase a record, the same data will
show up with the same filename. The modification time of the file is set
to the time the data was saved to the persistent store.  The current code
reserves the prefix "mce" (machine check exception) for files containing
fatal error information. Other uses would reserve their own prefixes so
that user level tools can find the data that they are interested in and
skip stuff intended for other scripts/tools.

After the user has finished looking at the file and got all the data
they need ... E.g.
$ grep RIP: /dev/pstore/dmesg-erst-5546531799825383425 
<4>[  552.268202] RIP: 0010:[<ffffffff812a3a25>]  [<ffffffff812a3a25>] sysrq_handle_crash+0x16/0x20

(s)he simply removes the file - which results in a call from the generic
pstore filesystem code to the platform driver to erase this data from
the persistent store.

# rm /dev/pstore/dmesg-erst-5546531799825383425

-Tony

Here's v4 of the generic part of the code - so if the answers to the big
questions were "yes", then you can pick holes in it.  The bit I'm most
worried might fail the good taste test is "pstore_writefile()" which
acts like an open+write to push data into a file.

---

 Documentation/ABI/testing/pstore |   35 ++++++
 fs/Kconfig                       |    1 
 fs/Makefile                      |    1 
 fs/pstore/Kconfig                |   13 ++
 fs/pstore/Makefile               |    7 +
 fs/pstore/inode.c                |  219 +++++++++++++++++++++++++++++++++++++++
 fs/pstore/internal.h             |    5 
 fs/pstore/platform.c             |  208 +++++++++++++++++++++++++++++++++++++
 include/linux/magic.h            |    1 
 include/linux/pstore.h           |   60 ++++++++++
 10 files changed, 550 insertions(+)


diff --git a/Documentation/ABI/testing/pstore b/Documentation/ABI/testing/pstore
new file mode 100644
index 0000000..f1fb2a0
--- /dev/null
+++ b/Documentation/ABI/testing/pstore
@@ -0,0 +1,35 @@
+Where:		/dev/pstore/...
+Date:		January 2011
+Kernel Version: 2.6.38
+Contact:	tony.luck@intel.com
+Description:	Generic interface to platform dependent persistent storage.
+
+		Platforms that provide a mechanism to preserve some data
+		across system reboots can register with this driver to
+		provide a generic interface to show records captured in
+		the dying moments.  In the case of a panic the last part
+		of the console log is captured, but other interesting
+		data can also be saved.
+
+		# mount -t pstore - /dev/pstore
+
+		$ ls -l /dev/pstore
+		total 0
+		-r--r--r-- 1 root root 7896 Nov 30 15:38 dmesg-erst-1
+
+		Different users of this interface will result in different
+		filename prefixes.  Currently two are defined:
+
+		"dmesg"	- saved console log
+		"mce"	- architecture dependent data from fatal h/w error
+
+		Once the information in a file has been read, removing
+		the file will signal to the underlying persistent storage
+		device that it can reclaim the space for later re-use.
+
+		$ rm /dev/pstore/dmesg-erst-1
+
+		The expectation is that all files in /dev/pstore
+		will be saved elsewhere and erased from persistent store
+		soon after boot to free up space ready for the next
+		catastrophe.
diff --git a/fs/Kconfig b/fs/Kconfig
index 771f457..2bbe47f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -188,6 +188,7 @@ source "fs/omfs/Kconfig"
 source "fs/hpfs/Kconfig"
 source "fs/qnx4/Kconfig"
 source "fs/romfs/Kconfig"
+source "fs/pstore/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index a7f7cef..db71a5b 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -121,3 +121,4 @@ obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_EXOFS_FS)          += exofs/
 obj-$(CONFIG_CEPH_FS)		+= ceph/
+obj-$(CONFIG_PSTORE)		+= pstore/
diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
new file mode 100644
index 0000000..867d0ac
--- /dev/null
+++ b/fs/pstore/Kconfig
@@ -0,0 +1,13 @@
+config PSTORE
+	bool "Persistant store support"
+	default n
+	help
+	   This option enables generic access to platform level
+	   persistent storage via "pstore" filesystem that can
+	   be mounted as /dev/pstore.  Only useful if you have
+	   a platform level driver that registers with pstore to
+	   provide the data, so you probably should just go say "Y"
+	   (or "M") to a platform specific persistent store driver
+	   (e.g. ACPI_APEI on X86) which will select this for you.
+	   If you don't have a platform persistent store driver,
+	   say N.
diff --git a/fs/pstore/Makefile b/fs/pstore/Makefile
new file mode 100644
index 0000000..760f4bc
--- /dev/null
+++ b/fs/pstore/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the linux pstorefs routines.
+#
+
+obj-y += pstore.o
+
+pstore-objs += inode.o platform.o
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
new file mode 100644
index 0000000..bc704ce
--- /dev/null
+++ b/fs/pstore/inode.c
@@ -0,0 +1,219 @@
+/*
+ * Persistent Storage - ramfs parts.
+ *
+ * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include <linux/highmem.h>
+#include <linux/time.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/mount.h>
+#include <linux/ramfs.h>
+#include <linux/sched.h>
+#include <linux/magic.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "internal.h"
+
+#define pstore_get_inode ramfs_get_inode
+
+static int pstore_unlink(struct inode *dir, struct dentry *dentry)
+{
+	pstore_erase(dentry->d_inode->i_private);
+
+	return simple_unlink(dir, dentry);
+}
+
+static const struct inode_operations pstore_dir_inode_operations = {
+	.lookup		= simple_lookup,
+	.unlink		= pstore_unlink,
+};
+
+static const struct super_operations pstore_ops = {
+	.statfs		= simple_statfs,
+	.drop_inode	= generic_delete_inode,
+	.show_options	= generic_show_options,
+};
+
+static struct super_block *pstore_sb;
+static struct vfsmount *pstore_mnt;
+
+int pstore_is_mounted(void)
+{
+	return pstore_mnt != NULL;
+}
+
+/*
+ * Set up a file structure as if we had opened this file and
+ * write our data to it.
+ */
+static int pstore_writefile(struct inode *inode, struct dentry *dentry,
+	char *data, size_t size)
+{
+	struct file f;
+	ssize_t n;
+	mm_segment_t old_fs = get_fs();
+
+	memset(&f, '0', sizeof f);
+	f.f_mapping = inode->i_mapping;
+	f.f_path.dentry = dentry;
+	f.f_path.mnt = pstore_mnt;
+	f.f_pos = 0;
+	f.f_op = inode->i_fop;
+	set_fs(KERNEL_DS);
+	n = do_sync_write(&f, data, size, &f.f_pos);
+	set_fs(old_fs);
+
+	return n == size;
+}
+
+/*
+ * Make a regular file in the root directory of our file system.
+ * Load it up with "size" bytes of data from "buf".
+ * Set the mtime & ctime to the date that this record was originally stored.
+ */
+int pstore_mkfile(char *name, char *data, size_t size, struct timespec time,
+		  void *private)
+{
+	struct dentry	*root = pstore_sb->s_root;
+	struct dentry	*dentry;
+	struct inode	*inode;
+	int		rc;
+
+	rc = -ENOMEM;
+	inode = pstore_get_inode(pstore_sb, root->d_inode, S_IFREG | 0444, 0);
+	if (!inode)
+		goto fail;
+
+	inode->i_private = private;
+
+	mutex_lock(&root->d_inode->i_mutex);
+
+	rc = -ENOSPC;
+	dentry = d_alloc_name(root, name);
+	if (IS_ERR(dentry))
+		goto fail_alloc;
+
+	d_add(dentry, inode);
+
+	mutex_unlock(&root->d_inode->i_mutex);
+
+	if (!pstore_writefile(inode, dentry, data, size))
+		goto fail_write;
+
+	if (time.tv_sec)
+		inode->i_mtime = inode->i_ctime = time;
+
+	return 0;
+
+fail_write:
+	inode->i_nlink--;
+	mutex_lock(&root->d_inode->i_mutex);
+	d_delete(dentry);
+	dput(dentry);
+	mutex_unlock(&root->d_inode->i_mutex);
+	goto fail;
+
+fail_alloc:
+	mutex_unlock(&root->d_inode->i_mutex);
+	iput(inode);
+
+fail:
+	return rc;
+}
+
+int pstore_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct inode *inode = NULL;
+	struct dentry *root;
+	int err;
+
+	save_mount_options(sb, data);
+
+	pstore_sb = sb;
+
+	sb->s_maxbytes		= MAX_LFS_FILESIZE;
+	sb->s_blocksize		= PAGE_CACHE_SIZE;
+	sb->s_blocksize_bits	= PAGE_CACHE_SHIFT;
+	sb->s_magic		= PSTOREFS_MAGIC;
+	sb->s_op		= &pstore_ops;
+	sb->s_time_gran		= 1;
+
+	inode = pstore_get_inode(sb, NULL, S_IFDIR | 0755, 0);
+	if (!inode) {
+		err = -ENOMEM;
+		goto fail;
+	}
+	/* override ramfs "dir" options so we catch unlink(2) */
+	inode->i_op = &pstore_dir_inode_operations;
+
+	root = d_alloc_root(inode);
+	sb->s_root = root;
+	if (!root) {
+		err = -ENOMEM;
+		goto fail;
+	}
+
+	pstore_get_records();
+
+	return 0;
+fail:
+	iput(inode);
+	return err;
+}
+
+static int pstore_get_sb(struct file_system_type *fs_type,
+	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	struct dentry *root;
+
+	root = mount_nodev(fs_type, flags, data, pstore_fill_super);
+	if (IS_ERR(root))
+		return -ENOMEM;
+
+	mnt->mnt_root = root;
+	mnt->mnt_sb = root->d_sb;
+	pstore_mnt = mnt;
+
+	return 0;
+}
+
+static void pstore_kill_sb(struct super_block *sb)
+{
+	kill_litter_super(sb);
+	pstore_sb = NULL;
+	pstore_mnt = NULL;
+}
+
+static struct file_system_type pstore_fs_type = {
+	.name		= "pstore",
+	.get_sb		= pstore_get_sb,
+	.kill_sb	= pstore_kill_sb,
+};
+
+static int __init init_pstore_fs(void)
+{
+	return register_filesystem(&pstore_fs_type);
+}
+module_init(init_pstore_fs)
+
+MODULE_AUTHOR("Tony Luck <tony.luck@intel.com>");
+MODULE_LICENSE("GPL");
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
new file mode 100644
index 0000000..1f274ff
--- /dev/null
+++ b/fs/pstore/internal.h
@@ -0,0 +1,5 @@
+extern void	pstore_get_records(void);
+extern int	pstore_mkfile(char *name, char *data, size_t size,
+			      struct timespec time, void *private);
+extern void	pstore_erase(void *private);
+extern int	pstore_is_mounted(void);
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
new file mode 100644
index 0000000..59939f0
--- /dev/null
+++ b/fs/pstore/platform.c
@@ -0,0 +1,208 @@
+/*
+ * Persistent Storage - platform driver interface parts.
+ *
+ * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/atomic.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kmsg_dump.h>
+#include <linux/module.h>
+#include <linux/pstore.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "internal.h"
+
+/*
+ * pstore_lock just protects "psinfo" during
+ * calls to pstore_register()
+ */
+static DEFINE_SPINLOCK(pstore_lock);
+static struct pstore_info *psinfo;
+
+#define	PSTORE_NAMELEN	64
+
+struct pstore_private {
+	u64	id;
+	int	(*erase)(u64);
+};
+
+/*
+ * callback from kmsg_dump. (s2,l2) has the most recently
+ * written bytes, older bytes are in (s1,l1). Save as much
+ * as we can from the end of the buffer.
+ */
+static void pstore_dump(struct kmsg_dumper *dumper,
+	    enum kmsg_dump_reason reason,
+	    const char *s1, unsigned long l1,
+	    const char *s2, unsigned long l2)
+{
+	unsigned long s1_start, s2_start;
+	unsigned long l1_cpy, l2_cpy;
+	char *dst = psinfo->buf;
+
+	/* Don't dump oopses to persistent store */
+	if (reason == KMSG_DUMP_OOPS)
+		return;
+
+	l2_cpy = min(l2, psinfo->bufsize);
+	l1_cpy = min(l1, psinfo->bufsize - l2_cpy);
+
+	s2_start = l2 - l2_cpy;
+	s1_start = l1 - l1_cpy;
+
+	mutex_lock(&psinfo->buf_mutex);
+	memcpy(dst, s1 + s1_start, l1_cpy);
+	memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
+
+	psinfo->write(PSTORE_TYPE_DMESG, l1_cpy + l2_cpy);
+	mutex_unlock(&psinfo->buf_mutex);
+}
+
+static struct kmsg_dumper pstore_dumper = {
+	.dump = pstore_dump,
+};
+
+/*
+ * platform specific persistent storage driver registers with
+ * us here. If pstore is already mounted, call the platform
+ * read function right away to populate the file system. If not
+ * then the pstore mount code will call us later to fill out
+ * the file system.
+ *
+ * Register with kmsg_dump to save last part of console log on panic.
+ */
+int pstore_register(struct pstore_info *psi)
+{
+	struct module *owner = psi->owner;
+
+	spin_lock(&pstore_lock);
+	if (psinfo) {
+		spin_unlock(&pstore_lock);
+		return -EBUSY;
+	}
+	psinfo = psi;
+	spin_unlock(&pstore_lock);
+
+	if (owner && !try_module_get(owner)) {
+		psinfo = NULL;
+		return -EINVAL;
+	}
+
+	if (pstore_is_mounted())
+		pstore_get_records();
+
+	kmsg_dump_register(&pstore_dumper);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pstore_register);
+
+/*
+ * Read all the records from the persistent store. Create and
+ * file files in our filesystem.
+ */
+void pstore_get_records(void)
+{
+	struct pstore_info *psi = psinfo;
+	size_t			size;
+	u64			id;
+	enum pstore_type_id	type;
+	char			name[PSTORE_NAMELEN];
+	struct pstore_private	*private;
+	struct timespec		time;
+	int			failed = 0;
+
+	if (!psi)
+		return;
+
+	mutex_lock(&psinfo->buf_mutex);
+	while ((size = psi->read(&id, &type, &time)) > 0) {
+		switch (type) {
+		case PSTORE_TYPE_DMESG:
+			sprintf(name, "dmesg-%s-%lld", psi->name, id);
+			break;
+		case PSTORE_TYPE_MCE:
+			sprintf(name, "mce-%s-%lld", psi->name, id);
+			break;
+		case PSTORE_TYPE_UNKNOWN:
+			sprintf(name, "unknown-%s-%lld", psi->name, id);
+			break;
+		default:
+			sprintf(name, "type%d-%s-%lld", type, psi->name, id);
+			break;
+		}
+		private = kmalloc(sizeof *private, GFP_KERNEL);
+		if (!private) {
+			failed++;
+			continue;
+		}
+		private->id = id;
+		private->erase = psi->erase;
+		if (pstore_mkfile(name, psi->buf, size, time, private)) {
+			kfree(private);
+			failed++;
+		}
+	}
+	mutex_unlock(&psinfo->buf_mutex);
+
+	if (failed)
+		printk(KERN_WARNING "pstore: failed to load %d record(s) from '%s'\n",
+		       failed, psi->name);
+}
+
+/*
+ * Call platform driver to write a record to the
+ * persistent store. We don't worry about making
+ * this visible in the pstore filesystem as the
+ * presumption is that we only save things to the
+ * store in the dying moments of OS failure. Hence
+ * nobody will see the entries in the filesystem.
+ */
+int pstore_write(enum pstore_type_id type, char *buf, size_t size)
+{
+	int	ret;
+
+	if (!psinfo)
+		return -ENODEV;
+
+	if (size > psinfo->bufsize)
+		return -EFBIG;
+
+	mutex_lock(&psinfo->buf_mutex);
+	memcpy(psinfo->buf, buf, size);
+	ret = psinfo->write(type, size);
+	mutex_unlock(&psinfo->buf_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pstore_write);
+
+/*
+ * When a file is unlinked from our file system we call the
+ * platform driver to erase the record from persistent store.
+ */
+void pstore_erase(void *private)
+{
+	struct pstore_private *p = private;
+
+	p->erase(p->id);
+	kfree(p);
+}
diff --git a/include/linux/magic.h b/include/linux/magic.h
index ff690d0..e87fd5a 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -26,6 +26,7 @@
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
 #define ANON_INODE_FS_MAGIC	0x09041934
+#define PSTOREFS_MAGIC		0x6165676C
 
 #define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix fs, 30 char names */
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
new file mode 100644
index 0000000..99bf5aa
--- /dev/null
+++ b/include/linux/pstore.h
@@ -0,0 +1,60 @@
+/*
+ * Persistent Storage - pstore.h
+ *
+ * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
+ *
+ * This code is the generic layer to export data records from platform
+ * level persistent storage via a file system.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef _LINUX_PSTORE_H
+#define _LINUX_PSTORE_H
+
+/* types */
+enum pstore_type_id {
+	PSTORE_TYPE_DMESG	= 0,
+	PSTORE_TYPE_MCE		= 1,
+	PSTORE_TYPE_UNKNOWN	= 255
+};
+
+struct pstore_info {
+	struct module	*owner;
+	char		*name;
+	struct mutex	buf_mutex;	/* serialize access to 'buf' */
+	char		*buf;
+	size_t		bufsize;
+	size_t		(*read)(u64 *id, enum pstore_type_id *type,
+			struct timespec *time);
+	int		(*write)(enum pstore_type_id type, size_t size);
+	int		(*erase)(u64 id);
+};
+
+#ifdef CONFIG_PSTORE
+extern int pstore_register(struct pstore_info *);
+extern int pstore_write(enum pstore_type_id type, char *buf, size_t size);
+#else
+static inline int
+pstore_register(struct pstore_info *psi)
+{
+	return -ENODEV;
+}
+static inline int
+pstore_write(enum pstore_type_id type, char *buf, size_t size)
+{
+	return -ENODEV;
+}
+#endif
+
+#endif /*_LINUX_PSTORE_H*/
