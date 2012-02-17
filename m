Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2BQJA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:00:59 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:54821 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751771Ab2BQJA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:00:56 -0500
Date: Fri, 17 Feb 2012 10:00:22 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20120217090022.GA24856@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Saravana Kannan <skannan@codeaurora.org>,
	Ingo Molnar <mingo@elte.hu>, linaro-kernel@lists.linaro.org,
	Nicolas Pitre <nico@fluxnic.net>,
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
References: <1328670355.2482.68.camel@laptop>
 <20120208202314.GA28290@redhat.com>
 <1328736834.2903.33.camel@pasglop>
 <20120209075106.GB18387@elte.hu>
 <4F35DD3E.4020406@codeaurora.org>
 <20120211144530.GA497@elte.hu>
 <4F3AEC4E.9000303@codeaurora.org>
 <1329313085.2293.106.camel@twins>
 <20120215140245.GB27825@n2100.arm.linux.org.uk>
 <1329318063.2293.136.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329318063.2293.136.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> 
> Anyway, one possibility is to keep cpufreq in its current state and use
> that for this 'interesting' class of hardware -- clearly its current
> state is good enough for it. And transition all sane hardware over to a
> new scheme.
> 
> Another possibility is we'll try and fudge something in the scheduler
> that either wakes a special per-cpu thread or allow enqueueing work and
> make this CONFIG_goo available to these platforms so as not to add to
> fast-path overhead of others.

Well, we can actually have both: Adding a new cpufreq governor "scheduler"
is easy. The scheduler stores the target frequency (in per-cent or
per-mille) in (per-cpu) data available to this governor, and kick a
(per-cpu?) thread which then handels the rest -- by existing cpufreq means.
The cpufreq part is easy, the sched part less so (I think).

Of course, this is still slower than manipulating some MSRs in sched.c
directly. However, we could make use of the existing infrastructure, and not
worry about whether things need to schedule, need to busy-loop etc, whether
we have thermal implications which mean that some frequences are not
available etc.

Best,
	Dominik
