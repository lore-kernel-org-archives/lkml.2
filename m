Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2A2Q23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 11:28:29 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52740 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2A2Q21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 11:28:27 -0500
Message-ID: <4F257395.9070804@linux.vnet.ibm.com>
Date: Sun, 29 Jan 2012 21:58:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
        Martin@lichtvoll.de
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
References: <201201281445.49377.rjw@sisk.pl>
In-Reply-To: <201201281445.49377.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12012907-3568-0000-0000-00000121F5EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2012 07:15 PM, Rafael J. Wysocki wrote:

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

...

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
> +


If freezing of kernel threads fails, freeze_kernel_threads() calls
thaw_processes(), which means, even userspace processes get thawed.
So, there would be a time-window in which userspace is thawed but the
filesystems are still frozen. That is not very desirable right?

If that is right, then modifying freeze_kernel_threads() to call
thaw_kernel_threads() instead of thaw_processes() would fix it
(and of course, we would need to explicitly call thaw_processes
above).

BTW, after your patch posted at https://lkml.org/lkml/2012/1/27/501,
I very much wanted to write a patch to convert the semantics of
freeze/thaw to something like:

freeze_processes() calls thaw_processes on error.
//Both touch only userspace processes.

freeze_kernel_threads() calls thaw_kernel_threads() on error.
//Both touch only kernel threads.

Of course, such a patch would need to do a lot of fixing up at several
places, but IMHO, it would really help make the overall code more logical
and easier to understand.

I can write it up and post it soon, but then you'll have to rebase
your patch (this one) on top of that. What do you say?

Regards,
Srivatsa S. Bhat

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

