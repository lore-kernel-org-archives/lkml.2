Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919Ab1LPPX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:23:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50253 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763Ab1LPPXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:23:55 -0500
Date: Fri, 16 Dec 2011 15:23:34 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "frank.rowand@am.sony.com" <frank.rowand@am.sony.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] PREEMPT_RT_FULL: ARM context switch needs IRQs enabled
Message-ID: <20111216152334.GD6342@arm.com>
References: <4EEAB90D.3050504@am.sony.com>
 <1324029272.18942.73.camel@twins>
 <20111216111319.GB6342@arm.com>
 <20111216114320.GC6342@arm.com>
 <1324039793.18942.80.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324039793.18942.80.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 12:49:53PM +0000, Peter Zijlstra wrote:
> On Fri, 2011-12-16 at 11:43 +0000, Catalin Marinas wrote:
> > From 26d87e955f089fd246bee29bb388f22da1297e0c Mon Sep 17 00:00:00 2001
> > From: Catalin Marinas <catalin.marinas@arm.com>
> > Date: Fri, 16 Dec 2011 11:32:26 +0000
> > Subject: [PATCH] sched, mm: Use activate_mm() instead of switch_mm()
> > 
> > The ARM port tries to remove __ARCH_WANT_INTERRUPTS_ON_CTXSW. Since the
> > actual pgd switching requires interrupts to be enabled on ARM (for
> > latency on ARMv5 and earlier and IPIs on ARMv6+), the solution is to
> > defer the pgd switching to a post context switch hook that is run with
> > interrupts enabled. There are however two additional direct calls to
> > switch_mm() without the additional post-switch hook and ARM would fail
> > to set the new pgd.
> > 
> > This patch changes the switch_mm() call with activate_mm() which ensures
> > that the required pgd has been set. The activate_mm() function must be
> > called with interrupts enabled.
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > ---
> >  kernel/sched.c   |    2 +-
> >  mm/mmu_context.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 7b46a39..3976157 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -6310,7 +6310,7 @@ void idle_task_exit(void)
> >         BUG_ON(cpu_online(smp_processor_id()));
> >  
> >         if (mm != &init_mm)
> > -               switch_mm(mm, &init_mm, current);
> > +               activate_mm(mm, &init_mm);
> >         mmdrop(mm);
> >  }
> >  
> > diff --git a/mm/mmu_context.c b/mm/mmu_context.c
> > index cf332bc..4e44ac4 100644
> > --- a/mm/mmu_context.c
> > +++ b/mm/mmu_context.c
> > @@ -32,7 +32,7 @@ void use_mm(struct mm_struct *mm)
> >                 tsk->active_mm = mm;
> >         }
> >         tsk->mm = mm;
> > -       switch_mm(active_mm, mm, tsk);
> > +       activate_mm(active_mm, mm);
> >         task_unlock(tsk);
> >  
> >         if (active_mm != mm)
> > 
> 
> alpha, cris, microblaze, powerpc appear to actually use that task
> argument of switch_mm(), so I'm not convinced this is actually correct.

We use it on ARM as well but in both cases above the task was current.
However, I can see that the activate_mm() implementation on other
architectures doesn't just call switch_mm(current), so the two may not
be functionally equivalent.

An alternative would be to only defer the pgd switching on ARM if
irqs_disabled() and leave the generic code untouched (well, apart from
the post-switch hook).

-- 
Catalin
