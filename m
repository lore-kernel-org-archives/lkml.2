Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1GDNKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:10:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56545 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab1GDNKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:10:21 -0400
Date: Mon, 4 Jul 2011 15:10:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 5/6] x86: Remove useless unwinder backlink from irq regs
 saving
Message-ID: <20110704131016.GD1915@somewhere.redhat.com>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
 <1309624184-9790-6-git-send-email-fweisbec@gmail.com>
 <4E1187E4020000780004BF2C@nat28.tlf.novell.com>
 <20110704091742.GC22943@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704091742.GC22943@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 11:17:42AM +0200, Ingo Molnar wrote:
> 
> * Jan Beulich <JBeulich@novell.com> wrote:
> 
> > >>> On 02.07.11 at 18:29, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > The unwinder backlink in interrupt entry is very useless.
> > > It's actually not part of the stack frame chain and thus is
> > > never used.
> > 
> > I very much doubt this - see dump_trace()'s comment in its IRQ-stack
> > related code portion (and the corresponding use of irq_stack_end[-1]).
> 
> > > +++ b/arch/x86/kernel/entry_64.S
> > > @@ -327,7 +327,6 @@ ENDPROC(native_usergs_sysret64)
> > >  	jne 2f
> > >  	mov PER_CPU_VAR(irq_stack_ptr),%rsp
> > >  	EMPTY_FRAME 0
> > > -	pushq_cfi %rbp			/* backlink for unwinder */
> > >  	/*
> > >  	 * We entered an interrupt context - irqs are off:
> > >  	 */
> 
> Frederic, please add it back with a much better comment in the .S 
> showing where it's used and how. Perhaps even try to trigger the 
> usage of this backlink and document the effect in the changelog.

Ok. Please also consider the point Jan made: save_regs() was created
a while ago to convert code from a macro to a function in order to
reduce the amount of duplicated code amongst interrupts.

I did not think about that. On the other hand, keeping that into a
function unoptimize a bit the interrupt entries I think (but then
at the cost of increasing a bit the i-cache footprint?)

Not sure what we should do. We can still revert/zap the whole
and focus on pure stacktrace fixes without underlying optimizations.
