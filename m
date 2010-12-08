Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0LHGYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 01:24:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40818 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab0LHGYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 01:24:40 -0500
Date: Wed, 8 Dec 2010 07:24:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] persistent store (version 3) (part 1 of 2)
Message-ID: <20101208062433.GB29751@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
	greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jim Keniston <jkenisto@linux.vnet.ibm.com>,
	Kyungmin Park <kmpark@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <4cfd2b97258571235f@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4cfd2b97258571235f@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tony,

looks good. Minor nitpicks below.

On Mon, Dec 06, 2010 at 10:29:43AM -0800, Luck, Tony wrote:
> Generic code for a "persistent store" file system as an interface
> to provide a friendly user level ABI to platform specific drivers
> for that access to some form of non-volatile storage that can be
> used to save the dying words of an OS instance and make them
> available after the reset/reboot.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> ---
> 
> Part 2 (smaller Cc: list) has the changes to the X86 ACPI/APEI/ERST
> code that makes use of this.
> 
> Version 3 drops use of /sys and the "daft" "erase" file that is used
> to clear entries from the persistent store. This version uses the much
> more natural "rm file" to delete entries from the platform store. This
> code is based on fs/ramfs - with most operations removed (cannot make
> new files, directories, symlinks, hook for unlink to pass the erase
> command down to the platform layer.
> 
> The bit that I think needs most eyeballs is pstore_mkfile() where I push
> the data from the persistent store into the file. I couldn't find any
> examples where other kernel code does this to copy - so I made it up.
> Questions I have:
> 1) Is "struct file" too big to be on the stack? I can change it to kmalloc() it.

Well, this happens during normal operation when we init the pstore and
since we don't need it after pstore_mkwrite has returned (do we?), I
guess we should be fine.

> 2) Did I get all the bits I need to fake a write to the file?
> 3) Is this whole thinng OK, or is there a better way? Peter had suggested
>    that I use aops->write_begin() & aops->write_end(). But I got lost in
>    the fs/vm code calling sequence working out what I'd need to set up
>    before calling these - using do_sync_write() seemed a lot easier, but
>    I've learned that "easy" is quite often not "right" :-)
> 
> Here's what the user sees now:
> 
> # ls -l /dev/pstore
> total 16
> -r--r--r--  1 root root 7896 Dec  3 10:56 dmesg-erst-5546531799825383425
> # grep RIP: /dev/pstore/dmesg-erst-5546531799825383425
> <4>[  552.268202] RIP: 0010:[<ffffffff812a3a25>]  [<ffffffff812a3a25>] sysrq_handle_crash+0x16/0x20
> # rm /dev//pstore/dmesg-erst-5546531799825383425
> 
> 
> diff --git a/Documentation/ABI/testing/pstore b/Documentation/ABI/testing/pstore
> new file mode 100644
> index 0000000..717fddb
> --- /dev/null
> +++ b/Documentation/ABI/testing/pstore
> @@ -0,0 +1,35 @@
> +Where:		/dev/pstore/...
> +Date:		January 2011
> +Kernel Version: 2.6.38
> +Contact:	tony.luck@intel.com
> +Description:	Generic interface to platform dependent persistent storage.
> +
> +		Platforms that provide a mechanism to preserve some data
> +		across system reboots can register with this driver to
> +		provide a generic interface to show records captured in
> +		the dying moments.  In the case of a panic() the last part

						    "panic" (I'd remove the
								     brackets)

> +		of the console log is captured, but other interesting
> +		data can also be saved.
> +
> +		# mount -t pstore - /dev/pstore
> +
> +		$ ls -l /dev/pstore
> +		total 0
> +		-r--r--r-- 1 root root 7896 Nov 30 15:38 dmesg-erst-1
> +
> +		Different users of this interface will result in different
> +		filename prefixes.  Currently two are defined:
> +
> +		"dmesg"	- saved console log
> +		"mce"	- architecture dependent data from fatal h/w error
> +
> +		Once the information in a file has been read, removing
> +		the file will signal to the underlying persistent storage
> +		device that it can reclaim the space for later re-use.
> +
> +		$ rm /dev/pstore/dmesg-erst-1
> +
> +		The expectation is that all files in /dev/pstore
> +		will be saved elsewhere and erased from persistent store
> +		soon after boot to free up space ready for the next
> +		catastrophe.

