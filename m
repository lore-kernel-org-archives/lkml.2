Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab2K3JWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:22:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:48351 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2K3JWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:22:21 -0500
Date: Fri, 30 Nov 2012 10:22:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frank Rowand <frank.rowand@am.sony.com>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        grant.likely@secretlab.ca
Subject: Re: 3.6.7-rt18 ARM BUG_ON() at kernel/sched/core.c:3817
In-Reply-To: <50B6D71E.30003@am.sony.com>
Message-ID: <alpine.LFD.2.02.1211301021550.2701@ionos>
References: <50B6D71E.30003@am.sony.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Nov 2012, Frank Rowand wrote:

> 3.6.7-rt18:  kernel BUG at .../kernel/sched/core.c:3817!
> 
> Grant reported this same problem for 3.6.5-rt15.
> 
> I am seeing it on a different arm board.
> 
> Here is the BUG_ON():
> 
>    asmlinkage void __sched preempt_schedule_irq(void)
>    {
>         struct thread_info *ti = current_thread_info();
> 
>         /* Catch callers which need to be fixed */
>         BUG_ON(ti->preempt_count || !irqs_disabled());
> 
> Putting in some extra printk(), the BUG_ON() is triggering because
> ti->preempt_count is non-zero.
> 
> 
> It appears that the cause is in arch/arm/kernel/entry-armv.S.
> 
> The call to preempt_schedule_irq() is from svc_preempt:
> 
>    #ifdef CONFIG_PREEMPT
>    svc_preempt:
>            mov     r8, lr
>    1:      bl      preempt_schedule_irq            @ irq en/disable is done inside
> 
> 
> svc_preempt is branched to from one of two possible places.  The first was
> present before the lazy preempt code was added.  The first appears ok to me.
> (Note that the first branch does not occur if preempt count is non-zero.)
> 
> The second branch can occur even if the preempt count is non-zero (which is
> what the BUG_ON() is finding):
> 
>    __irq_svc:
>            svc_entry
>            irq_handler
> 
>    #ifdef CONFIG_PREEMPT
>            get_thread_info tsk
>            ldr     r8, [tsk, #TI_PREEMPT]          @ get preempt count
>            ldr     r0, [tsk, #TI_FLAGS]            @ get flags
>            teq     r8, #0                          @ if preempt count != 0
>            movne   r0, #0                          @ force flags to 0
>            tst     r0, #_TIF_NEED_RESCHED
>            blne    svc_preempt
>            ldr     r8, [tsk, #TI_PREEMPT_LAZY]     @ get preempt lazy count
>            ldr     r0, [tsk, #TI_FLAGS]            @ get flags
>            teq     r8, #0                          @ if preempt lazy count != 0
>            movne   r0, #0                          @ force flags to 0
>            tst     r0, #_TIF_NEED_RESCHED_LAZY
>            blne    svc_preempt
>    #endif

Bah. I knew that I had messed up the ASM magic.
