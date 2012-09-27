Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2I0LfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:35:21 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47201 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2I0LfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:35:18 -0400
Message-ID: <50643912.8090408@linux.vnet.ibm.com>
Date: Thu, 27 Sep 2012 17:01:30 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: dlaor@redhat.com, Chegu Vinod <chegu_vinod@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <505C691D.4080801@hp.com> <505CA5BA.4020801@linux.vnet.ibm.com> <50601CE7.60801@redhat.com> <50604BF0.1070607@linux.vnet.ibm.com> <5061C70E.2090308@redhat.com> <50642139.80309@linux.vnet.ibm.com> <20120927102832.GA4106@turtle.usersys.redhat.com>
In-Reply-To: <20120927102832.GA4106@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092711-4790-0000-0000-000004D075C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 03:58 PM, Andrew Jones wrote:
> On Thu, Sep 27, 2012 at 03:19:45PM +0530, Raghavendra K T wrote:
>> On 09/25/2012 08:30 PM, Dor Laor wrote:
>>> On 09/24/2012 02:02 PM, Raghavendra K T wrote:
>>>> On 09/24/2012 02:12 PM, Dor Laor wrote:
>>>>> In order to help PLE and pvticketlock converge I thought that a small
>>>>> test code should be developed to test this in a predictable,
>>>>> deterministic way.
>>>>>
>>>>> The idea is to have a guest kernel module that spawn a new thread each
>>>>> time you write to a /sys/.... entry.
>>>>>
>>>>> Each such a thread spins over a spin lock. The specific spin lock is
>>>>> also chosen by the /sys/ interface. Let's say we have an array of spin
>>>>> locks *10 times the amount of vcpus.
>>>>>
>>>>> All the threads are running a
>>>>> while (1) {
>>>>>
>>>>> spin_lock(my_lock);
>>>>> sum += execute_dummy_cpu_computation(time);
>>>>> spin_unlock(my_lock);
>>>>>
>>>>> if (sys_tells_thread_to_die()) break;
>>>>> }
>>>>>
>>>>> print_result(sum);
>>>>>
>>>>> Instead of calling the kernel's spin_lock functions, clone them and make
>>>>> the ticket lock order deterministic and known (like a linear walk of all
>>>>> the threads trying to catch that lock).
>>>>
>>>> By Cloning you mean hierarchy of the locks?
>>>
>>> No, I meant to clone the implementation of the current spin lock code in
>>> order to set any order you may like for the ticket selection.
>>> (even for a non pvticket lock version)
>>>
>>> For instance, let's say you have N threads trying to grab the lock, you
>>> can always make the ticket go linearly from 1->2...->N.
>>> Not sure it's a good idea, just a recommendation.
>>>
>>>> Also I believe time should be passed via sysfs / hardcoded for each
>>>> type of lock we are mimicking
>>>
>>> Yap
>>>
>>>>
>>>>>
>>>>> This way you can easy calculate:
>>>>> 1. the score of a single vcpu running a single thread
>>>>> 2. the score of sum of all thread scores when #thread==#vcpu all
>>>>> taking the same spin lock. The overall sum should be close as
>>>>> possible to #1.
>>>>> 3. Like #2 but #threads > #vcpus and other versions of #total vcpus
>>>>> (belonging to all VMs) > #pcpus.
>>>>> 4. Create #thread == #vcpus but let each thread have it's own spin
>>>>> lock
>>>>> 5. Like 4 + 2
>>>>>
>>>>> Hopefully this way will allows you to judge and evaluate the exact
>>>>> overhead of scheduling VMs and threads since you have the ideal result
>>>>> in hand and you know what the threads are doing.
>>>>>
>>>>> My 2 cents, Dor
>>>>>
>>>>
>>>> Thank you,
>>>> I think this is an excellent idea. ( Though I am trying to put all the
>>>> pieces together you mentioned). So overall we should be able to measure
>>>> the performance of pvspinlock/PLE improvements with a deterministic
>>>> load in guest.
>>>>
>>>> Only thing I am missing is,
>>>> How to generate different combinations of the lock.
>>>>
>>>> Okay, let me see if I can come with a solid model for this.
>>>>
>>>
>>> Do you mean the various options for PLE/pvticket/other? I haven't
>>> thought of it and assumed its static but it can also be controlled
>>> through the temporary /sys interface.
>>>
>>
>> No, I am not there yet.
>>
>> So In summary, we are suffering with inconsistent benchmark result,
>> while measuring the benefit of our improvement in PLE/pvlock etc..
>
> Are you measuring the combined throughput of all running guests, or
> just looking at the results of the benchmarks in a single test guest?
>
> I've done some benchmarking as well and my stddevs look pretty good for
> kcbench, ebizzy, dbench, and sysbench-memory. I do 5 runs for each
> overcommit level (1.0 - 3.0, stepped by .25 or .5), and 2 runs of that
> full sequence of tests (one with the overcommit levels in scrambled
> order). The relative stddevs for each of the sets of 5 runs look pretty
> good, and the data for the 2 runs match nicely as well.
>
> To try and get consistent results I do the following
> - interleave the memory of all guests across all numa nodes on the
>    machine
> - echo 0 > /proc/sys/kernel/randomize_va_space on both host and test
>    guest

I was not doing this.

> - echo 3 > /proc/sys/vm/drop_caches on both host and test guest before
>    each run

was doing already as you know

> - use a ramdisk for the benchmark output files on all running guests

Yes.. this is also helpful

> - no periodically running services installed on the test guest
> - HT is turned off as you do, although I'd like to try running again
>    with it turned back on
> Although, I still need to run again measuring the combined throughput
> of all running vms (including the ones launched just to generate busy
> vcpus). Maybe my results won't be as consistent then...

May be. I take average from all the VMs..

>
> Drew
>
>>
>> So good point from your suggestion is,
>> - Giving predictability to workload that runs in guest, so that we have
>> pi-pi comparison of improvement.
>>
>> - we can easily tune the workload via sysfs, and we can have script to
>> automate them.
>>
>> What is complicated is:
>> - How can we simulate a workload close to what we measure with
>> benchmarks?
>> - How can we mimic lock holding time/ lock hierarchy close to the way
>> it is seen with real workloads (for e.g. highly contended zone lru lock
>> with similar amount of lockholding times).
>> - How close it would be to when we forget about other types of spinning
>> (for e.g, flush_tlb).
>>
>> So I feel it is not as trivial as it looks like.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

