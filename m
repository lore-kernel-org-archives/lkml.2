Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab1EQXcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:32:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33576 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab1EQXcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:32:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: Re: [PATCH 2/4] PM / Loss: power loss management
Date: Wed, 18 May 2011 01:32:30 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <201105122157.46895.rjw@sisk.pl> <20110513130212.GF29259@mail.gnudd.com>
In-Reply-To: <20110513130212.GF29259@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180132.30802.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the delay.

On Friday, May 13, 2011, Davide Ciminaghi wrote:
> On Thu, May 12, 2011 at 09:57:46PM +0200, Rafael J. Wysocki wrote:
> > Hi,
> >
> > On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> > > From: Davide Ciminaghi <ciminaghi@gnudd.com>
> > > 
> 
> hello, I (Davide) will reply as the patch author.
> 
> ....................
> > 
> > I'm not really sure about that.  Do you want to hardcode policies in some
> > platform/board-specific files inside of the kernel?
> > 
> 
> I think a little history of the patch can help: it looks like recent mmc 
> devices can do any sort of weird things in case of sudden power losses during 
> write operations. This is still to be confirmed by actual tests on our
> particular hardware, but we suspect that even a journalling fs could be 
> corrupted in such a case.

That very well may be the case.

> Stopping the mmc request queue when a power loss is detected, does not 
> completely solve the problem, but at least mitigates the risk of disasters.
> Plus, we needed to get our board to immediately turn off any unneeded power 
> sink in case of temporary power losses (just try to survive as long as you 
> can ...). 

I understand the motivation I think. :-)

> Our hardware triggers an interrupt about 100 millisenconds before the cpu 
> dies, so we needed to notify the drivers about the event as fast as we could.
> That was one of the two main reasons why we chose to put this stuff inside 
> the kernel. The other reason was that the mmc request queue can be easily 
> stopped from kernel space.

OK, but it's not really sufficient to notify drivers in that case, because
they may crash user space if they simply switch off devices.  Now, if the
power loss actually happens, that probably doesn't matter, but if power is
restored afterwards, that won't be nice.

The mmc request queue is a special case that shouldn't affect user space
directly, but other devices may be accessed in many different ways and
not all of them are safe to intercept forcibly.

However, even for the mmc case you'd need a mechanism that will force
the filesystem on it to flush everything to the storage immediately.

> Since forcing a given policy seemed the wrong thing to do, we chose to adopt
> a modular policy approach.
> 
> > > +The header file include/linux/pm_loss.h contains all the pm_loss function
> > > +prototypes, together with definitions of data structures.
> > > +For what concerns power loss policies, the framework already contains a couple
> > > +of predefined policies: "nop" and "default" (see later paragraphs for more
> > > +details).
> > 
> > I think it would be cleaner to split the patch so that the actual functionality
> > is added first and the policy part goes in a separate patch on top of that.
> > 
> 
> agreed.
> 
> > > +
> > > +1.1 Sysfs interface.
> > > +
> > > +It can be useful (for instance during tests), to be able to quickly switch
> > > +from one power loss policy to another, or to simulate power fail and resume
> > > +events. To this end, a sysfs interface of the following form has been devised:
> > > +
> > > +/sys/power/loss +
> > > +		|
> > > +		+-- active_policy
> > > +		|
> > > +		+-- policies -+
> > > +		|	      |
> > > +		|	      +-- nop
> > > +		|	      |
> > > +		|	      +-- default +
> > > +		|	      |		  |
> > > +		|	      |	 	  +-- bus_table
> > > +		|	      |
> > > +		|	      +-- ....
> > > +		|
> > > +		+-- pwrfail_sim
> > > +
> > > +2. Details
> > > +
> > > +2.1 Sending events to the power loss management core.
> > > +
> > > +The board specific code shall trigger a power failure event notification by
> > > +calling pm_loss_power_changed(SYS_PWR_FAILING).
> > > +In case of a temporary power loss, the same function shall be called with
> > > +SYS_PWR_GOOD argument on power resume. pm_loss_power_changed() can sleep, so
> > > +it shall not be called from interrupt context.
> > > +
> > > +2.3 Effects on bus and device drivers.
> > > +
> > > +One more entry has been added to the device PM callbacks:
> > > +
> > > +   int (*power_changed)(struct device *, enum sys_power_state);
> > 
> > Please don't use the second argument.  Make it two (or as many as you need)
> > callbacks each with one struct device * argument instead (following the
> > convention we have in struct dev_pm_ops already).
> > 
> > That said, I'm not quite sure we _need_ those additional callbacks at all.
> > Your example mmc implementation appears to use a simple "runtime suspend on
> > power fail, runtime resume on power good" approach, for which it's not
> > necessary to add any new callbacks.
> > 
> 
> maybe this is design choice comes from our little knowledge of pm_runtime, 
> but the reason why we didn't use the existing callbacks was that we wanted 
> to avoid any possible conflict.
> In our understanding, pm_runtime works more or less like this: "when 
> you're done with a peripheral, turn it off" (well, maybe also wait a little 
> while to avoid continuously toggling power on and off, thus wasting more 
> power than just doing nothing). This is because its goal is to save power 
> during normal operation.
> On the other hand, we needed something like this: "when some external event 
> takes place, just turn off anything you can as fast as you can".

This is more similar to system suspend than to runtime PM.

> Actually, one of the attempts we made before adding pm_loss was to implement 
> it via pm_runtime, by just immediately stopping devices on idle and refusing
> to turn them on again in case a power loss event took place in the meanwhile.
> This worked, and was ok for drivers with no implementation of the pm_runtime 
> callbacks, but introduced a potential conflict as far as pm_runtime enabled 
> drivers were concerned. That's why we (maybe wrongfully) thought a new 
> callback was needed.

Having considered that for a while I think that additional callbacks may be
necessary, because they generally may need to do more than just suspending
devices.

> > > +This function can be optionally invoked by power loss policies in case of
> > > +system power changes (loss and/or resume). Of course every bus or device driver
> > > +can react to such events in some specific way. For instance the mmc block
> > > +driver will probably block its request queue during a temporary power loss.
> > 
> > I think you'd have to deal with user space somehow before suspending devices.
> > Runtime PM suspends devices when they aren't in use (as indicated by the
> > usage counters), but in this power loss case we may really end up suspending
> > devices that _are_ in use, right?
> > 
> yes. This is not a problem for us right now, because when a power loss happens,
> the "power bad" condition just lasts for about 100ms. At present, pm_loss
> callbacks are implemented for the mmc block device and a video capture device
> only.

While that may not be a problem to you, it is a problem in general and it
should be taken into account if we are to provide a generic framework for
such things.

> In practice what happens on our platform is that processes accessing the mmc 
> can be put to sleep until either the board dies or a power resume event takes 
> place. If video capture is running, some "black" frames are generated, but 
> that is not considered a real fault because power losses should not occur 
> during normal operation (unless you really turn the board off, of course).
> 
> That said, I think you're right anyway, userspace should be notified somehow.
> SIGPWR to init ?. As far as I know, there's no single place in the kernel 
> where SIGPWR is sent to init:
> 
> find . -name \*.c  | xargs grep SIGPWR
> ...
> ./drivers/char/snsc_event.c:            kill_cad_pid(SIGPWR, 0);
> ...
> ./arch/s390/kernel/nmi.c:               kill_cad_pid(SIGPWR, 1);
> 
> Maybe pm_loss could become such a place ?

I think so.  SIGPWR seems to be a good candidate, but that would change the
current (documented) behavior where SIGPWR is a synonym for SIGINFO.

Thanks,
Rafael
