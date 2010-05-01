Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab0EABgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 21:36:14 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57242 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab0EABgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 21:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F0ZQvvTMPvxwyisQnljql1hGyvrXcA2+pOfzvev3m/plcEgoBLCuev3BgdXKzloDlb
         gff7ygSAWmamrWhsfJyKL/GHGp4TvEdXpb5EJKHHqCfSn+NxQU1GFoef+eDyx6/LHTgY
         svd8N3honLuIHUkfB7vS+ekIY79ZLOpQNPkz8=
Date: Sat, 1 May 2010 03:36:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] hw-breakpoints: Change/Enforce some breakpoints
	policies
Message-ID: <20100501013611.GD5357@nowhere>
References: <1271999639-23605-1-git-send-regression-fweisbec@gmail.com> <1271999639-23605-4-git-send-regression-fweisbec@gmail.com> <20100423093234.GC11770@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423093234.GC11770@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 06:32:35PM +0900, Paul Mundt wrote:
> On Fri, Apr 23, 2010 at 07:13:56AM +0200, Frederic Weisbecker wrote:
> > diff --git a/arch/sh/kernel/hw_breakpoint.c b/arch/sh/kernel/hw_breakpoint.c
> > index 675eea7..2d44a2d 100644
> > --- a/arch/sh/kernel/hw_breakpoint.c
> > +++ b/arch/sh/kernel/hw_breakpoint.c
> > @@ -120,25 +120,16 @@ static int get_hbp_len(u16 hbp_len)
> >  }
> >  
> >  /*
> > - * Check for virtual address in user space.
> > - */
> > -int arch_check_va_in_userspace(unsigned long va, u16 hbp_len)
> > -{
> > -	unsigned int len;
> > -
> > -	len = get_hbp_len(hbp_len);
> > -
> > -	return (va <= TASK_SIZE - len);
> > -}
> > -
> > -/*
> >   * Check for virtual address in kernel space.
> >   */
> 
> We were also using the va_in_userspace check for the case of signal
> delivery, so I've just inverted the test for that. Perhaps there's a
> cleaner way to handle it, though.


That looks fine. I wonder if I can assume that such tests, that
are the same between x86 and Sh, can apply to every archs, in which
case I could move that to the generic code.


> 
> Other than that, everything seems to work ok. The ksym tracer and ptrace
> tests still pass at least. Feel free to add my Tested/Acked-by on the
> rest if you're respinning it at some point.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>


Great, I'll then merge this fix to the appropriate patch and
add the appropriate tags.

Thanks Paul!



> 
> ---
> 
> diff --git a/arch/sh/include/asm/hw_breakpoint.h b/arch/sh/include/asm/hw_breakpoint.h
> index 4d5e514..89890f6 100644
> --- a/arch/sh/include/asm/hw_breakpoint.h
> +++ b/arch/sh/include/asm/hw_breakpoint.h
> @@ -54,8 +54,6 @@ static inline int hw_breakpoint_slots(int type)
>  /* arch/sh/kernel/hw_breakpoint.c */
>  extern int arch_check_bp_in_kernelspace(struct perf_event *bp);
>  extern int arch_validate_hwbkpt_settings(struct perf_event *bp);
> -extern int arch_validate_hwbkpt_settings(struct perf_event *bp,
> -					 struct task_struct *tsk);
>  extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
>  					   unsigned long val, void *data);
>  
> diff --git a/arch/sh/kernel/hw_breakpoint.c b/arch/sh/kernel/hw_breakpoint.c
> index 67564e3..efae6ab 100644
> --- a/arch/sh/kernel/hw_breakpoint.c
> +++ b/arch/sh/kernel/hw_breakpoint.c
> @@ -344,8 +344,7 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
>  		perf_bp_event(bp, args->regs);
>  
>  		/* Deliver the signal to userspace */
> -		if (arch_check_va_in_userspace(bp->attr.bp_addr,
> -					       bp->attr.bp_len)) {
> +		if (!arch_check_bp_in_kernelspace(bp)) {
>  			siginfo_t info;
>  
>  			info.si_signo = args->signr;

