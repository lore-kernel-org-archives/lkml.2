Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424756Ab2LFTiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:38:15 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:46629 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424743Ab2LFTiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:38:10 -0500
Message-ID: <50C0F3CA.7070105@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2012 01:06:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Oleg Nesterov <oleg@redhat.com>, tj@kernel.org, tglx@linutronix.de,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"	atomic
 readers to prevent CPU offline
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com> <50BF96DF.3000500@linux.vnet.ibm.com> <50BF979A.50304@linux.vnet.ibm.com> <50BF982D.7090704@linux.vnet.ibm.com> <50BF98F7.3030600@linux.vnet.ibm.com> <50BF999C.6030707@linux.vnet.ibm.com> <50BFAB17.3090603@linux.vnet.ibm.com> <20121206161850.GA6710@redhat.com> <50C0E88E.9050909@linux.vnet.ibm.com> <1354822103.17101.24.camel@gandalf.local.home>
In-Reply-To: <1354822103.17101.24.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120619-5564-0000-0000-000005ABF457
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 12:58 AM, Steven Rostedt wrote:
> On Fri, 2012-12-07 at 00:18 +0530, Srivatsa S. Bhat wrote:
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
>> I wanted them to be able to nest in any manner they wanted,
>> such as:
>>
>> Full inside light:
>>
>> get_online_cpus_atomic_light()
>> 	...
>> 	get_online_cpus_atomic_full()
>> 	...
>> 	put_online_cpus_atomic_full()
>> 	...
>> put_online_cpus_atomic_light()
>>
>> Or, light inside full:
>>
>> get_online_cpus_atomic_full()
>> 	...
>> 	get_online_cpus_atomic_light()
>> 	...
>> 	put_online_cpus_atomic_light()
>> 	...
>> put_online_cpus_atomic_full()
>>
>> To allow this, I made the two sets of APIs take the locks
>> in the same order internally.
>>
>> (I had some more description of this logic in the changelog
>> of 2/10; the only difference there is that instead of atomic
>> counters, I used rwlocks for the full-readers as well.
>> https://lkml.org/lkml/2012/12/5/320)
>>
> 
> You know reader locks can deadlock with each other, right? And this
> isn't caught be lockdep yet. This is because rwlocks have been made to
> be fair with writers. Before writers could be starved if a CPU always
> let a reader in. Now if a writer is waiting, a reader will block behind
> the writer. But this has introduced new issues with the kernel as
> follows:
> 
> 
>    CPU0			   CPU1	 	   CPU2		   CPU3
>    ----			   ----		   ----		   ----
> read_lock(A);
> 			read_lock(B)
> 					write_lock(A) <- block
> 							write_lock(B) <- block
> read_lock(B) <-block
> 
> 			read_lock(A) <- block
> 
> DEADLOCK!
> 

The root-cause of this deadlock is again lock-ordering mismatch right?
CPU0 takes locks in order A, B
CPU1 takes locks in order B, A

And the writer facilitates in actually getting deadlocked.

I avoid this in this patchset by always taking the locks in the same
order. So we won't be deadlocking like this.

Regards,
Srivatsa S. Bhat


