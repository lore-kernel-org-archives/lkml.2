Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0LBAxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:53:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447Ab0LBAxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:53:05 -0500
Date: Wed, 1 Dec 2010 16:51:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        ying.huang@intel.com, "Borislav Petkov" <bp@alien8.de>,
        "David Miller" <davem@davemloft.net>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Jim Keniston" <jkenisto@linux.vnet.ibm.com>,
        "Kyungmin Park" <kmpark@infradead.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [RFC] persistent store (version 2) (part 1 of 2)
Message-Id: <20101201165139.a3bb2199.akpm@linux-foundation.org>
In-Reply-To: <4cf594e21679631af0@agluck-desktop.sc.intel.com>
References: <4cf594e21679631af0@agluck-desktop.sc.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 16:20:50 -0800
"Luck, Tony" <tony.luck@intel.com> wrote:

> Here's version 2 with most of the fixes suggested in the discussion
> for version 1 (see http://marc.info/?l=linux-arch&m=129045078803118&w=2).

I haven't really thought about the overall concept, but I saw stuff to
nitpick at.


> Stuff that I haven't done:
> 
> 1) Still has the "daft" echo filename > erase to clear entries from the
> persistent store.  I looked hard at /sys and can't see how to get a
> notification for an unlink(2). If I'm missing something, would somebody
> please send me a clue. If this is a fatal flaw - then this will have to
> move to debugfs (or turn into its own filesystem type). But I'd really
> prefer to not give up the convenience of /sys
> 
> 2) Did not implement Jim's suggestion to save OOPs ... I'm not at
> all sure how to let the user configure this. mtdoops.c has a module
> parameter for it - but I gave up on letting pstore be a module ...
> it needs to be initialized before the platform driver, and there doesn't
> seem to be much point in having it be unloadable.
> 
> I did write the ERST platform hooks (they are part 2 of 2, but I'd advise
> the faint of heart not to look too closely at the ACPI/APEI'isms involved).
> Here's a sample of what it looks like (with a debug call to panic() from
> the pstore_erase() function added for testing purposes):
> 
> $ cd /sys/firmware/pstore
> $ ls -l
> total 0
> -r--r--r-- 1 root root 7896 Nov 30 15:38 dmesg-1
> --w------- 1 root root    0 Nov 30 15:38 erase
> $ cat dmesg-1 | tail -12
> <4>[  201.840197] mtrr: type mismatch for 90000000,2000000 old: write-back new: write-combining
> <0>[ 1044.792139] Kernel panic - not syncing: Testing pstore
> <4>[ 1044.792147] Pid: 7634, comm: bash Not tainted 2.6.36-rc6 #13
> <4>[ 1044.792150] Call Trace:
> <4>[ 1044.792166]  [<ffffffff815c7266>] panic+0xbc/0x1c6
> <4>[ 1044.792176]  [<ffffffff810e6c50>] ? get_write_access+0x1e/0x50
> <4>[ 1044.792182]  [<ffffffff810ea77d>] ? do_filp_open+0x1f4/0x594
> <4>[ 1044.792193]  [<ffffffff814d72f5>] pstore_erase+0x41/0x14f
> <4>[ 1044.792199]  [<ffffffff8112fbf2>] write+0x11e/0x160
> <4>[ 1044.792208]  [<ffffffff810dec87>] vfs_write+0xb3/0x13a
> <4>[ 1044.792213]  [<ffffffff810deddc>] sys_write+0x4c/0x73
> <4>[ 1044.792222]  [<ffffffff81002bdb>] system_call_fastpath+0x16/0x1b
> 
>
> ...
>
> --- /dev/null
> +++ b/drivers/firmware/pstore.c
> @@ -0,0 +1,294 @@
> +/*
> + * Persistent Storage - pstore.c
> + *
> + * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
> + *
> + * This code is the generic layer to export data records from platform
> + * level persistent storage via sysfs.
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
> +#include <linux/sysfs.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +
> +MODULE_AUTHOR("Tony Luck <tony.luck@intel.com>");
> +MODULE_DESCRIPTION("sysfs interface to persistent storage");
> +MODULE_LICENSE("GPL");
> +
> +static DEFINE_SPINLOCK(pstore_lock);

It'd be nice to know what pstore_lock actually locks.

> +static LIST_HEAD(pstore_list);
> +static struct kset *pstore_kset;

It locks psinfo (at least), so I'd suggest that all things which
pstore_lock locks be collected immediately after its definition.

> +#define	PSTORE_NAMELEN	16
> +
> +struct pstore_entry {
> +	struct	bin_attribute attr;
> +	char	name[PSTORE_NAMELEN];
> +	u64	id;
> +	int	type;
> +	int	size;
> +	struct	list_head list;
> +	char	data[];
> +};
> +
> +static int pstore_create_sysfs_entry(struct pstore_entry *new_pstore);
> +
> +static struct pstore_info *psinfo;
> +
> +static char *pstore_buf;
> +
>
> ...
>
> +/*
> + * platform specific persistent storage driver registers with
> + * us here. Read out all the records right away and install
> + * them in /sys.  Register with kmsg_dump to save last part
> + * of console log on panic.
> + */
> +int
> +pstore_register(struct pstore_info *psi)

