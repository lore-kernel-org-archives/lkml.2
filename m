Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0KUJH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 04:07:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60982 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0KUJHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 04:07:15 -0500
Date: Sun, 21 Nov 2010 10:07:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com
Subject: Re: [RFC] persistent store
Message-ID: <20101121090707.GA5016@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
	greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com
References: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

this is actually very cool.

See below for minor nitpicks:

On Sat, Nov 20, 2010 at 03:48:19PM -0800, Luck, Tony wrote:
> Here's a patch based on some discussions I had with Thomas
> Gleixner at plumbers conference that implements a generic
> layer for persistent storage usable to pass tens or hundreds
> of kilobytes of data from the dying breath of a crashing
> kernel to its successor.
> 
> The usage model I'm envisioning is that a platform driver
> will register with this code to provide the actual storage.
> I've tried to make this interface general, but I'm working
> from a sample of one (the ACPI ERST code), so if anyone else
> has some persistent store that can't be handled by this code,
> speak up and we can put in the necessary tweaks.
> 
> My assumptions are that the data that Linux cares about will
> be wrapped in some error record structure with a header, and
> possibly a footer that the device code needs. So the driver
> specifies how much padding to put around a buffer to make
> life easy for it.  It also specifies the maximum number of
> bytes that can be saved in one record.
> 
> There are three callback functions from the generic code to
> the driver:
> 
> "reader" which iterates over all records currently in the
> store - returning type, size and a record identifier as
> well as the actual data.
> 
> "writer" which writes a record with a type to the persistent store
> 
> "eraser" which takes a record identifier, and clears that item
> from the store.
> 
> 
> The Linux user visible interface is via /sys (similar to
> the "efivars" interface)
> 
> # ls -l /sys/firmware/pstore
> total 0
> -r--r--r-- 1 root root 0 2010-11-20 11:03 dmesg-0
> --w------- 1 root root 0 2010-11-20 11:03 erase
> 
> The "type" of error record I mentioned earlier is used to
> name the files ... saved console logs from kmsg_dmp() are
> named with a "dmesg" prefix as shown above.
> 
> Once an error record has been viewed, analysed, saved. The
> user can request it to be cleared by writing its name to the
> "erase" file:
> 
> # echo "dmesg-0" > erase
> 
> Answers to a few questions that I think you might ask:
> 
> 1) "Why do you only allow one platform driver to register?"
>   I only have one such driver.  Adding more is easy from the "read" side
>   (just collect all the records from all devices and remember where they
>   came from so you can call the correct "eraser" function).  But the "write"
>   side opens up questions that I don't have good answers for:
>   - Which device(s) should error records be written to?
>     All of them? Start with one and move on when it is
>     full?  Write some types of records to one device?

Maybe based on the error type? We definitely need one device which
should contain all the records, something like main pstore device.

>   If someone has a machine with multiple persistent storage devices -
>   then we can talk about how to answer these questions.
> 
> 2) "Why do you read in all the data from the device when it
> registers and save it in memory?  Couldn't you just get the
> list of records and pick up the data from the device when
> the user reads the file?"
>   I don't think this is going to be very much data, just a few hundred
>   kilobytes (i.e. less that $0.01 worth of memory, even expensive server
>   memory).  The memory is freed when the record is erased ... which is
>   likely to be soon after boot.

This is actually a nice idea from the aspect that when those files
appear in sysfs on boot, a userspace daemon can check for their
existence and tell the user that she has valid error records from the
last crash and she could report them to lkml/hw vendor/...

> 3) "/sys/firmware/pstore is the wrong pathname for this".
>   You are probably right. I put it under "firmware" because that's where
>   the "efivars" driver put its top level directory. In my case the ERST
>   back end is firmware, so there is some vague logic to it ... but better
>   suggestions are welcome. Perhaps /sys/devices/platform/pstore?
> 
> 4) "/sys is the wrong place for this."
>   Perhaps.  I definitely want to use some sort of filesystem interface (so
>   each record shows up as a file to the user). This seems a lot cleaner
>   than trying to map the semantics of actual persistent storage devices
>   onto a character device.  The "sysfs_create_bin_file()" API seems very
>   well designed for this usage.  If not /sys, then where?  "debugfs"
>   would work - but not everyone mounts debugfs. Creating a whole new
>   filesystem for this seems like overkill.

No, I think /sys is the right place for it being always present and
all. Besides, for example, all the ACPI tables are there anyway
(/sys/firmware/acpi/tables/) so pstore won't be the first blob there.

/sys/firmware might not be all that sensible if someone comes up with
persistent storage type which is the network but we'll change that then.

