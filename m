Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935493Ab1ETSf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:35:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38125 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934869Ab1ETSf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:35:26 -0400
Date: Fri, 20 May 2011 20:35:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, kees.cook@canonical.com,
        davem@davemloft.net, eranian@google.com, torvalds@linux-foundation.org,
        adobriyan@gmail.com, penberg@kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110520183516.GA18322@elte.hu>
References: <1305292059.1949.0.camel@dan>
 <1305293345.1949.22.camel@dan>
 <20110516153527.GC21107@elte.hu>
 <1305852966.3005.19.camel@dan>
 <20110520120750.GJ14745@elte.hu>
 <1305896093.3005.24.camel@dan>
 <20110520131108.GA17699@elte.hu>
 <1305913261.20623.12.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305913261.20623.12.camel@dan>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> On Fri, 2011-05-20 at 15:11 +0200, Ingo Molnar wrote:
> 
> > We need to allocate the IDT dynamically: just kmalloc() it, update idt_descr 
> > and do a load_idt(). Double check places that modify idt_descr or use 
> > idt_table.
> > 
> > Note, you could do this as a side effect of a nice performance optimization: 
> > would you be interested in allocating it in the percpu area, using 
> > percpu_alloc()? That way the IDT is distributed between CPUs - this has 
> > scalability advantages on NUMA systems and maybe even on SMP.
> > 
> 
> Any suggestions on when this allocation should take place?  I'm hesitant to 
> touch anything in arch/x86/kernel/head_32.S, where the IDT is setup and lidt 
> idt_descr is called (on x86-32 anyway).  That means at some point I'd have to 
> copy the table into a region allocated with alloc_percpu() and set up a new 
> descriptor.  Seems like this should happen before IRQ is enabled, but I'm not 
> sure about the best place.

I think there's a static percpu area that can be used pretty early on.

The boot IDT can be marked __initdata so its space wont be wasted.

The thing is, until SMP is not initialized the boot IDT can be kept. So i'd 
suggest allocating per CPU IDTs after memory has initialized. For that a pretty 
good place is trap_init(): there we already have the page allocator initialized 
and probably the percpu allocator too. IDT allocation is also pretty naturally 
done in trap_init().

> Also, I'd still welcome suggestions on generating entropy so early in the 
> boot process as to randomize the location at which the kernel is 
> decompressed.
> 
> On a related note, would there be obstacles to marking the IDT as read-only?

The cost is that its access TLB may change from a 2MB TB to a 4K TLB. We 
generally try to keep critical data structures in 2MB mapped areas.

But this is really hard to measure (you'd have to have a borderline workload 
where the loss of a single 4K TLB is measurable) so i'd suggest splitting this 
from the randomization step.

Thanks,

	Ingo
