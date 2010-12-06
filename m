Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab0LFW6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:58:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59374 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0LFW6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:58:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: 2.6.35.5: hibernation broken... AGAIN
Date: Mon, 6 Dec 2010 23:57:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>
References: <201011171139.33398.linux@rainbow-software.org> <201011272147.01828.rjw@sisk.pl> <201012062209.33084.linux@rainbow-software.org>
In-Reply-To: <201012062209.33084.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012062357.38699.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 06, 2010, Ondrej Zary wrote:
> On Saturday 27 November 2010 21:47:01 Rafael J. Wysocki wrote:
> > On Saturday, November 27, 2010, Ondrej Zary wrote:
> > > On Saturday 27 November 2010 00:10:04 Rafael J. Wysocki wrote:
> > > > On Friday, November 26, 2010, Ondrej Zary wrote:
> > > > > On Thursday 18 November 2010, Hugh Dickins wrote:
> > > > > > On Wed, 17 Nov 2010, Ondrej Zary wrote:
> > > > > > > On Wednesday 17 November 2010 22:12:01 Rafael J. Wysocki wrote:
> > > > > > > > On Wednesday, November 17, 2010, Andrew Morton wrote:
> > > > > > > > > On Wed, 17 Nov 2010 21:53:52 +0100
> > > > > > > > >
> > > > > > > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > > > > > > On Wednesday, November 17, 2010, Ondrej Zary wrote:
> > > > > > > > > > > Hello,
> > > > > > > > > > > the nasty memory-corrupting hibernation bug
> > > > > > > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=15753 is back
> > > > > > > > > > > since 2.6.35.5. 2.6.35.4 works fine, 2.6.35.5 crashes
> > > > > > > > > > > after two days.
> > > > > >
> > > > > > That's distressing, for both and all of us: I'm sorry.
> > > > > >
> > > > > > > > > > > It seems to be caused by
> > > > > > > > > > > b77c254d8d66e5e9aa81239fedba9f3d568097d9.
> > > > > > > > >
> > > > > > > > > commit b77c254d8d66e5e9aa81239fedba9f3d568097d9
> > > > > > > > > Author: Hugh Dickins <hughd@google.com>
> > > > > > > > > Date:   Thu Sep 9 16:38:09 2010 -0700
> > > > > > > > >
> > > > > > > > >     swap: prevent reuse during hibernation
> > > > > >
> > > > > > Embarrassing: I suspect that I've been confused, not for the first
> > > > > > time, by the fork-like nature of hibernation and its images.
> > > > > > I wonder if this patch below fixes it, Ondrej?
> > > > > >
> > > > > > (And is it kernel swsusp or user swsusp that you're using?  May not
> > > > > > matter at all, but will help us to think more clearly about it,
> > > > > > if the corruption remains after this patch.)
> > > > > >
> > > > > > Rafael, do you agree that this patch was actually required even for
> > > > > > your original commit 452aa6999e6703ffbddd7f6ea124d3968915f3e3
> > > > > > mm/pm: force GFP_NOIO during suspend/hibernation and resume?
> > > > > >
> > > > > > Or am I still just as confused?  Or if not, are there more forking
> > > > > > places which require a similar patch?
> > > > > >
> > > > > > Not signing it off yet,
> > > > > > Hugh
> > > > >
> > > > > Could you please do that? The patch fixes the problem.
> > > >
> > > > Can you check if the problem is also fixed by the patch below, please?
> > >
> > > The patch does not apply to 2.6.35.4, 2.6.35.5 and also 2.6.36. What
> > > version should I test?
> >
> > The patch was against the current mainline.
> >
> > The one below was rebased on top of 2.6.36, so please test it with this
> > kernel.
> 
> This seems to work fine (5 days and no crash).

Thanks for testing!

Rafael


