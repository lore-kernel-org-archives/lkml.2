Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab1KVKlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:41:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:60275 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1KVKlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:41:00 -0500
Message-ID: <1321958457.5148.17.camel@twins>
Subject: Re: [PATCH] perf_event: fix loss of notification with multi-event
 sampling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Tue, 22 Nov 2011 11:40:57 +0100
In-Reply-To: <20111116145320.GA20146@quad>
References: <20111116145320.GA20146@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 15:53 +0100, Stephane Eranian wrote:
> +       /* ring_buffer waitq pointer */
> +       wait_queue_head_t               *waitq; 

Not a big issue, but is there a reason to keep this pointer instead of
always having to do:

  rcu_read_lock();
  rb = rcu_dereference(event->rb);
  if (rb)
    wake_up_all(rb->waitq);
  rcu_read_unlock();

Hmm, looking at that there must be a reason we go through all the RCU
trouble for event->rb, assuming there is, your lack of rcu in say
perf_poll() could go funny.

/me ponders..

Ah, could it be a race of poll()/wakeup() vs perf_event_set_output() ?

Suppose you're a threaded proglet and either one cpu/thread has an
incoming event that does a wakeup, or one thread is stuck in poll()
whilst another thread does perf_event_set_output(), it could swizzle the
event->rb right out from under you.

Now, this is of course a somewhat silly thing to do.. but still it
shouldn't make things go *bang*.

Now the above wake_up_all() thing would work just fine, its just poll()
that I'm not sure how to fix.
