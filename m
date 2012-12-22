Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851Ab2LVFms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 00:42:48 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34362 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LVFmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 00:42:45 -0500
MIME-Version: 1.0
In-Reply-To: <20121221185147.4ae48ab5@annuminas.surriel.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	<20121221185147.4ae48ab5@annuminas.surriel.com>
Date: Fri, 21 Dec 2012 21:42:44 -0800
Message-ID: <CANN689ETQgT48WkW4upUuv-5xj=g1wgkCuhW0AQ0H7pWfG1BPQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] x86,smp: auto tune spinlock backoff delay factor
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 3:51 PM, Rik van Riel <riel@redhat.com> wrote:
> Subject: x86,smp: auto tune spinlock backoff delay factor
>
> Many spinlocks are embedded in data structures; having many CPUs
> pounce on the cache line the lock is in will slow down the lock
> holder, and can cause system performance to fall off a cliff.
>
> The paper "Non-scalable locks are dangerous" is a good reference:
>
>         http://pdos.csail.mit.edu/papers/linux:lock.pdf
>
> In the Linux kernel, spinlocks are optimized for the case of
> there not being contention. After all, if there is contention,
> the data structure can be improved to reduce or eliminate
> lock contention.
>
> Likewise, the spinlock API should remain simple, and the
> common case of the lock not being contended should remain
> as fast as ever.
>
> However, since spinlock contention should be fairly uncommon,
> we can add functionality into the spinlock slow path that keeps
> system performance from falling off a cliff when there is lock
> contention.
>
> Proportional delay in ticket locks is delaying the time between
> checking the ticket based on a delay factor, and the number of
> CPUs ahead of us in the queue for this lock. Checking the lock
> less often allows the lock holder to continue running, resulting
> in better throughput and preventing performance from dropping
> off a cliff.
>
> Proportional spinlock delay with a high delay factor works well
> when there is lots contention on a lock. Likewise, a smaller
> delay factor works well when a lock is lightly contended.
>
> Making the code auto-tune the delay factor results in a system
> that performs well with both light and heavy lock contention.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>

So I like the idea a lot, and I had never seen the auto-tuning as you
propose it. Your implementation looks simple enough and doesn't slow
the uncontended case, so props for that.

However, I have a few concerns about the behavior of this, which I
think deserve more experimentation (I may try helping with it after
new years).

One thing you mentioned in 0/3 is that the best value varies depending
on the number of CPUs contending. This is somewhat surprising to me; I
would have guessed/hoped that the (inc.tail - inc.head) multiplicative
factor would account for that already. I wonder if we can somehow
adjust the code so that a same constant would work no matter how many
threads are contending for the lock (note that one single read to the
spinlock word gives us both the current number of waiters and our
position among them).

The other factor that might change your auto-tuned value is the amount
of time that each thread holds the spinlock. I wonder what would
happen if the constant was tuned for spinlocks that have a low hold
time, and then used on spinlocks that might have a higher hold time.
obviously this would result in accessing the spinlock word more often
than necessary, but it shouldn't be very bad since the accesses
wouldn't be any more frequent than in the low hold time case, where
throughput is good. So maybe this would work acceptably well.

What I'm getting at is that I would be more confident that the
autotune algorithm will work well in all cases if the value only
depended on the system parameters such as CPU type and frequency,
rather than per-spinlock parameters such as number of waiters and hold
time.

I feel this review is too high-level to be really helpful, so I'll
stop until I can find time to experiment :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
