Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2JaGlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:41:20 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:50787 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab2JaGlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:41:17 -0400
Message-ID: <5090C6F2.5030103@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2012 12:06:34 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com, Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH V2 RFC 0/3] kvm: Improving undercommit,overcommit scenarios
References: <20121029140621.15448.92083.sendpatchset@codeblue> <1351599420.23105.14.camel@oc6622382223.ibm.com>
In-Reply-To: <1351599420.23105.14.camel@oc6622382223.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12103106-3864-0000-0000-0000054F992E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 05:47 PM, Andrew Theurer wrote:
> On Mon, 2012-10-29 at 19:36 +0530, Raghavendra K T wrote:
>> In some special scenarios like #vcpu <= #pcpu, PLE handler may
>> prove very costly, because there is no need to iterate over vcpus
>> and do unsuccessful yield_to burning CPU.
>>
>>   Similarly, when we have large number of small guests, it is
>> possible that a spinning vcpu fails to yield_to any vcpu of same
>> VM and go back and spin. This is also not effective when we are
>> over-committed. Instead, we do a yield() so that we give chance
>> to other VMs to run.
>>
>> This patch tries to optimize above scenarios.
>>
>>   The first patch optimizes all the yield_to by bailing out when there
>>   is no need to continue yield_to (i.e., when there is only one task
>>   in source and target rq).
>>
>>   Second patch uses that in PLE handler.
>>
>>   Third patch uses overall system load knowledge to take decison on
>>   continuing in yield_to handler, and also yielding in overcommits.
>>   To be precise,
>>   * loadavg is converted to a scale of 2048  / per CPU
>>   * a load value of less than 1024 is considered as undercommit and we
>>   return from PLE handler in those cases
>>   * a load value of greater than 3586 (1.75 * 2048) is considered as overcommit
>>    and  we yield to other VMs in such cases.
>>
>> (let threshold = 2048)
>> Rationale for using threshold/2 for undercommit limit:
>>   Having a load below (0.5 * threshold) is used to avoid (the concern rasied by Rik)
>> scenarios where we still have lock holder preempted vcpu waiting to be
>> scheduled. (scenario arises when rq length is > 1 even when we are under
>> committed)
>>
>> Rationale for using (1.75 * threshold) for overcommit scenario:
>> This is a heuristic where we should probably see rq length > 1
>> and a vcpu of a different VM is waiting to be scheduled.
>>
>>   Related future work (independent of this series):
>>
>>   - Dynamically changing PLE window depending on system load.
>>
>>   Result on 3.7.0-rc1 kernel shows around 146% improvement for ebizzy 1x
>>   with 32 core PLE machine with 32 vcpu guest.
>>   I believe we should get very good improvements for overcommit (especially > 2)
>>   on large machines with small vcpu guests. (Could not test this as I do not have
>>   access to a bigger machine)
>>
>> base = 3.7.0-rc1
>> machine: 32 core mx3850 x5 PLE mc
>>
>> --+-----------+-----------+-----------+------------+-----------+
>>                 ebizzy (rec/sec higher is beter)
>> --+-----------+-----------+-----------+------------+-----------+
>>      base        stdev       patched     stdev       %improve
>> --+-----------+-----------+-----------+------------+-----------+
>> 1x  2543.3750    20.2903    6279.3750    82.5226   146.89143
>> 2x  2410.8750    96.4327    2450.7500   207.8136     1.65396
>> 3x  2184.9167   205.5226    2178.3333    97.2034    -0.30131
>> --+-----------+-----------+-----------+------------+-----------+
>>
>> --+-----------+-----------+-----------+------------+-----------+
>>          dbench (throughput in MB/sec. higher is better)
>> --+-----------+-----------+-----------+------------+-----------+
>>      base        stdev       patched     stdev       %improve
>> --+-----------+-----------+-----------+------------+-----------+
>> 1x  5545.4330   596.4344    7042.8510  1012.0924    27.00272
>> 2x  1993.0970    43.6548    1990.6200    75.7837    -0.12428
>> 3x  1295.3867    22.3997    1315.5208    36.0075     1.55429
>> --+-----------+-----------+-----------+------------+-----------+
>
> Could you include a PLE-off result for 1x over-commit, so we know what
> the best possible result is?

Yes,

base no PLE

ebizzy_1x 7651.3000 rec/sec
ebizzy_2x   51.5000 rec/sec

ebizzy we are closer.

dbench_1x 12631.4210 MB/sec
dbench_2x 45.0842    MB/sec

(strangely dbench 1x result is not consistent sometime despite 10 runs
of 3min + 30 sec warmup runs on a 3G tmpfs. But surely it tells the trend)

>
> Looks like skipping the yield_to() for rq = 1 helps, but I'd like to
> know if the performance is the same as PLE off for 1x.  I am concerned
> the vcpu to task lookup is still expensive.
>

Yes. I still see that.

> Based on Peter's comments I would say the 3rd patch and the 2x,3x
> results are not conclusive at this time.

Avi, IMO patch 1 and 2 seem to be good to go. Please let me know.

>
> I think we should also discuss what we think a good target is.  We
> should know what our high-water mark is, and IMO, if we cannot get
> close, then I do not feel we are heading down the right path.  For
> example, if dbench aggregate throughput for 1x with PLE off is 10000
> MB/sec, then the best possible 2x,3x result, should be a little lower
> than that due to task switching the vcpus and sharing chaches.  This
> should be quite evident with current PLE handler and smaller VMs (like
> 10 vcpus or less).

Very much agree here. If we see the 2x 3x results (all/any of them).
aggregate is not near 1x. May be even 70% is a good target.

