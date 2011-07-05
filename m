Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1GEORR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:17:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50674 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752552Ab1GEORP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:17:15 -0400
Date: Tue, 5 Jul 2011 10:17:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Partha Basak <p-basak2@ti.com>, Keshava Munegowda <keshava_mgowda@ti.com>,
        USB list <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anand Gadiyar <gadiyar@ti.com>, <sameo@linux.intel.com>,
        <parthab@india.ti.com>, <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
In-Reply-To: <20110705125227.GI2820@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1107050958090.2060-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jul 2011, Felipe Balbi wrote:

> > The real problem here is that you guys are trying to use the runtime PM
> > framework to carry out activities during system suspend.  That won't
> > work; it's just a bad idea all round.  Use the proper callbacks to do
> > what you want.
> 
> then what's the point in even having runtime PM if we will still have to
> implement the same functionality on the other callbacks ?

You don't have to duplicate the functionality.  You can use exactly the
same functions for both sets of callbacks if you want; just make sure
the callbacks point to them.

>  Well, of
> course runtime PM will conserve power on runtime, but system suspend
> should be no different other than an "always deepest sleep state"
> decision.

No, it is significantly different for several reasons.  Some of the
most important differences are concerned with freezing userspace and
deciding what events should be allowed to wake up the system.  Also, 
there are systems which can achieve greater power savings by system 
sleep than they can by runtime PM + cpuidle.

> The thing now is that pm_runtime was done so that drivers would stop
> caring about clocks, which is a big plus, but if we still have to handle
> ->suspend()/->resume() differently, we will still need to clk_get();
> clk_enable(); clk_disable(); Then what was the big deal with runtime PM?

I don't know about that.  Clock usage has always been internal to the
implementation you guys have been working on, and I haven't followed
it.  If your implementation was designed incorrectly, well, that's a
shame but it's understandable.  Things like that happen.  It shouldn't
be too hard to fix.

But first you do need to understand that system suspend really _is_ 
different from runtime suspend.  Sure, you may be able to share some 
code between them, but you should not expect to be able to use one in 
place of the other.

> IMHO, we should have only one PM layer. System suspend/resume should be
> implemented so that core PM "forcefully" calls
> ->runtime_suspend()/->runtime_resume() of call drivers, all
> synchronously. Maybe we need an extra
> RPM_STATIC_SUSPEND_PLEASE_HANDLE_IT_ALL_SYNCHRONOUSLY flag, but that's
> another detail.

Statements like this should be posted to linux-pm where they can be 
discussed properly.  It certainly isn't fair to make such claims 
without even CC-ing the PM maintainer.

Besides, handling runtime PM synchronously won't do you any good if the 
user has disabled runtime PM via sysfs or not enabled 
CONFIG_PM_RUNTIME in the first place.  Have you forgotten about those 
possibilities?

Furthermore, from what I've gathered so far from this thread, the
_real_ problem is that nobody has written suspend and resume callbacks
for the parent device.  You're relying on runtime PM to do things with
the parent, but instead you should make use of the usual system sleep
mechanism: Parents are always suspended after their children and
awakened before.  Have the parent's suspend routine disable the clocks 
and have the resume routine enable them.  Problem solved, no changes 
needed in the child's driver code.

> If drivers are really supposed to stop handling clocks directly, then
> runtime PM is THE framework to do that, but if we still have system
> suspend/resume the old way, I don't see the benefit for the driver
> (other than the uAmps saved during runtime, which is great, don't get me
> wrong ;-) that this will bring. Having two PM layers which, in fact, are
> doing the same thing - reducing power consumption - is just too much
> IMO.

They aren't doing the same thing.  If you don't believe me, ask the PM 
maintainer.

And if you actually do need your callbacks to do the same thing, simply
use shared subroutines.

Alan Stern

