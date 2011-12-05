Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1LEW3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:29:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43524 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab1LEW3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:29:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during shutdown
Date: Mon, 5 Dec 2011 23:32:10 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Ming Lei <tom.leiming@gmail.com>,
        "Chen Peter-B29397" <B29397@freescale.com>, Greg KH <greg@kroah.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "hzpeterchen@gmail.com" <hzpeterchen@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
References: <Pine.LNX.4.44L0.1112051544350.5138-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1112051544350.5138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112052332.10822.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 05, 2011, Alan Stern wrote:
> On Tue, 6 Dec 2011, NeilBrown wrote:
> 
> > > We don't want to put devices into the active state when it's not 
> > > necessary.  A better approach would be:
> > > 
> > > 		/* Don't allow any more runtime suspends */
> > > 		pm_runtime_get_noresume(dev);
> > > 		pm_runtime_barrier(dev);

That's exactly what we do during system suspend and I _really_ think it's
not a good idea to do anything different (given that the original "disable"
idea didn't work), because that may result in serious amount of confusion.

> > 
> > That sounds like a reasonable approach if we really need to do something at
> > this level.

We do.

> > But is this the only place that ->shutdown methods are called
> > from?  If they are called from elsewhere, would those places need the
> > same pm_runtime protection?
> 
> I don't know if shutdown methods are called from anywhere else, but 
> they shouldn't be.  The kerneldoc for struct bus_type plainly says:
> 
> * @shutdown:	Called at shut-down time to quiesce the device.

It's a bug to run the shutdown callback in any other situation.

> > BTW I was wrong when I said that only calling pm_runtime_disable if there was
> > a ->shutdown function would not work for me. i.e. the following patch does
> > solve my particular issue (though I'm not sure it is "right").
> > I was getting confused by the two different devices: the i2c device and the
> > platform device.
> > The i2c device has a ->shutdown which does nothing, but doesn't need to wake
> > up.
> > The platform device is the one which needs to wake up, but it doesn't have a
> > ->shutdown function is this patch causes it not have pm_runtime disabled.
> > 
> > Thanks,
> > NeilBrown
> > 
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index d8b3d89..b9aa5d2 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -1743,13 +1743,13 @@ void device_shutdown(void)
> >  		 */
> >  		list_del_init(&dev->kobj.entry);
> >  		spin_unlock(&devices_kset->list_lock);
> > -		/* Disable all device's runtime power management */
> > -		pm_runtime_disable(dev);
> >  
> >  		if (dev->bus && dev->bus->shutdown) {
> > +			pm_runtime_disable(dev);
> >  			dev_dbg(dev, "shutdown\n");
> >  			dev->bus->shutdown(dev);
> >  		} else if (dev->driver && dev->driver->shutdown) {
> > +			pm_runtime_disable(dev);
> >  			dev_dbg(dev, "shutdown\n");
> >  			dev->driver->shutdown(dev);
> >  		}
> 
> Still, it's quite conceivable that a shutdown routine might want to 
> resume a device that had been runtime-suspended.  Disabling runtime PM 
> for that device would prevent the routine from doing its work.
> 
> The original problem the $SUBJECT patch was meant to solve was that a
> runtime-PM suspend method was called after the shutdown routine had
> run.  Doing a runtime_pm_get_noresume() ought to solve this.

That's correct.

> There still remains the possibility of a runtime resume method being
> called after the shutdown routine.  So far nobody has complained about
> that happening except you -- and your complaint was that it didn't
> work, not that it shouldn't happen.  But if necessary, individual
> drivers could add pm_runtime_disable() calls to their shutdown
> routines.

I agree.

The whole problem is that .shutdown() had been there before the PM
callbacks were added (let alone runtime PM) and it pretty much duplicates
.pm->poweroff().  Also, it doesn't handle the case when the _noirq()
callbacks are necessary (although it's very hard to trigger in practice, if
possible at all).

Anyway, since .shutdown() is quite analogous to .pm->poweroff(), the core
should treat them both consistently and do the same to synchronize with
runtime PM before calling them.  Whatever is needed beyond that, should be
done by drivers and subsystems.

So, Alan, can you please post a patch implementing your proposed approach
against the current Linus' tree?

Rafael