> > ---
> >  kernel/power/hibernate.c |   36 ++++++++++++++++++++++++++----------
> >  kernel/power/power.h     |    1 +
> >  kernel/power/user.c      |    2 ++
> >  3 files changed, 29 insertions(+), 10 deletions(-)
> >
> > Index: suspend-2.6/kernel/power/hibernate.c
> > ===================================================================
> > --- suspend-2.6.orig/kernel/power/hibernate.c
> > +++ suspend-2.6/kernel/power/hibernate.c
> > @@ -29,6 +29,21 @@
> >  #include "power.h"
> >
> >
> > +static gfp_t saved_gfp_mask;
> > +
> > +static void hibernate_restrict_gfp_mask(void)
> > +{
> > +	saved_gfp_mask = clear_gfp_allowed_mask(GFP_IOFS);
> > +}
> > +
> > +void hibernate_restore_gfp_mask(void)
> > +{
> > +	if (saved_gfp_mask) {
> > +		set_gfp_allowed_mask(saved_gfp_mask);
> > +		saved_gfp_mask = 0;
> > +	}
> > +}
> > +
> >  static int noresume = 0;
> >  static char resume_file[256] = CONFIG_PM_STD_PARTITION;
> >  dev_t swsusp_resume_device;
> > @@ -326,7 +341,6 @@ static int create_image(int platform_mod
> >  int hibernation_snapshot(int platform_mode)
> >  {
> >  	int error;
> > -	gfp_t saved_mask;
> >
> >  	error = platform_begin(platform_mode);
> >  	if (error)
> > @@ -338,7 +352,7 @@ int hibernation_snapshot(int platform_mo
> >  		goto Close;
> >
> >  	suspend_console();
> > -	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
> > +	hibernate_restrict_gfp_mask();
> >  	error = dpm_suspend_start(PMSG_FREEZE);
> >  	if (error)
> >  		goto Recover_platform;
> > @@ -347,7 +361,10 @@ int hibernation_snapshot(int platform_mo
> >  		goto Recover_platform;
> >
> >  	error = create_image(platform_mode);
> > -	/* Control returns here after successful restore */
> > +	/*
> > +	 * Control returns here (1) after the image has been created or the
> > +	 * image creation has failed and (2) after a successful restore.
> > +	 */
> >
> >   Resume_devices:
> >  	/* We may need to release the preallocated image pages here. */
> > @@ -356,7 +373,10 @@ int hibernation_snapshot(int platform_mo
> >
> >  	dpm_resume_end(in_suspend ?
> >  		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
> > -	set_gfp_allowed_mask(saved_mask);
> > +
> > +	if (error || !in_suspend)
> > +		hibernate_restore_gfp_mask();
> > +
> >  	resume_console();
> >   Close:
> >  	platform_end(platform_mode);
> > @@ -451,17 +471,16 @@ static int resume_target_kernel(bool pla
> >  int hibernation_restore(int platform_mode)
> >  {
> >  	int error;
> > -	gfp_t saved_mask;
> >
> >  	pm_prepare_console();
> >  	suspend_console();
> > -	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
> > +	hibernate_restrict_gfp_mask();
> >  	error = dpm_suspend_start(PMSG_QUIESCE);
> >  	if (!error) {
> >  		error = resume_target_kernel(platform_mode);
> >  		dpm_resume_end(PMSG_RECOVER);
> >  	}
> > -	set_gfp_allowed_mask(saved_mask);
> > +	hibernate_restore_gfp_mask();
> >  	resume_console();
> >  	pm_restore_console();
> >  	return error;
> > @@ -475,7 +494,6 @@ int hibernation_restore(int platform_mod
> >  int hibernation_platform_enter(void)
> >  {
> >  	int error;
> > -	gfp_t saved_mask;
> >
> >  	if (!hibernation_ops)
> >  		return -ENOSYS;
> > @@ -491,7 +509,6 @@ int hibernation_platform_enter(void)
> >
> >  	entering_platform_hibernation = true;
> >  	suspend_console();
> > -	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
> >  	error = dpm_suspend_start(PMSG_HIBERNATE);
> >  	if (error) {
> >  		if (hibernation_ops->recover)
> > @@ -535,7 +552,6 @@ int hibernation_platform_enter(void)
> >   Resume_devices:
> >  	entering_platform_hibernation = false;
> >  	dpm_resume_end(PMSG_RESTORE);
> > -	set_gfp_allowed_mask(saved_mask);
> >  	resume_console();
> >
> >   Close:
> > Index: suspend-2.6/kernel/power/power.h
> > ===================================================================
> > --- suspend-2.6.orig/kernel/power/power.h
> > +++ suspend-2.6/kernel/power/power.h
> > @@ -49,6 +49,7 @@ static inline char *check_image_kernel(s
> >  extern int hibernation_snapshot(int platform_mode);
> >  extern int hibernation_restore(int platform_mode);
> >  extern int hibernation_platform_enter(void);
> > +extern void hibernate_restore_gfp_mask(void);
> >  #endif
> >
> >  extern int pfn_is_nosave(unsigned long);
> > Index: suspend-2.6/kernel/power/user.c
> > ===================================================================
> > --- suspend-2.6.orig/kernel/power/user.c
> > +++ suspend-2.6/kernel/power/user.c
> > @@ -263,6 +263,7 @@ static long snapshot_ioctl(struct file *
> >  	case SNAPSHOT_UNFREEZE:
> >  		if (!data->frozen || data->ready)
> >  			break;
> > +		hibernate_restore_gfp_mask();
> >  		thaw_processes();
> >  		usermodehelper_enable();
> >  		data->frozen = 0;
> > @@ -275,6 +276,7 @@ static long snapshot_ioctl(struct file *
> >  			error = -EPERM;
> >  			break;
> >  		}
> > +		hibernate_restore_gfp_mask();
> >  		error = hibernation_snapshot(data->platform_support);
> >  		if (!error)
> >  			error = put_user(in_suspend, (int __user *)arg);
> 
> 
> 
> 

