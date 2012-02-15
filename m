Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab2BOODk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:03:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36022 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122Ab2BOODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:03:39 -0500
Date: Wed, 15 Feb 2012 14:02:45 +0000
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
Message-ID: <20120215140245.GB27825@n2100.arm.linux.org.uk>
References: <20120208013959.GA24535@panacea> <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com> <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu> <4F35DD3E.4020406@codeaurora.org> <20120211144530.GA497@elte.hu> <4F3AEC4E.9000303@codeaurora.org> <1329313085.2293.106.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329313085.2293.106.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 02:38:05PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-02-14 at 15:20 -0800, Saravana Kannan wrote:
> > On 02/11/2012 06:45 AM, Ingo Molnar wrote:
> > >
> > > * Saravana Kannan<skannan@codeaurora.org>  wrote:
> > >
> > >> When you say accommodate all hardware, does it mean we will
> > >> keep around CPUfreq and allow attempts at improving it? Or we
> > >> will completely move to scheduler based CPU freq scaling, but
> > >> won't try to force atomicity? Say, may be queue up a
> > >> notification to a CPU driver to scale up the frequency as soon
> > >> as it can?
> > >
> > > I don't think we should (or even could) force atomicity - we
> > > adapt to whatever the hardware can do.
> > 
> > May be I misread the emails from Peter and you, but it sounded like the 
> > idea being proposed was to directly do a freq change from the scheduler. 
> > That would force the freq change API to be atomic (if it can be 
> > implemented is another issue). That's what I was referring to when I 
> > loosely used the terms "force atomicity".
> 
> Right, so we all agree cpufreq wants scheduler notifications because
> polling sucks. The result is indeed you get to do cpufreq from atomic
> context, because scheduling from the scheduler is 'interesting'.

There's a problem with that: SA11x0 platforms (for which cpufreq was
_originally_ written for before it spouted all the policy stuff which
Linus demanded) need to notify drivers when the CPU frequency changes so
that drivers can readjust stuff to keep within the bounds of the hardware.

Unfortunately, there's embedded platforms out there where the CPU core
clock is not just the CPU core clock, but also is the memory bus clock,
PCMCIA clock, and some peripheral clocks.  All these peripherals need
their timing registers rewritten when the CPU core clock changes.

Even more unfortunately, some of these peripherals can't be adjusted
with the click of your fingers: you have to wait for them to finish
what they're doing.  In the case of a LCD controller, that means the
hardware must finish displaying the current frame before the LCD
controller will shut down and let you change its registers.

We _could_ make it atomic, but in return we'd have to spin in the driver
for maybe 20+ ms, during which time the system would not be able to do
anything else, not even those threaded IRQs.  That's on top of however
long it takes for the CPU core clock PLL to re-lock at the requested
frequency.  That might not be too bad if the CPU clock rate changes
only occasionally, but if we're talking about doing that more often
then I think there's something wrong with the cpufreq policy design.
