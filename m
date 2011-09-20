Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1ITP7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:59:35 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:20429 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750772Ab1ITP7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:59:34 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: DbKvzh8VM1ndc.gwpY1puvdlikS34.OD6IY8KXda4Ar35x6
 L7pRXs9XDU.U3uKNfaMfag9UtgUcRnoYUjTqvCtyBgMfYYu90oRhIHaX6GhQ
 t_smj899BFhe7z2Wv5noN4kD5BjSI_Sljlwyw.9sjaC7n3vuLA8wb_XXBHFq
 qriBc0yrDSBZADEr..yIctNupNsOGkfe.pdlXYjQngnzIv0I2rMpGlb4_HHt
 FSkdxzkgIpTqYfQvrupAKLng2cJVWC._yS.SEyddzMnTmZ22PxIeouJnR7fH
 0UyylJPnqFwMpWJ132YkdoJoq64MdLtZmre7XxGa3ODdNsCVIaHAxKvns0F.
 4Lrm6.g.3PMeFN7Qe2SZZCKoTlMWY9VvFOBIkv6L3OEumjqc-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 10:59:29 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: <1316531505.29966.57.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1109201055470.8056@router.home>
References: <20110919212040.745370781@goodmis.org>  <20110919212640.688732950@goodmis.org>  <alpine.DEB.2.00.1109191657150.19059@router.home>  <alpine.LFD.2.02.1109201334590.2723@ionos>  <alpine.DEB.2.00.1109200947100.8056@router.home>
 <1316531505.29966.57.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Steven Rostedt wrote:

> On Tue, 2011-09-20 at 09:51 -0500, Christoph Lameter wrote:
>
> > I see that __this_cpu_xx operations may not work as intended in
> > preemptable contexts and there we could have more changes.
>
> Then why do you use it in slub.c?
>
> in mm/slab.c slab_alloc():
>
> redo:
>
> 	/*
> 	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
> 	 * enabled. We may switch back and forth between cpus while
> 	 * reading from one cpu area. That does not matter as long
> 	 * as we end up on the original cpu again when doing the cmpxchg.
> 	 */
> 	c = __this_cpu_ptr(s->cpu_slab);
>
> The __this_cpu_*() is in preempt enabled location. In fact, the three
> this_cpu_write()'s in acquire_slab() is done within a spinlock and thus
> with preemption disabled.

So the this_cpu_writes could become __this_cpu_writes

The __this_cpu_ptr operation in slab_alloc is special. We explicitly do
address calculation and do not care from which per cpu area we fetch
multiple per cpu data items because we can verify that we are on the same
per cpu area during the this_cpu_cmpxchg_double operation.

> The point is, people get it wrong all the time. In fact, we should
> really require that ALL USES of this_cpu_*() must be with preemption
> disabled. Regardless. Because anytime you touch a per cpu variable,

NO!! This defeats the whole purpose of this_cpu_ops and make the whole
scheme utterly useless.

> Monkeying around with per cpu data is tricky. If you start doing it in
> preempt enabled code, you are most certainly about to get it wrong. Why
> have this super optimization. A preempt_disable() is a single operation
> that touches cache hot data.

There are trivial cases like counter increments that are not a problem at
all. Most use cases are those. More complex ones can be developed to avoid
various overhead in performance critical sections of the kernel.


