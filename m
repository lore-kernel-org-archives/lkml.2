Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab0FYKjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 06:39:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:46299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab0FYKjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 06:39:43 -0400
Subject: Re: [RFC][PATCH] irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100624123804.GK578@basil.fritz.box>
References: <20100624105254.GB578@basil.fritz.box>
	 <1277377121.1875.948.camel@laptop> <20100624110830.GC578@basil.fritz.box>
	 <1277377852.1875.950.camel@laptop> <20100624112040.GD578@basil.fritz.box>
	 <1277379204.1875.957.camel@laptop> <20100624115520.GF578@basil.fritz.box>
	 <1277380649.1875.962.camel@laptop> <20100624120226.GH578@basil.fritz.box>
	 <1277381887.1875.966.camel@laptop>  <20100624123804.GK578@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Jun 2010 12:38:51 +0200
Message-ID: <1277462331.32034.221.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 14:38 +0200, Andi Kleen wrote:
>  The sleepable 
> soft irq would have avoided that (that's not a show stopper) 

I'm still not convinced sleepable softirq is a workable thing.

Softirqs:
  A) are non-preemptible
  B) are per-cpu because of A
  C) can be ran from ksoftirqd context
  D) generic kernel infrastructure with identical semantics on all archs

If you were to make something like a sleepable softirq, you'd loose A
(per definition), B (sleepable implies migratable to cpus_allowed) and
possibly D (unless you want to touch all architectures).

Now from your 'requirements':

> I have one case that needs to sleep (but only when interrupting user code)

> TIF works for user space, but it's a bit ugly because it requires adding
> more data to the task_struct because CPUs can change.

Which I read as:

 1) needs to run in the task context of the task that got 'interrupted'
 2) needs to stay on the cpu it got interrupted on.

So C is out of the window too, at which point there's nothing resembling
softirqs left.

To boot, x86_64 runs softirqs from the hardirq stack:

/* Call softirq on interrupt stack. Interrupts are off. */
ENTRY(call_softirq)
        CFI_STARTPROC
        push %rbp
        CFI_ADJUST_CFA_OFFSET   8
        CFI_REL_OFFSET rbp,0
        mov  %rsp,%rbp
        CFI_DEF_CFA_REGISTER rbp
        incl PER_CPU_VAR(irq_count)
        cmove PER_CPU_VAR(irq_stack_ptr),%rsp
        push  %rbp                      # backlink for old unwinder
        call __do_softirq
        leaveq
        CFI_DEF_CFA_REGISTER    rsp
        CFI_ADJUST_CFA_OFFSET   -8
        decl PER_CPU_VAR(irq_count)
        ret 
        CFI_ENDPROC
END(call_softirq) 

Also, -rt has something that could be considered sleepable softirqs,
although we call them preemptible softirqs. It runs all softirqs from
cpu bound kthreads, which again doesn't match your requirements.

So no, I don't think your idea of sleepable softirqs is sound.

