Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1GZPvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:51:39 -0400
Received: from smtp.citrix.com ([66.165.176.89]:32777 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab1GZPve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:51:34 -0400
X-IronPort-AV: E=Sophos;i="4.67,270,1309752000"; 
   d="scan'208";a="15265701"
Subject: Re: [PATCH 0/3] minor cleanups to EFLAGS initialisation in
 ret_from_fork
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1311691594.24752.40.camel@twins>
References: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
	 <20110725101902.GP4362@sun> <20110725182049.GD27137@sun>
	 <4E2DDBAA.60200@zytor.com>  <20110725214731.GE27137@sun>
	 <1311691594.24752.40.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 26 Jul 2011 16:51:31 +0100
Message-ID: <1311695491.24408.66.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 16:46 +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-26 at 01:47 +0400, Cyrill Gorcunov wrote:
> > > > schedule (sched.c)
> > > >         ...
> > > >         raw_spin_lock_irq
> > > >         ...
> > > >         context_switch
> > > >                 switch_to
> > > >                         "jnz   ret_from_fork\n\t"
> > > >                         pushq_cfi kernel_eflags(%rip)
> > > >                         popfq_cfi                               # reset kernel eflags
> > > > 
> > > > --->                    irqs are still disabled
> > > > 
> > > >                         call schedule_tail                      # rdi: 'prev' task parameter
> > > >                                 finish_lock_switch
> > > >                                         raw_spin_unlock_irq
> > > > 
> > > > I bet raw_spin_lock_irq at the beginning of the schedule() is set
> > > > for a reason and such change is not safe. Though I may be missing
> > > > something again...
> > > > 
> > > 
> > > This definitely doesn't look "obviously safe" to me.  However, does
> > > anyone see a problem with unconditionally leaving IF disabled even on 32
> > > bits (I haven't traced all the paths yet), i.e. doing the *opposite* of
> > > Ian's patch #2?
> 
> Right, enabling IRQs there isn't cool, currently there's still
> __ARCH_WANT_INTERRUPTS_ON_CTXSW but we're working hard on getting rid of
> that nightmare.
> 
> There's a number of very subtle things that can go wrong when you enable
> interrupts over the context switch.
> 
> Leaving IRQs disabled should be the right thing, on x86 we should
> _never_ have interrupts enabled there.

Thanks Peter. I'll flip the (not any longer) "arbitrary" decision in my
#2 patch and repost when I return from debconf/vacation.

Ian.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


