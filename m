Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1DFBs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 21:48:28 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56160 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753050Ab1DFBs1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 21:48:27 -0400
Date: Tue, 5 Apr 2011 21:48:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "lenb@kernel.org" <lenb@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: About lock-less data structure patches
Message-ID: <20110406014824.GB32321@Krystal>
References: <20110329202649.137a8a18.akpm@linux-foundation.org> <20110330133411.GA11101@Krystal> <BLU0-SMTP52616BFA7ABB7E8E73E8396BC0@phx.gbl> <4D93DB49.3060205@intel.com> <20110401213748.GA26543@Krystal> <4D96AEAE.2010800@intel.com> <20110404155328.GA13390@Krystal> <BANLkTin3XpOnnqWcu-bsUCJ_6JaYcBkJkg@mail.gmail.com> <20110405044227.GA20013@Krystal> <BANLkTinLH=s419RVQXSUTjBSdH0XjdpZWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <BANLkTinLH=s419RVQXSUTjBSdH0XjdpZWg@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:45:26 up 133 days,  6:48,  4 users,  load average: 0.02, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* huang ying (huang.ying.caritas@gmail.com) wrote:
> On Tue, Apr 5, 2011 at 12:42 PM, Mathieu Desnoyers
[snip] 
> 
> >> It seems hard to implement the
> >> dequeue_all,
> >
> > Actually, there is already one implemented :)
> >
> > See urcu-call-rcu.c: call_rcu_thread()
> 
> Have not understand the whole algorithm fully. Will continue to study
> it.  I found there is a synchronize_rcu() in call_crc_thread().  Must
> "dequeue_all" use that too?

Please note that call_rcu_thread() does more than just a dequeue_all: it
dequeues all the current callbacks from the list, waits for a grace
period to elapse, and then execute all the callbacks it got. So the
synchronize_rcu() would not be needed in a dequeue_all implementation.

> 
> >> >> >> mutex is needed between multiple "_slist_stack_pop", but not needed
> >> >> >> between slist_stack_push_lf and _slist_stack_pop.  I think it is hard to
> >> >> >> explain that clearly via function naming.
> >> >> >
> >> >> > Good point. A ascii-art table might be appropriate here, e.g.:
> >> >> >
> >> >> >
> >> >> > M: Mutual exclusion needed to protect one from another.
> >> >> > -: lockless.
> >> >> >
> >> >> >              |     push     |   pop    |   pop_all
> >> >> > push         |      -       |    -     |     -
> >> >> > pop          |              |    L     |     L
> >> >> > pop_all      |              |          |     -
> >> >> >
> >> >> > How about adding this (or something prettier) to the header ?
> >> >>
> >> >> Cool!  I will add that to header.
> >> >>
> >> >> >>> * If we choose to go with an alternate wait-free push implementation:
> >> >> >>>
> >> >> >>> llist_add -> slist_stack_push_wf              (wait-free)
> >> >> >>> llist_del_first -> slist_stack_pop_blocking   (blocking)
> >> >> >>> llist_del_all -> slist_stack_pop_all_blocking (blocking)
> >> >> >>
> >> >> >> We need non-blocking pop, so maybe you need implement another data
> >> >> >> structure which has these interface.  I think there can be multiple
> >> >> >> lock-less data structure in kernel.
> >> >> >
> >> >> > As I noted earlier, the blocking was only due to our user-level
> >> >> > implementation. It can be turned in a very short-lived busy loop
> >> >> > instead.
> >> >> >
> >> >> >>
> >> >> >>>> + *
> >> >> >>>> + * If there are multiple producers and multiple consumers, llist_add
> >> >> >>>> + * can be used in producers and llist_del_all can be used in
> >> >> >>>> + * consumers.  They can work simultaneously without lock.  But
> >> >> >>>> + * llist_del_first can not be used here.  Because llist_del_first
> >> >> >>>> + * depends on list->first->next does not changed if list->first is not
> >> >> >>>> + * changed during its operation, but llist_del_first, llist_add,
> >> >> >>>> + * llist_add sequence in another consumer may violate that.
> >> >> >>>
> >> >> >>> You did not seem to define the locking rules when using both
> >> >> >>>
> >> >> >>>   llist_del_all
> >> >> >>> and
> >> >> >>>   llist_del_first
> >> >> >>>
> >> >> >>> in parallel. I expect that a mutex is needed, because a
> >> >> >>>
> >> >> >>>   llist_del_all, llist_add, llist_add
> >> >> >>>
> >> >> >>> in parallel with
> >> >> >>>
> >> >> >>>   llist_del_first
> >> >> >>>
> >> >> >>> could run into the same ABA problem as described above.
> >> >> >>
> >> >> >> OK.  I will add that.
> >> >> >>
> >> >> >>>> + *
> >> >> >>>> + * If there are multiple producers and one consumer, llist_add can be
> >> >> >>>> + * used in producers and llist_del_all or llist_del_first can be used
> >> >> >>>> + * in the consumer.
> >> >> >>>> + *
> >> >> >>>> + * The list entries deleted via llist_del_all can be traversed with
> >> >> >>>> + * traversing function such as llist_for_each etc.  But the list
> >> >> >>>> + * entries can not be traversed safely before deleted from the list.
> >> >> >>>
> >> >> >>> Given that this is in fact a stack, specifying the traversal order of
> >> >> >>> llist_for_each and friends would be appropriate.
> >> >> >>
> >> >> >> Ok.  I will add something like "traversing from head to tail" in the
> >> >> >> comments.
> >> >> >
> >> >> > Traversing from last element pushed to first element pushed would
> >> >> > probably be clearer.
> >> >>
> >> >> head and tail describe the current state, while "last/first element
> >> >> pushed" describe the history.  I think both are understandable.
> >> >
> >> > head and tail, in a list implemented as a stack (but that is not
> >> > clearly advertised as such), don't convey the meaning of "we're
> >> > iterating from the newest element pushed to the oldest one". This
> >> > counter-intuitiveness is part of why I would really like to see this
> >> > turned into a queue.
> >>
> >> OK.  I will change the comments, adding these semantics explanation.
> >> The user should be warned :)
> >
> > Yes, that makes sense. After this generalization step, if you're ok with
> > this, we could aim at moving the implementation from a stack to a queue
> > and provide fifo semantic rather than lifo, so that other users (e.g.
> > call_rcu in the kernel) can start benefiting from it.
> 
> I think that is good to move from stack to queue.
> 
> I will send out changed lock-less data structure patchset soon.  And
> we can continue to work on the new lock-less queue at the same time.

Sounds like a very good plan! Thanks!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
