Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1IFVpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 17:45:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:54629 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab1IFVpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 17:45:36 -0400
Date: Tue, 6 Sep 2011 23:45:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] clockevents: Use an atomic RCU notifier for
 clockevents
In-Reply-To: <20110906203338.GL7761@one.firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109062235530.2723@ionos>
References: <1314652136-11350-1-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109062120420.2723@ionos> <20110906203338.GL7761@one.firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Sep 2011, Andi Kleen wrote:

> On Tue, Sep 06, 2011 at 09:23:55PM +0200, Thomas Gleixner wrote:
> > On Mon, 29 Aug 2011, Andi Kleen wrote:
> > 
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Use an atomic_notifier instead of a raw_notifier for the clockevents
> > > notification.
> > > 
> > > This avoids a global lock in the idle path, is a scalability
> > > problem. With this patch we don't have a global lock anymore
> > > at least on systems with an always running timer.
> > 
> > And why is that code called on a system with an always running local
> > apic timer at all? The broadcast horror is explicitely only for those
> > systems with wreckaged hardware.
> 
> Because the notifier is before the check for always running local apic timer.

The idle code, at least the one in drivers/idle/intel_idle.c, does
_NOT_ call into that code at all when a reliable lapic timer is
available:

        if (!(lapic_timer_reliable_states & (1 << (cstate))))
	   clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);

....

	if (boot_cpu_has(X86_FEATURE_ARAT))     /* Always Reliable APIC Timer */
                lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;

Same applies for drivers/acpi/processor_idle.c

Though according to your changelog something is calling that
clockevents callchain despite of an ALWAYS RUNNING local apic
timer. That means:

Either you are using different code or your machine does not have that
ARAT flag set.

 - If your machine has the ARAT feature, then calling into the
   clockevents code is fcking wrong.

 - If your machine does NOT have the ARAT feature, then removing that
   lock is nice, but has ABSOLUTELY NOTHING TO DO WITH AN ALWAYS
   RUNNING TIMER.

> You also get bonus points for a incredible convoluted call chain,
> about 50% of it being unnecessary and full of scalability problems.

I gladly accept those bonus points for writing correct code, which was
never meant to be scalable on larger systems at all. Assuming that
HPET broadcasting is scalable in any way is just hilarious.

I'm sorry that I'm not able to return the favour of bonus points for
you. There are no bonus points for sloppy patches, sloppy changelogs
and ignorance vs. the problems at hand.

I'm reserving those bonus points for you once you come up with the
patches which remove those 50 percent unnecessary code along with the
scalability problems without breaking the world and some
more. According to your profound analysis above and the other perfect
patches (including the perfect changelogs) which I had the pleasure to
review today, this should be a trivial to solve problem for you.

Thanks,

	tglx
