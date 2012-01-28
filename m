Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2A1VcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 16:32:04 -0500
Received: from tuxonice.net ([96.126.116.212]:57459 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2A1Vb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 16:31:58 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jan 2012 16:31:58 EST
Message-ID: <4F24676A.4070907@tuxonice.net>
Date: Sun, 29 Jan 2012 08:23:54 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
References: <201201281445.49377.rjw@sisk.pl>
In-Reply-To: <201201281445.49377.rjw@sisk.pl>
X-TagToolbar-Keys: D20120129082354880
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 29/01/12 00:45, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Freeze all filesystems during system suspend and (kernel-driven)
> hibernation by calling freeze_supers() for all superblocks and thaw
> them during the subsequent resume with the help of thaw_supers().
> 
> This makes filesystems stay in a consistent state in case something
> goes wrong between system suspend (or hibernation) and the subsequent
> resume (e.g. journal replays won't be necessary in those cases).  In
> particular, this should help to solve a long-standing issue that, in
> some cases, during resume from hibernation the boot loader causes the
> journal to be replied for the filesystem containing the kernel image
> and/or initrd causing it to become inconsistent with the information
> stored in the hibernation image.
> 
> The user-space-driven hibernation (s2disk) is not covered by this
> change, because the freezing of filesystems prevents s2disk from
> accessing device special files it needs to do its job.
> 
> This change is based on earlier work by Nigel Cunningham.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  fs/super.c               |   73 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h       |    3 +
>  kernel/power/hibernate.c |   11 +++++--
>  kernel/power/power.h     |   23 --------------
>  kernel/power/suspend.c   |   42 +++++++++++++++++++++++++++
>  5 files changed, 128 insertions(+), 24 deletions(-)
> 
> Index: linux/include/linux/fs.h
> ===================================================================
> --- linux.orig/include/linux/fs.h
> +++ linux/include/linux/fs.h
> @@ -210,6 +210,7 @@ struct inodes_stat_t {
>  #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
>  #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
>  #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
> +#define MS_FROZEN	(1<<25) /* Frozen filesystem */
>  #define MS_NOSEC	(1<<28)
>  #define MS_BORN		(1<<29)
>  #define MS_ACTIVE	(1<<30)
> @@ -2501,6 +2502,8 @@ extern void drop_super(struct super_bloc
>  extern void iterate_supers(void (*)(struct super_block *, void *), void *);
>  extern void iterate_supers_type(struct file_system_type *,
>  			        void (*)(struct super_block *, void *), void *);
> +extern int freeze_supers(void);
> +extern void thaw_supers(void);
>  
>  extern int dcache_dir_open(struct inode *, struct file *);
>  extern int dcache_dir_close(struct inode *, struct file *);
> Index: linux/fs/super.c
> ===================================================================
> --- linux.orig/fs/super.c
> +++ linux/fs/super.c
> @@ -594,6 +594,79 @@ void iterate_supers_type(struct file_sys
>  EXPORT_SYMBOL(iterate_supers_type);
>  
>  /**
> + *	thaw_supers - call thaw_super() for all superblocks
> + */
> +void thaw_supers(void)
> +{
> +	struct super_block *sb, *p = NULL;
> +
> +	spin_lock(&sb_lock);
> +	list_for_each_entry(sb, &super_blocks, s_list) {
> +		if (list_empty(&sb->s_instances))
> +			continue;
> +		sb->s_count++;
> +		spin_unlock(&sb_lock);
> +
> +		if (sb->s_flags & MS_FROZEN) {
> +			thaw_super(sb);
> +			sb->s_flags &= ~MS_FROZEN;
> +		}
> +
> +		spin_lock(&sb_lock);
> +		if (p)
> +			__put_super(p);
> +		p = sb;
> +	}
> +	if (p)
> +		__put_super(p);
> +	spin_unlock(&sb_lock);
> +}

It might be helpful to explain why you delay calling __put_super (I
can't see why, though I realise that fs/super.c does it this way too),
and perhaps also where the balancing get is (it's not obvious that
s->count++ is the open coded get).

> +
> +/**
> + *	freeze_supers - call freeze_super() for all superblocks
> + */
> +int freeze_supers(void)
> +{
> +	struct super_block *sb, *p = NULL;
> +	int error = 0;
> +
> +	spin_lock(&sb_lock);
> +	/*
> +	 * Freeze in reverse order so filesystems depending on others are
> +	 * frozen in the right order (eg. loopback on ext3).
> +	 */
> +	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
> +		if (list_empty(&sb->s_instances))
> +			continue;
> +		sb->s_count++;
> +		spin_unlock(&sb_lock);
> +
> +		if (sb->s_root && sb->s_frozen != SB_FREEZE_TRANS
> +		    && !(sb->s_flags & MS_RDONLY)) {
> +			error = freeze_super(sb);

No chance of a race against another caller of freeze_super, right?
(Userspace is already frozen and kernel threads aren't going to invoke
this without pushing). Might be good to document that there's no locking
in freeze_super anyway?

> +			if (!error)
> +				sb->s_flags |= MS_FROZEN;
> +		}
> +
> +		spin_lock(&sb_lock);
> +		if (error)
> +			break;
> +		if (p)
> +			__put_super(p);
> +		p = sb;
> +	}
> +	if (p)
> +		__put_super(p);
> +	spin_unlock(&sb_lock);
> +
> +	if (error)
> +		thaw_supers();
> +
> +	return error;
> +}
> +
> +
> +/**
>   *	get_super - get the superblock of a device
>   *	@bdev: device to get the superblock for
>   *	
> Index: linux/kernel/power/power.h
> ===================================================================
> --- linux.orig/kernel/power/power.h
> +++ linux/kernel/power/power.h
> @@ -1,3 +1,4 @@
> +#include <linux/fs.h>
>  #include <linux/suspend.h>
>  #include <linux/suspend_ioctls.h>
>  #include <linux/utsname.h>
> @@ -227,25 +228,3 @@ enum {
>  #define TEST_MAX	(__TEST_AFTER_LAST - 1)
>  
>  extern int pm_test_level;
> -
> -#ifdef CONFIG_SUSPEND_FREEZER
> -static inline int suspend_freeze_processes(void)
> -{
> -	int error = freeze_processes();
> -	return error ? : freeze_kernel_threads();
> -}
> -
> -static inline void suspend_thaw_processes(void)
> -{
> -	thaw_processes();
> -}
> -#else
> -static inline int suspend_freeze_processes(void)
> -{
> -	return 0;
> -}
> -
> -static inline void suspend_thaw_processes(void)
> -{
> -}
> -#endif
> Index: linux/kernel/power/suspend.c
> ===================================================================
> --- linux.orig/kernel/power/suspend.c
> +++ linux/kernel/power/suspend.c
> @@ -29,6 +29,48 @@
>  
>  #include "power.h"
>  
> +#ifdef CONFIG_SUSPEND_FREEZER
> +
> +static inline int suspend_freeze_processes(void)
> +{
> +	int error;
> +
> +	error = freeze_processes();
> +	if (error)
> +		return error;
> +
> +	error = freeze_supers();
> +	if (error) {
> +		thaw_processes();
> +		return error;
> +	}
> +
> +	error = freeze_kernel_threads();
> +	if (error)
> +		thaw_supers();

Comment why there's no matching thaw_processes() as well?

That's all from me.

Regards,

Nigel

> +
> +	return error;
> +}
> +
> +static inline void suspend_thaw_processes(void)
> +{
> +	thaw_supers();
> +	thaw_processes();
> +}
> +
> +#else /* !CONFIG_SUSPEND_FREEZER */
> +
> +static inline int suspend_freeze_processes(void)
> +{
> +	return 0;
> +}
> +
> +static inline void suspend_thaw_processes(void)
> +{
> +}
> +
> +#endif /* !CONFIG_SUSPEND_FREEZER */
> +
>  const char *const pm_states[PM_SUSPEND_MAX] = {
>  	[PM_SUSPEND_STANDBY]	= "standby",
>  	[PM_SUSPEND_MEM]	= "mem",
> Index: linux/kernel/power/hibernate.c
> ===================================================================
> --- linux.orig/kernel/power/hibernate.c
> +++ linux/kernel/power/hibernate.c
> @@ -626,12 +626,17 @@ int hibernate(void)
>  	if (error)
>  		goto Finish;
>  
> -	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
> +	error = freeze_supers();
>  	if (error)
>  		goto Thaw;
> +
> +	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
> +	if (error)
> +		goto Thaw_fs;
> +
>  	if (freezer_test_done) {
>  		freezer_test_done = false;
> -		goto Thaw;
> +		goto Thaw_fs;
>  	}
>  
>  	if (in_suspend) {
> @@ -655,6 +660,8 @@ int hibernate(void)
>  		pr_debug("PM: Image restored successfully.\n");
>  	}
>  
> + Thaw_fs:
> +	thaw_supers();
>   Thaw:
>  	thaw_processes();
>   Finish:
> 

-- 
Evolution (n): A hypothetical process whereby improbable
events occur with alarming frequency, order arises from chaos, and
no one is given credit.
