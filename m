Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1DEMqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 08:46:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50750 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1DEMqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 08:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vyAvzRcqnS1U/9PKVC4eWZpJU2iFOk8is8qNmnjHBbrnltYXcmpORAzzG/ZSjYqO27
         VjfWrTOGU4vhQ54sW9w872pO+9AHtIjBojRN944tyqRFcqv0wXUpOyDJoa1d7Zb84/cm
         0gtgg/0aiNUUFXpMclsxDsqrt/5o/d1OrdPkI=
MIME-Version: 1.0
In-Reply-To: <20110405044227.GA20013@Krystal>
References: <4D9287C3.7030103@intel.com>
	<20110330032203.GC21838@one.firstfloor.org>
	<20110329202649.137a8a18.akpm@linux-foundation.org>
	<20110330133411.GA11101@Krystal>
	<BLU0-SMTP52616BFA7ABB7E8E73E8396BC0@phx.gbl>
	<4D93DB49.3060205@intel.com>
	<20110401213748.GA26543@Krystal>
	<4D96AEAE.2010800@intel.com>
	<20110404155328.GA13390@Krystal>
	<BANLkTin3XpOnnqWcu-bsUCJ_6JaYcBkJkg@mail.gmail.com>
	<20110405044227.GA20013@Krystal>
Date: Tue, 5 Apr 2011 20:46:41 +0800
Message-ID: <BANLkTinLH=s419RVQXSUTjBSdH0XjdpZWg@mail.gmail.com>
Subject: Re: About lock-less data structure patches
From: huang ying <huang.ying.caritas@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "lenb@kernel.org" <lenb@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 12:42 PM, Mathieu Desnoyers
[snip]
>> >> >>> Because this single-linked-list works like a stack (with "push"
>> >> >>> operation for llist_add, "pop" operation for llist_del_first), I would
>> >> >>> recommend to rename it accordingly (as a stack rather than "list"). If
>> >> >>> we think about other possible users of this kind of lock-free list, such
>> >> >>> as call_rcu(), a "queue" would be rather more appropriate than a "stack"
>> >> >>> (with enqueue/dequeue operations). So at the very least I would like to
>> >> >>> make sure this API keeps room for lock-free queue implementations that
>> >> >>> won't be confused with this stack API. It would also be important to
>> >> >>> figure out if what we really want is a stack or a queue. Some naming
>> >> >>> ideas follow (maybe they are a bit verbose, comments are welcome).
>> >> >>>
>> >> >>> We should note that this list implements "lock-free" push and pop
>> >> >>> operations (cmpxchg loops), and a "wait-free" "llist_del_all" operation
>> >> >>> (using xchg) (only really true for architectures with "true" xchg
>> >> >>> operation though, not those using LL/SC). We should think about the real
>> >> >>> use-case requirements put on this lockless stack to decide which variant
>> >> >>> is most appropriate. We can either have, with the implementation you
>> >> >>> propose:
>> >> >>>
>> >> >>> - Lock-free push
>> >> >>> - Pop protected by mutex
>> >> >>> - Wait-free pop all
>> >> >>>
>> >> >>> Or, as an example of an alternative structure (as Paul and I implemented
>> >> >>> in the userspace RCU library):
>> >> >>>
>> >> >>> - Wait-free push (stronger real-time guarantees provided by xchg())
>> >> >>> - Blocking pop/pop all (use cmpxchg and busy-wait for very short time
>> >> >>>   periods)
>> >> >>>
>> >> >>> (there are others, with e.g. lock-free push, lock-free pop, lock-free
>> >> >>> pop all, but this one requires RCU read lock across the pop/pop/pop all
>> >> >>> operations and that memory reclaim of the nodes is only performed after
>> >> >>> a RCU grace-period has elapsed. This deals with ABA issues of concurrent
>> >> >>> push/pop you noticed without requiring mutexes protecting pop operations.)
>> >> >>>
>> >> >>> So it all boils down to which are the constraints of the push/pop
>> >> >>> callers.  Typically, I would expect that the "push" operation has the
>> >> >>> most strict real-time constraints (and is possibly executed the most
>> >> >>> often, thus would also benefit from xchg() which is typically slightly
>> >> >>> faster than cmpxchg()), which would argue in favor of a wait-free
>> >> >>> push/blocking pop.  But maybe I'm lacking understanding of what you are
>> >> >>> trying to do with this stack. Do you need to ever pop from a NMI
>> >> >>> handler ?
>> >> >>
>> >> >> In my user case, I don't need to pop in a NMI handler, just push.  But
>> >> >> we need to pop in a IRQ handler, so we can not use blocking pop.  Please
>> >> >> take a look at the user case patches listed later.
>> >> >
>> >> > Actually, I marked that as a "blocking" in our implementation because I
>> >> > have a busy-loop in there, and because my algorithm was implemented in
>> >> > user-space, I added an adaptative delay to make sure not to busy-loop
>> >> > waiting for a preempted thread to come back.
>> >> >
>> >> > But by disabling preemption and using a real busy-loop in the kernel,
>> >> > the pop can trivially be made non-blocking, and thus OK for interrupt
>> >> > handlers.
>> >>
>> >> OK.  I see.  Thanks for clarification.  Takes a look at your "wfs"
>> >> implementation.  It seems that we need to disable interrupt in wf push
>> >> side to make it possible to use pop in interrupt handler. Do you think so?
>> >
>> > It would be appropriate, yes, because the irq handler doing "pop" can
>> > busy-wait during the short period of time during which it sees a "NULL"
>> > value. We don't want to have a softirq running on top of the push that
>> > would make the irq handler busy-wait for longer than the duration of
>> > interrupt handlers. In your case, the push is done by a NMI handler,
>> > which already has interrupts disabled, so no worry for this specific
>> > use-case.
>>
>> The semantics of irq_work doesn't restrict the push must be in NMI
>> handler, it is possible for the push to be called in process context.
>> And we are working on library code, so I don't think it is a good idea
>> to restrict that the priority of context of push must be higher (such
>> as NMI vs IRQ) than that of pop.
>
> OK. Anyway, the busy-looping on the pop side is an implementation
> choice. We have the luxury to choose between either xchg on
> push/busy-loop on pop or a cmpxchg on push (as in your implementation),
> which removes the need for busy-loop on pop. Maybe going for a cmpxchg
> on push might make more sense, because it would not require to disable
> interrupts.

