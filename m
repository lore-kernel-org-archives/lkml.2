Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1F3Tgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:36:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab1F3Tgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:36:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH 7/10 v6] PM / Domains: Don't stop wakeup devices during system sleep transitions
Date: Thu, 30 Jun 2011 21:37:23 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
References: <201106112223.04972.rjw@sisk.pl> <201106252329.24342.rjw@sisk.pl> <87fwmsnqno.fsf@ti.com>
In-Reply-To: <87fwmsnqno.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106302137.23801.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 30, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Devices that are set up to wake up the system from sleep states
> > should not be stopped and power should not be removed from them
> > when the system goes into a sleep state.  
> 
> I don't think this belongs in the generic layer since the two
> assumptions above are not generally true on embedded systems, and would
> result in rather significant power consumption unnecessarily.

As to whether or not this belongs to the generic layer, I don't quite agree
(see below), but the changelog seems to be a bit inaccurate.

> First, whether the device should be stopped on device_may_wakeup():
> 
> Some IP blocks (at least on OMAP) have "asynchronous" wakeups.  Meaning
> that they can generate wakeups even when they're not clocked (a.k.a
> stopped).  So in this case, even after a ->stop_device (which clock
> gates the IP), it can still generate wakeups.
> 
> Second, whether the device should be powered off if device_may_wakeup():
> 
> Embedded SoCs have other ways to wakeup than device-level wakeups.
> 
> For example, on OMAP, every pad on the SoC can be configured as a wakeup
> source So, for example, you could completely power down the UART IP
> blocks (and the enclosing power domain), configure the UART RX pad as a
> wakeup source, and still wakeup the system on UART activity.  The OMAP
> docs call these IO pad wakeups.
> 
> On OMAP in fact, this is the common, default behavior when we enable
> "off-mode" in idle and/or suspend, since most of the IPs are powered off
> but can still wake up the system.
> 
> So in summary, even if device_may_wakeup() is true, many devices (with
> additional SoC magic) can still generate wakeups even when stopped and
> powered off.

Well, on the other hand, on some SoCs there are devices that can't be
powered off (or "declocked") if they are supposed to generate wakeups.
Also, I'm sure there are cases in which wakeups can be generated for devices
with their clocks off, but only if power is present.  So there are multiple
cases, but not so many overall.  So, IMO, it makes sense to handle that at
the generic level, although not necessarily in such a simplistic way.

Now, at this point, I want to do something very simple, which I think is
done by this patch.  Is this optimal power comsumption-wise for every potential
user of the framework?  No, but certainly for some it's sufficient.  Is it
going to work in general?  I think it is.

Of course, there's the question how to handle that more accurately and I have
some ideas.  If you have any, please let me know.

In the meantime, I'm going to modify the changelog so that it's clear that
it's a "first approximation" thing, like in the patch below.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Domains: Don't stop wakeup devices during system sleep transitions

There is the problem how to handle devices set up to wake up the
system from sleep states during system-wide power transitions.
In some cases, those devices can be turned off entirely, because the
wakeup signals will be generated on their behalf anyway.  In some
other cases, they will generate wakeup signals if their clocks are
stopped, but only if power is not removed from them.  Finally, in
some cases, they can only generate wakeup signals if power is not
removed from them and their clocks are enabled.

In the future, it will be necessary to take all of the above
situations into account, but for starters it is possible to use
the observation that if all wakeup devices are treated like the
last group (i.e. their clocks are enabled and power in not removed
from them during system suspend transitions), they all will be able
to generate wakeups, although power consumption in the resulting
system sleep state may not be optimal in some cases.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -450,6 +450,9 @@ static int pm_genpd_suspend_noirq(struct
 	if (ret)
 		return ret;
 
+	if (device_may_wakeup(dev))
+		return 0;
+
 	if (genpd->stop_device)
 		genpd->stop_device(dev);
 
@@ -670,6 +673,9 @@ static int pm_genpd_dev_poweroff_noirq(s
 	if (ret)
 		return ret;
 
+	if (device_may_wakeup(dev))
+		return 0;
+
 	if (genpd->stop_device)
 		genpd->stop_device(dev);
 
