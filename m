Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0G2X0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:26:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:32908 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab0G2X0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:26:01 -0400
Subject: Re: [RFC][PATCH 1/2] Remove stop_machine from change_clocksource
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <1280444895.2829.164.camel@localhost.localdomain>
References: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
	 <20100728091733.56004b06@mschwide.boeblingen.de.ibm.com>
	 <1280333569.1848.34.camel@work-vm>
	 <20100729091125.6e25368e@mschwide.boeblingen.de.ibm.com>
	 <1280436547.2829.72.camel@localhost.localdomain>
	 <1280444895.2829.164.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 16:25:37 -0700
Message-ID: <1280445937.2829.172.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 16:08 -0700, john stultz wrote:
> On Thu, 2010-07-29 at 13:49 -0700, john stultz wrote:
> > On Thu, 2010-07-29 at 09:11 +0200, Martin Schwidefsky wrote:
> > > What about a clocksource_unregister while a cpu is in the middle of a
> > > read_seqbegin/timekeeping_get_ns/read_seqretry? The clocksource structure
> > > is "free" after the successful call to the unregister. At least in theory
> > > this could be a use after free. The race window is tiny but on virtual
> > > systems there can be an arbitrary delay in the ktime_get sequence.
> >
> > So yes, unregister has been contentious in the past for this very
> > reason. Once registered, its really hard to find a safe point when it
> > can be un-registered. Stop machine mostly solves this (although one
> > should note: vsyscall enabled clocksources really can't be freed, as
> > their vread() page needs to be statically mapped into userspace).
> > 
> > So while stop_machine is a solution here, it would make more sense to me
> > to use stop_machine (or maybe even a different method, as it sort of
> > screams RCU to me) to make sure all the cpus are out of the xtime_lock
> > critical section prior to returning from unregister_clocksource, rather
> > then stopping everything for the clocksource change.
> 
> 
> Below is a rough patch to use stop_machine to get the same level of race
> protection for clocksource_unregister as we have currently in Linus's
> tree (which may possibly have holes in it?).
> 
> Comments or suggestions for other ideas would be appreciated.
> 
> I'm thinking RCU might be really close to what we actually want here,
> but I'd like to be able to avoid any extra work on the read-side (ie:
> even the preempt_disable()), and would even be more prone to disallowing
> clocksource unregistration then impacting the xtime_lock read side.
> 
> 
> Any other thoughts?

Actually, the more I think about it.. The more I really just think we
should kill clocksource_unregister and simply not allow it.

Part of the reason is that we have other issues lurking under here, such
as: "what do we do if someone unregisters the only HRT capable
clocksource? As there's currently no way to fall back from HRT mode to
non HRT mode."

It just adds a ton of complexity and issues for really zero gain. The
only reasonable use-case I can come up with is having a clocksource
loaded via a module, and then wanting to unload it.

So while loading clocksources as a module is a nice feature that could
save folks in a pinch (think old distro kernels needing a clock fix on
new hardware), unregister and removal really doesn't have much
functional use. Its just only nice an symmetrical.

So unless anyone else objects, I'm prone to kill off unregister (and
change the single user's error-handling path to delay registration until
the hardware is known to be good).

Any counter points?

thanks
-john

