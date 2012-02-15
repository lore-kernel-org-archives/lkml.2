Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2BOQBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:01:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45989 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2BOQBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:01:35 -0500
Date: Wed, 15 Feb 2012 16:00:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
Message-ID: <20120215160028.GD27825@n2100.arm.linux.org.uk>
References: <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com> <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu> <4F35DD3E.4020406@codeaurora.org> <20120211144530.GA497@elte.hu> <4F3AEC4E.9000303@codeaurora.org> <1329313085.2293.106.camel@twins> <20120215140245.GB27825@n2100.arm.linux.org.uk> <1329318063.2293.136.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329318063.2293.136.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 04:01:03PM +0100, Peter Zijlstra wrote:
> On Wed, 2012-02-15 at 14:02 +0000, Russell King - ARM Linux wrote:
> 
> > There's a problem with that: SA11x0 platforms (for which cpufreq was
> > _originally_ written for before it spouted all the policy stuff which
> > Linus demanded) need to notify drivers when the CPU frequency changes so
> > that drivers can readjust stuff to keep within the bounds of the hardware.
> > 
> > Unfortunately, there's embedded platforms out there where the CPU core
> > clock is not just the CPU core clock, but also is the memory bus clock,
> > PCMCIA clock, and some peripheral clocks.  All these peripherals need
> > their timing registers rewritten when the CPU core clock changes.
> > 
> > Even more unfortunately, some of these peripherals can't be adjusted
> > with the click of your fingers: you have to wait for them to finish
> > what they're doing.  In the case of a LCD controller, that means the
> > hardware must finish displaying the current frame before the LCD
> > controller will shut down and let you change its registers.
> > 
> > We _could_ make it atomic, but in return we'd have to spin in the driver
> > for maybe 20+ ms, during which time the system would not be able to do
> > anything else, not even those threaded IRQs. 
> 
> Thing is, the scheduler doesn't care about completion, all it needs is
> to be able to kick-start the thing atomically. So you really have to
> wait for it or can you do an interrupt driven state machine?

Well, in the case I'm most familiar with, the sequence is this:

1. Receive request to change frequency
2. Shut down LCD controller and wait for it to stop (can take 20ms)
3. Check new frequency wrt old frequency, reprogram timings for PCMCIA
   if moving to a faster clock rate
4. Simultaneously program new frequency and SDRAM clocking
5. Recheck new frequency wrt old frequency, reprogram things for PCMCIA
   if moving to a slower clock rate
6. Reconfigure LCD controller

Now, the problem is that this sequence is spread across multiple drivers,
and today is handled by a notifier, which can sleep in the case of the
LCD controller waiting for the shutdown to complete.

> A third possibility is to self-IPI and take it from there.. assuming
> these platforms can actually self-IPI.

Even if there was an IPI (not talking about SMP anyway) I'm not sure
what good it would be.  We can (and do) get an IRQ from the LCD
controller when its shutdown is complete, but that would have to be
somehow propagated back up to the cpufreq code.  And the cpufreq code
would have to know that the LCD controller was alive and therefore had
to be waited for.  All sounds rather yucky to me.
