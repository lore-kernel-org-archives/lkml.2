Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1FUKar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:30:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43331 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1FUKap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:30:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E0072AF.1090601@jp.fujitsu.com>
Date: Tue, 21 Jun 2011 19:30:07 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 16/16] sched: add documentation for bandwidth control
References: <20110621071649.862846205@google.com> <20110621071701.268573809@google.com>
In-Reply-To: <20110621071701.268573809@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor typos/nitpicks:

(2011/06/21 16:17), Paul Turner wrote:
> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> Basic description of usage and effect for CFS Bandwidth Control.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Signed-off-by: Paul Turner <pjt@google.com>
> ---
>  Documentation/scheduler/sched-bwc.txt |   98
>  ++++++++++++++++++++++++++++++++++
>  Documentation/scheduler/sched-bwc.txt |  110 ++++++++++++++++++++++++++++++++++
>  1 file changed, 110 insertions(+)
> 
> Index: tip/Documentation/scheduler/sched-bwc.txt
> ===================================================================
> --- /dev/null
> +++ tip/Documentation/scheduler/sched-bwc.txt
> @@ -0,0 +1,110 @@
> +CFS Bandwidth Control
> +=====================
> +
> +[ This document talks about CPU bandwidth control for CFS groups only.
> +  Bandwidth control for RT groups covered in:
> +  Documentation/scheduler/sched-rt-group.txt ]
> +
> +CFS bandwidth control is a group scheduler extension that can be used to
> +control the maximum CPU bandwidth obtained by a CPU cgroup.
> +
> +Bandwidth allowed for a group is specified using quota and period. Within
> +a given "period" (microseconds), a group is allowed to consume up to "quota"
> +microseconds of CPU time, which is the upper limit or the hard limit. When the
> +CPU bandwidth consumption of a group exceeds the hard limit, the tasks in the
> +group are throttled and are not allowed to run until the end of the period at
> +which time the group's quota is replenished.
> +
> +Runtime available to the group is tracked globally. At the beginning of
> +each period, the group's global runtime pool is replenished with "quota"
> +microseconds worth of runtime.  This bandwidth is then transferred to cpu local
> +"accounts" on a demand basis.  Thie size of this transfer is described as a

                                  The ?

> +"slice".
> +
> +Interface
> +---------
> +Quota and period can be set via cgroup files.
> +
> +cpu.cfs_quota_us: the enforcement interval (microseconds)
> +cpu.cfs_period_us: the maximum allowed bandwidth (microseconds)
> +
> +Within a period of cpu.cfs_period_us, the group as a whole will not be allowed
> +to consume more than cpu_cfs_quota_us worth of runtime.
> +
> +The default value of cpu.cfs_period_us is 100ms and the default value
> +for cpu.cfs_quota_us is -1.
> +
> +A group with cpu.cfs_quota_us as -1 indicates that the group has infinite
> +bandwidth, which means that it is not bandwidth controlled.

(I think it's better to use "unconstrained (bandwidth) group" as the
 standardized expression instead of "infinite bandwidth group", so ...)

                                               ... controlled. Such group is
described as an unconstrained bandwidth group.

> +
> +Writing any negative value to cpu.cfs_quota_us will turn the group into
> +an infinite bandwidth group. Reading cpu.cfs_quota_us for an unconstrained
      ^^^^^^^^
      unconstrained

> +bandwidth group will always return -1.
> +
> +System wide settings
> +--------------------
> +The amount of runtime obtained from global pool every time a CPU wants the
> +group quota locally is controlled by a sysctl parameter
> +sched_cfs_bandwidth_slice_us. The current default is 5ms. This can be changed
> +by writing to /proc/sys/kernel/sched_cfs_bandwidth_slice_us.
> +
> +Statistics
> +----------
> +cpu.stat file lists three different stats related to bandwidth control's
> +activity.
> +
> +- nr_periods: Number of enforcement intervals that have elapsed.
> +- nr_throttled: Number of times the group has been throttled/limited.
> +- throttled_time: The total time duration (in nanoseconds) for which entities
> +  of the group have been throttled.
> +
> +These files are read-only.
> +
> +Hierarchy considerations
> +------------------------
> +The interface enforces that an individual entity's bandwidth is always
> +attainable, that is: max(c_i) <= C. However, over-subscription in the
> +aggregate case is explicitly allowed:
> +  e.g. \Sum (c_i) may exceed C
> +[ Where C is the parent's bandwidth, and c_i its children ]
> +
> +There are two ways in which a group may become throttled:
> +
> +a. it fully consumes its own quota within a period
> +b. a parent's quota is fully consumed within its period
> +
> +In case b above, even though the child may have runtime remaining it will not
> +be allowed to un until the parent's runtime is refreshed.

                 run ?

> +
> +Examples
> +--------
> +1. Limit a group to 1 CPU worth of runtime.
> +
> +	If period is 250ms and quota is also 250ms, the group will get
> +	1 CPU worth of runtime every 250ms.
> +
> +	# echo 500000 > cpu.cfs_quota_us /* quota = 250ms */
               ~~~~~~
               250000 ?

> +	# echo 250000 > cpu.cfs_period_us /* period = 250ms */
> +
> +2. Limit a group to 2 CPUs worth of runtime on a multi-CPU machine.
> +
> +	With 500ms period and 1000ms quota, the group can get 2 CPUs worth of
> +	runtime every 500ms.
> +
> +	# echo 1000000 > cpu.cfs_quota_us /* quota = 1000ms */
> +	# echo 500000 > cpu.cfs_period_us /* period = 500ms */
> +
> +	The larger period here allows for increased burst capacity.
> +
> +3. Limit a group to 20% of 1 CPU.
> +
> +	With 50ms period, 10ms quota will be equivalent to 20% of 1 CPU.
> +
> +	# echo 10000 > cpu.cfs_quota_us /* quota = 10ms */
> +	# echo 50000 > cpu.cfs_period_us /* period = 50ms */
> +
> +	By using a small period her we are ensuring a consistent latency

                                here ?

> +	response at the expense of burst capacity.
> +
> +
> +

Blank lines at EOF ?


Thank you for improving the document!  Especially I think it is pretty
good that now it provide examples of how "period" is used.

For the rests in the V7 set (overall it looks very good), give me some
time to review & tests. ;-)


Thanks,
H.Seto

