Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab0FUUOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:14:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36135 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab0FUUO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oymqtB+CxakqcRAxh/aBfRrHeAGaaYiijQ2XNAxPnVCfwJSu2hcB5GCjg+uU26467a
         +IM4dAFjETdLUn0XEC3Svf7TqaXYBU6var8zOeptnXxX7W5/0GnCjyNEThNK/+drJHlL
         M48LKNEHmHx4MrZ1kneRWCKX8Df61XOq+c+K8=
Subject: Re: [PATCH 1/2] MMC: fix all hangs related to mmc/sd card
 insert/removal during suspend/resume.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
In-Reply-To: <4C1FC5BC.20008@nokia.com>
References: <1276809695.28201.13.camel@maxim-laptop>
	 <1276809814-28683-1-git-send-email-maximlevitsky@gmail.com>
	 <4C1FC5BC.20008@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 23:14:21 +0300
Message-ID: <1277151261.5409.30.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 23:04 +0300, Adrian Hunter wrote: 
> ext Maxim Levitsky wrote:
> > If you don't use CONFIG_MMC_UNSAFE_RESUME, as soon as you attempt to
> > suspend, the card will be removed, therefore this patch doesn't change
> > the behavior of this option.
> > 
> > However the removal will be done by pm notifier, which runs while
> > userspace is still not frozen and thus can freely use del_gendisk,
> > without the risk of deadlock which would happen otherwise.
> > 
> > 
> > Card detect workqueue is now freezeable,
> > therefore if you do use CONFIG_MMC_UNSAFE_RESUME,
> > and remove the card during suspend, the removal will be
> > detected as soon as userspace is unfrozen, again at the moment
> > it is safe to call del_gendisk.
> > 
> > Tested with and without CONFIG_MMC_UNSAFE_RESUME with suspend and hibernate.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  drivers/mmc/core/core.c  |   54 +++++++++++++++++++++++++++------------------
> >  drivers/mmc/core/host.c  |    6 +++++
> >  include/linux/mmc/host.h |    3 ++
> >  3 files changed, 41 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > index 569e94d..0cba53a 100644
> > --- a/drivers/mmc/core/core.c
> > +++ b/drivers/mmc/core/core.c
> > @@ -1259,26 +1259,11 @@ int mmc_suspend_host(struct mmc_host *host)
> >  
> >  	if (host->caps & MMC_CAP_DISABLE)
> >  		cancel_delayed_work(&host->disable);
> > -	cancel_delayed_work(&host->detect);
> > -	mmc_flush_scheduled_work();
> >  
> >  	mmc_bus_get(host);
> >  	if (host->bus_ops && !host->bus_dead) {
> >  		if (host->bus_ops->suspend)
> >  			err = host->bus_ops->suspend(host);
> > -		if (err == -ENOSYS || !host->bus_ops->resume) {
> > -			/*
> > -			 * We simply "remove" the card in this case.
> > -			 * It will be redetected on resume.
> > -			 */
> > -			if (host->bus_ops->remove)
> > -				host->bus_ops->remove(host);
> > -			mmc_claim_host(host);
> > -			mmc_detach_bus(host);
> > -			mmc_release_host(host);
> > -			host->pm_flags = 0;
> > -			err = 0;
> > -		}
> >  	}
> >  	mmc_bus_put(host);
> >  
> > @@ -1310,12 +1295,6 @@ int mmc_resume_host(struct mmc_host *host)
> >  			printk(KERN_WARNING "%s: error %d during resume "
> >  					    "(card was removed?)\n",
> >  					    mmc_hostname(host), err);
> > -			if (host->bus_ops->remove)
> > -				host->bus_ops->remove(host);
> > -			mmc_claim_host(host);
> > -			mmc_detach_bus(host);
> > -			mmc_release_host(host);
> > -			/* no need to bother upper layers */
> >  			err = 0;
> >  		}
> >  	}
> > @@ -1330,6 +1309,37 @@ int mmc_resume_host(struct mmc_host *host)
> >  	return err;
> >  }
> >  
> > +/* Do the card removal on suspend if card is assumed removeable
> > + * Do that in pm notifier while userspace isn't yet frozen, so we will be able
> > +   to sync the card.
> > +*/
> > +int mmc_pm_notify(struct notifier_block *notify_block,
> > +					unsigned long mode, void *unused)
> > +{
> > +	struct mmc_host *host = container_of(
> > +		notify_block, struct mmc_host, pm_notify);
> > +
> > +
> > +	switch (mode) {
> > +	case PM_HIBERNATION_PREPARE:
> > +	case PM_SUSPEND_PREPARE:
> > +
> > +		if (!host->bus_ops || host->bus_ops->suspend)
> > +			break;
> > +
> > +		if (host->bus_ops->remove)
> > +			host->bus_ops->remove(host);
> > +		mmc_claim_host(host);
> > +		mmc_detach_bus(host);
> > +		mmc_release_host(host);
> > +		host->pm_flags = 0;
> > +		break;
> 
> Is it possible that you receive PM_SUSPEND_PREPARE
> but there is no suspend and therefore no resume
> and therefore the card is removed but not detected
> again?
This is very good point.
The solution is to kick mmc detection thread from this notifier.
on resume.
I update the patch.

> 
> Is it possible that you are racing with kmmcd and the
> card is added after you receive PM_SUSPEND_PREPARE but
> before kmmcd is frozen?
This is unlikely but valid race.
I afraid I don't know nice way to solve it right now.
I can add some ad-hoc variable to tell interrupt handler not to kick the
detection workqueue after suspend notifier was called.

I wish there was a generic freeze_workqueue function.


Best regards,
Maxim Levitsky

