Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2LSSSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:18:15 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36660 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2LSSSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:18:06 -0500
Message-ID: <50D2047A.1040606@linux.vnet.ibm.com>
Date: Wed, 19 Dec 2012 23:46:26 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <50C8C4A5.4080104@linux.vnet.ibm.com> <20121212180248.GA24882@redhat.com> <50C8CD52.8040808@linux.vnet.ibm.com> <20121212184849.GA26784@redhat.com> <50C8D739.6030903@linux.vnet.ibm.com> <50C9F38F.3020005@linux.vnet.ibm.com> <50D0CCB3.10105@linux.vnet.ibm.com> <20121219163900.GA18516@redhat.com>
In-Reply-To: <20121219163900.GA18516@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121918-5564-0000-0000-000005DE605C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 10:09 PM, Oleg Nesterov wrote:
> (sorry if you see this email twice)
> 
> On 12/19, Srivatsa S. Bhat wrote:
>>
>> On 12/19/2012 01:13 AM, Oleg Nesterov wrote:
>>
>>>> I tried thinking about other ways to avoid that smp_mb() in the reader,
>>>
>>> Just in case, I think there is no way to avoid mb() in _get (although
>>> perhaps it can be "implicit").
>>>
>>
>> Actually, I was trying to avoid mb() in the _fastpath_, when there is no
>> active writer. I missed stating that clearly, sorry.
> 
> Yes, I meant the fastpath too,
> 
>>> The writer changes cpu_online_mask and drops the lock. We need to ensure
>>> that the reader sees the change in cpu_online_mask after _get returns.
>>>
>>
>> The write_unlock() will ensure the completion of the update to cpu_online_mask,
>> using the same semi-permeable logic that you pointed above. So readers will
>> see the update as soon as the writer releases the lock, right?
> 
> Why?
> 
> Once again, the writer (say) removes CPU_1 from cpu_online_mask, and
> sets writer_signal[0] = 0, this "enables" fast path on CPU_0.
> 
> But, without a barrier, there is no guarantee that CPU_0 will see the
> change in cpu_online_mask after get_online_cpus_atomic() checks
> writer_signal[0] and returns.
> 

Hmm, because a reader's code can get reordered to something like:

read cpu_online_mask

get_online_cpus_atomic()

You are right, I missed that.

> Hmm. And this means that the last version lacks the additional rmb()
> (at least) if writer_active() == F.
> 

Yes, the fast path needs that smp_rmb(), whereas the slow-path is fine,
because it takes the read_lock().

BTW, there is a small problem with the synchronize_sched() approach:
We can't generalize the synchronization scheme as a generic percpu rwlock
because the writer's role is split into 2, the first part (the one having
synchronize_sched()) which should be run in process context, and the
second part (the rest of it), which can be run in atomic context.

That is, needing the writer to be able to sleep (due to synchronize_sched())
will make the locking scheme unusable (in other usecases) I think. And
the split (blocking and non-blocking part) itself seems hard to express
as a single writer API.

Hmmm.. so what do we do? Shall we say "We anyway have to do smp_rmb() in the
reader in the fast path. Instead let's do a full smp_mb() and get rid of
the synchronize_sched() in the writer, and thereby expose this synchronization
scheme as generic percpu rwlocks?" Or should we rather use synchronize_sched()
and keep this synchronization scheme restricted to CPU hotplug only?

Regards,
Srivatsa S. Bhat

