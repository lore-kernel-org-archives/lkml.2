Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1HHUUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:20:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab1HHUUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:20:10 -0400
Date: Mon, 8 Aug 2011 16:19:51 -0400
From: Don Zickus <dzickus@redhat.com>
To: ZAK Magnus <zakmagnus@google.com>, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v4 2/2] Output stall traces in /proc
Message-ID: <20110808201951.GY1972@redhat.com>
References: <1312495991-28377-1-git-send-email-zakmagnus@chromium.org>
 <1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
 <20110805134042.GJ1972@redhat.com>
 <CAAuSN919rQj93P8HE69_N5vC04ywMFfeJjRdMhn8ga1V-jFb7A@mail.gmail.com>
 <20110805184323.GK20762@redhat.com>
 <CAAuSN91Pi8SbWbU87v7QdDWS_N1GiXsM8dGUYSYKTUCUp+2Mww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAuSN91Pi8SbWbU87v7QdDWS_N1GiXsM8dGUYSYKTUCUp+2Mww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Peter to the discussion)

On Fri, Aug 05, 2011 at 02:26:12PM -0700, ZAK Magnus wrote:
> On Fri, Aug 5, 2011 at 11:43 AM, Don Zickus <dzickus@redhat.com> wrote:
> > I missed that you defined that as a pointer to a spinlock and assigned it
> > later.  I see what you are doing now, but I am not a fan of it because you
> > are now using the same spinlock in both the NMI context and the userspace
> > context.  This can cause deadlocks if something got screwed up in the
> > seq_printf functions or produced a very large amount of data.  Normally
> > you don't want to do that.
> >
> > What others have done like perf and the APEI error handling is use
> > something called irq_work_queue(??).  Basically you would capture the
> > tracae in the NMI context, put it on an irq_work_queue and in the
> > interrupt context save it to your global trace variable.  Then you could
> > put spin_lock_irqsave inside the proc sys function and the work queue
> > function and not have any potential deadlocks.
> Work queue? Okay. The worker thread still needs a lock in order to

not work_queue, irq_work_queue.

> share the intermediate buffer with the NMI context, though. Any chance
> of something screwing up in the middle of copying that structure,
> causing a stall and deadlocking with the NMI?

I believe irq_work_queue uses cmpxchg for all its locking and just swaps
entries on to a linked list?

> 
> Or maybe the intermediate buffer should be dynamically allocated. That
> would work without a lock, although it seems slightly inefficient.

Peter,

How does the irq_work_queue work such that you can save info in the NMI
context and safely pass it to the irq context for processing? 

> 
> Regarding the lock between the work queue thread and the system call,
> maybe that should become a mutex instead, since it's all outside of
> interrupt context at that point?

No it is still in the irq context.

Peter,

If we want to expose data captured in the NMI context through the procfs,
I assume we can pass that info along using irq_work_queue.  But then when
reading from procfs do we just lock the data with 'spin_lock_irq' to block
the irq_work_queue from manipulating the data?  (note we are expecting
data to be overwritten with fresh data, not serialized out like
trace/perf).

Cheers,
Don

> 
> > The softstall case should be ok though.
> Why's that? The soft stall traces are not written in a NMI context but
> just in a regular interrupt context, right? Doesn't that pose similar
> problems?
> 
> 
> These are weird rare corner cases anyway, right? Maybe the simplest
> thing could be to let the interrupts only try_lock(), so they might
> sometimes fail to record a stall, but it would be a pretty big
> coincidence.
