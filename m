Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1ASUy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:54:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35161 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1ASUy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:54:28 -0500
Date: Wed, 19 Jan 2011 21:53:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: percpu related boot crash on x86 (was: Linux 2.6.38-rc1)
Message-ID: <20110119205353.GA14810@elte.hu>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119120200.GA1057@elte.hu>
 <1295441307.28776.15.camel@laptop>
 <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com>
 <20110119131329.GB14096@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119131329.GB14096@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Wed, Jan 19, 2011 at 02:56:23PM +0200, Pekka Enberg wrote:
> > Is vmalloc() and vfree() supposed to work with interrupts disabled? I
> > always thought they weren't which would mean something in
> > pcpu_mem_alloc() needs changing...
> 
> They aren't but percpu allocator doesn't call them with interrupts
> disabled normally.  It only happens during early boot before it's
> enabled for the first time but this is an allowed exception.  We'll
> probably need to update the WARN_ON to consider the rare call path.
> It also looks like something in that path is turning off/on IRQ
> instead of saving/restoring it, so that probably needs to be changed
> too but both aren't really critical.
> 
> I think the real problem is a lot of unsigned int percpu allocations
> added by 6c9ae009 (irq: use per_cpu kstat_irqs).  percpu allocator
> should be able to cope but it assumes that it would always be able to
> allocate contiguous allocation map using vmalloc and that might be
> failing, although I cannot readily see how or why that would happen
> frequently on a 64bit machine.

Btw., based on Peter's suggestion i tried the limit-bumping hack below - but it did 
not help, the crash still triggers on 5%-10% of all randconfig bootups.

Thanks,

	Ingo

>From e2c013d28c8fe81cd30976dcd3058cc86c6285d3 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 19 Jan 2011 20:15:20 +0100
Subject: [PATCH] <not for upstream> percpu: Increase allocation limits

Might solve the boot crashes ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3f93001..5cd9cf4 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -74,7 +74,7 @@
 #include <asm/io.h>
 
 #define PCPU_SLOT_BASE_SHIFT		5	/* 1-31 shares the same slot */
-#define PCPU_DFL_MAP_ALLOC		16	/* start a map with 16 ents */
+#define PCPU_DFL_MAP_ALLOC		64	/* start a map with 64 ents */
 
 #ifdef CONFIG_SMP
 /* default addr <-> pcpu_ptr mapping, override in asm/percpu.h if necessary */
