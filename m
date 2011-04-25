Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab1DYK3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:29:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47985 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab1DYK3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:29:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH/RFC] MMC: remove unbalanced pm_runtime_suspend()
Date: Mon, 25 Apr 2011 12:29:27 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-mmc@vger.kernel.org,
        Magnus Damm <damm@opensource.se>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1104221709030.1791-100000@iolanthe.rowland.org> <201104230011.48073.rjw@sisk.pl>
In-Reply-To: <201104230011.48073.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104251229.27263.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 23, 2011, Rafael J. Wysocki wrote:
> On Friday, April 22, 2011, Alan Stern wrote:
> > On Fri, 22 Apr 2011, Rafael J. Wysocki wrote:
> > 
> > > > The barrier would not prevent the race between the notifier and runtie PM
> > > > from taking place.  Why don't we do something like this instead:
> > > > 
> > > > ---
> > > >  drivers/base/dd.c |    3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > Index: linux-2.6/drivers/base/dd.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/drivers/base/dd.c
> > > > +++ linux-2.6/drivers/base/dd.c
> > > > @@ -326,6 +326,8 @@ static void __device_release_driver(stru
> > > >  						     BUS_NOTIFY_UNBIND_DRIVER,
> > > >  						     dev);
> > > >  
> > > > +		pm_runtime_put_sync(dev);
> > > > +
> > > 
> > > In fact, I think this one may be _noidle.  If we allow the bus/driver
> > > to do what they wont, we might as well let them handle the "device idle"
> > > case from ->remove().
> > 
> > Maybe...  But keeping it put_sync doesn't do any harm.  In Guennadi's 
> > case, it might allow him to get rid of the pm_runtime_suspend() call in 
> > the remove routine.
> > 
> > > >  		if (dev->bus && dev->bus->remove)
> > > >  			dev->bus->remove(dev);
> > > >  		else if (drv->remove)
> > > > @@ -338,7 +340,6 @@ static void __device_release_driver(stru
> > > >  						     BUS_NOTIFY_UNBOUND_DRIVER,
> > > >  						     dev);
> > > >  
> > > > -		pm_runtime_put_sync(dev);
> > > >  	}
> > > >  }
> > 
> > Basically this is okay with me, and it should allow Guennadi to avoid
> > the extra put/get pair.
> 
> OK, so I'm going to put the appended patch into my linux-next branch
> (hopefully, the problem is explained sufficiently in the changelog).

I thought about that a bit more and came to the conclusion that we should
do things a bit differently in __device_release_driver().  Namely, the fact
that the device can be resumed (either synchronously or asynchronously) after
the pm_runtime_barrier() has returned may be problematic too, because it
may race with the bus notifier in some cases.  For this reason, I think it
would be better to do pm_runtime_get_sync() instead of the
pm_runtime_get_noresume() and pm_runtime_barrier().

So, I think the appended patch would be better than the previous one.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Rework runtime PM handling during driver removal

The driver core tries to prevent race conditions between runtime PM
and driver removal from happening by incrementing the runtime PM
usage counter of the device and executing pm_runtime_barrier() before
running the bus notifier and the ->remove() callbacks provided by the
device's subsystem or driver.  This guarantees that, if a future
runtime suspend of the device has been scheduled or a runtime resume
or idle request has been queued up right before the driver removal,
it will be canceled or waited for to complete and no other
asynchronous runtime suspend or idle requests for the device will be
put into the PM workqueue until the ->remove() callback returns.
However, it doesn't prevent resume requests from being queued up
after pm_runtime_barrier() has been called and it doesn't prevent
pm_runtime_resume() from executing the device subsystem's runtime
resume callback.  Morever, it prevents the device's subsystem or
driver from putting the device into the suspended state by calling
pm_runtime_suspend() from its ->remove() routine.  This turns out to
be a major inconvenience for some subsystems and drivers that want to
leave the devices they handle in the suspended state.

To really prevent runtime PM callbacks from racing with the bus
notifier callback in __device_release_driver(), which is necessary,
because the notifier is used by some subsystems to carry out
operations affecting the runtime PM functionality, use
pm_runtime_get_sync() instead of the combination of
pm_runtime_get_noresume() and pm_runtime_barrier().  This will resume
the device if it's in the suspended state and will prevent it from
being suspended again until pm_runtime_put_*() is called.

To allow subsystems and drivers to put devices into the suspended
state by calling pm_runtime_suspend() from their ->remove() routines,
execute pm_runtime_put_sync() after running the bus notifier in
__device_release_driver().  This will require subsystems and drivers
to make their ->remove() callbacks avoid races with runtime PM
directly, but it will allow of more flexibility in the handling of
devices during the removal of their drivers.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/dd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/base/dd.c
===================================================================
--- linux-2.6.orig/drivers/base/dd.c
+++ linux-2.6/drivers/base/dd.c
@@ -316,8 +316,7 @@ static void __device_release_driver(stru
 
 	drv = dev->driver;
 	if (drv) {
-		pm_runtime_get_noresume(dev);
-		pm_runtime_barrier(dev);
+		pm_runtime_get_sync(dev);
 
 		driver_sysfs_remove(dev);
 
@@ -326,6 +325,8 @@ static void __device_release_driver(stru
 						     BUS_NOTIFY_UNBIND_DRIVER,
 						     dev);
 
+		pm_runtime_put_sync(dev);
+
 		if (dev->bus && dev->bus->remove)
 			dev->bus->remove(dev);
 		else if (drv->remove)
@@ -338,7 +339,6 @@ static void __device_release_driver(stru
 						     BUS_NOTIFY_UNBOUND_DRIVER,
 						     dev);
 
-		pm_runtime_put_sync(dev);
 	}
 }
 
