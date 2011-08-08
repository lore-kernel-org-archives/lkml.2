Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1HHUxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:53:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32902 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab1HHUxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:53:09 -0400
Subject: Re: [PATCH v4 2/2] Output stall traces in /proc
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: ZAK Magnus <zakmagnus@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Mandeep Singh Baines <msb@chromium.org>
Date: Mon, 08 Aug 2011 22:52:51 +0200
In-Reply-To: <20110808201951.GY1972@redhat.com>
References: <1312495991-28377-1-git-send-email-zakmagnus@chromium.org>
	 <1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
	 <20110805134042.GJ1972@redhat.com>
	 <CAAuSN919rQj93P8HE69_N5vC04ywMFfeJjRdMhn8ga1V-jFb7A@mail.gmail.com>
	 <20110805184323.GK20762@redhat.com>
	 <CAAuSN91Pi8SbWbU87v7QdDWS_N1GiXsM8dGUYSYKTUCUp+2Mww@mail.gmail.com>
	 <20110808201951.GY1972@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312836771.22367.35.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 16:19 -0400, Don Zickus wrote:

> I believe irq_work_queue uses cmpxchg for all its locking and just swaps
> entries on to a linked list?

yeah, cmpxchg to add entries, xchg to splice the whole list out.

> > 
> > Or maybe the intermediate buffer should be dynamically allocated. That
> > would work without a lock, although it seems slightly inefficient.
> 
> Peter,
> 
> How does the irq_work_queue work such that you can save info in the NMI
> context and safely pass it to the irq context for processing? 

It doesn't cover that part. It assumes a pre-allocated struct irq_work
exists and can enqueue that on a list, if its already enqueued, nothing
to do (irq_work_queue() returns that state).

Typically irq_work would be embedded in a larger structure.


> > Regarding the lock between the work queue thread and the system call,
> > maybe that should become a mutex instead, since it's all outside of
> > interrupt context at that point?
> 
> No it is still in the irq context.

Right, irq_work is typically ran from hardirq context, either through
some self-IPI, raised at irq_work_queue() or in the fallback case from
the timer interrupt.

> Peter,
> 
> If we want to expose data captured in the NMI context through the procfs,
> I assume we can pass that info along using irq_work_queue.  But then when
> reading from procfs do we just lock the data with 'spin_lock_irq' to block
> the irq_work_queue from manipulating the data?  (note we are expecting
> data to be overwritten with fresh data, not serialized out like
> trace/perf).

Since its the NMI context that's generating the data, disabling IRQs
will obviously not do much good.

Also, if you've got a procfs output, what do you need irq_work for?

Depending on the type of data and kind of data loss you can incur, would
a static per-cpu buffer be ok? You can guard it by a single bit, if
cleared NMI can write, if set NMI will skip over and loose the data.

Then your procfs routine can set the bit, dump out the latest version of
the data and clear the bit again. If you always want the NMI thing to be
able to write, use two buffers, if you 'lock' then one at a time,
there's always one writable.

All you need is atomic bitops :-)

> > > The softstall case should be ok though.
> > Why's that? The soft stall traces are not written in a NMI context but
> > just in a regular interrupt context, right? Doesn't that pose similar
> > problems?

You should be able to do stack traces from NMI context, that's what perf
does after all.

> > These are weird rare corner cases anyway, right? Maybe the simplest
> > thing could be to let the interrupts only try_lock(), so they might
> > sometimes fail to record a stall, but it would be a pretty big
> > coincidence.

Sure you can do a trylock. I'm still not quite sure what you want the
irq_work for.. there's no guarantee the interrupt runs immediately after
the NMI, it could be the NMI is in the middle of a irq disabled region,
or the whole thing is ran on an architecture without
arch_irq_work_raise().
