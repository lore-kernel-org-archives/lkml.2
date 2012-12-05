Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2LEMnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:43:23 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:44035 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2LEMnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:43:22 -0500
Message-ID: <50BF410F.5020204@linux.vnet.ibm.com>
Date: Wed, 05 Dec 2012 18:11:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, sbw@mit.edu, tj@kernel.org,
        amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/10] smp, cpu hotplug: Fix smp_call_function_*()
 to prevent CPU offline properly
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com> <20121204085419.25919.79543.stgit@srivatsabhat.in.ibm.com> <20121204141707.b792e488.akpm@linux-foundation.org>
In-Reply-To: <20121204141707.b792e488.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120512-6102-0000-0000-000002AB82D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 03:47 AM, Andrew Morton wrote:
> On Tue, 04 Dec 2012 14:24:28 +0530
> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> From: Michael Wang <wangyun@linux.vnet.ibm.com>
>>
>> With stop_machine() gone from the CPU offline path, we can't depend on
>> preempt_disable() to prevent CPUs from going offline from under us.
>>
>> Use the get/put_online_cpus_stable_atomic() APIs to prevent CPUs from going
>> offline, while invoking from atomic context.
>>
>> ...
>>
>>  	 */
>> -	this_cpu = get_cpu();
>> +	get_online_cpus_stable_atomic();
>> +	this_cpu = smp_processor_id();
> 
> I wonder if get_online_cpus_stable_atomic() should return the local CPU
> ID.  Just as a little convenience thing.  Time will tell.
>

With the new version which doesn't use extra cpumasks, we won't have to
bother about this..
 
>>  	/*
>>  	 * Can deadlock when called with interrupts disabled.
>>
>> ...
>>
>> @@ -380,15 +383,15 @@ int smp_call_function_any(const struct cpumask *mask,
>>  	nodemask = cpumask_of_node(cpu_to_node(cpu));
>>  	for (cpu = cpumask_first_and(nodemask, mask); cpu < nr_cpu_ids;
>>  	     cpu = cpumask_next_and(cpu, nodemask, mask)) {
>> -		if (cpu_online(cpu))
>> +		if (cpu_online_stable(cpu))
>>  			goto call;
>>  	}
>>  
>>  	/* Any online will do: smp_call_function_single handles nr_cpu_ids. */
>> -	cpu = cpumask_any_and(mask, cpu_online_mask);
>> +	cpu = cpumask_any_and(mask, cpu_online_stable_mask);
>>  call:
>>  	ret = smp_call_function_single(cpu, func, info, wait);
>> -	put_cpu();
>> +	put_online_cpus_stable_atomic();
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(smp_call_function_any);
> 
> So smp_call_function_any() has no synchronization against CPUs coming
> online.  Hence callers of smp_call_function_any() are responsible for
> ensuring that CPUs which are concurrently coming online will adopt the
> required state?
>

Yes.
 
> I guess that has always been the case...
> 

Right.

Regards,
Srivatsa S. Bhat

