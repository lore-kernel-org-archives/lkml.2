Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab2BQMPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:15:40 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55147 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2BQMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:15:38 -0500
Message-ID: <4F3E44DB.20201@linux.vnet.ibm.com>
Date: Fri, 17 Feb 2012 17:45:23 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        paul@paulmenage.org, tj@kernel.org, frank.rowand@am.sony.com,
        pjt@google.com, tglx@linutronix.de, lizf@cn.fujitsu.com,
        prashanth@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling related
 to cpusets
References: <Pine.LNX.4.44L0.1202101647440.1179-100000@iolanthe.rowland.org> <201202102339.02702.rjw@sisk.pl> <1328926042.2476.3.camel@laptop> <4F35EE11.5010202@linux.vnet.ibm.com> <4F394CA0.9020902@linux.vnet.ibm.com>
In-Reply-To: <4F394CA0.9020902@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021712-2674-0000-0000-0000036025A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 11:17 PM, Srivatsa S. Bhat wrote:

> On 02/11/2012 09:56 AM, Srivatsa S. Bhat wrote:
> 
>> On 02/11/2012 07:37 AM, Peter Zijlstra wrote:
>>
>>> On Fri, 2012-02-10 at 23:39 +0100, Rafael J. Wysocki wrote:
>>>>
>>>>> I don't see why not.  Presumably no CPUs will be added or removed while 
>>>>> the system is asleep.
>>>>
>>>> ACPI explicitly forbids that level of hardware reconfiguration in a sleep
>>>> state (even in S4), AFAICS.  Still, people may try to do that ... 
>>>
>>> I'm ok with breaking that :-) If its really really important to someone
>>> we (him most likely) could fix it by detecting the topology changed over
>>> the suspend and do a fixup. Assuming it actually gets that far.
>>>
>>> Srivatsa, wanna give this (the proposal to not modify cpusets on
>>> CPU_TASKS_FROZEN) a try?
>>>
>>
>>
>> Sure! After you pointed out that CPU Hotplug is destructive in general and
>> hence it is not a good idea to put back online CPUs to cpusets, the next
>> thing I thought of trying was a special case handling for suspend/resume
>> alone, IOW, not calling the cpuset update upon CPU_TASKS_FROZEN.
>>
>> So, yes, I'll write up a patch for that and post it soon :-)
>>
> 
> 
> Trivially removing CPU_TASKS_FROZEN as shown below doesn't look right to me:
> 
> ---
> 
>  kernel/sched/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 5255c9d..43a166e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6729,7 +6729,7 @@ int __init sched_create_sysfs_power_savings_entries(struct device *dev)
>  static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
>  			     void *hcpu)
>  {
> -	switch (action & ~CPU_TASKS_FROZEN) {
> +	switch (action) {
>  	case CPU_ONLINE:
>  	case CPU_DOWN_FAILED:
>  		cpuset_update_active_cpus();
> @@ -6742,7 +6742,7 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
>  static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
>  			       void *hcpu)
>  {
> -	switch (action & ~CPU_TASKS_FROZEN) {
> +	switch (action) {
>  	case CPU_DOWN_PREPARE:
>  		cpuset_update_active_cpus();
>  		return NOTIFY_OK;
> 
> 
> IMO, irrespective of whether we keep cpusets unaware of all CPU Hotplug or
> only unaware of the CPU hotplug in the suspend/resume path, I feel the
> scheduler should always know the true state of the system, ie., offline CPUs
> must not be part of any sched domain, at any point in time.
> 
> At the moment, I am exploring several ways to achieve this (I can think of 2
> ways at the moment, will see which one is better). But in case this approach
> itself seems wrong for any reason, please let me know.
> 


Ok, here it goes (v2):

----
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: CPU hotplug, cpusets, suspend: Don't touch cpusets during suspend/resume

Currently, during CPU hotplug, the cpuset callbacks modify the cpusets
to reflect the state of the system, and this handling is asymmetric.
That is, upon CPU offline, that CPU is removed from all cpusets. However
when it comes back online, it is put back only to the root cpuset.

This gives rise to a significant problem during suspend/resume. During
suspend, we offline all non-boot cpus and during resume we online them back.
Which means, after a resume, all cpusets (except the root cpuset) will be
restricted to just one single CPU (the boot cpu). But the whole point of
suspend/resume is to restore the system to a state which is as close as
possible to how it was before suspend.

So to fix this, to begin with, don't touch cpusets during suspend/resume.
But cpusets are closely tied up with sched domain rebuild. But since our
intention is to only fool cpusets but not the scheduler during a suspend/
resume, we do the following:

* Towards the end of suspend, we will anyway end up with one single sched
  domain with one CPU in it. So, right from the first CPU offline, we just
  build a single sched domain, ignoring cpusets. Moreover, this won't do
  any harm since tasks would have been anyways frozen before beginning CPU
  hotplug in the suspend/resume sequence.

* Luckily suspend/resume is symmetric with respect to CPU hotplug. That is,
  exactly the same number of CPUs are taken offline and online. So, keep
  track of the number of CPUs taken offline/online, and when we detect that
  this is the last CPU online operation (ie., all CPUs onlined during resume,
  or after a suspend failure), invoke the cpusets code to rebuild the sched
  domains as per the cpusets.

Ultimately, this will not only solve the cpuset problem related to suspend
resume (ie., restores the cpusets to exactly what it was before suspend, by
not touching it at all) but also speeds up suspend/resume because we avoid
running cpuset update code for every CPU being offlined/onlined.

Related bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=714271

Reported-by: Prashanth K. Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/sched/core.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..e2b4e2b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6721,34 +6721,66 @@ int __init sched_create_sysfs_power_savings_entries(struct device *dev)
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
+static int num_cpus_frozen;
+
 /*
  * Update cpusets according to cpu_active mask.  If cpusets are
  * disabled, cpuset_update_active_cpus() becomes a simple wrapper
  * around partition_sched_domains().
+ *
+ * If we come here as part of a suspend/resume, don't touch cpusets because we
+ * want to restore it back to its original state upon resume anyways.
  */
 static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 			     void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
+	case CPU_ONLINE_FROZEN:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_UP_CANCELED_FROZEN:
+		/*
+		 * num_cpus_frozen tracks how many CPUs are involved in suspend
+		 * resume sequence. As long as we are in an intermediate state
+		 * (some more CPUs online/offline is necessary to get system
+		 * back to original state), we just build a single sched domain.
+		 */
+		num_cpus_frozen--;
+		if (num_cpus_frozen != 0) {
+			/*
+			 * This is not the last CPU to come online. More
+			 * CPU online events are yet to come.
+			 */
+			partition_sched_domains(1, NULL, NULL);
+			break;
+		}
+
+		/* Fall through, if this is the last CPU to come online */
+
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
 		cpuset_update_active_cpus();
-		return NOTIFY_OK;
+		break;
 	default:
 		return NOTIFY_DONE;
 	}
+	return NOTIFY_OK;
 }
 
 static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 			       void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
 	case CPU_DOWN_PREPARE:
 		cpuset_update_active_cpus();
-		return NOTIFY_OK;
+		break;
+	case CPU_DOWN_PREPARE_FROZEN:
+		num_cpus_frozen++;
+		partition_sched_domains(1, NULL, NULL);
+		break;
 	default:
 		return NOTIFY_DONE;
 	}
+	return NOTIFY_OK;
 }
 
 void __init sched_init_smp(void)


