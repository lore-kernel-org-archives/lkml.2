Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab3AIMwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 07:52:54 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50900 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab3AIMww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 07:52:52 -0500
Message-ID: <50ED679B.9020306@linux.vnet.ibm.com>
Date: Wed, 09 Jan 2013 18:20:35 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, mingo@redhat.com
Subject: Re: [PATCH 0/5] x86,smp: make ticket spinlock proportional backoff
 w/ auto tuning
References: <20130108172632.1126898a@annuminas.surriel.com>
In-Reply-To: <20130108172632.1126898a@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010912-5490-0000-0000-000002C674AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 03:56 AM, Rik van Riel wrote:
> Many spinlocks are embedded in data structures; having many CPUs
> pounce on the cache line the lock is in will slow down the lock
> holder, and can cause system performance to fall off a cliff.
>
> The paper "Non-scalable locks are dangerous" is a good reference:
>
> 	http://pdos.csail.mit.edu/papers/linux:lock.pdf
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
> The test case has a number of threads locking and unlocking a
> semaphore. With just one thread, everything sits in the CPU
> cache and throughput is around 2.6 million operations per
> second, with a 5-10% variation.
>
> Once a second thread gets involved, data structures bounce
> from CPU to CPU, and performance deteriorates to about 1.25
> million operations per second, with a 5-10% variation.
>
> However, as more and more threads get added to the mix,
> performance with the vanilla kernel continues to deteriorate.
> Once I hit 24 threads, on a 24 CPU, 4 node test system,
> performance is down to about 290k operations/second.
>
> With a proportional backoff delay added to the spinlock
> code, performance with 24 threads goes up to about 400k
> operations/second with a 50x delay, and about 900k operations/second
> with a 250x delay. However, with a 250x delay, performance with
> 2-5 threads is worse than with a 50x delay.
>
> Making the code auto-tune the delay factor results in a system
> that performs well with both light and heavy lock contention,
> and should also protect against the (likely) case of the fixed
> delay factor being wrong for other hardware.
>
> The attached graph shows the performance of the multi threaded
> semaphore lock/unlock test case, with 1-24 threads, on the
> vanilla kernel, with 10x, 50x, and 250x proportional delay,
> as well as the v1 patch series with autotuning for 2x and 2.7x
> spinning before the lock is obtained, and with the v2 series.
>
> The v2 series integrates several ideas from Michel Lespinasse
> and Eric Dumazet, which should result in better throughput and
> nicer behaviour in situations with contention on multiple locks.
>
> For the v3 series, I tried out all the ideas suggested by
> Michel. They made perfect sense, but in the end it turned
> out they did not work as well as the simple, aggressive
> "try to make the delay longer" policy I have now. Several
> small bug fixes and cleanups have been integrated.
>
> Performance is within the margin of error of v2, so the graph
> has not been update.
>
> Please let me know if you manage to break this code in any way,
> so I can fix it...
>

Patch series does not show anymore weird behaviour because of the
underflow (pointed by Michael) and looks fine.

I ran kernbench on 32 core (mx3850) machine with 3.8-rc2 base.
x base_3.8rc2
+ rik_backoff
     N           Min           Max        Median           Avg        Stddev
x   8       222.977        231.16       227.735       227.388     3.1512986
+   8        218.75       232.347      229.1035     228.25425     4.2730225
No difference proven at 95.0% confidence

The run did not show much difference. But I believe a spinlock stress
test would have shown the benefit.
I 'll start running benchmarks now on kvm guests and comeback with report.

