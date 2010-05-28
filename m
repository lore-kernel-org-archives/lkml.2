Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0E1Gjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:39:48 -0400
Received: from ist.d-labs.de ([213.239.218.44]:55247 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab0E1Gjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:39:43 -0400
Date: Fri, 28 May 2010 08:39:34 +0200
From: Florian Mickler <florian@mickler.org>
To: Brian Swetland <swetland@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528083934.5f2f2cb6@schatten.dmk.lab>
In-Reply-To: <AANLkTimqcVYhRxa4JUaiArPHS4_T7I-kbclhVx_jJOt3@mail.gmail.com>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<AANLkTimqcVYhRxa4JUaiArPHS4_T7I-kbclhVx_jJOt3@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 21:55:26 -0700
Brian Swetland <swetland@google.com> wrote:

> On Thu, May 27, 2010 at 3:55 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> > This started because the Android people came to a meeting that was put
> > together of various folks to try and sort of the big blockage in getting
> > Android and Linux kernels back towards merging.
> >
> > I am interested right now in finding a general solution to the Android
> > case and the fact it looks very similar to the VM, hard RT, gamer and
> > other related problems although we seem to have diverged from that logic.
> 
> I think that the suspend block model can be viewed as a constraints
> problem (similar to some of things things you've been sketching out in
> these threads), but I think we (Google/Android) view it as more of a
> state constraint (don't enter suspend) than a latency constraint.
> 
> We think there's a need for these constraints both from the driver
> side and userspace side, and that these constraints are not tied to
> processes (multiple entities in one process may have different
> constraints at different times or multiple processes may be working
> together to accomplish some goal under a single constraint -- at least
> both cases exist in the Android system as it ships today).
> 
> The exact naming of the API is not terribly important to us.  The
> first thing we spent a bunch of time discussing last summer when Arve
> first looked into sending wakelocks upstream was changing the name
> because many objected to "wakelock" for various reasons.
> 
> Being able to have userful statistics (which drivers/processes/etc
> held which wakelock for how long, how many times, etc) is important to
> us.  While we want to do the best we can in the face of poorly written
> apps, we also want to educate users and developers about which apps
> are contributing to their poor battery life -- so users can decide to
> uninstall an app if its usefulness does not justify its impact on
> battery life and application developers can be more aware of what the
> cost of their app is to endusers.
> 
> As an example, http://frotz.net/misc/battery-stats-unplugged.txt
> contains a dump from the "battery service" aggregating wakelock usage,
> cpu usage, and sensor device usage of processes (#....: sections) on
> my phone the other day for a ~3 hour period.  This data is presented
> visually to the enduser in a "what's using my battery" feature of the
> platform.  "realtime" refers to wall clock time here and "uptime"
> refers to not-in-suspend execution time.
> 
> Brian


Hi!
Thinking about the issue a little more, this isn't really about trusted
apps and not trusted apps. Or crapplications. 

The point is, that as soon as an app takes a suspend-blocker it becomes
 what is here referred to as a "trusted app". But just because it is then visible as
consuming power in an official way. 

Android suspends (as in echo mem > /sys/power/state)
whenever possible. It's as if there were a spring on the laptop lid,
and if the user doesnt hold his grip on it, the thing closes. How does
he hold his grip? The application registers a suspend-blocker for him.

So, why not use something like idle/QOS with this? 

I can imagine to theoretically have a "latency requirement" where 0
means this application does not interact with the user. and != 0 means
this application interacts with the user.

("latency requirement" doesn't quite get it, but it works for now)

In android land, the default would be that every application has a
latency-requirement of 0. And then everything (userland) that takes a
suspend-blocker would be changed to take a "latency requirement != 0". 

Now, if the system interacts with the user
( i.e. there is a global
latency requirement > 0, where "global latency requirement" is
computed by the pm framework maxing over all the userland processes
and the kernel side)
everything has to run. So we also need to schedule things which specify 
a latency requirement == 0.

This last thing means, that it has to be independent of the scheduler, doesn't it?

I don't see how renaming suspend_blocker to set_pidle would not do
something equivalent to this, but the bit's are probably a bit scattered
throughout the kernel. 
(Which I don't think is introduced by that patch set, but by the fact that 
suspend is currently not an idle state.)

I can understand if there needs to be a good solution in the kernel
from day 1. 

So, what would compose to a good solution? 

Here should probably the more experienced people jump in, but let me express 
what i've gathered in this discussion (especially from Thomas and Alan Cox):

1. change suspend framework to be "just another idle state"
2. specify that "just another idle state" can only be entered if
"global latency requirement" == 0
3. probably add some cost-estimate-computation to the "just another
idle state"

(the trick here is, that this idle-state ignores all current measures of "idle", 
so the cost for this would only depend on the cost-estimate to enter it and 
the suspend-power-usage. which also means it is probably 'opportune' to enter it, whenever possible, 
except the machine is idle the old way already (because the cost to enter is bigger))

4. change the userspace suspend interface 
	i.e. echo mem > /sys/power/state to override the "global
	latency requirement" to be 0.

5. convert the drivers to relax their latency-requirement to be 0
whenever possible. (in android land, this is already done, probably just needs a 
s/suspend_block/set_pidle(1)/ )
6. enhance the cpufreq drivers to take global latency requirement into
view. (i.e. opportunistic suspend would be implemented in the proper place,
 don't know which that is, please chime in)

So, what specifically would have to be done to the suspend blockers patches?
And can it be done incrementally? (I guess the answer is no, we don't want this done 
in the kernel , we want it done right?)

Cheers,
Flo



