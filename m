Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2LKNPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:15:31 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:55502 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LKNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:15:30 -0500
Message-ID: <50C73192.9010905@linux.vnet.ibm.com>
Date: Tue, 11 Dec 2012 18:43:54 +0530
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
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com> <20121209191437.GA2816@redhat.com> <50C4EB79.5050203@linux.vnet.ibm.com> <20121209202234.GA5793@redhat.com> <50C564ED.9090803@linux.vnet.ibm.com> <20121210172410.GA28479@redhat.com>
In-Reply-To: <20121210172410.GA28479@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121113-2000-0000-0000-00000A376BB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 10:54 PM, Oleg Nesterov wrote:
> On 12/10, Srivatsa S. Bhat wrote:
>>
>> On 12/10/2012 01:52 AM, Oleg Nesterov wrote:
>>> On 12/10, Srivatsa S. Bhat wrote:
>>>>
>>>> On 12/10/2012 12:44 AM, Oleg Nesterov wrote:
>>>>
>>>>> But yes, it is easy to blame somebody else's code ;) And I can't suggest
>>>>> something better at least right now. If I understand correctly, we can not
>>>>> use, say, synchronize_sched() in _cpu_down() path
>>>>
>>>> We can't sleep in that code.. so that's a no-go.
>>>
>>> But we can?
>>>
>>> Note that I meant _cpu_down(), not get_online_cpus_atomic() or take_cpu_down().
>>>
>>
>> Maybe I'm missing something, but how would it help if we did a
>> synchronize_sched() so early (in _cpu_down())? Another bunch of preempt_disable()
>> sections could start immediately after our call to synchronize_sched() no?
>> How would we deal with that?
> 
> Sorry for confusion. Of course synchronize_sched() alone is not enough.
> But we can use it to synchronize with preempt-disabled section and avoid
> the barriers/atomic in the fast-path.
> 
> For example,
> 
> 	bool writer_pending;
> 	DEFINE_RWLOCK(writer_rwlock);
> 	DEFINE_PER_CPU(int, reader_ctr);
> 
> 	void get_online_cpus_atomic(void)
> 	{
> 		preempt_disable();
> 	
> 		if (likely(!writer_pending) || __this_cpu_read(reader_ctr)) {
> 			__this_cpu_inc(reader_ctr);
> 			return;
> 		}
> 
> 		read_lock(&writer_rwlock);
> 		__this_cpu_inc(reader_ctr);
> 		read_unlock(&writer_rwlock);
> 	}
> 
> 	// lacks release semantics, but we don't care
> 	void put_online_cpus_atomic(void)
> 	{
> 		__this_cpu_dec(reader_ctr);
> 		preempt_enable();
> 	}
> 
> Now, _cpu_down() does
> 
> 	writer_pending = true;
> 	synchronize_sched();
> 
> before stop_one_cpu(). When synchronize_sched() returns, we know that
> every get_online_cpus_atomic() must see writer_pending == T. And, if
> any CPU incremented its reader_ctr we must see it is not zero.
> 
> take_cpu_down() does
> 
> 	write_lock(&writer_rwlock);
> 
> 	for_each_online_cpu(cpu) {
> 		while (per_cpu(reader_ctr, cpu))
> 			cpu_relax();
> 	}
> 
> and takes the lock.
> 
> However. This can lead to the deadlock we already discussed. So
> take_cpu_down() should do
> 
>  retry:
> 	write_lock(&writer_rwlock);
> 
> 	for_each_online_cpu(cpu) {
> 		if (per_cpu(reader_ctr, cpu)) {
> 			write_unlock(&writer_rwlock);
> 			goto retry;
> 		}
> 	}
> 
> to take the lock. But this is livelockable. However, I do not think it
> is possible to avoid the livelock.
> 
> Just in case, the code above is only for illustration, perhaps it is not
> 100% correct and perhaps we can do it better. cpu_hotplug.active_writer
> is ignored for simplicity, get/put should check current == active_writer.
> 

This approach (of using synchronize_sched()) also looks good. It is simple,
yet effective, but unfortunately inefficient at the writer side (because
he'll have to wait for a full synchronize_sched()).

So I would say that we should keep this approach as a fallback, if we don't
come up with any better synchronization scheme (in terms of efficiency) at
a comparable level of simplicity/complexity.

I have come up with a v4 that simplifies several aspects of the synchronization
and makes it look a lot more simpler than v3. (Lesser race windows to take
care of, implicit ACKs, no atomic ops etc..)

I'll post it soon. Let me know what you think...

Regards,
Srivatsa S. Bhat

