Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424189Ab2LGU1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:27:19 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:52489 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2LGU1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:27:17 -0500
Message-ID: <50C250CA.8070209@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2012 01:55:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tj@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, sbw@mit.edu, amit.kucheria@linaro.org,
        rostedt@goodmis.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"	atomic
 readers to prevent CPU offline
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com> <50BF96DF.3000500@linux.vnet.ibm.com> <50BF979A.50304@linux.vnet.ibm.com> <50BF982D.7090704@linux.vnet.ibm.com> <50BF98F7.3030600@linux.vnet.ibm.com> <50BF999C.6030707@linux.vnet.ibm.com> <50BFAB17.3090603@linux.vnet.ibm.com> <20121206161850.GA6710@redhat.com> <50C0E88E.9050909@linux.vnet.ibm.com> <20121207195629.GA13238@redhat.com>
In-Reply-To: <20121207195629.GA13238@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120720-8878-0000-0000-000005157533
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2012 01:26 AM, Oleg Nesterov wrote:
> On 12/07, Srivatsa S. Bhat wrote:
>>
>> On 12/06/2012 09:48 PM, Oleg Nesterov wrote:
>>> On 12/06, Srivatsa S. Bhat wrote:
>>>>
>>>> +void get_online_cpus_atomic(void)
>>>> +{
>>>> +	int c, old;
>>>> +
>>>> +	preempt_disable();
>>>> +	read_lock(&hotplug_rwlock);
>>>
>>> Confused... Why it also takes hotplug_rwlock?
>>
>> To avoid ABBA deadlocks.
>>
>> hotplug_rwlock was meant for the "light" readers.
>> The atomic counters were meant for the "heavy/full" readers.
> 
> OK, I got lost a bit. I'll try to read v3 tomorrow.
> 

OK, thanks! But note that v3 is completely different from v2.

>>> Obviously you can't use get_online_cpus_atomic() under rq->lock or
>>> task->pi_lock or any other lock CPU_DYING can take. Probably this is
>>> fine, but perhaps it makes sense to add the lockdep annotations.
>>
>> Hmm, you are right. We can't use _atomic() in the CPU_DYING path.
> 
> Not sure I undestand... I simply meant that, say,
> get_online_cpus_atomic() under task->pi_lock can obviously deadlock
> with take_cpu_down() which can want the same task->pi_lock after
> disable_atomic_reader().
> 

Right, I mistook your point for something else (i.e., ability for
the writer to do get_online_cpus_atomic() safely, which I fixed in
v3).

So, your point above is very valid. And yes, we can't do much
about it, we'll just have to teach lockdep to catch such usages.

Regards,
Srivatsa S. Bhat

