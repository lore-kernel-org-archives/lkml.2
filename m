Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0FTMvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 08:51:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57595 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab0FTMvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 08:51:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Sun, 20 Jun 2010 14:49:14 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <201006200005.35771.rjw@sisk.pl> <20100620055254.GA21994@gvim.org>
In-Reply-To: <20100620055254.GA21994@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006201449.14754.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 20, 2010, mark gross wrote:
> On Sun, Jun 20, 2010 at 12:05:35AM +0200, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > One of the arguments during the suspend blockers discussion was that the
> > mainline kernel didn't contain any mechanisms allowing it to avoid losing
> > wakeup events during system suspend.
> > 
> > Generally, there are two problems in that area.  First, if a wakeup event
> > occurs exactly at the same time when /sys/power/state is being written to,
> > the even may be delivered to user space right before the freezing of it,
> > in which case the user space consumer of the event may not be able to process
> yes this is racy.  souldn't the wakeup event handers/driver force a user
> mode ACK before they stop failing suspend attempts? 

I'm not sure what you mean.  There are wake-up events without any user space
consumers, like wake-on-LAN.

> > it before the system is suspended.  Second, if a wakeup event occurs after user
> > space has been frozen and that event is not a wakeup interrupt, the kernel will
> > not react to it and the system will be suspended.
> 
> If its not a wakeup interrupt is it not fair to allow the suspend to
> happen even if its handler's are "in flight" at suspend time?

A wakeup event need not be an interrupt, or at least there are interrupts that
have other meanings, like ACPI SCI.

> > The following patch illustrates my idea of how these two problems may be
> > addressed.  It introduces a new global sysfs attribute,
> > /sys/power/wakeup_count, associated with a running counter of wakeup events
> > and a helper function, pm_wakeup_event(), that may be used by kernel subsystems
> > to increment the wakeup events counter.
> > 
> > /sys/power/wakeup_count may be read from or written to by user space.  Reads
> > will always succeed and return the current value of the wakeup events counter.
> > Writes, however, will only succeed if the written number is equal to the
> > current value of the wakeup events counter.  If a write is successful, it will
> > cause the kernel to save the current value of the wakeup events counter and
> > to compare the saved number with the current value of the counter at certain
> > points of the subsequent suspend (or hibernate) sequence.  If the two values
> > don't match, the suspend will be aborted just as though a wakeup interrupt
> > happened.  Reading from /sys/power/wakeup_count again will turn that mechanism
> > off.
> 
> why would you want to turn it off?

In some cases I may want to suspend/hibernate losing some wakeup events,
like for example in the case of emergency hibernation on critical battery.

