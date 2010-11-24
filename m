Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0KXR0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:26:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:56723 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab0KXR0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:26:52 -0500
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless)
 fastpaths for slub
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <alpine.DEB.2.00.1011241013240.14268@router.home>
References: <20101123235139.908255844@linux.com>
	 <20101123235201.758191189@linux.com> <1290586512.2072.423.camel@laptop>
	 <alpine.DEB.2.00.1011241013240.14268@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 18:26:50 +0100
Message-ID: <1290619610.2072.500.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 10:14 -0600, Christoph Lameter wrote:
> On Wed, 24 Nov 2010, Peter Zijlstra wrote:
> 
> > This thing still relies on disabling IRQs in the slow path, which means
> > its still going to be a lot of work to make it work on -rt.
> 
> The disabling of irqs is because slab operations are used from interrupt
> context. If we can avoid slab operations from interrupt contexts then we
> can drop the interrupt disable in the slab allocators.

That's not so much the point, there's per-cpu assumptions due to that.
Not everything is under a proper lock, see for example this bit:

        new = new_slab(s, gfpflags, node);

        if (gfpflags & __GFP_WAIT)
                local_irq_disable();

        if (new) {
                c = __this_cpu_ptr(s->cpu_slab);
                stat(s, ALLOC_SLAB);
                if (c->page)
                        flush_slab(s, c);
                slab_lock(new);
                __SetPageSlubFrozen(new);
                c->page = new;
                goto load_freelist;
        }

There we have the __this_cpu_ptr, c->page deref and flush_slab()->stat()
call all before we take a lock.


