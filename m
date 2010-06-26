Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0FZLQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 07:16:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0FZLQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 07:16:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: Add driver to enable access to the user dynamic network.
Date: Sat, 26 Jun 2010 13:16:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201006252110.o5PLArvw010770@farm-0002.internal.tilera.com>
In-Reply-To: <201006252110.o5PLArvw010770@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006261316.12816.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18yAJXqxLTub+k2BAQoZpw7G5ROWlglbRUebDt
 BW1gH7S4VgTMslQWMLhxNkH+AuPQkiP9DjGVCiWcQ5Y2mqbqx0
 ixrvdnr85OG5Eaz1jqvYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 June 2010, Chris Metcalf wrote:

> The original submission of this code to LKML had the driver
> instantiated under /proc/tile/hardwall.  Now we just use a character
> device for this, conventionally /dev/hardwall.  Some futures planning
> for the TILE-Gx chip suggests that we may want to have other types of
> devices that share the general model of "bind a task to a cpu, then
> 'activate' a file descriptor on a pseudo-device that gives access to
> some hardware resource".  As such, we are using a device rather
> than, for example, a syscall, to set up and activate this code.

The character device looks much better than the proc file. I still
think a system call would be a more appropriate abstraction here,
but the two are equivalent after all.

> diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
> index 96c50d2..95b54bc 100644
> --- a/arch/tile/include/asm/processor.h
> +++ b/arch/tile/include/asm/processor.h
> @@ -74,6 +74,14 @@ struct async_tlb {
>  	unsigned long address;   /* what address faulted? */
>  };
>  
> +#ifdef CONFIG_HARDWALL
> +struct hardwall_info;
> +
> +/* Can't use a normal list_head here due to header-file inclusion issues. */
> +struct hardwall_list {
> +	struct list_head *next, *prev;
> +};
> +#endif

It seems strange that you need this. Why does linux/list.h
depend on asm/processor.h?
It certainly seems that the code would get simpler if this
can be avoided.

> +/*
> + * Guard changes to the hardwall data structures.
> + * This could be finer grained (e.g. one lock for the list of hardwall
> + * rectangles, then separate embedded locks for each one's list of tasks),
> + * but there are subtle correctness issues when trying to start with
> + * a task's "hardwall" pointer and lock the correct rectangle's embedded
> + * lock in the presence of a simultaneous deactivation, so it seems
> + * easier to have a single lock, given that none of these data
> + * structures are touched very frequently during normal operation.
> + */
> +static DEFINE_SPINLOCK(hardwall_lock);

I think instead of making the lock more fine-grained, a better optimization
might be to use RCU to protect the updates. AFAICT, the updates to the
structure are rare but you need to read it a lot.

> +/*
> + * Low-level primitives
> + */
> +
> +/* Map a HARDWALL_FILE file to the matching hardwall info structure */
> +#define _file_to_hardwall(file) ((file)->private_data)
> +#define file_to_hardwall(file) \
> +	((struct hardwall_info *)_file_to_hardwall(file))

I wouldn't bother with these abstractions, you can simply write
file->private_data in every place where they are used.

> +/*
> + * Code to create, activate, deactivate, and destroy hardwall rectangles.
> + */
> +
> +/* Create a hardwall for the given rectangle */
> +static struct hardwall_info *hardwall_create(
> +	size_t size, const unsigned long __user *bits)
> +{

To make this a system call, I'd wrap this function with one that roughly
does

asmlinkage long sys_hardwall_create(size_t size,
			 const unsigned long __user *bits)
{
	int fd;
	struct hardwall_info *info;

	info = hardwall_create(size, bits);
	if (IS_ERR(info))
		return PTR_ERR(info);

	fd = anon_inode_getfd("hardwall", &hardwall_fops, info, O_CREAT | O_RDWR);
	if (fd < 0)
		hardwall_destroy(info);
	
	return fd;
}

The main difference between this and the ioctl approach would be that
using chardev/ioctl allows you to give access to the hardwall functionality
to a specific group or user with file permissions, while the system call
would be less fine-grained, either associating access with a specific
capability (e.g. CAP_SYS_ADMIN) or giving it to all users.

> +#ifdef CONFIG_COMPAT
> +static long hardwall_compat_ioctl(struct file *file,
> +				  unsigned int a, unsigned long b)
> +{
> +	/* Sign-extend the argument so it can be used as a pointer. */
> +	return hardwall_ioctl(file, a, (int)(long)b);
> +}
> +#endif

Better use compat_ptr(b) instead of the manual cast.

	Arnd
