Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1EDOKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:10:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:41017 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab1EDOKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:10:50 -0400
Date: Wed, 4 May 2011 16:10:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <20110504132022.GA17294@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1105041539050.3005@ionos>
References: <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com> <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Tejun Heo wrote:
> Hello,
> 
> On Wed, May 04, 2011 at 03:00:37PM +0200, Thomas Gleixner wrote:
> > On Wed, 4 May 2011, Tejun Heo wrote:
> > > > > And that code runs with preemption enabled. So when the task gets
> > > > > preempted _BEFORE_ it has actuallty written back the data, then the
> > > > > race window is wide open.
> > > 
> > > Hmmm... if it's a race caused by preemtion enabled where it shouldn't
> > > be, it's most likely the wrong type of this_cpu_cmpxchg_double() being
> > > used in SLUB?  ie. __this_cpu_cmpxchg_double() where it should have
> > > been this_cpu_cmpxchg_double()?  Christoph?
> > 
> > No, the problem is that ELAN prevents the cmpxchg8b, but keeps
> > CONFIG_CMPXCHG_LOCAL=y which then results in the unprotected code for
> > the following reason:
> ...
> > So the question is whether CMPXCHG_LOCAL for x86 wants to depend on
> > X86_CMPXCHG64.
> > 
> > The other solution is to use irqsafe_cpu_cmpxchg_double() instead of
> > this_cpu_cmpxchg_double() in slub.c. 
> 
> I think this is the root cause.  CMPXCHG_LOCAL is an optimization
> flag, indicating that the processor provides fast local cmpxchg, it
> doesn't say anything about local synchronization properties and if the
> code required irq exclusion, it should have used
> irqsafe_cpu_cmpxchg_double() whether the processor supports it
> natively or not, so there's the bug.  Pekka, can you please change the
> offending cmpxchg_double() to irqsafe variant?

Patch below. Ingo, can you test that please ?

> As for CMPXCHG_LOCAL being set spuriously, maybe introduce
> CMPXCHG_DOUBLE_LOCAL?  I don't know.  It's pretty nasty to implement

Oh no, please not another CONFIG_WTF and more #ifdeffery.

> different high-level code paths depending on CPU features.  We can't
> even determine whether the feature will be actually available at
> compile time.  But, then again, it might incur noticeable slowdown for

Right, and the x86 implementation should not do 

#ifdef CONFIG_X86_CMPXCHG64
#define percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
#endif

And let the code fallback to the generic variant. It should have an
#else path using the the cmpxchg64_local() implementation which has
alternatives for runtime selection of cmpxchg8b or the cli protected
emulation.

> cases where the generic implementation is used.  Has anyone measured
> the difference against before the whole this_cpu conversion?

Yes, that really wants to be done. The whole CMPXCHG_LOCAL ifdeffery
should have been avoided in the first place. this_cpu_cmpxchg can
really be implemented with preempt_enable/disable and the irqsafe
variant in any case.

Thanks,

	tglx

--------->
Subject: slub-hmm.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 04 May 2011 15:38:19 +0200

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/percpu.h |    2 +-
 mm/slub.c              |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h
+++ linux-2.6/include/linux/percpu.h
@@ -948,7 +948,7 @@ do {									\
 	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
 # define irqsafe_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_int(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+	__pcpu_double_call_return_bool(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
 #endif
 
 #endif /* __LINUX_PERCPU_H */
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -1940,7 +1940,7 @@ redo:
 		 * Since this is without lock semantics the protection is only against
 		 * code executing on this cpu *not* from access by other cpus.
 		 */
-		if (unlikely(!this_cpu_cmpxchg_double(
+		if (unlikely(!irqsafe_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				object, tid,
 				get_freepointer(s, object), next_tid(tid)))) {
@@ -2145,7 +2145,7 @@ redo:
 		set_freepointer(s, object, c->freelist);
 
 #ifdef CONFIG_CMPXCHG_LOCAL
-		if (unlikely(!this_cpu_cmpxchg_double(
+		if (unlikely(!irqsafe_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				c->freelist, tid,
 				object, next_tid(tid)))) {
