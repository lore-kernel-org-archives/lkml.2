Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1GZOrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:47:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:54064 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1GZOrA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:47:00 -0400
Subject: Re: [PATCH 0/3] minor cleanups to EFLAGS initialisation in
 ret_from_fork
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110725214731.GE27137@sun>
References: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
	 <20110725101902.GP4362@sun> <20110725182049.GD27137@sun>
	 <4E2DDBAA.60200@zytor.com>  <20110725214731.GE27137@sun>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Jul 2011 16:46:34 +0200
Message-ID: <1311691594.24752.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 01:47 +0400, Cyrill Gorcunov wrote:
> > > schedule (sched.c)
> > >         ...
> > >         raw_spin_lock_irq
> > >         ...
> > >         context_switch
> > >                 switch_to
> > >                         "jnz   ret_from_fork\n\t"
> > >                         pushq_cfi kernel_eflags(%rip)
> > >                         popfq_cfi                               # reset kernel eflags
> > > 
> > > --->                    irqs are still disabled
> > > 
> > >                         call schedule_tail                      # rdi: 'prev' task parameter
> > >                                 finish_lock_switch
> > >                                         raw_spin_unlock_irq
> > > 
> > > I bet raw_spin_lock_irq at the beginning of the schedule() is set
> > > for a reason and such change is not safe. Though I may be missing
> > > something again...
> > > 
> > 
> > This definitely doesn't look "obviously safe" to me.  However, does
> > anyone see a problem with unconditionally leaving IF disabled even on 32
> > bits (I haven't traced all the paths yet), i.e. doing the *opposite* of
> > Ian's patch #2?

Right, enabling IRQs there isn't cool, currently there's still
__ARCH_WANT_INTERRUPTS_ON_CTXSW but we're working hard on getting rid of
that nightmare.

There's a number of very subtle things that can go wrong when you enable
interrupts over the context switch.

Leaving IRQs disabled should be the right thing, on x86 we should
_never_ have interrupts enabled there.
