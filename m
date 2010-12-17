Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0LQOMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:12:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab0LQOMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:12:15 -0500
Subject: Re: likely() vs. unlikely()
From: Steven Rostedt <srostedt@redhat.com>
To: Daniel Kopko <dk_fedorabugs@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <37836.43110.qm@web120713.mail.ne1.yahoo.com>
References: <294021.5068.qm@web120709.mail.ne1.yahoo.com>
	 <1292423418.2733.220.camel@fedora>
	 <37836.43110.qm@web120713.mail.ne1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 17 Dec 2010 09:12:13 -0500
Message-ID: <1292595133.31039.10.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 22:07 -0800, Daniel Kopko wrote:

> OK, perhaps I'm misusing "fastpath" here.  I just mean the path where latency is 
> more of a concern.  Also, I agree with your last point here, but I have a couple 
> of more concrete counter-examples below for which I don't think the last 
> statement holds true.

Actually, we have used unlikely() for latency concerns and not really
just "what is more likely", but that is usually discouraged, and no
annotation is recommended.


> 
> OK, so here are two examples that perhaps better illustrate my point:
> 
> 1)  A spinlock.  This one is not one from the kernel, just one implemented in 
> userspace:

I'll ignore the fact that userspace spin locks is an extremely bad idea.
It is prone to live locks when used on RT systems. This is why futex was
made (fast userspace mutex). It is just as fast as userspace imlemented
spin locks, but is does not have the live lock problems.

> 
> #define CACHE_PAUSE() __asm__ __volatile__ ("pause" : :) 
> #define SPIN_ACQUIRE_LOCK(x) do { while(unlikely(__sync_lock_test_and_set(&(x), 
> 1))) { CACHE_PAUSE(); } } while(0)
> 
> Let's assume, for sake of argument, that this lock is known to be highly 
> contended.  (And let's ignore any better alternatives to spinlocks for this 
> case, this is just illustrative.)  Due to the high contention, the 
> __sync_lock_test_and_set() call will in the vast majority of cases return 1, 
> indicating the lock was already taken.  However, even though the result is 
> *likely 1*, we do not want to use likely() here, but instead unlikely().  The 
> reason being is that the penalty of the incorrect unlikely() usage occurs on a 
> path for which we have nothing better to do anyway, we're just going to pause 
> for a moment waiting for the lock to become free.  However, in the smaller 
> fraction of time in which the lock is available, we want to suffer as little 
> penalty as possible.  It seems that it is correct here to invert/abuse 
> unlikely() to cause the penalty to be paid in say 90% of cases (which are just 
> going to wait anyway), in order to not pay the penalty at all in the 10% of 
> cases where work can actually progress.

Actually, the best thing to do in this case, is simply do not use
likely() or unlikely(). But I do understand the point.


> 
> 2) Suppose there is message processing system which has two classifications of 
> messages:  LOWEST_LATENCY, NORMAL.  When a message is submitted into this 
> system, it can be submitted with a flag/enum which indicates which type of 
> message it is.  The logic then goes something like this:
> 
> if(message_type == LOWEST_LATENCY)
> {
>      do { sendmsg(msg); } while(errno == EAGAIN);
> }
> else
>         enqueue_message_for_subsequent_send(msg);
> 
> Setting all messages to LOWEST_LATENCY would actually probably degrade 
> performance, but let's say roughly 5-10% are set with this flag, and the rest of 
> the messages are NORMAL.  I would argue that even though it is actually 
> *unlikely* for message_type to be LOWEST_LATENCY, it would be appropriate to use 
> likely(message_type == LOWEST_LATENCY) here.  The reason being that we want to 
> optimize for latency for things requesting LOWEST_LATENCY, and permit the 
> latency degradation which is thereby caused to messages which are indifferent to 
> latency (NORMAL transmissions).  It doesn't even matter whether or not our 
> average latency across all messages has increased, what matters is that for the 
> messages marked as sensitive to latency, average latency has decreased.
> 
> Now, I am aware that as latency increases elsewhere in the system (the NORMAL 
> handling), that this may bog down the processing loop and ultimately impact the 
> LOWEST_LATENCY handling as well.  However, this is *not necessarily* the case.  
> Nothing says that the processing loop must be handling so many messages that the 
> likely()/unlikely() inversion costs so much that the loop must slow down.  In 
> fact, the processing loop may have enough intervals where it has nothing to do 
> that it can readily absorb the additional latency of the NORMAL handling in the 
> time it would have otherwise spent waiting.  And indeed, for some applications, 
> this is the case.

We usually don't have this worry in the kernel, since the kernel itself
tries to be fair. In cases that we use likely() or unlikey() for latency
reasons, would require a comment more than a new interface. This sounds
like a case by case instance. Not something that would be commented by a
"inverse_unlikely()" notation. Simply using the normal likely() and
unlikely() and commenting it above the usage is good enough.

> 
> 
> These are the only two cases which I've personally come across.  In these cases, 
> I tested performance with and without the inversions, and was satisfied by the 
> improvements that the inversions gave me.  I hadn't ever heard anyone discuss 
> something like this, so I figured I should air it on LKML.  If there's yet a 
> flaw in my reasoning, I'm sure you (or some other expert) will let me know.  :)  
> Even if there isn't, I do not know enough to say if any situations like the 
> above even occur in the kernel code to where an inversion would be appropriate.

Again, these sound like case by case exceptions to the rule. For which a
good comment is much better than any new interface.

-- Steve


