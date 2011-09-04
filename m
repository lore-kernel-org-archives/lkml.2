Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1IDUuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 16:50:16 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51534 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753165Ab1IDUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 16:50:13 -0400
Date: Sun, 4 Sep 2011 16:50:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Huang Ying <ying.huang@intel.com>, lenb@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC patch 1/2] Rename the "llist" (lockless list) to
	"llstack" (lockless stack)
Message-ID: <20110904205009.GA19876@Krystal>
References: <20110903174721.390074195@efficios.com> <20110903175543.363519825@efficios.com> <20110903224155.GG7761@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110903224155.GG7761@one.firstfloor.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:51:15 up 285 days, 54 min,  4 users,  load average: 0.02,
	0.02, 0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

* Andi Kleen (andi@firstfloor.org) wrote:
> 
> I don't see why a rename is necessary. People implement stacks and queues
> and all other kinds of data structures using the standard list.h.
> No reason why this shouldn't work with llist.h either.

What you are saying here is only partially true. Gien that Linux
supports multiprocessing, people implement stack ans queues with list.h
_and_ mutual exclusion (spin locks, mutexes, rwlocks) for SMP
synchronization.

The flexibility of list.h combined with the flexibility of mutual
exclusion synchronisation primitives allow people to implement basically
all the list-based data structure they feel like implementing, with the
known performance downsides of mutual exclusion: only one thread can
touch the data structure at a given time, and touching the mutex adds
cache-line bouncing. It's also not permitted to use mutual exclusion in
NMI handlers.

However, in the realm of lock-free data structures, things are very much
different. Synchronization can be performed in a much more fine-grained
fashion and the data structure is tailored to the needed
synchronization, which enables performance enhancements not possible
with mutual-exclusion techniques. The lock-free queue is a good example
(FIFO behavior):

With list.h and mutexes, you would implement this queue very
straightforwardly using:

DEFINE_MUTEX(somemutex);
LIST_HEAD(somelist);

And then protect all list_add_tail (enqueue) operations and list_del of
list_first_entry (dequeue) operations with the mutex.

A lock-free queue has come very interesting advantages compared to the
mutex-protected queue. One of them being that if the queue list
structure is crafted appropriately, enqueuer and dequeuer threads can
concurrently enqueue and dequeue elements to/from the queue without
wrestling for the same cache-line (when there is at least one element in
the queue, which is usually the case when high-throughput matters).

Now some words about stacks (LIFO behavior):

You can indeed implement stacks with mutex/list.h by using list_add
(push) and list_del of list_first_entry (pop) protected by a mutex, with
the downside of having to touch both the mutex and the list head for
each of these operations. Also, this is not safe to use in NMI handlers,
which seems to be a use-case NMI handler implementors are facing
(which is I think what motivated the implementation of llist.h in the
first place).

A lock-free stack lets you do this with a single cmpxchg on the push,
and an xchg on the "pop all" (there are also variants that can use a
xchg() on the push). In addition, it lets you return whether the stack
was empty when performing the push operation, which is a feature quite
useful to know if a wakeup should be triggered or not.

But the data structures required to implement a lock-free queue and a
lock-free stack differ quite significantly: some ways to implement a
lock-free queue require either special sequence numbering of both ends,
or dummy elements that ensures the queue is never empty. The lock-free
stack can be implemented by putting a NULL bottom node to detect the end
of stack. Moreover, even though the stack "push" operation can return
whether the stack was previously empty at no cost, it is not true for
the queue, because this would require the enqueuer to touch the dequeuer
cache-lines.


> I would assume everyone hacking on the Linux kernel will understand
> that a list can be used as a building block for all of these.

Although strictly speaking this is true, I'm afraid a single "generic"
list container would be at best a building block for either efficient
lock-free queues or stacks, but not both.

This is why I'm proposing to turn the generic "llist.h" namespace into
the more specific "llstack.h", so the API reflects not only the basic
list structure, but also the exposed behavior and the implicit
synchronization performed within this API, because those are
intrinsically linked to the data structure layout, unlike
mutual-exclusion-based approaches.

Best regards,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
