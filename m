Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2ETCBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:01:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12944 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab2ETCBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:01:50 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=EjmRXsF7va4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=Fa28DSThtZBP2gPdt18A:9 a=Sp8DGfp2UTYGkJo8mOMA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337479307.32434.16.camel@gandalf.stny.rr.com>
Subject: [PATCH] pidmap: Use GFP_ATOMIC to allocate page (was: Re: [ 00/54]
 3.0.32-stable review)
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <peterz@infradead.org>
Date: Sat, 19 May 2012 22:01:47 -0400
In-Reply-To: <20120519042038.GB11939@kroah.com>
References: <20120518212656.GA4992@kroah.com>
	 <20120519010105.GB18264@home.goodmis.org>
	 <20120519042038.GB11939@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 21:20 -0700, Greg KH wrote:

> > Well, I set up a box to run ktest randconfigs and some other checks.
> > Right now it's running on the 3.2.18-rc release. If I can sneak away
> > from the misses, I may be able to kick off tests against these releases
> > too. But I only have one box dedicated for this, so everything needs to
> > be processed serially.
> 
> No rush, do it on Monday if needed.  Thanks for testing, I appreciate
> it.

Ran 18 tests against 3.0.32-rc, 2 failed (16 passed!). One failed by a
lock up (still looking into it) and the other is this one:

Calibrating delay loop (skipped), value calculated using timer frequency.. 4799.59 BogoMIPS (lpj=2399799)
pid_max: default: 32768 minimum: 301
BUG: scheduling while atomic: swapper/0/0x10000002
Modules linked in:
Pid: 0, comm: swapper Not tainted 3.1.0-rc9-test+ #1
Call Trace:
 [<ffffffff81435b3e>] __schedule_bug+0x57/0x5b
 [<ffffffff8143c44f>] __schedule+0x90/0x672
 [<ffffffff810636dd>] ? kzalloc.constprop.2+0x24/0x26
 [<ffffffff810460d1>] __cond_resched+0x23/0x2f
 [<ffffffff8143ca83>] _cond_resched+0x14/0x1d^M
 [<ffffffff810f7cd3>] slab_pre_alloc_hook.isra.52+0x28/0x2c
 [<ffffffff810f8b1a>] kmem_cache_alloc_trace+0x29/0xbd
 [<ffffffff810636dd>] kzalloc.constprop.2+0x24/0x26
 [<ffffffff81b7a434>] pidmap_init+0x81/0xc0
 [<ffffffff81b61b03>] start_kernel+0x330/0x3c2
 [<ffffffff81b612c4>] x86_64_start_reservations+0xaf/0xb3
 [<ffffffff81b61140>] ? early_idt_handlers+0x140/0x140
 [<ffffffff81b613ca>] x86_64_start_kernel+0x102/0x111
Security Framework initialized

Had CONFIG_SLUB, IRQ_FORCED_THREADING and voluntary preempt enabled.
Seems the might_resched() check from might_sleep_if() in
pre_alloc_hook() caused a schedule in early boot (pidmap_init). Not sure
why it scheduled that early, perhaps a threaded interrupt was added? I
haven't been able to reproduce it again.

Perhaps we should not be using GFP_KERNEL when allocating memory for
pidmap_init()? As we have preemption disabled at this point, we should
be using GFP_ATOMIC. Also add a BUG_ON if the page fails to get
allocated.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

This patch is against 3.4-rc2 (just happened to be a kernel checkout I
had).

diff --git a/kernel/pid.c b/kernel/pid.c
index 9f08dfa..32dab20 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -563,7 +563,9 @@ void __init pidmap_init(void)
 				PIDS_PER_CPU_MIN * num_possible_cpus());
 	pr_info("pid_max: default: %u minimum: %u\n", pid_max, pid_max_min);
 
-	init_pid_ns.pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	/* Preemption is still disabled at this point */
+	init_pid_ns.pidmap[0].page = kzalloc(PAGE_SIZE, GFP_ATOMIC);
+	BUG_ON(!init_pid_ns.pidmap[0].page);
 	/* Reserve PID 0. We never call free_pidmap(0) */
 	set_bit(0, init_pid_ns.pidmap[0].page);
 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);