Yes.  It is luxury to have two choices. :-)

>> >> >>> Some ideas for API identifiers:
>> >> >>>
>> >> >>> struct llist_head -> slist_stack_head
>> >> >>> struct llist_node -> slist_stack_node
>> >> >>
>> >> >> Why call it a stack and a list?  Because it is a stack implemented with
>> >> >> single list?  I think it is better to name after usage instead of
>> >> >> implementation.
>> >> >>
>> >> >> The next question is whether it should be named as stack or list.  I
>> >> >> think from current user's point of view, they think they are using a
>> >> >> list instead of stack.  There are 3 users so far as follow.
>> >> >>
>> >> >> https://lkml.org/lkml/2011/1/17/14
>> >> >> https://lkml.org/lkml/2011/1/17/15
>> >> >> https://lkml.org/lkml/2011/2/21/16
>> >> >
>> >> > Hrm, I'm concerned about the impact of handing the irq work from one
>> >> > execution context to another in the reverse order (because a stack is
>> >> > implemented here). Can this have unwanted side-effects ?
>> >>
>> >> For irq work, this is not an issue.  irq work users should not depend on
>> >> the order of raising.  But if it is necessary, we can reserve the order
>> >> again in irq_work_run to keep the original order.  After deleting all
>> >> nodes from lock-less list, we can operate on them at will.
>> >
>> > Ouch. This seems counter-intuitive. I'd rather prefer if we can change
>> > the way this lock-less list operates to use a "queue" fifo scheme rather
>> > than "stack" (lifo). This would seem much more intuitive: the first
>> > entry added to the list is the first to be removed. And for iteration on
>> > multiple entries removed at once, rather than iterating in reverse
>> > order, it would iterate from the oldest to the newest entry, which again
>> > seems more natural.
>>
>> I don't think "lifo" is a big issue here, although "fifo" may be more
>> natural.  After all, this is a very simple data structure with very
>> simple code.
>
> Yessss, although I would never apply the "simple" qualifier to lockless
> code. ;-)
>
>>
>> >> >> And if we named this data structure as list, we can still use "queue"
>> >> >> for another data structure.  Do you think so?
>> >> >
>> >> > Well, the "delete first entry" is really unclear if we call all this a
>> >> > "list". Which is the first entry ? The first added to the list, or the
>> >> > last one ? The natural reflex would be to think it is the first added,
>> >> > but in this case, it's the opposite. This is why I think using stack or
>> >> > lifo (with push/pop) would be clearer than "list" (with add/del).
>> >>
>> >> The llist is ordered list and has only one list "head", so the first
>> >> entry is the one pointed to by the "head".  Is it clear?
>> >>
>> >> > So maybe "lockless stack" could be palatable ? The name "lockless lifo"
>> >> > came to my mind in the past days too.
>> >>
>> >> But what we need is just a lock-less list, not a stack.  It behaves like
>> >> a stack just because we can not implement other functions such as
>> >> llist_add_tail etc in a lock-less way yet.  And we will add these
>> >> functions when we know how to do that.
>> >
>> > Well, we do already know how to do that ;-) ;-) Please have a look at
>> > wfqueue.h and wfqueue-static.h in Userspace RCU library. In this
>> > implementation too, the "blocking" busy-wait can be replaced by an
>> > active busy-looping in pretty much the same way I explained for the
>> > stack implementation.
>>
>> Find your wfqeueu implementation, that is great!  I just have some
>> concern about the performance.
>
> I guess you are referring to the need to disable interrupts. As I stated
> above, we can choose to go for a cmpxchg-based push instead, which
> removes the busy-loop from dequeue altogether.

