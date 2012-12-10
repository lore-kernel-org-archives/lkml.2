Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab2LJFVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 00:21:30 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60438 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2LJFV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 00:21:28 -0500
Message-ID: <50C570F9.2020801@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 10:49:53 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: rostedt@goodmis.org, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, tj@kernel.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com> <20121209205733.GA7038@redhat.com>
In-Reply-To: <20121209205733.GA7038@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121005-7014-0000-0000-00000251C7B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 02:27 AM, Oleg Nesterov wrote:
> On 12/07, Srivatsa S. Bhat wrote:
>>
>> 4. No deadlock possibilities
>>
>>    Per-cpu locking is not the way to go if we want to have relaxed rules
>>    for lock-ordering. Because, we can end up in circular-locking dependencies
>>    as explained in https://lkml.org/lkml/2012/12/6/290
> 
> OK, but this assumes that, contrary to what Steven said, read-write-read
> deadlock is not possible when it comes to rwlock_t.

What I meant is, with a single (global) rwlock, you can't deadlock like that.
But if you used per-cpu rwlocks and if we don't implement them properly, then we
can end up in circular locking dependencies like shown above.

That is, if you take the same example and replace the lock with global
rwlock, you won't deadlock:


Readers:

         CPU 0                                CPU 1
         ------                               ------

1.    spin_lock(&random_lock);             read_lock(&my_rwlock);


2.    read_lock(&my_rwlock);               spin_lock(&random_lock);


Writer:

         CPU 2:
         ------

       write_lock(&my_rwlock);


Even if the writer does a write_lock() in-between steps 1 and 2 at the reader-
side, nothing will happen. The writer would spin because CPU 1 already got
the rwlock for read, and hence both CPU 0 and 1 go ahead. When they finish,
the writer will get the lock and proceed. So, no deadlocks here.
So, what I was pointing out here was, if somebody replaced this global
rwlock with a "straight-forward" implementation of per-cpu rwlocks, he'll
immediately end up in circular locking dependency deadlock between the 3
entities as explained in the link above.

Let me know if my assumptions are incorrect!

> So far I think this
> is true and we can't deadlock. Steven?
> 
> However. If this is true, then compared to preempt_disable/stop_machine
> livelock is possible. Probably this is fine, we have the same problem with
> get_online_cpus(). But if we can accept this fact I feel we can simmplify
> this somehow... Can't prove, only feel ;)
> 

Not sure I follow..

Anyway, my point is that, we _can't_ implement per-cpu rwlocks like lglocks
and expect it to work in this case. IOW, we can't do:

Reader-side:
   -> read_lock() your per-cpu rwlock and proceed.

Writer-side:
   -> for_each_online_cpu(cpu)
          write_lock(per-cpu rwlock of 'cpu');


Also, like Tejun said, one of the important measures for per-cpu rwlocks
should be that, if a user replaces global rwlocks with percpu rwlocks (for
performance reasons), he shouldn't suddenly end up in numerous deadlock
possibilities which never existed before. The replacement should continue to
remain safe, and perhaps improve the performance.

Regards,
Srivatsa S. Bhat

