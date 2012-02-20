Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2BTNAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 08:00:16 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:54020 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2BTNAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 08:00:14 -0500
Message-ID: <4F4243B6.8070507@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 18:29:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20120131 Thunderbird/10.0
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
References: <Pine.LNX.4.44L0.1202101647440.1179-100000@iolanthe.rowland.org> <201202102339.02702.rjw@sisk.pl> <1328926042.2476.3.camel@laptop> <4F35EE11.5010202@linux.vnet.ibm.com> <4F394CA0.9020902@linux.vnet.ibm.com> <4F3E44DB.20201@linux.vnet.ibm.com> <1329742145.2293.337.camel@twins>
In-Reply-To: <1329742145.2293.337.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12022002-6102-0000-0000-000000DEBCA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 02/20/2012 06:19 PM, Peter Zijlstra wrote:

> On Fri, 2012-02-17 at 17:45 +0530, Srivatsa S. Bhat wrote:
> 
>>> Trivially removing CPU_TASKS_FROZEN as shown below doesn't look right to me:
>>>
>>> ---
>>>
>>>  kernel/sched/core.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>>
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index 5255c9d..43a166e 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -6729,7 +6729,7 @@ int __init sched_create_sysfs_power_savings_entries(struct device *dev)
>>>  static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
>>>  			     void *hcpu)
>>>  {
>>> -	switch (action & ~CPU_TASKS_FROZEN) {
>>> +	switch (action) {
>>>  	case CPU_ONLINE:
>>>  	case CPU_DOWN_FAILED:
>>>  		cpuset_update_active_cpus();
>>> @@ -6742,7 +6742,7 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
>>>  static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
>>>  			       void *hcpu)
>>>  {
>>> -	switch (action & ~CPU_TASKS_FROZEN) {
>>> +	switch (action) {
>>>  	case CPU_DOWN_PREPARE:
>>>  		cpuset_update_active_cpus();
>>>  		return NOTIFY_OK;
>>>
>>>
>>> IMO, irrespective of whether we keep cpusets unaware of all CPU Hotplug or
>>> only unaware of the CPU hotplug in the suspend/resume path, I feel the
>>> scheduler should always know the true state of the system, ie., offline CPUs
>>> must not be part of any sched domain, at any point in time.
> 
> That's really not a problem as long as they're not in the active mask.
> 


Ok..

>>> At the moment, I am exploring several ways to achieve this (I can think of 2
>>> ways at the moment, will see which one is better). But in case this approach
>>> itself seems wrong for any reason, please let me know.
> 
> 
> Have you actually tried the simple patch? 
> 


Yes, I tried it out and it fixed the suspend/resume bug. I was just unsure that it
was the right fix, because the scheduler's sched domains wouldn't be up-to-date,
unintentionally.

> Calling partition_sched_domains() like you do doesn't seem right, it
> completely ignores cpusets, it will make certain cpuset configurations
> mis-behave.
> 


Well, why do we care about cpuset configurations when we are in the midst of
suspend/resume? Anyway all tasks are frozen during suspend, and when we resume,
we restore everything (including cpusets and sched domains) to exactly how it
was before suspend.. So that must be fine right?

(I am referring to the patch posted at https://lkml.org/lkml/2012/2/17/125).

Regards,
Srivatsa S. Bhat