bah, ia64 coding style leaking into core kernel.

> +{
> +	struct pstore_entry	*new_pstore;
> +	unsigned long		size, ps_maxsize;
> +	u64			id;
> +	int			rc = 0, type;
> +
> +	spin_lock(&pstore_lock);
> +	if (psinfo) {
> +		spin_unlock(&pstore_lock);
> +		return -EBUSY;
> +	}
> +	if (!psi->reader || !psi->writer || !psi->eraser) {
> +		spin_unlock(&pstore_lock);
> +		return -EINVAL;

It doesn't seem appropriate to check this here.  It's a programming
error!  Just install the thing and let the kernel oops - the programmer
will notice.

> +	}
> +	psinfo = psi;
> +	spin_unlock(&pstore_lock);
> +
> +	ps_maxsize = psi->header_size + psi->data_size + psi->footer_size;
> +	pstore_buf = kzalloc(ps_maxsize, GFP_KERNEL);
> +	if (!pstore_buf)
> +		return -ENOMEM;

Here the state of the driver gets screwed up.  We've installed the
psinfo and we're unable to install a new one, but the one which we
installed is only partially constructed.  And it will cause oopses if
we actually try to use it.

> +	for (;;) {
> +		if (psi->reader(&id, &type, pstore_buf, &size) <= 0)
> +			break;
> +		new_pstore = kzalloc(sizeof(struct pstore_entry) + size,
> +				     GFP_KERNEL);
> +		if (!new_pstore) {
> +			rc = -ENOMEM;
> +			break;
> +		}
> +		new_pstore->id = id;
> +		new_pstore->type = type;
> +		new_pstore->size = size;
> +		memcpy(new_pstore->data, pstore_buf + psi->header_size, size);
> +		if (pstore_create_sysfs_entry(new_pstore)) {
> +			kfree(new_pstore);
> +			rc =  -EINVAL;
> +			break;
> +		}
> +	}
> +
> +	kobject_uevent(&pstore_kset->kobj, KOBJ_ADD);
> +
> +	kmsg_dump_register(&pstore_dumper);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(pstore_register);

So I'd suggest that this function *fully* back out if anything fails. 
That means restoring psinfo.  And fixing the error-path memory leaks
which might be there (I didn't check too hard).

Bonus points for implementing it with only one `return' statement ;)

>
> ...
>
> +/*
> + * Erase records by writing their filename to the "erase" file. E.g.
> + *	# echo "dmesg-0" > erase
> + */

Since when are "records" identified by "filenames"?

filenames refer to files!  And lo, that's what we have here.  A
filesystem!  The files are created by the kernel and are read and
unlinked by userspace.

So why not implement this whole thing as a proper filesystem?

> +static ssize_t pstore_erase(struct file *filp, struct kobject *kobj,
> +			    struct bin_attribute *bin_attr,
> +			    char *buf, loff_t pos, size_t count)
> +{
> +	struct pstore_entry *search_pstore, *n;
> +	int len1, len2, found = 0;
> +
> +	len1 = count;
> +	if (buf[len1 - 1] == '\n')
> +		len1--;
> +
> +	spin_lock(&pstore_lock);
> +
> +	/*
> +	 * Find this record
> +	 */
> +	list_for_each_entry_safe(search_pstore, n, &pstore_list, list) {
> +		len2 = strlen(search_pstore->name);
> +		if (len1 == len2 && memcmp(buf, search_pstore->name,
> +					   len1) == 0) {
> +			found = 1;
> +			break;
> +		}
> +	}

hm, what's going on here.

Can that line really have a trailing \n?

Part of this code assumes that we're using null-terminated strings but
other parts don't do it that way.

All seems a bit confusing and messed up.  Might be improved via
appropriate use of strim() and sysfs_streq().  Would definitely be
improved via a comment explaining what's going on here!

> +	if (!found) {
> +		spin_unlock(&pstore_lock);
> +		return -EINVAL;
> +	}
> +
> +	if (psinfo->eraser(search_pstore->id)) {
> +		spin_unlock(&pstore_lock);

I just discovered something else which pstore_lock locks.

> +		return -EIO;

A single return site per function is better.  Multiple-returns often
lead to locking errors and memory leaks as the code evolves.

> +	}
> +
> +	list_del(&search_pstore->list);
> +
> +	spin_unlock(&pstore_lock);
> +
> +	sysfs_remove_bin_file(&pstore_kset->kobj, &search_pstore->attr);
> +
> +	kfree(search_pstore);
> +
> +	return count;
> +}
> +
> +static struct bin_attribute attr_erase = {
> +	.attr = {.name = "erase", .mode = 0200},
> +	.write = pstore_erase,
> +};
> +
> +static int
> +pstore_create_sysfs_entry(struct pstore_entry *new_pstore)
> +{
> +	static	atomic_t	next;
> +	int	error, seq;
> +
> +	seq = atomic_add_return(1, &next);
> +
> +	switch (new_pstore->type) {
> +	case PSTORE_TYPE_DMESG:
> +		sprintf(new_pstore->name, "dmesg-%d", seq);
> +		break;
> +	case PSTORE_TYPE_MCE:
> +		sprintf(new_pstore->name, "mce-%d", seq);
> +		break;
> +	default:
> +		sprintf(new_pstore->name, "type%d-%d", new_pstore->type, seq);
> +		break;
> +	}
> +
> +	sysfs_attr_init(&new_pstore->attr.attr);
> +	new_pstore->attr.size = new_pstore->size;
> +	new_pstore->attr.read = pstore_show;
> +	new_pstore->attr.attr.name = new_pstore->name;
> +	new_pstore->attr.attr.mode = 0444;
> +	error = sysfs_create_bin_file(&pstore_kset->kobj, &new_pstore->attr);
> +	if (!error) {
> +		spin_lock(&pstore_lock);
> +		list_add(&new_pstore->list, &pstore_list);
> +		spin_unlock(&pstore_lock);
> +	}
> +	return error;
> +}

Wait.  It *is* a filesystem.

<looks back at the changelog>

Nope, that was secret info.

So why can't I remove these "records" with rm?

>
> ...
>
> +#if defined(CONFIG_PSTORE) || defined(CONFIG_PSTORE_MODULE)
> +extern int pstore_register(struct pstore_info *);
> +extern int pstore_write(int type, char *buf, unsigned long size);
> +#else
> +static inline int
> +pstore_register(struct pstore_info *psi)
> +{
> +	return -ENODEV;
> +}
> +static inline int
> +pstore_write(int type, char *buf, unsigned long size)
> +{
> +	return -ENODEV;
> +}

write() takes a size_t.

> +#endif
> +
> +#endif /*_LINUX_PSTORE_H*/
