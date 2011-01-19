Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1ASNL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 08:11:58 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57533 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab1ASNL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 08:11:57 -0500
Subject: Re: percpu related boot crash on x86 (was: Linux 2.6.38-rc1)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	 <20110119120200.GA1057@elte.hu> <1295441307.28776.15.camel@laptop>
	 <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Jan 2011 14:12:02 +0100
Message-ID: <1295442722.28776.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 14:56 +0200, Pekka Enberg wrote:
> 
> On Wed, Jan 19, 2011 at 2:48 PM, Peter Zijlstra
> <a.p.zijlstra@chello.nl> wrote:
> >  start_kernel()
> >   local_irq_disable()
> >   ...
> >   early_irq_init()
> >     alloc_desc()
> >       alloc_percpu()
> >         __alloc_percpu()
> >           pcpu_alloc()
> >             pcpu_extend_area_map()
> >               pcpu_mem_free()
> >                 vfree()
> >                   __vunmap()
> >                     remove_vm_area()
> >                       free_unmap_vmap_area()
> >                         vmap_debug_free_range()
> > #ifdef CONFIG_DEBUG_PAGEALLOC
> >                           flush_tlb_kernel_range()
> >                             flush_tlb_all()
> >                               on_each_cpu()
> >                                 smp_call_function()
> >                                   WARN_ON_ONCE(irqs_disabled()....);
> >
> >
> > Not quite sure that to do about that though..
> 
> Is vmalloc() and vfree() supposed to work with interrupts disabled? 

I'm not sure about vmalloc(), but vfree() has been known to not work
with IRQs disabled for a long long while.

Looking at the code neither can work, since vmalloc() can end up calling
vfree(), what's curious though is that all the BUG_ON()s in there are on
in_interrupt() instead of for irqs_disabled().

> I always thought they weren't which would mean something in
> pcpu_mem_alloc() needs changing... 

Is alloc_percpu() supposed to work from atomic context?
