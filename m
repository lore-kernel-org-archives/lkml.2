Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1HJP1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:27:31 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:61572 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1HJP1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:27:30 -0400
X-IronPort-AV: E=Sophos;i="4.67,351,1309737600"; 
   d="scan'208";a="7214899"
Subject: Re: [PATCH 0/3] minor cleanups to EFLAGS initialisation in
 ret_from_fork
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pekka Enberg" <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1311691594.24752.40.camel@twins>
References: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
	 <20110725101902.GP4362@sun> <20110725182049.GD27137@sun>
	 <4E2DDBAA.60200@zytor.com>  <20110725214731.GE27137@sun>
	 <1311691594.24752.40.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 10 Aug 2011 16:27:27 +0100
Message-ID: <1312990047.26263.248.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 15:46 +0100, Peter Zijlstra wrote:
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

Just getting back to this after my vac, sorry for the delay.

raw_spin_unlock_irq unconditionally re-enables interrupts so I don't
really see what I've changed since interrupts are enabled by
schedule_tail and I've moved (on 64 bit) the EFLAGS reset to after
schedule_tail, so it should have interrupts enabled at that point
already and so they should remain enabled. Or are you suggesting that
things were already wrong?

However I've switched the order of my second patch anyway, so EFLAGS is
reset to 0x0002 (interrupts disabled) on both 32- and 64-bit before the
call to schedule_tail, since it does seem like the simpler option. I'll
repost shortly.

Ian.