> > The assumption is that there's a user space power manager that will first
> > read from /sys/power/wakeup_count.  Then it will check all user space consumers
> > of wakeup events known to it for unprocessed events.  If there are any, it will
> > wait for them to be processed and repeat.  In turn, if there are not any,
> > it will try to write to /sys/power/wakeup_count and if the write is successful,
> > it will write to /sys/power/state to start suspend, so if any wakeup events
> > accur past that point, they will be noticed by the kernel and will eventually
> > cause the suspend to be aborted.
> > 
> > In addition to the above, the patch adds a wakeup events counter to the
> > power member of struct device and makes these per-device wakeup event counters
> > available via sysfs, so that it's possible to check the activity of various
> > wakeup event sources within the kernel.
> > 
> > To illustrate how subsystems can use pm_wakeup_event(), I added it to the
> > PCI runtime PM wakeup-handling code.
> > 
> > At the moment the patch only contains code changes (ie. no documentation),
> > but I'm going to add comments etc. if people like the idea.
> > 
> > Please tell me what you think.
> > 
> > Rafael
> > 
> > ---
> >  drivers/base/power/Makefile     |    2 -
> >  drivers/base/power/main.c       |    1 
> >  drivers/base/power/power.h      |    3 +
> >  drivers/base/power/sysfs.c      |    9 ++++
> >  drivers/base/power/wakeup.c     |   74 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/pci/pci-acpi.c          |    2 +
> >  drivers/pci/pcie/pme/pcie_pme.c |    2 +
> >  include/linux/pm.h              |    6 +++
> >  kernel/power/hibernate.c        |   14 ++++---
> >  kernel/power/main.c             |   24 ++++++++++++
> >  kernel/power/power.h            |    6 +++
> >  kernel/power/suspend.c          |    2 -
> >  12 files changed, 138 insertions(+), 7 deletions(-)
> > 
> > Index: linux-2.6/kernel/power/main.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/power/main.c
> > +++ linux-2.6/kernel/power/main.c
> > @@ -204,6 +204,28 @@ static ssize_t state_store(struct kobjec
> >  
> >  power_attr(state);
> >  
> > +static ssize_t wakeup_count_show(struct kobject *kobj,
> > +				struct kobj_attribute *attr,
> > +				char *buf)
> > +{
> > +	return sprintf(buf, "%lu\n", pm_get_wakeup_count());
> > +}
> > +
> > +static ssize_t wakeup_count_store(struct kobject *kobj,
> > +				struct kobj_attribute *attr,
> > +				const char *buf, size_t n)
> > +{
> > +	unsigned long val;
> > +
> > +	if (sscanf(buf, "%lu", &val) == 1) {
> > +		if (pm_save_wakeup_count(val))
> > +			return n;
> > +	}
> > +	return -EINVAL;
> > +}
> > +
> > +power_attr(wakeup_count);
> > +
> >  #ifdef CONFIG_PM_TRACE
> >  int pm_trace_enabled;
> >  
> > @@ -236,6 +258,7 @@ static struct attribute * g[] = {
> >  #endif
> >  #ifdef CONFIG_PM_SLEEP
> >  	&pm_async_attr.attr,
> > +	&wakeup_count_attr.attr,
> >  #ifdef CONFIG_PM_DEBUG
> >  	&pm_test_attr.attr,
> >  #endif
> > @@ -266,6 +289,7 @@ static int __init pm_init(void)
> >  	int error = pm_start_workqueue();
> >  	if (error)
> >  		return error;
> > +	pm_wakeup_events_init();
> >  	power_kobj = kobject_create_and_add("power", NULL);
> >  	if (!power_kobj)
> >  		return -ENOMEM;
> > Index: linux-2.6/drivers/base/power/wakeup.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/drivers/base/power/wakeup.c
> > @@ -0,0 +1,74 @@
> > +
> > +#include <linux/device.h>
> > +#include <linux/pm.h>
> > +
> > +static unsigned long event_count;
> > +static unsigned long saved_event_count;
> 
> what about over flow issues?

There's no issue AFAICS.  It only matters if the value is different from the
previous one after incrementation.

> > +static bool events_check_enabled;
> > +static spinlock_t events_lock;
> > +
> > +void pm_wakeup_events_init(void)
> > +{
> > +	spin_lock_init(&events_lock);
> > +}
> > +
> > +void pm_wakeup_event(struct device *dev)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&events_lock, flags);
> > +	event_count++;
> should event_count be an atomic type so we can not bother with taking
> the evnets_lock?

The lock is there, because two counters are incremented at the same time.
Also, in some other places the counter is accessed along with the enable
flag, so there are two operations that need to be done in the same critical
section.

> > +	if (dev)
> > +		dev->power.wakeup_count++;
> > +	spin_unlock_irqrestore(&events_lock, flags);
> > +}
> > +
> > +bool pm_check_wakeup_events(bool enable)
> > +{
> > +	unsigned long flags;
> > +	bool ret;
> > +
> > +	spin_lock_irqsave(&events_lock, flags);
> > +	ret = !events_check_enabled || (event_count == saved_event_count);
> I'm not getting the events_check_enbled flag yet.

I tells the PM core whether or not to check wakeup events during suspend.
The checking is only enabled after a successful write to
/sys/power/wakeup_count, it is disabled by reads and by the final check right
before the system enters suspend.  [That's because the "saved" value from
the previous suspend should not be used for checking wakeup events during
the next one.]

> > +	events_check_enabled = enable;
> I'm not sure if this is the right thing depending on all the different
> ways the boolians are interacting with eachother.
> 
> Which is a red flag to me.  This code is confusing.

Well, I could use check_wakeup_events() and
check_and_disable_wakeup_events() (the latter is only necessary for the final
check), but I'm not sure if that's going to be better.

> I'll look at it some more when I'm fresh tomorrow.

Thanks for the comments.

Rafael
