Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1A3Qip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 11:38:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1A3Qio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 11:38:44 -0500
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused
 by pm_idle
From: Peter Zijlstra <peterz@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTikagMAGssG09D+SCKTsu9T+==R2fsSM3tgHctdv@mail.gmail.com>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	 <1295894492.28776.470.camel@laptop>
	 <AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
	 <1295946736.28776.479.camel@laptop>
	 <AANLkTikQs1UcfBGf_6shNVtdDSzR+8XzUKcx0amFZXey@mail.gmail.com>
	 <1296210619.15234.263.camel@laptop>
	 <AANLkTikagMAGssG09D+SCKTsu9T+==R2fsSM3tgHctdv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 30 Jan 2011 17:36:06 +0100
Message-ID: <1296405366.2274.60.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-29 at 13:44 +0800, Luming Yu wrote:
> On Fri, Jan 28, 2011 at 6:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> We have seen an extremely slow system under the CPU-OFFLINE-ONLIE test
> >> on a 4-sockets NHM-EX system.
> >
> > Slow is OK, cpu-hotplug isn't performance critical by any means.
> 
> Here is one example that the "slow" is not acceptable. Maybe I should
> not use "slow" in the first place. It happnes after I resolved a
> similar NMI watchdog warnning in calibrate_delay_direct..
> 
> Please note, I got the BUG in a 2.6.32-based kernel. Upstream  behaves
> similar I guess.

Guessing is totally the wrong thing when you're sending stuff upstream,
esp ugly patches such as this. .32 is more than a year old, anything
could have happened.

> BUG: soft lockup - CPU#63 stuck for 61s! [migration/63:256]

> > If its slow but working, the test is broken, I don't see a reason to do
> > anything to the kernel, let alone the below.
> 
> It not working sometimes, so I think it's not a solid feature right now.

But you didn't say anything about not working, you merely said slow. If
its not working, you need to very carefully explain what is not working,
where its deadlocked and how your patch solves this and how you avoid
wrecking stuff for everybody else.

> >>  since it currently unnecessarily implicitly interact with
> >> CPU power management.
> >
> > daft statement at best, because if not for some misguided power
> > management purpose, what are you actually unplugging cpus for?
> > (misguided because unplug doesn't actually safe more power than simply
> > idling the cpu).
> It's a RAS feature and Suspend Resume also hits same code path I think.

That still doesn't say anything, also who in his right mind suspends a
nhm-ex system?

> > So you flip the pm_idle pointer protected unter hotplug mutex, but
> > that's not serialized against module loading, so what happens if you
> > concurrently load a module that sets another idle policy?
> >
> > Your changelog is vague at best, so what exactly is the purpose here? We
> > flip to default_idle(), which uses HLT, which is C1. Then you run
> > cpu_idle_wait(), which will IPI all cpus, all these CPUs (except one)
> > could have been in deep C states (C3+) so you get your slow wakeup
> > anyway.
> >
> > There-after you do the normal stop-machine hot-plug dance, which again
> > will IPI all cpus once, then you flip it back to the saved pm_idle
> > handler and again IPI all cpus.
> 
> https://lkml.org/lkml/2009/6/29/60
> it needs 50-100us latency to send one IPI, you could get an idea on a
> large NHM-EX system which contains 64 logical processors. With
> Tickless and APIC timer stopped in C3 on NHM-EX, you could also have
> an idea about the problem I have.

Ok, so one IPI costs 50-100 us, even with 64 cpu, that's at most 6.4ms
nowhere near enough to trigger the NMI watchdog. So what does go wrong?

Why does your patch solve things, like said, it doesn't avoid the slow
IPI at all, you still IPI each cpu right after changing the pm_idle
function. Those IPIs will still hit C3+ states.

> Let me know if there are still questions .

Yeah, what are you smoking? Why do you wreck perfectly fine code for one
backward ass piece of hardware.


