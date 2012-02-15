Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2BOPB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:01:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45132 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2BOPBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:01:25 -0500
Message-ID: <1329318063.2293.136.camel@twins>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Saravana Kannan <skannan@codeaurora.org>, Ingo Molnar <mingo@elte.hu>,
        linaro-kernel@lists.linaro.org, Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Oleg Nesterov <oleg@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Chan <mike@android.com>, Dave Jones <davej@redhat.com>,
        Todd Poynor <toddpoynor@google.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 15 Feb 2012 16:01:03 +0100
In-Reply-To: <20120215140245.GB27825@n2100.arm.linux.org.uk>
References: <20120208013959.GA24535@panacea>
	 <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com>
	 <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu>
	 <4F35DD3E.4020406@codeaurora.org> <20120211144530.GA497@elte.hu>
	 <4F3AEC4E.9000303@codeaurora.org> <1329313085.2293.106.camel@twins>
	 <20120215140245.GB27825@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 14:02 +0000, Russell King - ARM Linux wrote:

> There's a problem with that: SA11x0 platforms (for which cpufreq was
> _originally_ written for before it spouted all the policy stuff which
> Linus demanded) need to notify drivers when the CPU frequency changes so
> that drivers can readjust stuff to keep within the bounds of the hardware.
> 
> Unfortunately, there's embedded platforms out there where the CPU core
> clock is not just the CPU core clock, but also is the memory bus clock,
> PCMCIA clock, and some peripheral clocks.  All these peripherals need
> their timing registers rewritten when the CPU core clock changes.
> 
> Even more unfortunately, some of these peripherals can't be adjusted
> with the click of your fingers: you have to wait for them to finish
> what they're doing.  In the case of a LCD controller, that means the
> hardware must finish displaying the current frame before the LCD
> controller will shut down and let you change its registers.
> 
> We _could_ make it atomic, but in return we'd have to spin in the driver
> for maybe 20+ ms, during which time the system would not be able to do
> anything else, not even those threaded IRQs. 

Thing is, the scheduler doesn't care about completion, all it needs is
to be able to kick-start the thing atomically. So you really have to
wait for it or can you do an interrupt driven state machine?

Anyway, one possibility is to keep cpufreq in its current state and use
that for this 'interesting' class of hardware -- clearly its current
state is good enough for it. And transition all sane hardware over to a
new scheme.

Another possibility is we'll try and fudge something in the scheduler
that either wakes a special per-cpu thread or allow enqueueing work and
make this CONFIG_goo available to these platforms so as not to add to
fast-path overhead of others.

A third possibility is to self-IPI and take it from there.. assuming
these platforms can actually self-IPI.

>  That's on top of however
> long it takes for the CPU core clock PLL to re-lock at the requested
> frequency.  That might not be too bad if the CPU clock rate changes
> only occasionally, but if we're talking about doing that more often
> then I think there's something wrong with the cpufreq policy design.

I guess that all will depend on the hardware.. there'll still be some
sort of governor in between taking the per-cpu/task load-tracking data
and scheduler events and using that to compute some volt/freq setting.

>From what I've heard there's a number of different classes of hardware
out there, some like race to idle, some can power gate more than others
etc.. I'm not particularly bothered by those details, I'm sure there's
people who are.

All I really want is to consolidate all the various statistics we have
across cpufreq/cpuidle/sched and provide cpufreq with scheduler
callbacks because they've been telling me their current polling stuff
sucks rocks.

Also the current state of affairs is that the cpufreq stuff is trying to
guess what the scheduler is doing, and people are feeding that back into
the scheduler. This I need to stop from happening ;-)