That is great!

>> It seems hard to implement the
>> dequeue_all,
>
> Actually, there is already one implemented :)
>
> See urcu-call-rcu.c: call_rcu_thread()

Have not understand the whole algorithm fully. Will continue to study
it.  I found there is a synchronize_rcu() in call_crc_thread().  Must
"dequeue_all" use that too?

> Please note that this "dequeue all" implementation does not support
> concurrent "dequeue single node" operation (because we did not need it
> in the specific call_rcu() use-case), but it could possibly be adapted
> by handling the dummy node more carefully, although I'm not sure it's
> worth the effort (unless the combined use of dequeue one and dequeue all
> becomes an important use-case for a given list).
>
>> and IRQ may need to be turned off in enqueue side.
>
> Not if we use a cmpxchg-based enqueue.
>
>>
>> >> >>> * For your lock-free push/pop + wait-free pop_all implementation:
>> >> >>>
>> >> >>> llist_add -> slist_stack_push_lf        (lock-free)
>> >> >>> llist_del_first -> _slist_stack_pop     (needs mutex protection)
>> >> >>> llist_del_all -> slist_stack_pop_all_wf (wait-free)
>> >> >>
>> >> >> Do we really need to distinguish between lock-free and wait-free from
>> >> >> interface?
>> >> >
>> >> > I don't think it is needed, and it's probably even just more confusing
>> >> > for API users.
>> >> >
>> >> >> Will we implement both slist_stack_push_lf and
>> >> >> slist_stack_push_wf for one data structure?
>> >> >
>> >> > Those will possibly even require different data structures. It might be
>> >> > less confusing to find out clearly what our needs are, and only propose
>> >> > a single behavior, otherwise it will be confusing for users of these
>> >> > APIs without good reason.
>> >>
>> >> Yes.  I agree.  The semantics of my original lock-less list has already
>> >> been used by irq work and xlist of net rds.  My original implementation
>> >> can be seen as generalizing the existing implementation.  How about take
>> >> my original implementation as the first step, that is, generalizing,
>> >> then consider how to optimize it after that?
>> >>
>> >> But if you want to compare the two semantics above, I am OK too.
>> >
>> > In the spirit of not providing more APIs than needed, I would argue that
>> > it would be better to settle on the question of stack vs queue before
>> > this API gets into mainline.
>> >
>> > Unless we can show that you have users that need your list to behave
>> > like a stack, I would be in favor of moving it to a queue
>> > implementation and provide the semantic of "enqueue/dequeue", with list
>> > iteration order from oldest to newest node. Trying to change this
>> > afterward could bring us surprises, so it might be better to do it right
>> > now before this gets introduced.
>> >
>> > Moreover, we're not talking about that many lines of code to port from
>> > the userspace implementation to kernel-space. It just needs very
>> > thorough testing.
>>
>> The current users don't need a stack semantics.  They are USING the
>> stack semantics and implementation.  So I am NOT writing a new data
>> structure, I just generalize some existing data structure used by more
>> than one user into lib directory.
>
> I see. That's the part of the big picture I was missing.
>
>>
>> So I think the lock-less list data structure should be done in 2 steps.
>>
>> 1. Generalize the existing lock-less list data structure into lib.
>> Because exactly same implementation is used, there will be no big
>> issue here.  And if there are some issue in 2, we can revert to here
>> easily.
>>
>> 2. Change the implementation/semantics of lock-less list data
>> structure and change all users, this can based on your "queue"
>> implementation.  This involves performance compromise and semantics
>> changing, so will need more testing and more review.
>>
>> Do you agree?
>
> Yep. What I was missing is that you took existing implementations and
> merged them together and did not create your own implementation from
> scratch. Considering that there are already users of these
> implementation, it indeed makes sense to go through this intermediate
> step.

