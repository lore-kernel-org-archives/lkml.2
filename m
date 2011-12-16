Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824Ab1LPVhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 16:37:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55031 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760653Ab1LPVg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 16:36:59 -0500
Date: Fri, 16 Dec 2011 21:36:34 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH] PREEMPT_RT_FULL: ARM context switch needs IRQs enabled
Message-ID: <20111216213634.GA25241@arm.com>
References: <4EEAB90D.3050504@am.sony.com>
 <4EEBB07D.2070905@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEBB07D.2070905@am.sony.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 08:56:29PM +0000, frank.rowand@am.sony.com wrote:
> On 12/15/11 19:20, Frank Rowand wrote:
> > ARMv6 and later have VIPT caches and the TLBs are tagged with an ASID
> > (application specific ID). The number of ASIDs is limited to 256 and
> > the allocation algorithm requires IPIs when all the ASIDs have been
> > used.  The IPIs require interrupts enabled during context switch for
> > deadlock avoidance.
> > 
> > The RT patch mm-protect-activate-switch-mm.patch disables irqs around
> > activate_mm() and switch_mm(), which are the portion of the ARMv6
> > context switch that require interrupts enabled.
> > 
> > The solution for the ARMv6 processors could be to _not_ disable irqs.
> > A more conservative solution is to provide the same environment that
> > the scheduler provides, that is preempt_disable().  This is more
> > resilient for possible future changes to the ARM context switch code
> > that is not aware of the RT patches.
> > 
> > This patch will conflict slightly with Catalin's patch set to remove
> > __ARCH_WANT_INTERRUPTS_ON_CTXSW, when that is accepted:
> > 
> >    http://lkml.indiana.edu/hypermail/linux/kernel/1111.3/01893.html
> > 
> > When Catalin's patch set is accepted, this RT patch will need to reverse
> > the change in patch 6 to arch/arm/include/asm/system.h:
> > 
> >    -#ifndef CONFIG_CPU_HAS_ASID
> >    -#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
> >    -#endif
> > 
> > Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
> > 
> > ---
> >  fs/exec.c        |    8 	8 +	0 -	0 !
> >  mm/mmu_context.c |    8 	8 +	0 -	0 !
> >  2 files changed, 16 insertions(+)
> > 
> > Index: b/fs/exec.c
> > ===================================================================
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -837,12 +837,20 @@ static int exec_mmap(struct mm_struct *m
> >  		}
> >  	}
> >  	task_lock(tsk);
> > +#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> 
> Self critique...  I really, really dislike this ifdef because it will
> fail silently if the includes are changed and as a result the include file that
> defines __ARCH_WANT_INTERRUPTS_ON_CTXSW (arch/arm/include/asm/system.h) is not
> included.
> 
> Does anyone have any brilliant ideas for an alternative approach?

What I don't like is reintroducing __ARCH_WANT_INTERRUPTS_ON_CTXSW as we
try to get rid of it. Can the -rt code not be modified to call
switch_mm() with interrupts enabled? The non-rt code seems to do this
anyway.

BTW, I pushed to fixups to the ctxsw changes for ARM:

http://git.kernel.org/?p=linux/kernel/git/cmarinas/linux.git;a=shortlog;h=refs/heads/intr-ctxsw

to cope with switch_mm() being called directly with interrupts enabled,
in which case it won't defer the pgd switch. I think I can improve them
a bit but it needs to wait until Monday (busy with Christmas shopping
this weekend).

-- 
Catalin
