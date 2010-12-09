Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab0LIUiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:38:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41816 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab0LIUiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:38:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] mmc: Fix re-probing after hibernation
Date: Thu, 9 Dec 2010 21:37:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Chris Ball <cjb@laptop.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
        Oliver Neukum <oneukum@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1291821839-15088-1-git-send-email-tiwai@suse.de> <20101209015303.GB19741@void.printf.net> <s5hlj3z1ksb.wl%tiwai@suse.de>
In-Reply-To: <s5hlj3z1ksb.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012092137.24603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 09, 2010, Takashi Iwai wrote:
> At Thu, 9 Dec 2010 01:53:03 +0000,
> Chris Ball wrote:
> > 
> > Hi Takashi,
> > 
> > On Wed, Dec 08, 2010 at 04:23:59PM +0100, Takashi Iwai wrote:
> > > The commit 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e
> > >   mmc: fix all hangs related to mmc/sd card insert/removal during
> > >   suspend/resume
> > > introduced a bug where the device probing no longer works after
> > > hibernation.  This was because the pm notifier expects
> > > PM_POST_HIBERNATION call while the system sends PM_POST_RESTORE
> > > instead, thus disable_rescan is kept as 1.
> > > 
> > > Cc: <stable@kernel.org>
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > ---
> > >  drivers/mmc/core/core.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > > index 31ae07a..30094f6 100644
> > > --- a/drivers/mmc/core/core.c
> > > +++ b/drivers/mmc/core/core.c
> > > @@ -1772,7 +1772,7 @@ int mmc_pm_notify(struct notifier_block *notify_block,
> > >  		break;
> > >  
> > >  	case PM_POST_SUSPEND:
> > > -	case PM_POST_HIBERNATION:
> > > +	case PM_POST_RESTORE:
> > >  
> > >  		spin_lock_irqsave(&host->lock, flags);
> > >  		host->rescan_disable = 0;
> > 
> > Thanks very much for tracking this down!  The code suggests that
> > POST_RESTORE is only emitted on a *failed* hibernation restore --
> > from include/linux/notifier.h:
> > 
> > /* Hibernation and suspend events */
> > #define PM_POST_HIBERNATION     0x0002 /* Hibernation finished */
> > #define PM_POST_SUSPEND         0x0004 /* Suspend finished */
> > #define PM_POST_RESTORE         0x0006 /* Restore failed */
> > 
> > So, this all suggests that we want to add the POST_RESTORE case but
> > also want to keep the POST_HIBERNATION case.  Do you agree?  Was the 
> > case you saw of failed probe after hibernation a failed restore from
> > hibernation image?
> 
> Right, I took a look at Documentation/pm/notifiers.txt, and it's
> clearly written that PM_POST_RESTORE is only for the error case.  But
> S4 resume succeeded actually on my machine, so it took time to spot
> out the culprit.
> 
> Looking at the code in kernel/power/, this might be the case of
> user-space suspend.  hibernate.c seems returning PM_POST_HIBERNATION
> while user.c returns PM_POST_RESTORE after image restoration, and I
> guess it's a bug of user.c. 
> 
> The untested patch is below (sorry I have no corresponding machine
> at my home.)  Rafael, Pavel, could you check this?
> 
> 
> thanks,
> 
> Takashi
> 
> ===
> From 915fda609e02b02e4fc6b944e4432ea1d964adc5 Mon Sep 17 00:00:00 2001
> From: Takashi Iwai <tiwai@suse.de>
> Date: Thu, 9 Dec 2010 08:09:21 +0100
> Subject: [PATCH] PM: Fix PM_POST_* notification with user-space suspend
> 
> The user-space hibernation sends a wrong notification after the image
> restoration because of thinko for the file flag check.  RDONLY
> corresponds to hibernation and WRONLY to restoration, confusingly.

The patch is correct.  I'm taking it to my tree.

Thanks,
Rafael


> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  kernel/power/user.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index e819e17..11d92b2 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -137,7 +137,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
>  	free_all_swap_pages(data->swap);
>  	if (data->frozen)
>  		thaw_processes();
> -	pm_notifier_call_chain(data->mode == O_WRONLY ?
> +	pm_notifier_call_chain(data->mode == O_RDONLY ?
>  			PM_POST_HIBERNATION : PM_POST_RESTORE);
>  	atomic_inc(&snapshot_device_available);
>  
> 