"next catastrophe", hehe, this sounds very optimistic :)

> diff --git a/fs/Kconfig b/fs/Kconfig
> index 771f457..2bbe47f 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -188,6 +188,7 @@ source "fs/omfs/Kconfig"
>  source "fs/hpfs/Kconfig"
>  source "fs/qnx4/Kconfig"
>  source "fs/romfs/Kconfig"
> +source "fs/pstore/Kconfig"
>  source "fs/sysv/Kconfig"
>  source "fs/ufs/Kconfig"
>  source "fs/exofs/Kconfig"
> diff --git a/fs/Makefile b/fs/Makefile
> index a7f7cef..db71a5b 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -121,3 +121,4 @@ obj-$(CONFIG_BTRFS_FS)		+= btrfs/
>  obj-$(CONFIG_GFS2_FS)           += gfs2/
>  obj-$(CONFIG_EXOFS_FS)          += exofs/
>  obj-$(CONFIG_CEPH_FS)		+= ceph/
> +obj-$(CONFIG_PSTORE)		+= pstore/
> diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
> new file mode 100644
> index 0000000..867d0ac
> --- /dev/null
> +++ b/fs/pstore/Kconfig
> @@ -0,0 +1,13 @@
> +config PSTORE
> +	bool "Persistant store support"
> +	default n
> +	help
> +	   This option enables generic access to platform level
> +	   persistent storage via "pstore" filesystem that can
> +	   be mounted as /dev/pstore.  Only useful if you have
> +	   a platform level driver that registers with pstore to
> +	   provide the data, so you probably should just go say "Y"
> +	   (or "M") to a platform specific persistent store driver
> +	   (e.g. ACPI_APEI on X86) which will select this for you.
> +	   If you don't have a platform persistent store driver,
> +	   say N.
> diff --git a/fs/pstore/Makefile b/fs/pstore/Makefile
> new file mode 100644
> index 0000000..760f4bc
> --- /dev/null
> +++ b/fs/pstore/Makefile
> @@ -0,0 +1,7 @@
> +#
> +# Makefile for the linux pstorefs routines.
> +#
> +
> +obj-y += pstore.o
> +
> +pstore-objs += inode.o platform.o
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> new file mode 100644
> index 0000000..5673b83
> --- /dev/null
> +++ b/fs/pstore/inode.c
> @@ -0,0 +1,185 @@
> +/*
> + * Persistent Storage - ramfs parts.
> + *
> + * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/pagemap.h>
> +#include <linux/highmem.h>
> +#include <linux/time.h>
> +#include <linux/init.h>
> +#include <linux/string.h>
> +#include <linux/mount.h>
> +#include <linux/ramfs.h>
> +#include <linux/sched.h>
> +#include <linux/magic.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +
> +#include "internal.h"
> +
> +#define pstore_get_inode ramfs_get_inode
> +
> +static int pstore_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +	pstore_erase(dentry->d_inode->i_private);
> +
> +	return simple_unlink(dir, dentry);
> +}
> +
> +static const struct inode_operations pstore_dir_inode_operations = {
> +	.lookup		= simple_lookup,
> +	.unlink		= pstore_unlink,
> +};
> +
> +static const struct super_operations pstore_ops = {
> +	.statfs		= simple_statfs,
> +	.drop_inode	= generic_delete_inode,
> +	.show_options	= generic_show_options,
> +};
> +
> +static struct super_block *pstore_sb;
> +static struct vfsmount *pstore_mnt;
> +
> +int pstore_is_mounted(void)
> +{
> +	return pstore_mnt != NULL;
> +}
> +
> +/*
> + * Make a regular file in the root directory of our file system.
> + * Load it up with "size" bytes of data from "buf".
> + * Set the mtime & ctime to the date that this record was originally stored.
> + */
> +int pstore_mkfile(char *name, char *data, size_t size, struct timespec time,
> +		  void *private)
> +{
> +	struct dentry *root = pstore_sb->s_root;
> +	struct dentry *dentry;
> +	struct inode *inode;
> +	struct file f;
> +	ssize_t n;
> +	mm_segment_t old_fs = get_fs();
> +
> +	inode = pstore_get_inode(pstore_sb, root->d_inode, S_IFREG | 0444, 0);
> +	if (!inode)
> +		return -ENOMEM;
> +
> +	mutex_lock(&root->d_inode->i_mutex);
> +
> +	inode->i_private = private;
> +
> +	dentry = d_alloc_name(root, name);
> +	if (!IS_ERR(dentry))
> +		d_add(dentry, inode);

what happens if it IS_ERR? Error handling like

	goto d_alloc_error;

d_alloc_error:
	iput(inode);
	return -ENOSPC;


or similar, at least this is what ramfs seems to be doing.

> +
> +	mutex_unlock(&root->d_inode->i_mutex);
> +
> +	memset(&f, '0', sizeof f);
> +	f.f_mapping = inode->i_mapping;
> +	f.f_path.dentry = dentry;
> +	f.f_path.mnt = pstore_mnt;
> +	f.f_pos = 0;
> +	f.f_op = inode->i_fop;
> +	set_fs(KERNEL_DS);
> +	n = do_sync_write(&f, data, size, &f.f_pos);
> +	set_fs(old_fs);
> +
> +	if (time.tv_sec)
> +		inode->i_mtime = inode->i_ctime = time;
> +
> +	return (n == size) ? 0 : -EIO;
> +}
> +
> +int pstore_fill_super(struct super_block *sb, void *data, int silent)
> +{
> +	struct inode *inode = NULL;
> +	struct dentry *root;
> +	int err;
> +
> +	save_mount_options(sb, data);
> +
> +	pstore_sb = sb;
> +
> +	sb->s_maxbytes		= MAX_LFS_FILESIZE;
> +	sb->s_blocksize		= PAGE_CACHE_SIZE;
> +	sb->s_blocksize_bits	= PAGE_CACHE_SHIFT;
> +	sb->s_magic		= PSTOREFS_MAGIC;
> +	sb->s_op		= &pstore_ops;
> +	sb->s_time_gran		= 1;
> +
> +	inode = pstore_get_inode(sb, NULL, S_IFDIR | 0755, 0);
> +	if (!inode) {
> +		err = -ENOMEM;
> +		goto fail;
> +	}
> +	/* override ramfs "dir" options so we catch unlink(2) */
> +	inode->i_op = &pstore_dir_inode_operations;
> +
> +	root = d_alloc_root(inode);
> +	sb->s_root = root;
> +	if (!root) {
> +		err = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	pstore_get_records();
> +
> +	return 0;
> +fail:
> +	iput(inode);
> +	return err;
> +}
> +
> +static int pstore_get_sb(struct file_system_type *fs_type,
> +	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
> +{
> +	struct dentry *root;
> +
> +	root = mount_nodev(fs_type, flags, data, pstore_fill_super);
> +	if (IS_ERR(root))
> +		return -ENOMEM;
> +
> +	mnt->mnt_root = root;
> +	mnt->mnt_sb = root->d_sb;
> +	pstore_mnt = mnt;
> +
> +	return 0;
> +}
> +
> +static void pstore_kill_sb(struct super_block *sb)
> +{
> +	kill_litter_super(sb);
> +	pstore_sb = NULL;
> +	pstore_mnt = NULL;
> +}
> +
> +static struct file_system_type pstore_fs_type = {
> +	.name		= "pstore",
> +	.get_sb		= pstore_get_sb,
> +	.kill_sb	= pstore_kill_sb,
> +};
> +
> +static int __init init_pstore_fs(void)
> +{
> +	return register_filesystem(&pstore_fs_type);
> +}
> +module_init(init_pstore_fs)
> +
> +MODULE_AUTHOR("Tony Luck <tony.luck@intel.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
> new file mode 100644
> index 0000000..1f274ff
> --- /dev/null
> +++ b/fs/pstore/internal.h
> @@ -0,0 +1,5 @@
> +extern void	pstore_get_records(void);
> +extern int	pstore_mkfile(char *name, char *data, size_t size,
> +			      struct timespec time, void *private);
> +extern void	pstore_erase(void *private);
> +extern int	pstore_is_mounted(void);
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> new file mode 100644
> index 0000000..63f08db
> --- /dev/null
> +++ b/fs/pstore/platform.c
> @@ -0,0 +1,194 @@
> +/*
> + * Persistent Storage - platform driver interface parts.
> + *
> + * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/atomic.h>
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/kmsg_dump.h>
> +#include <linux/module.h>
> +#include <linux/pstore.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +
> +#include "internal.h"
> +
> +/*
> + * pstore_lock just protects "psinfo" during
> + * calls to pstore_register()
> + */
> +static DEFINE_SPINLOCK(pstore_lock);
> +static struct pstore_info *psinfo;
> +
> +#define	PSTORE_NAMELEN	64
> +
> +struct pstore_private {
> +	u64	id;
> +	int	(*erase)(u64);
> +};
> +
> +/*
> + * callback from kmsg_dump. (s2,l2) has the most recently
> + * written bytes, older bytes are in (s1,l1). Save as much
> + * as we can from the end of the buffer.
> + */
> +static void pstore_dump(struct kmsg_dumper *dumper,
> +	    enum kmsg_dump_reason reason,
> +	    const char *s1, unsigned long l1,
> +	    const char *s2, unsigned long l2)
> +{
> +	unsigned long s1_start, s2_start;
> +	unsigned long l1_cpy, l2_cpy;
> +	char *dst = psinfo->buf;
> +
> +	/* Don't dump oopses to persistent store */
> +	if (reason == KMSG_DUMP_OOPS)
> +		return;
> +
> +	l2_cpy = min(l2, psinfo->bufsize);
> +	l1_cpy = min(l1, psinfo->bufsize - l2_cpy);
> +
> +	s2_start = l2 - l2_cpy;
> +	s1_start = l1 - l1_cpy;
> +
> +	mutex_lock(&psinfo->mutex);
> +	memcpy(dst, s1 + s1_start, l1_cpy);
> +	memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
> +
> +	psinfo->write(PSTORE_TYPE_DMESG, l1_cpy + l2_cpy);
> +	mutex_unlock(&psinfo->mutex);
> +}
> +
> +static struct kmsg_dumper pstore_dumper = {
> +	.dump = pstore_dump,
> +};
> +
> +/*
> + * platform specific persistent storage driver registers with
> + * us here. If pstore is already mounted, call the platform
> + * read function right away to populate the file system. If not
> + * then the pstore mount code will call us later to fill out
> + * the file system.
> + *
> + * Register with kmsg_dump to save last part of console log on panic.
> + */
> +int pstore_register(struct pstore_info *psi)
> +{
> +	struct module *owner = psi->owner;
> +
> +	spin_lock(&pstore_lock);
> +	if (psinfo) {
> +		spin_unlock(&pstore_lock);
> +		return -EBUSY;
> +	}
> +	psinfo = psi;
> +	spin_unlock(&pstore_lock);
> +
> +	if (owner && !try_module_get(owner)) {
> +		psinfo = NULL;
> +		return -EINVAL;
> +	}
> +
> +	if (pstore_is_mounted())
> +		pstore_get_records();
> +
> +	kmsg_dump_register(&pstore_dumper);

You don't check psi->write() method's existence anymore, I'm assuming
this is implied now... ?

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pstore_register);
> +
> +/*
> + * Read all the records from the persistent store. Create and
> + * file files in our filesystem.
> + */
> +void pstore_get_records(void)
> +{
> +	struct pstore_info *psi = psinfo;
> +	size_t			size;
> +	u64			id;
> +	int			type;
> +	char			name[PSTORE_NAMELEN];
> +	struct pstore_private	*private;
> +	struct timespec		time;
> +
> +	if (!psi)
> +		return;
> +
> +	mutex_lock(&psinfo->mutex);
> +	for (;;) {
> +		if (psi->read(&id, &type, &size, &time) <= 0)
> +			break;
> +		switch (type) {
> +		case PSTORE_TYPE_DMESG:
> +			sprintf(name, "dmesg-%s-%lld", psi->name, id);
> +			break;
> +		case PSTORE_TYPE_MCE:
> +			sprintf(name, "mce-%s-%lld", psi->name, id);
> +			break;
> +		default:
> +			sprintf(name, "type%d-%s-%lld", type, psi->name, id);
> +			break;
> +		}
> +		private = kmalloc(sizeof *private, GFP_KERNEL);
> +		private->id = id;
> +		private->erase = psi->erase;
> +		pstore_mkfile(name, psi->buf, size, time, private);
> +	}
> +	mutex_unlock(&psinfo->mutex);
> +}
> +
> +/*
> + * Call platform driver to write a record to the
> + * persistent store. We don't worry about making
> + * this visible in the pstore filesystem as the
> + * presumption is that we only save things to the
> + * store in the dying moments of OS failure. Hence
> + * nobody will see the entries in the filesystem.
> + */
> +int pstore_write(int type, char *buf, size_t size)
> +{
> +	int	ret;
> +
> +	if (!psinfo)
> +		return -ENODEV;

newline.

> +	if (size > psinfo->bufsize)
> +		return -EFBIG;
> +
> +	mutex_lock(&psinfo->mutex);
> +	memcpy(psinfo->buf, buf, size);
> +	ret = psinfo->write(type, size);
> +	mutex_unlock(&psinfo->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pstore_write);
> +
> +/*
> + * When a file is unlinked from our file system we call the
> + * platform driver to erase the record from persistent store.
> + */
> +void pstore_erase(void *private)
> +{
> +	struct pstore_private *p = private;
> +
> +	p->erase(p->id);
> +	kfree(p);
> +}
> diff --git a/include/linux/magic.h b/include/linux/magic.h
> index ff690d0..e87fd5a 100644
> --- a/include/linux/magic.h
> +++ b/include/linux/magic.h
> @@ -26,6 +26,7 @@
>  #define ISOFS_SUPER_MAGIC	0x9660
>  #define JFFS2_SUPER_MAGIC	0x72b6
>  #define ANON_INODE_FS_MAGIC	0x09041934
> +#define PSTOREFS_MAGIC		0x6165676C

what does that mean anyway? "aegl" :)

>  
>  #define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
>  #define MINIX_SUPER_MAGIC2	0x138F		/* minix fs, 30 char names */
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> new file mode 100644
> index 0000000..4d635c0
> --- /dev/null
> +++ b/include/linux/pstore.h
> @@ -0,0 +1,57 @@
> +/*
> + * Persistent Storage - pstore.h
> + *
> + * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
> + *
> + * This code is the generic layer to export data records from platform
> + * level persistent storage via a file system.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +#ifndef _LINUX_PSTORE_H
> +#define _LINUX_PSTORE_H
> +
> +/* types */
> +#define	PSTORE_TYPE_DMESG	0
> +#define	PSTORE_TYPE_MCE		1

You could make this into a proper enum

enum pstore_type_id {
	PSTORE_TYPE_DMESG	= 0,
	PSTORE_TYPE_MCE		= 1,
	PSTORE_TYPE_MAX,
};

so that...

> +
> +struct pstore_info {
> +	struct module	*owner;
> +	char		*name;
> +	struct mutex	mutex;	/* serialize access to 'buf' */

 [ maybe a more descriptive variable name like buf_mutex or whatever ]

> +	char		*buf;
> +	size_t		bufsize;
> +	int		(*read)(u64 *id, int *type, size_t *size,
> +			struct timespec *time);
> +	int		(*write)(int type, size_t size);

... you can enforce typechecking for pstore->write:

	int             (*write)(enum pstore_type_id type, size_t size);


> +	int		(*erase)(u64 id);
> +};
> +
> +#if defined(CONFIG_PSTORE) || defined(CONFIG_PSTORE_MODULE)

What is CONFIG_PSTORE_MODULE? Can't seem to find it in your (2 of 2)
message either.

> +extern int pstore_register(struct pstore_info *);
> +extern int pstore_write(int type, char *buf, size_t size);
> +#else
> +static inline int
> +pstore_register(struct pstore_info *psi)
> +{
> +	return -ENODEV;
> +}
> +static inline int
> +pstore_write(int type, char *buf, size_t size)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
> +#endif /*_LINUX_PSTORE_H*/
> 

-- 
Regards/Gruss,
    Boris.
