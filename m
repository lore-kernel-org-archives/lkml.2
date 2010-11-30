Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0K3Wl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:41:56 -0500
Received: from smtp-out.google.com ([74.125.121.35]:48562 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0K3Wlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:41:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NUoQq4OM8G3T/TtwC2xH1JNUFz6pJsWJ0l/f8N2VvKnAXUBW+5kgCydVREpnwPWqpK
         Ig1jB5UPIYbka7kn4W+w==
Date: Tue, 30 Nov 2010 14:16:25 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ondrej Zary <linux@rainbow-software.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: 2.6.35.5: hibernation broken... AGAIN
In-Reply-To: <201011272147.01828.rjw@sisk.pl>
Message-ID: <alpine.LSU.2.00.1011301333380.11072@tigran.mtv.corp.google.com>
References: <201011171139.33398.linux@rainbow-software.org> <201011270010.04323.rjw@sisk.pl> <201011271558.14786.linux@rainbow-software.org> <201011272147.01828.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010, Rafael J. Wysocki wrote:
> On Saturday, November 27, 2010, Ondrej Zary wrote:
> > > > >
> > > > > Not signing it off yet,
> > > > > Hugh
> > > >
> > > > Could you please do that? The patch fixes the problem.

Sorry for going quiet for so long.

Thanks for testing, Ondrej.  I completely agree with Rafael that my
patch was inadequate: it turned out to be good enough for your useful
feedback on the main path through hibernation, but missed a number
of details.  We do need something like Rafael's patch - thanks.

(And I realize that it's tiresome and frustrating for you to be
trying first that and then this etc; but we had bugs here precisely
because this is a confusing area, so I think it is worth some effort
to get right now.)

> > >
> > > Can you check if the problem is also fixed by the patch below, please?
> > 
> > The patch does not apply to 2.6.35.4, 2.6.35.5 and also 2.6.36. What version 
> > should I test?
> 
> The patch was against the current mainline.
> 
> The one below was rebased on top of 2.6.36, so please test it with this kernel.

I'll comment on this version, since it has one more line than your original.

> 
> Thanks,
> Rafael
> 
> ---
>  kernel/power/hibernate.c |   36 ++++++++++++++++++++++++++----------
>  kernel/power/power.h     |    1 +
>  kernel/power/user.c      |    2 ++
>  3 files changed, 29 insertions(+), 10 deletions(-)
> 
> Index: suspend-2.6/kernel/power/hibernate.c
> ===================================================================
> --- suspend-2.6.orig/kernel/power/hibernate.c
> +++ suspend-2.6/kernel/power/hibernate.c
> @@ -29,6 +29,21 @@
>  #include "power.h"
>  
>  
> +static gfp_t saved_gfp_mask;
> +
> +static void hibernate_restrict_gfp_mask(void)
> +{
> +	saved_gfp_mask = clear_gfp_allowed_mask(GFP_IOFS);
> +}
> +
> +void hibernate_restore_gfp_mask(void)
> +{
> +	if (saved_gfp_mask) {
> +		set_gfp_allowed_mask(saved_gfp_mask);
> +		saved_gfp_mask = 0;
> +	}
> +}
> +

Trivial point, I suppose, but it bothers me that PM is accumulating
wrappers around wrappers around gfp_allowed_mask.  Looks like
clear_gfp_allowed_mask and set_gfp_allowed_mask (oddly asymmetrical)
were not really what we need.  How about scrapping them, and putting
pm_restrict_gfp_mask() and pm_restore_gfp_mask() into page_alloc.c?

>  static int noresume = 0;
>  static char resume_file[256] = CONFIG_PM_STD_PARTITION;
>  dev_t swsusp_resume_device;
> @@ -326,7 +341,6 @@ static int create_image(int platform_mod
>  int hibernation_snapshot(int platform_mode)
>  {
>  	int error;
> -	gfp_t saved_mask;
>  
>  	error = platform_begin(platform_mode);
>  	if (error)
> @@ -338,7 +352,7 @@ int hibernation_snapshot(int platform_mo
>  		goto Close;
>  
>  	suspend_console();
> -	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
> +	hibernate_restrict_gfp_mask();

Yes.

>  	error = dpm_suspend_start(PMSG_FREEZE);
>  	if (error)
>  		goto Recover_platform;
> @@ -347,7 +361,10 @@ int hibernation_snapshot(int platform_mo
>  		goto Recover_platform;
>  
>  	error = create_image(platform_mode);
> -	/* Control returns here after successful restore */
> +	/*
> +	 * Control returns here (1) after the image has been created or the
> +	 * image creation has failed and (2) after a successful restore.
> +	 */
>  
>   Resume_devices:
>  	/* We may need to release the preallocated image pages here. */
> @@ -356,7 +373,10 @@ int hibernation_snapshot(int platform_mo
>  
>  	dpm_resume_end(in_suspend ?
>  		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
> -	set_gfp_allowed_mask(saved_mask);
> +
> +	if (error || !in_suspend)
> +		hibernate_restore_gfp_mask();
> +

I'm worried that it's hard to find and maintain the places that need
this restoration - and if we miss one, we won't find out about it for
ages.  It would help a lot if the gfp restoration always accompanies
some other essential stage - thaw_processes() looks to be right,
so could we skip conditionally restoring here if we do it then?

I suggest that in part because I cannot find where you restore in
the case that hibernate()'s swsusp_write() fails - that was the
case that made me realize my little patch was too simplistic.

>  	resume_console();
>   Close:
>  	platform_end(platform_mode);
> @@ -451,17 +471,16 @@ static int resume_target_kernel(bool pla
>  int hibernation_restore(int platform_mode)
>  {
>  	int error;
> -	gfp_t saved_mask;
>  
>  	pm_prepare_console();
>  	suspend_console();
> -	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
> +	hibernate_restrict_gfp_mask();

Yes.

>  	error = dpm_suspend_start(PMSG_QUIESCE);
>  	if (!error) {
>  		error = resume_target_kernel(platform_mode);
>  		dpm_resume_end(PMSG_RECOVER);
>  	}
> -	set_gfp_allowed_mask(saved_mask);
> +	hibernate_restore_gfp_mask();

But this could be left until software_resume()'s thaw_processes()?
Ah, that won't cover the SNAPSHOT_ATOMIC_RESTORE case, hmmm.

>  	resume_console();
>  	pm_restore_console();
>  	return error;
> @@ -475,7 +494,6 @@ int hibernation_restore(int platform_mod
>  int hibernation_platform_enter(void)
>  {
>  	int error;
> -	gfp_t saved_mask;
>  
>  	if (!hibernation_ops)
>  		return -ENOSYS;
> @@ -491,7 +509,6 @@ int hibernation_platform_enter(void)
>  
>  	entering_platform_hibernation = true;
>  	suspend_console();
> -	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);

Right.

>  	error = dpm_suspend_start(PMSG_HIBERNATE);
>  	if (error) {
>  		if (hibernation_ops->recover)
> @@ -535,7 +552,6 @@ int hibernation_platform_enter(void)
>   Resume_devices:
>  	entering_platform_hibernation = false;
>  	dpm_resume_end(PMSG_RESTORE);
> -	set_gfp_allowed_mask(saved_mask);

Right.

>  	resume_console();
>  
>   Close:
> Index: suspend-2.6/kernel/power/power.h
> ===================================================================
> --- suspend-2.6.orig/kernel/power/power.h
> +++ suspend-2.6/kernel/power/power.h
> @@ -49,6 +49,7 @@ static inline char *check_image_kernel(s
>  extern int hibernation_snapshot(int platform_mode);
>  extern int hibernation_restore(int platform_mode);
>  extern int hibernation_platform_enter(void);
> +extern void hibernate_restore_gfp_mask(void);
>  #endif
>  
>  extern int pfn_is_nosave(unsigned long);
> Index: suspend-2.6/kernel/power/user.c
> ===================================================================
> --- suspend-2.6.orig/kernel/power/user.c
> +++ suspend-2.6/kernel/power/user.c
> @@ -263,6 +263,7 @@ static long snapshot_ioctl(struct file *
>  	case SNAPSHOT_UNFREEZE:
>  		if (!data->frozen || data->ready)
>  			break;
> +		hibernate_restore_gfp_mask();

Right, here you have one next to thaw_processes().
But the SNAPSHOT ioctls are a nightmarish maze to me,
I cannot comment much on what's right here.

>  		thaw_processes();
>  		usermodehelper_enable();
>  		data->frozen = 0;
> @@ -275,6 +276,7 @@ static long snapshot_ioctl(struct file *
>  			error = -EPERM;
>  			break;
>  		}
> +		hibernate_restore_gfp_mask();
>  		error = hibernation_snapshot(data->platform_support);

That might be good safety, but it does strongly suggest that you
needed to put it somewhere else, and couldn't work out where?

>  		if (!error)
>  			error = put_user(in_suspend, (int __user *)arg);
> 

Hugh
