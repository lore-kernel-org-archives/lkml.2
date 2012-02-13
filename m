Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2BMRr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:47:28 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36434 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab2BMRr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:47:27 -0500
Message-ID: <4F394CA0.9020902@linux.vnet.ibm.com>
Date: Mon, 13 Feb 2012 23:17:12 +0530
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
References: <Pine.LNX.4.44L0.1202101647440.1179-100000@iolanthe.rowland.org> <201202102339.02702.rjw@sisk.pl> <1328926042.2476.3.camel@laptop> <4F35EE11.5010202@linux.vnet.ibm.com>
In-Reply-To: <4F35EE11.5010202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021317-2674-0000-0000-000003537E60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2012 09:56 AM, Srivatsa S. Bhat wrote:

> On 02/11/2012 07:37 AM, Peter Zijlstra wrote:
> 
>> On Fri, 2012-02-10 at 23:39 +0100, Rafael J. Wysocki wrote:
>>>
>>>> I don't see why not.  Presumably no CPUs will be added or removed while 
>>>> the system is asleep.
>>>
>>> ACPI explicitly forbids that level of hardware reconfiguration in a sleep
>>> state (even in S4), AFAICS.  Still, people may try to do that ... 
>>
>> I'm ok with breaking that :-) If its really really important to someone
>> we (him most likely) could fix it by detecting the topology changed over
>> the suspend and do a fixup. Assuming it actually gets that far.
>>
>> Srivatsa, wanna give this (the proposal to not modify cpusets on
>> CPU_TASKS_FROZEN) a try?
>>
> 
> 
> Sure! After you pointed out that CPU Hotplug is destructive in general and
> hence it is not a good idea to put back online CPUs to cpusets, the next
> thing I thought of trying was a special case handling for suspend/resume
> alone, IOW, not calling the cpuset update upon CPU_TASKS_FROZEN.
> 
> So, yes, I'll write up a patch for that and post it soon :-)
> 


Trivially removing CPU_TASKS_FROZEN as shown below doesn't look right to me:

---

 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..43a166e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6729,7 +6729,7 @@ int __init sched_create_sysfs_power_savings_entries(struct device *dev)
 static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 			     void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
 		cpuset_update_active_cpus();
@@ -6742,7 +6742,7 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 			       void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
 	case CPU_DOWN_PREPARE:
 		cpuset_update_active_cpus();
 		return NOTIFY_OK;


IMO, irrespective of whether we keep cpusets unaware of all CPU Hotplug or
only unaware of the CPU hotplug in the suspend/resume path, I feel the
scheduler should always know the true state of the system, ie., offline CPUs
must not be part of any sched domain, at any point in time.

At the moment, I am exploring several ways to achieve this (I can think of 2
ways at the moment, will see which one is better). But in case this approach
itself seems wrong for any reason, please let me know.

Regards,
Srivatsa S. Bhat

