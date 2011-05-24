Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab1EXEGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:06:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35934 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab1EXEGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:06:40 -0400
Date: Tue, 24 May 2011 06:06:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110524040624.GA1638@elte.hu>
References: <20110516153527.GC21107@elte.hu>
 <1305852966.3005.19.camel@dan>
 <20110520120750.GJ14745@elte.hu>
 <1305896093.3005.24.camel@dan>
 <20110520131108.GA17699@elte.hu>
 <1306089922.1806.27.camel@dan>
 <BANLkTik1SK_kWVvGsKk0SqdByQ5-0b5nFg@mail.gmail.com>
 <1306110336.25049.7.camel@dan>
 <20110523104902.GB24674@elte.hu>
 <6733.1306202368@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6733.1306202368@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Mon, 23 May 2011 12:49:02 +0200, Ingo Molnar said:
> > Well, since entropy does not get reduced on addition of independent variables 
> > the right sequence is (pseudocode):
> >
> > 	rnd  = entropy_cycles();
> > 	rnd += entropy_rdrand();
> > 	rnd += entropy_RTC();
> > 	rnd += entropy_system();
> 
> I'm having trouble convincing myself that RTC and cycles are truly independent
> variables.... ;)

Generally the RTC stores absolute time in seconds (it stores the date), while 
cycles start new when the CPU is reset.

So they are independent.

The question i think you are asking is whether the fact that we can observe 
current values of them after bootup can be used to figure out their value:

> Consider the case of a fixed-frequency CPU - if you know the time since boot, 
> and the current RTC, and the current cycle count, you can work backwards to 
> find the RTC and cycle count at boot. [...]

Yes, you are correct, if you are local then the guessing the RTC to the second 
is probably possible.

Guessing the cycle counter's value will be hard: see the natural noise it has 
at a fixed instruction after bootup in the same-bzImage test i performed - with 
no IRQs having executed at all yet ...

The RTC is still reasonably noisy to external attackers though.

> [...] I'm not sure that a variable clockspeed helps all that much - an 
> attacker can perhaps find a way to force the highest/ lowest CPU speed - or 
> the system may even helpfully do it for the attacker - I've seen plenty of 
> misconfigured laptops that force lowest supported CPU clockspeed on battery 
> rather than race-to-idle.

The tests i performed were on a fixed frequency system - the cycle counter was 
still largely random during early bootup.

Others should try it too - i've attached a simple patch. Maybe my system has 
more bootup noise than others.

> Having said that, the 13 bootup rdtsc values you list *seem* to have on the 
> order of 24-28 bits of entropy, and only the lowest-order bit seems to be 
> non-random (the low-order byte of the 13 values are 28, b6, 44, 54, dc, 78, 
> 2c, 38, 02, 58, 76, 16, and be).  So rdtsc appears to be good enough for what 
> we want here...

Yeah. And for cases that the rdtsc might be predictable for some weird reason 
(say it would be 0 on an old system with no RDTSC), the RTC would give some 
minimal fallback seed to make the canary at least not remotely guessable.

Thanks,

	Ingo

---
 init/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/init/main.c
===================================================================
--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -472,6 +472,12 @@ asmlinkage void __init start_kernel(void
 	 */
 	boot_init_stack_canary();
 
+	{
+		u64 cycles = get_cycles();
+
+		printk("RDTSC: %Ld / %08Lx\n", cycles, cycles);
+	}
+
 	cgroup_init_early();
 
 	local_irq_disable();
