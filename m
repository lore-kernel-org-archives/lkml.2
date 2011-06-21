Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1FUTrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:47:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28398 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1FUTrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o6eONigzRxvhckeH715sxVPRdIctrNr+D9RLBSCH1DpInSHEmGos5dzGec0cI64N7y
         5lnHEIi6SUHbAvYyWBkQ==
MIME-Version: 1.0
In-Reply-To: <4E0072AF.1090601@jp.fujitsu.com>
References: <20110621071649.862846205@google.com> <20110621071701.268573809@google.com>
 <4E0072AF.1090601@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 21 Jun 2011 12:46:42 -0700
Message-ID: <BANLkTi=5+f31e5WkRgu1u+BnJf09so4zQj=5H5Q947OCvXdgOw@mail.gmail.com>
Subject: Re: [patch 16/16] sched: add documentation for bandwidth control
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 3:30 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> Minor typos/nitpicks:
>
> (2011/06/21 16:17), Paul Turner wrote:
>> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
>>
>> Basic description of usage and effect for CFS Bandwidth Control.
>>
>> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
>> Signed-off-by: Paul Turner <pjt@google.com>
>> ---
>>  Documentation/scheduler/sched-bwc.txt |   98
>>  ++++++++++++++++++++++++++++++++++
>>  Documentation/scheduler/sched-bwc.txt |  110 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 110 insertions(+)
>>
>> Index: tip/Documentation/scheduler/sched-bwc.txt
>> ===================================================================
>> --- /dev/null
>> +++ tip/Documentation/scheduler/sched-bwc.txt
>> @@ -0,0 +1,110 @@
>> +CFS Bandwidth Control
>> +=====================
>> +
>> +[ This document talks about CPU bandwidth control for CFS groups only.
>> +  Bandwidth control for RT groups covered in:
>> +  Documentation/scheduler/sched-rt-group.txt ]
>> +
>> +CFS bandwidth control is a group scheduler extension that can be used to
>> +control the maximum CPU bandwidth obtained by a CPU cgroup.
>> +
>> +Bandwidth allowed for a group is specified using quota and period. Within
>> +a given "period" (microseconds), a group is allowed to consume up to "quota"
>> +microseconds of CPU time, which is the upper limit or the hard limit. When the
>> +CPU bandwidth consumption of a group exceeds the hard limit, the tasks in the
>> +group are throttled and are not allowed to run until the end of the period at
>> +which time the group's quota is replenished.
>> +
>> +Runtime available to the group is tracked globally. At the beginning of
>> +each period, the group's global runtime pool is replenished with "quota"
>> +microseconds worth of runtime.  This bandwidth is then transferred to cpu local
>> +"accounts" on a demand basis.  Thie size of this transfer is described as a
>
>                                  The ?
>
>> +"slice".
>> +
>> +Interface
>> +---------
>> +Quota and period can be set via cgroup files.
>> +
>> +cpu.cfs_quota_us: the enforcement interval (microseconds)
>> +cpu.cfs_period_us: the maximum allowed bandwidth (microseconds)
>> +
>> +Within a period of cpu.cfs_period_us, the group as a whole will not be allowed
>> +to consume more than cpu_cfs_quota_us worth of runtime.
>> +
>> +The default value of cpu.cfs_period_us is 100ms and the default value
>> +for cpu.cfs_quota_us is -1.
>> +
>> +A group with cpu.cfs_quota_us as -1 indicates that the group has infinite
>> +bandwidth, which means that it is not bandwidth controlled.
>
> (I think it's better to use "unconstrained (bandwidth) group" as the
>  standardized expression instead of "infinite bandwidth group", so ...)
>
>                                               ... controlled. Such group is
> described as an unconstrained bandwidth group.
>
>> +
>> +Writing any negative value to cpu.cfs_quota_us will turn the group into
>> +an infinite bandwidth group. Reading cpu.cfs_quota_us for an unconstrained
>      ^^^^^^^^
>      unconstrained
>
>> +bandwidth group will always return -1.
>> +
>> +System wide settings
>> +--------------------
>> +The amount of runtime obtained from global pool every time a CPU wants the
>> +group quota locally is controlled by a sysctl parameter
>> +sched_cfs_bandwidth_slice_us. The current default is 5ms. This can be changed
>> +by writing to /proc/sys/kernel/sched_cfs_bandwidth_slice_us.
>> +
>> +Statistics
>> +----------
>> +cpu.stat file lists three different stats related to bandwidth control's
>> +activity.
>> +
>> +- nr_periods: Number of enforcement intervals that have elapsed.
>> +- nr_throttled: Number of times the group has been throttled/limited.
>> +- throttled_time: The total time duration (in nanoseconds) for which entities
>> +  of the group have been throttled.
>> +
>> +These files are read-only.
>> +
>> +Hierarchy considerations
>> +------------------------
>> +The interface enforces that an individual entity's bandwidth is always
>> +attainable, that is: max(c_i) <= C. However, over-subscription in the
>> +aggregate case is explicitly allowed:
>> +  e.g. \Sum (c_i) may exceed C
>> +[ Where C is the parent's bandwidth, and c_i its children ]
>> +
>> +There are two ways in which a group may become throttled:
>> +
>> +a. it fully consumes its own quota within a period
>> +b. a parent's quota is fully consumed within its period
>> +
>> +In case b above, even though the child may have runtime remaining it will not
>> +be allowed to un until the parent's runtime is refreshed.
>
>                 run ?
>
>> +
>> +Examples
>> +--------
>> +1. Limit a group to 1 CPU worth of runtime.
>> +
>> +     If period is 250ms and quota is also 250ms, the group will get
>> +     1 CPU worth of runtime every 250ms.
>> +
>> +     # echo 500000 > cpu.cfs_quota_us /* quota = 250ms */
>               ~~~~~~
>               250000 ?
>
>> +     # echo 250000 > cpu.cfs_period_us /* period = 250ms */
>> +
>> +2. Limit a group to 2 CPUs worth of runtime on a multi-CPU machine.
>> +
>> +     With 500ms period and 1000ms quota, the group can get 2 CPUs worth of
>> +     runtime every 500ms.
>> +
>> +     # echo 1000000 > cpu.cfs_quota_us /* quota = 1000ms */
>> +     # echo 500000 > cpu.cfs_period_us /* period = 500ms */
>> +
>> +     The larger period here allows for increased burst capacity.
>> +
>> +3. Limit a group to 20% of 1 CPU.
>> +
>> +     With 50ms period, 10ms quota will be equivalent to 20% of 1 CPU.
>> +
>> +     # echo 10000 > cpu.cfs_quota_us /* quota = 10ms */
>> +     # echo 50000 > cpu.cfs_period_us /* period = 50ms */
>> +
>> +     By using a small period her we are ensuring a consistent latency
>
>                                here ?
>
>> +     response at the expense of burst capacity.
>> +
>> +
>> +
>
> Blank lines at EOF ?
>
>
> Thank you for improving the document!  Especially I think it is pretty
> good that now it provide examples of how "period" is used.

Yeah I gave Bharata's documentation a once-over, the errors above are
a mix of original and introduced.  :(

I'll clean up the nits above as well as doing a proper general editing
pass for language and flow.

>
> For the rests in the V7 set (overall it looks very good), give me some
> time to review & tests. ;-)
>

Sounds good!  Thanks!

>
> Thanks,
> H.Seto
>
>