Thanks.

>> >> >> mutex is needed between multiple "_slist_stack_pop", but not needed
>> >> >> between slist_stack_push_lf and _slist_stack_pop.  I think it is hard to
>> >> >> explain that clearly via function naming.
>> >> >
>> >> > Good point. A ascii-art table might be appropriate here, e.g.:
>> >> >
>> >> >
>> >> > M: Mutual exclusion needed to protect one from another.
>> >> > -: lockless.
>> >> >
>> >> >              |     push     |   pop    |   pop_all
>> >> > push         |      -       |    -     |     -
>> >> > pop          |              |    L     |     L
>> >> > pop_all      |              |          |     -
>> >> >
>> >> > How about adding this (or something prettier) to the header ?
>> >>
>> >> Cool!  I will add that to header.
>> >>
>> >> >>> * If we choose to go with an alternate wait-free push implementation:
>> >> >>>
>> >> >>> llist_add -> slist_stack_push_wf              (wait-free)
>> >> >>> llist_del_first -> slist_stack_pop_blocking   (blocking)
>> >> >>> llist_del_all -> slist_stack_pop_all_blocking (blocking)
>> >> >>
>> >> >> We need non-blocking pop, so maybe you need implement another data
>> >> >> structure which has these interface.  I think there can be multiple
>> >> >> lock-less data structure in kernel.
>> >> >
>> >> > As I noted earlier, the blocking was only due to our user-level
>> >> > implementation. It can be turned in a very short-lived busy loop
>> >> > instead.
>> >> >
>> >> >>
>> >> >>>> + *
>> >> >>>> + * If there are multiple producers and multiple consumers, llist_add
>> >> >>>> + * can be used in producers and llist_del_all can be used in
>> >> >>>> + * consumers.  They can work simultaneously without lock.  But
>> >> >>>> + * llist_del_first can not be used here.  Because llist_del_first
>> >> >>>> + * depends on list->first->next does not changed if list->first is not
>> >> >>>> + * changed during its operation, but llist_del_first, llist_add,
>> >> >>>> + * llist_add sequence in another consumer may violate that.
>> >> >>>
>> >> >>> You did not seem to define the locking rules when using both
>> >> >>>
>> >> >>>   llist_del_all
>> >> >>> and
>> >> >>>   llist_del_first
>> >> >>>
>> >> >>> in parallel. I expect that a mutex is needed, because a
>> >> >>>
>> >> >>>   llist_del_all, llist_add, llist_add
>> >> >>>
>> >> >>> in parallel with
>> >> >>>
>> >> >>>   llist_del_first
>> >> >>>
>> >> >>> could run into the same ABA problem as described above.
>> >> >>
>> >> >> OK.  I will add that.
>> >> >>
>> >> >>>> + *
>> >> >>>> + * If there are multiple producers and one consumer, llist_add can be
>> >> >>>> + * used in producers and llist_del_all or llist_del_first can be used
>> >> >>>> + * in the consumer.
>> >> >>>> + *
>> >> >>>> + * The list entries deleted via llist_del_all can be traversed with
>> >> >>>> + * traversing function such as llist_for_each etc.  But the list
>> >> >>>> + * entries can not be traversed safely before deleted from the list.
>> >> >>>
>> >> >>> Given that this is in fact a stack, specifying the traversal order of
>> >> >>> llist_for_each and friends would be appropriate.
>> >> >>
>> >> >> Ok.  I will add something like "traversing from head to tail" in the
>> >> >> comments.
>> >> >
>> >> > Traversing from last element pushed to first element pushed would
>> >> > probably be clearer.
>> >>
>> >> head and tail describe the current state, while "last/first element
>> >> pushed" describe the history.  I think both are understandable.
>> >
>> > head and tail, in a list implemented as a stack (but that is not
>> > clearly advertised as such), don't convey the meaning of "we're
>> > iterating from the newest element pushed to the oldest one". This
>> > counter-intuitiveness is part of why I would really like to see this
>> > turned into a queue.
>>
>> OK.  I will change the comments, adding these semantics explanation.
>> The user should be warned :)
>
> Yes, that makes sense. After this generalization step, if you're ok with
> this, we could aim at moving the implementation from a stack to a queue
> and provide fifo semantic rather than lifo, so that other users (e.g.
> call_rcu in the kernel) can start benefiting from it.

I think that is good to move from stack to queue.

I will send out changed lock-less data structure patchset soon.  And
we can continue to work on the new lock-less queue at the same time.

Best Regards,
Huang Ying
