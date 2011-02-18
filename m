Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab1BRTEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:04:07 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40397 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab1BRTEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:04:04 -0500
Date: Fri, 18 Feb 2011 11:03:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Newton <will.newton@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Matt Fleming <matt@console-pimps.org>,
        David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        peterz@infradead.org, jbaron@redhat.com, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110218190346.GE2201@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1297707868.5226.189.camel@laptop>
 <1297718964.23343.75.camel@gandalf.stny.rr.com>
 <1297719576.23343.80.camel@gandalf.stny.rr.com>
 <20110214.134600.179933733.davem@davemloft.net>
 <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
 <BLU0-SMTP166A8555C791786059B0FF96D00@phx.gbl>
 <20110214230902.GM2256@linux.vnet.ibm.com>
 <AANLkTikO_BCyFvcp=VZXQK-AvAFSB7sxQS_4_=HW3bZi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikO_BCyFvcp=VZXQK-AvAFSB7sxQS_4_=HW3bZi@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 11:53:37AM +0000, Will Newton wrote:
> On Mon, Feb 14, 2011 at 11:09 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> 
> Hi Paul,
> 
> > What CPU family are we talking about here?  For cache coherent CPUs,
> > cache coherence really is supposed to work, even for mixed atomic and
> > non-atomic instructions to the same variable.
> 
> Is there a specific situation you can think of where this would be a
> problem? I have to admit to a certain amount of unease with the design
> our hardware guys came up with, but I don't have a specific case where
> it won't work, just cases where it is less than optimal.

OK, you did ask...

One case is when a given block of memory was subject to atomic
instructions, then was freed and reallocated as a structure used by
normal instructions.  It would be quite bad if the last pre-free atomic
operation failed to play nice with the first post-allocate non-atomic
instruction.  The reverse situation is of course important as well,
where a block subject to non-atomic instructions is freed and reallocated
as a structure subject to atomic instructions.  I would guess you would
handle these cases by making the memory allocator deal with any hardware
caching issues, but however it is handled, it does need to be handled.

Another case is a leaky-bucket token protocol, where there is a rate
limit of some sort.  There is an integer that is positive when progress
is permitted, and negative otherwise.  This integer is periodically reset
to its upper limit, and this reset operation can use a non-atomic store.
When attempting to carry out a rate-limited operation, you use either
atomic_add_return() if underflow cannot happen, but you must use
cmpxchg() if underflow is a possibility.  Now you -could- use atomic
xchg() to reset the integer, but you don't have to.  You -could- also
use atomic_cmpxchg() to check and atomic_set() to reset the limit, but
again, you don't have to.  And there might well be places in the Linux
kernel that mix atomic and non-atomic operations in this case.

Yet another case is a variation on the lockless queue that can have
concurrent enqueues but where only one task may dequeue at a time, for
example, dequeuing might be guarded by a lock.  Suppose that dequeues
removed all the elements on the queue at one shot.  Such a queue might
have a head and tail pointer, where the tail pointer references the
->next pointer of the last element, or references the head pointer if
the queue is empty.  Each element also has a flag that indicates whether
it is a normal element or a dummy element.

Enqueues are handled in the normal way for this sort of queue:

1.	Initialize the element to be added, including NULLing out
	its ->next pointer.

2.	Atomically exchange the queue's tail pointer with a pointer
	to the element's ->next pointer, placing the old tail pointer
	into a local variable (call it "oldtail").

3.	Nonatomically set the pointer referenced by oldtail to
	point to the newly added element.

Then a bulk dequeue could be written as follows:

1.	Pick up the head pointer, placing it in a local variable
	(call it "oldhead").  If NULL, return an empty list, otherwise
	continue through the following steps.

2.	Store NULL into the head pointer.  This can be done nonatomically,
	because no one else will be concurrently storing into this
	pointer -- there is at least one element on the list, and so
	the enqueuers will be instead storing to the ->next pointer
	of the last element.

3.	Atomically exchange the queue's tail pointer with a pointer
	to the queue's head pointer, placing the old value of the
	tail pointer into a local variable (again, call it "oldtail").

4.	Return a list with oldhead as the head pointer and oldtail
	as the tail pointer.

	The caller cannot rely on NULL pointers to find the end of the
	list, as an enqueuer might be delayed between steps 2 and 3.
	Instead, the caller must check to see if the address of the NULL
	pointer is equal to oldtail, in which case, the caller has in
	fact reached the end of the list.  Otherwise, the caller must
	wait for the pointer to become non-NULL.

Yes, you can replace the non-atomic loads and stores in the enqueuer's
step #3 and in the bulk dequeue's steps #1 and #2 with atomic exchange
instructions -- in fact you can replace either or both.  And you could
also require that the caller use atomic instructions when looking at
each element's ->next pointer.

There are other algorithms, but this should be a decent start.

And yes, you -can- make these algorithms use only atomic instructions, but
you don't -have- to.  So it is quite likely that similar algorithms exist
somewhere in the 10+ million lines of code making up the Linux kernel.

							Thanx, Paul
