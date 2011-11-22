Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1KVNPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:15:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51330 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1KVNPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:15:31 -0500
MIME-Version: 1.0
In-Reply-To: <1321958457.5148.17.camel@twins>
References: <20111116145320.GA20146@quad>
	<1321958457.5148.17.camel@twins>
Date: Tue, 22 Nov 2011 14:15:30 +0100
Message-ID: <CABPqkBT-ZPZC2Ku6NjyMygWUU+kMr3h9FCdKTAjvhR6ywFmNqw@mail.gmail.com>
Subject: Re: [PATCH] perf_event: fix loss of notification with multi-event sampling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:40 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-11-16 at 15:53 +0100, Stephane Eranian wrote:
>> +       /* ring_buffer waitq pointer */
>> +       wait_queue_head_t               *waitq;
>
> Not a big issue, but is there a reason to keep this pointer instead of
> always having to do:
>
>  rcu_read_lock();
>  rb = rcu_dereference(event->rb);
>  if (rb)
>    wake_up_all(rb->waitq);
>  rcu_read_unlock();
>
> Hmm, looking at that there must be a reason we go through all the RCU
> trouble for event->rb, assuming there is, your lack of rcu in say
> perf_poll() could go funny.
>
I think we go drop waitq and go through event->rb each time we need to get
to the wait queue.

> /me ponders..
>
> Ah, could it be a race of poll()/wakeup() vs perf_event_set_output() ?
>
Are you saying that by dropping event->waitq in favor of event->rb->waitq
we make this problem disappear due to rcu protections?

Poll_wait() is a blocking call. It may wait on a stale waitq.  But that problem
was probably already there. I am not clear as to what to do about that.
in perf_set_output() you would need to wakeup from poll_wait() and then
go back in with the new waitq.

Similarly, I am not clear as to what happens when you close an event for
which you have  a waiter in poll_wait(). I assume you wakeup from it.
But I don't see where that's implemented.


> Suppose you're a threaded proglet and either one cpu/thread has an
> incoming event that does a wakeup, or one thread is stuck in poll()
> whilst another thread does perf_event_set_output(), it could swizzle the
> event->rb right out from under you.
>
> Now, this is of course a somewhat silly thing to do.. but still it
> shouldn't make things go *bang*.
>
> Now the above wake_up_all() thing would work just fine, its just poll()
> that I'm not sure how to fix.
>
