Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1FRVAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 17:00:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab1FRVAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 17:00:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] calling runtime PM from system PM methods
Date: Sat, 18 Jun 2011 23:01:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1106181123050.29370-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106181123050.29370-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182301.04090.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 18, 2011, Alan Stern wrote:
> On Sat, 18 Jun 2011, Rafael J. Wysocki wrote:
> 
> > On Friday, June 17, 2011, Rafael J. Wysocki wrote:
> > > On Friday, June 17, 2011, Alan Stern wrote:
> > > > On Fri, 17 Jun 2011, Rafael J. Wysocki wrote:
> > > > 
> > > > > Having considered that a bit more I see that, in fact, commit
> > > > > e8665002477f0278f84f898145b1f141ba26ee26 (PM: Allow pm_runtime_suspend() to
> > > > > succeed during system suspend) has introduced at least one regression.
> > > > > Namely, the PCI bus type runs pm_runtime_resume() in its .prepare()
> > > > > callback to guarantee that devices will be in a well known state before
> > > > > the PCI .suspend() and .suspend_noirq() callbacks are executed.
> > > > > Unfortunately, after commit e8665002477f0278f84f898145b1f141ba26ee26 this
> > > > > isn't valid any more, because devices can be runtime-suspend after the
> > > > > pm_runtime_resume() in .prepare() has run.
> > > > > 
> > > > > USB seems to do something similar in choose_wakeup().
> > > > > 
> > > > > So, either the both of these subsystems should be modified to use
> > > > > pm_runtime_get_sync() and then pm_runtime_put_<something>() some time
> > > > > during resume, or we should revert commit e8665002477f0278f84f898145b1f141ba26ee26.
> > > > 
> > > > pm_runtime_put_noidle would be appropriate.
> > > > 
> > > > > Quite frankly, which shouldn't be a surprise to anyone at this point, I'd
> > > > > prefer to revert that commit for 3.0.
> > > > 
> > > > Maybe we can compromise.  Instead of reverting that commit outright,
> > > > put the get_noresume just before the suspend callback and put the
> > > > put_sync just after the resume callback.
> > > 
> > > That wouldn't fix the PCI problem, though, because it would leave a small
> > > window in which the device could be suspended after the pm_runtime_resume()
> > > in pci_pm_prepare() had run.
> > 
> > That said, the PCI case can be solved with a separate patch and if the other
> > subsystems are not affected, perhaps that's the best approach.
> 
> Yes, it would be a simple change.
> 
> > Still, I'd like to make sure that there won't be any races between runtime
> > PM and .suspend_noirq() and .resume_noirq() callbacks, so I'd like to apply
> > the patch below.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> >  drivers/base/power/main.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/drivers/base/power/main.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/main.c
> > +++ linux-2.6/drivers/base/power/main.c
> > @@ -591,6 +591,8 @@ void dpm_resume(pm_message_t state)
> >  	async_error = 0;
> >  
> >  	list_for_each_entry(dev, &dpm_suspended_list, power.entry) {
> > +		pm_runtime_get_noresume(dev);
> > +		pm_runtime_enable(dev);
> >  		INIT_COMPLETION(dev->power.completion);
> >  		if (is_async(dev)) {
> >  			get_device(dev);
> > @@ -614,6 +616,7 @@ void dpm_resume(pm_message_t state)
> >  		}
> >  		if (!list_empty(&dev->power.entry))
> >  			list_move_tail(&dev->power.entry, &dpm_prepared_list);
> > +		pm_runtime_put_noidle(dev);
> >  		put_device(dev);
> >  	}
> >  	mutex_unlock(&dpm_list_mtx);
> > @@ -939,8 +942,10 @@ int dpm_suspend(pm_message_t state)
> >  			put_device(dev);
> >  			break;
> >  		}
> > -		if (!list_empty(&dev->power.entry))
> > +		if (!list_empty(&dev->power.entry)) {
> >  			list_move(&dev->power.entry, &dpm_suspended_list);
> > +			pm_runtime_disable(dev);
> > +		}
> 
> The put_noidle is in the wrong place for async resumes.  Likewise for
> the pm_runtime_disable() and async suspends.  Also this runs into
> problems if a device is never suspended (i.e., if the sleep transition
> aborts before suspending that device).

I overlooked that, thanks for pointing it out.

Well, assuming that https://patchwork.kernel.org/patch/893722/ is applied,
which is going to be, I think we can put

+       pm_runtime_get_noresume(dev);
+       pm_runtime_enable(dev);

in device_resume() after the dev->power.is_suspended check and
pm_runtime_put_noidle() under the End label.  That cause them to
be called under the device lock, but that shouldn't be a big deal.

Accordingly, we can call pm_runtime_disable(dev) in __device_suspend(),
right next to the setting of power.is_suspended.

This is implemented by the patch below.

Thanks,
Rafael

---
 drivers/base/power/main.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -521,6 +521,9 @@ static int device_resume(struct device *
 	if (!dev->power.is_suspended)
 		goto Unlock;
 
+	pm_runtime_get_noresume(dev);
+	pm_runtime_enable(dev);
+
 	if (dev->pwr_domain) {
 		pm_dev_dbg(dev, state, "power domain ");
 		error = pm_op(dev, &dev->pwr_domain->ops, state);
@@ -557,6 +560,7 @@ static int device_resume(struct device *
 
  End:
 	dev->power.is_suspended = false;
+	pm_runtime_put_noidle(dev);
 
  Unlock:
 	device_unlock(dev);
@@ -888,7 +892,10 @@ static int __device_suspend(struct devic
 	}
 
  End:
-	dev->power.is_suspended = !error;
+	if (!error) {
+		dev->power.is_suspended = true;
+		pm_runtime_disable(dev);
+	}
 
  Unlock:
 	device_unlock(dev);