> 5) "Why is the record identifier type 'u64'?"
>   This is one place where I knowingly let the ERST implementation bleed
>   all the way up to the top - it uses 64-bit record numbers. It would be
>   possible to map these to something smaller like "int" ... but the code
>   to do so would be far larger than the memory saved.  The most common
>   usage case is likely to be a software crash with just one "dmesg" record.
> 
> 6) "Is this widely useful? How many systems have persistent storage?"
>   Although ERST was only added to the ACPI spec earlier this year, it
>   merely documents existing functionality required for WHEA (Windows
>   Hardware Error Architecture).  So most modern server systems should
>   have it (my test system has it, and it has a BIOS written in mid 2008).
>   Sorry desktops & laptops - no love for you here.
> 
> No-sign-off-yet-this-is-just-RFC
> 
> -Tony
> 
> ---
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index e8b6a13..06afe40 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -134,4 +134,16 @@ config ISCSI_IBFT
>  	  detect iSCSI boot parameters dynamically during system boot, say Y.
>  	  Otherwise, say N.
>  
> +config PSTORE
> +	tristate "Persistant store support via /sys"
> +	default n
> +	help
> +	  This option enables generic access to platform level persistent
> +	  storage via /sys/firmware/pstore.  Only useful if you have a
> +	  platform level driver that registers with pstore to provide
> +	  the data, so you probably should just go say "Y" (or "M") to
> +	  a platform specific persistent store driver (e.g. ACPI_APEI on
> +	  X86) which will select this for you.  If you don't have a platform
> +	  persistent store driver, say N.
> +
>  endmenu
> diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
> index 1c3c173..ba19784 100644
> --- a/drivers/firmware/Makefile
> +++ b/drivers/firmware/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
>  obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
>  obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
>  obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
> +obj-$(CONFIG_PSTORE)		+= pstore.o
> diff --git a/drivers/firmware/pstore.c b/drivers/firmware/pstore.c
> new file mode 100644
> index 0000000..e11b454
> --- /dev/null
> +++ b/drivers/firmware/pstore.c
> @@ -0,0 +1,313 @@
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
> +static LIST_HEAD(pstore_list);
> +static struct kset *pstore_kset;
> +
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
> +/*
> + * callback from kmsg_dump. (s2,l2) has the most recently
> + * written bytes, older bytes are in (s1,l1). Save as much
> + * as we can from the end of the buffer.
> + */
> +static void
> +pstore_dump(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
> +	    const char *s1, unsigned long l1,
> +	    const char *s2, unsigned long l2)
> +{
> +	unsigned long s1_start, s2_start;
> +	unsigned long l1_cpy, l2_cpy;
> +	char *dst = pstore_buf + psinfo->header_size;
> +
> +	/* Don't dump oopses to persistent store */
> +	if (reason == KMSG_DUMP_OOPS)
> +		return;
> +
> +	l2_cpy = min(l2, psinfo->data_size);
> +	l1_cpy = min(l1, psinfo->data_size - l2_cpy);
> +
> +	s2_start = l2 - l2_cpy;
> +	s1_start = l1 - l1_cpy;
> +
> +	memcpy(dst, s1 + s1_start, l1_cpy);
> +	memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
> +
> +	psinfo->writer(PSTORE_DMESG, pstore_buf, l1_cpy + l2_cpy);
> +}
> +
> +static struct kmsg_dumper pstore_dumper = {
> +	.dump = pstore_dump,
> +};
> +
> +/*
> + * platform specific persistent storage driver registers with
> + * us here. Read out all the records right away and install
> + * them in /sys.  Register with kmsg_dump to save last part
> + * of console log on panic.
> + */
> +int
> +pstore_register(struct pstore_info *psi)
> +{
> +	struct	pstore_entry	*new_pstore;
> +	int	rc = 0, type;
> +	unsigned long size;
> +	u64	id;
> +	unsigned long ps_maxsize;

Alignment here? Maybe something like this:

	struct pstore_entry	*new_pstore;
	unsigned long		ps_maxsize;
	int			rc = 0, type;

> +
> +	spin_lock(&pstore_lock);
> +	if (psinfo) {
> +		spin_unlock(&pstore_lock);
> +		return -EBUSY;
> +	}
> +	psinfo = psi;
> +	spin_unlock(&pstore_lock);

Maybe make this lockless with cmpxchg? OTOH, the spinlock would be
easier when you have multiple persistent storage devices...

> +	ps_maxsize = psi->header_size + psi->data_size + psi->footer_size;
> +	pstore_buf = kzalloc(ps_maxsize, GFP_KERNEL);
> +	if (!pstore_buf)
> +		return -ENOMEM;

newline

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
> +
> +int
> +pstore_write(int type, char *buf, unsigned long size)
> +{
> +	if (!psinfo->writer)
> +		return -ENODEV;

I think you should move this check to the pstore_register() above. We
don't want persistent storage backends which do not implement ->write
anyway since the whole point of them becomes moot, no?

> +	if (size > psinfo->data_size)
> +		return -EFBIG;
> +
> +	memcpy(pstore_buf + psinfo->header_size, buf, size);
> +	return psinfo->writer(type, pstore_buf, size);
> +}
> +EXPORT_SYMBOL_GPL(pstore_write);
> +
> +#define to_pstore_entry(obj)  container_of(obj, struct pstore_entry, attr)
> +
> +/*
> + * "read" function for files containing persistent store records
> + */
> +static ssize_t pstore_show(struct file *filp, struct kobject *kobj,
> +			   struct bin_attribute *bin_attr, char *buf,
> +			   loff_t offset, size_t count)
> +{
> +	struct pstore_entry *ps = to_pstore_entry(bin_attr);
> +
> +	return memory_read_from_buffer(buf, count, &offset,
> +			ps->data, ps->size);
> +}
> +
> +/*
> + * Erase records by writing their filename to the "erase" file. E.g.
> + *	# echo "dmesg-0" > erase
> + */
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
> +	if (!found) {
> +		spin_unlock(&pstore_lock);
> +		return -EINVAL;
> +	}
> +
> +	if (psinfo->eraser)
> +		if (psinfo->eraser(search_pstore->id)) {
> +			spin_unlock(&pstore_lock);
> +			return -EIO;
> +		}
> +
> +	list_del(&search_pstore->list);
> +
> +	spin_unlock(&pstore_lock);
> +
> +	sysfs_remove_bin_file(&pstore_kset->kobj, &search_pstore->attr);

AFAICT, you might want to remove the sysfs file _before_ you remove it
from the pstore list/erase its contents, otherwise concurrent accesses
to it from userspace readers might make us go boom.

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
> +	case PSTORE_DMESG:
> +		sprintf(new_pstore->name, "dmesg-%d", seq);
> +		break;
> +	case PSTORE_MCE:
> +		sprintf(new_pstore->name, "mce-%d", seq);
> +		break;
> +	default:
> +		sprintf(new_pstore->name, "type%d-%d", new_pstore->type, seq);
> +		break;
> +	}
> +
> +	sysfs_attr_init(&new_pstore->attr.attr);
> +	new_pstore->attr.size = 0;
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
> +
> +static int __init
> +pstore_init(void)
> +{
> +	int error = 0;
> +
> +	/* Register the pstore directory at /sys/firmware/pstore */
> +	pstore_kset = kset_create_and_add("pstore", NULL, firmware_kobj);
> +	if (!pstore_kset) {
> +		printk(KERN_ERR "pstore: Subsystem registration failed.\n");
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * Add attribute to allow records to be erased from persistent store
> +	 */
> +	error = sysfs_create_bin_file(&pstore_kset->kobj,
> +				      &attr_erase);
> +	if (error) {
> +		printk(KERN_ERR "pstore: unable to create 'erase' sysfs file"
> +				" due to error %d\n", error);
> +		kset_unregister(pstore_kset);
> +	}
> +
> +	return error;
> +}
> +
> +static void __exit
> +pstore_exit(void)
> +{
> +	struct pstore_entry *entry, *n;
> +
> +	if (psinfo)
> +		kmsg_dump_unregister(&pstore_dumper);
> +
> +	list_for_each_entry_safe(entry, n, &pstore_list, list) {
> +		spin_lock(&pstore_lock);
> +		list_del(&entry->list);
> +		spin_unlock(&pstore_lock);
> +		sysfs_remove_bin_file(&pstore_kset->kobj, &entry->attr);
> +	}
> +	sysfs_remove_bin_file(&pstore_kset->kobj, &attr_erase);

ditto.

> +
> +	kset_unregister(pstore_kset);
> +
> +	kfree(pstore_buf);
> +}
> +
> +module_init(pstore_init);
> +module_exit(pstore_exit);
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> new file mode 100644
> index 0000000..785ad86
> --- /dev/null
> +++ b/include/linux/pstore.h
> @@ -0,0 +1,54 @@
> +/*
> + * Persistent Storage - pstore.h
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
> +#ifndef _LINUX_PSTORE_H
> +#define _LINUX_PSTORE_H
> +
> +/* types */
> +#define	PSTORE_DMESG	0
> +#define	PSTORE_MCE	1

maybe PSTORE_TYPE_DMESG/PSTORE_TYPE_MCE ?

> +
> +struct pstore_info {
> +	unsigned long	header_size;
> +	unsigned long	data_size;
> +	unsigned long	footer_size;
> +	int	(*reader)(u64 *id, int *type, char *buf, unsigned long *size);
> +	int	(*writer)(int type, char *buf, unsigned long size);
> +	int	(*eraser)(u64 id);
> +};
> +
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
> +#endif
> +
> +#endif /*_LINUX_PSTORE_H*/
> --

Thanks.

-- 
Regards/Gruss,
    Boris.
