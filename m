Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0LABVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:21:54 -0500
Received: from smtp-out.google.com ([74.125.121.35]:15322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab0LABVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=uhTubGbYZQ8CnZhjs57sb4pS6FrFwQeplnWzRWw2ezthaNn3ucF4qEq4AGhz9Ti+NM
         0XFkgET/Lv7joLL1imLw==
Date: Tue, 30 Nov 2010 17:21:39 -0800 (PST)
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
In-Reply-To: <201012010138.53575.rjw@sisk.pl>
Message-ID: <alpine.LSU.2.00.1011301715480.15050@tigran.mtv.corp.google.com>
References: <201011171139.33398.linux@rainbow-software.org> <alpine.LSU.2.00.1011301333380.11072@tigran.mtv.corp.google.com> <201012010007.44553.rjw@sisk.pl> <201012010138.53575.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Rafael J. Wysocki wrote:
> Below is an updated patch in which I tried to address your comments.
> 
> I didn't find it very useful to couple pm_restore_gfp_mask() with the thawing
> of tasks, but nevertheless I think all of the spots where it's needed are
> covered now.

So far as I can see, yes, they are: I'm still a bit worried about
future changes leaving the wrong gfp mask behind by mistake;
but I trust you more than I trust me on that, so you can add my
Acked-by: Hugh Dickins <hughd@google.com> when it comes to
sending in the patch.

Thanks,
Hugh

> 
> The patch has only been compile-tested for now, so caveat emptor.
> 
> Thanks,
> Rafael
> 
> ---
>  include/linux/gfp.h      |    4 ++--
>  kernel/power/hibernate.c |   22 ++++++++++++----------
>  kernel/power/suspend.c   |    5 ++---
>  kernel/power/user.c      |    2 ++
>  mm/page_alloc.c          |   18 +++++++++++-------
>  5 files changed, 29 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6/kernel/power/hibernate.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/hibernate.c
> +++ linux-2.6/kernel/power/hibernate.c
> @@ -327,7 +327,6 @@ static int create_image(int platform_mod
>  int hibernation_snapshot(int platform_mode)
>  {
>  	int error;
> -	gfp_t saved_mask;
>  
>  	error = platform_begin(platform_mode);
>  	if (error)
> @@ -339,7 +338,7 @@ int hibernation_snapshot(int platform_mo
>  		goto Close;
>  
>  	suspend_console();
> -	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
> +	pm_restrict_gfp_mask();
>  	error = dpm_suspend_start(PMSG_FREEZE);
>  	if (error)
>  		goto Recover_platform;
> @@ -348,7 +347,10 @@ int hibernation_snapshot(int platform_mo
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
> @@ -357,7 +359,10 @@ int hibernation_snapshot(int platform_mo
>  
>  	dpm_resume_end(in_suspend ?
>  		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
> -	set_gfp_allowed_mask(saved_mask);
> +
> +	if (error || !in_suspend)
> +		pm_restore_gfp_mask();
> +
>  	resume_console();
>   Close:
>  	platform_end(platform_mode);
> @@ -452,17 +457,16 @@ static int resume_target_kernel(bool pla
>  int hibernation_restore(int platform_mode)
>  {
>  	int error;
> -	gfp_t saved_mask;
>  
>  	pm_prepare_console();
>  	suspend_console();
> -	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
> +	pm_restrict_gfp_mask();
>  	error = dpm_suspend_start(PMSG_QUIESCE);
>  	if (!error) {
>  		error = resume_target_kernel(platform_mode);
>  		dpm_resume_end(PMSG_RECOVER);
>  	}
> -	set_gfp_allowed_mask(saved_mask);
> +	pm_restore_gfp_mask();
>  	resume_console();
>  	pm_restore_console();
>  	return error;
> @@ -476,7 +480,6 @@ int hibernation_restore(int platform_mod
>  int hibernation_platform_enter(void)
>  {
>  	int error;
> -	gfp_t saved_mask;
>  
>  	if (!hibernation_ops)
>  		return -ENOSYS;
> @@ -492,7 +495,6 @@ int hibernation_platform_enter(void)
>  
>  	entering_platform_hibernation = true;
>  	suspend_console();
> -	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
>  	error = dpm_suspend_start(PMSG_HIBERNATE);
>  	if (error) {
>  		if (hibernation_ops->recover)
> @@ -536,7 +538,6 @@ int hibernation_platform_enter(void)
>   Resume_devices:
>  	entering_platform_hibernation = false;
>  	dpm_resume_end(PMSG_RESTORE);
> -	set_gfp_allowed_mask(saved_mask);
>  	resume_console();
>  
>   Close:
> @@ -647,6 +648,7 @@ int hibernate(void)
>  		if (!error)
>  			power_down();
>  		in_suspend = 0;
> +		pm_restore_gfp_mask();
>  	} else {
>  		pr_debug("PM: Image restored successfully.\n");
>  	}
> Index: linux-2.6/kernel/power/user.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/user.c
> +++ linux-2.6/kernel/power/user.c
> @@ -263,6 +263,7 @@ static long snapshot_ioctl(struct file *
>  	case SNAPSHOT_UNFREEZE:
>  		if (!data->frozen || data->ready)
>  			break;
> +		pm_restore_gfp_mask();
>  		thaw_processes();
>  		usermodehelper_enable();
>  		data->frozen = 0;
> @@ -275,6 +276,7 @@ static long snapshot_ioctl(struct file *
>  			error = -EPERM;
>  			break;
>  		}
> +		pm_restore_gfp_mask();
>  		error = hibernation_snapshot(data->platform_support);
>  		if (!error)
>  			error = put_user(in_suspend, (int __user *)arg);
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -104,19 +104,23 @@ gfp_t gfp_allowed_mask __read_mostly = G
>   * only be modified with pm_mutex held, unless the suspend/hibernate code is
>   * guaranteed not to run in parallel with that modification).
>   */
> -void set_gfp_allowed_mask(gfp_t mask)
> +
> +static gfp_t saved_gfp_mask;
> +
> +void pm_restore_gfp_mask(void)
>  {
>  	WARN_ON(!mutex_is_locked(&pm_mutex));
> -	gfp_allowed_mask = mask;
> +	if (saved_gfp_mask) {
> +		gfp_allowed_mask = saved_gfp_mask;
> +		saved_gfp_mask = 0;
> +	}
>  }
>  
> -gfp_t clear_gfp_allowed_mask(gfp_t mask)
> +void pm_restrict_gfp_mask(void)
>  {
> -	gfp_t ret = gfp_allowed_mask;
> -
>  	WARN_ON(!mutex_is_locked(&pm_mutex));
> -	gfp_allowed_mask &= ~mask;
> -	return ret;
> +	saved_gfp_mask = gfp_allowed_mask;
> +	gfp_allowed_mask &= ~GFP_IOFS;
>  }
>  #endif /* CONFIG_PM_SLEEP */
>  
> Index: linux-2.6/include/linux/gfp.h
> ===================================================================
> --- linux-2.6.orig/include/linux/gfp.h
> +++ linux-2.6/include/linux/gfp.h
> @@ -360,7 +360,7 @@ void drain_local_pages(void *dummy);
>  
>  extern gfp_t gfp_allowed_mask;
>  
> -extern void set_gfp_allowed_mask(gfp_t mask);
> -extern gfp_t clear_gfp_allowed_mask(gfp_t mask);
> +extern void pm_restrict_gfp_mask(void);
> +extern void pm_restore_gfp_mask(void);
>  
>  #endif /* __LINUX_GFP_H */
> Index: linux-2.6/kernel/power/suspend.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/suspend.c
> +++ linux-2.6/kernel/power/suspend.c
> @@ -197,7 +197,6 @@ static int suspend_enter(suspend_state_t
>  int suspend_devices_and_enter(suspend_state_t state)
>  {
>  	int error;
> -	gfp_t saved_mask;
>  
>  	if (!suspend_ops)
>  		return -ENOSYS;
> @@ -208,7 +207,7 @@ int suspend_devices_and_enter(suspend_st
>  			goto Close;
>  	}
>  	suspend_console();
> -	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
> +	pm_restrict_gfp_mask();
>  	suspend_test_start();
>  	error = dpm_suspend_start(PMSG_SUSPEND);
>  	if (error) {
> @@ -225,7 +224,7 @@ int suspend_devices_and_enter(suspend_st
>  	suspend_test_start();
>  	dpm_resume_end(PMSG_RESUME);
>  	suspend_test_finish("resume devices");
> -	set_gfp_allowed_mask(saved_mask);
> +	pm_restore_gfp_mask();
>  	resume_console();
>   Close:
>  	if (suspend_ops->end)
> 
