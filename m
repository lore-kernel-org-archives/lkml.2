Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2CZTyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 15:54:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36414 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab2CZTyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 15:54:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Ball <cjb@laptop.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM / SDIO: Use empty system suspend/resume callbacks at the bus level (was: Re: Recent ...)
Date: Mon, 26 Mar 2012 21:59:09 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
References: <20120325203849.7a908e32@notabene.brown> <20120326084515.0fd3ee7f@notabene.brown> <201203260029.24826.rjw@sisk.pl>
In-Reply-To: <201203260029.24826.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201203262159.09335.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 26, 2012, Rafael J. Wysocki wrote:
> On Sunday, March 25, 2012, NeilBrown wrote:
> > On Sun, 25 Mar 2012 23:25:37 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Sunday, March 25, 2012, Rafael J. Wysocki wrote:
> > > > Hi,
> > > > 
> > > > On Sunday, March 25, 2012, NeilBrown wrote:
> > > > > 
> > > > > Hi Rafael,
> > > > > 
> > > > >  Your recent patch:
> > > > >    commit 35cd133c
> > > > >    PM: Run the driver callback directly if the subsystem one is not there
> > > > > 
> > > > >  breaks suspend for my libertas wifi and probably other SDIO devices.
> > > > 
> > > > Well, the patch is not recent.  The _commit_ is more than three months old
> > > > and the patch has been around since the last November (at least).
> > > > 
> > > > >  SDIO (and possible MMC in general) has a protocol where the suspend
> > > > >  method can return -ENOSYS and this means "There is no point in suspending,
> > > > >  just turn me off".
> > > > >
> > > > >  The device itself "mmc1:0001" (I think) doesn't have any bus etc 'suspend'
> > > > >  function so the new code call the device's suspend function which returns
> > > > >  ENOSYS and the suspend fails.
> > > > > 
> > > > >  The previous code ignores the device as there is no bus suspend, and when it
> > > > >  gets to suspend the ancestor - which for me is omap_hsmmc.1, it calls the
> > > > >  device suspend function catches the ENOSYS, and turns it off.
> > > > 
> > > > Well, I can only call that a blatant abuse of the PM infrastructure.
> > > > 
> > > > >  I suspect just reverting it isn't the right long term solution, however I
> > > > >  can confirm that it works for me for now.
> > > > 
> > > > It's not a solution at all, because there's code that depends on it already in
> > > > the tree and the fact that it works for you doesn't mean it won't break other
> > > > systems.  So no, it's not an option.
> > > > 
> > > > >  I'm happy to try any alternate fixes you would like to suggest (but I cannot
> > > > >  promise how quickly I will get the testing done).
> > > > > 
> > > > >  (I'm testing with 3.3)
> > > > 
> > > > The only fix I can think of is to rework SDIO to stop abusing the PM callbacks.
> > > > I'll have a look at that next week, although I can't promise anything any time
> > > > soon, because I'm heading to San Francisco on Saturday.
> > > 
> > > Well, this is kind of a long shot, but I wonder if the patch below makes
> > > any difference?
> > 
> > Hi Rafael,
> >  thanks for looking into this so quickly.
> > 
> > I removed the revert and applied this patch instead and can confirm that
> > suspend completes now (and resume works and the wifi works after resume).
> > 
> > Further, this patch fits with my (fairly shallow) understanding of the
> > problem.
> > 
> > Thanks!
> 
> Thanks for the confirmation.
> 
> Below it goes again with a changelog and tags.
> 
> I don't really think that SDIO does the right thing here overall, but that's
> all I can do to address the problem timely.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / SDIO: Use empty system suspend/resume callbacks at the bus level
> 
> Neil Brown reports that commit 35cd133c
> 
>    PM: Run the driver callback directly if the subsystem one is not there
> 
> breaks suspend for his libertas wifi, because SDIO has a protocol
> where the suspend method can return -ENOSYS and this means "There is
> no point in suspending, just turn me off".  Moreover, the suspend
> methods provided by SDIO drivers are not supposed to be called by
> the PM core or bus-level suspend routines (which aren't presend for
> SDIO).  Instead, when the SDIO core gets to suspend the device's
> ancestor, it calls the device driver's suspend function, catches the
> ENOSYS, and turns the device off.
> 
> The commit above breaks the SDIO core's assumption that the device
> drivers' callbacks won't be executed if it doesn't provide any
> bus-level callbacks.  If fact, however, this assumption has never
> been really satisfied, because device class or device type suspend
> might very well use the driver's callback even without that commit.
> 
> The simplest way to address this problem is to make the SDIO core
> tell the PM core to ignore driver callbacks, for example by providing
> no-operation suspend/resume callbacks at the bus level for it,
> which is implemented by this change.
> 
> Reported-and-tested-by: Neil Brown <neilb@suse.de>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

OK, I don't see any objections.  Does it mean I can push this patch as a fix
for 3.4?  Chris?

Rafael


> ---
>  drivers/mmc/core/sdio_bus.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> Index: linux/drivers/mmc/core/sdio_bus.c
> ===================================================================
> --- linux.orig/drivers/mmc/core/sdio_bus.c
> +++ linux/drivers/mmc/core/sdio_bus.c
> @@ -192,9 +192,15 @@ static int sdio_bus_remove(struct device
>  	return ret;
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
> +
> +static int pm_no_operation(struct device *dev)
> +{
> +	return 0;
> +}
>  
>  static const struct dev_pm_ops sdio_bus_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(pm_no_operation, pm_no_operation)
>  	SET_RUNTIME_PM_OPS(
>  		pm_generic_runtime_suspend,
>  		pm_generic_runtime_resume,
> @@ -204,11 +210,11 @@ static const struct dev_pm_ops sdio_bus_
>  
>  #define SDIO_PM_OPS_PTR	(&sdio_bus_pm_ops)
>  
> -#else /* !CONFIG_PM_RUNTIME */
> +#else /* !CONFIG_PM */
>  
>  #define SDIO_PM_OPS_PTR	NULL
>  
> -#endif /* !CONFIG_PM_RUNTIME */
> +#endif /* !CONFIG_PM */
>  
>  static struct bus_type sdio_bus_type = {
>  	.name		= "sdio",
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

