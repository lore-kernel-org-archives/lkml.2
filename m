Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2EOJZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:25:04 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45661 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab2EOJZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:25:01 -0400
Message-ID: <4FB220C3.40606@linux.vnet.ibm.com>
Date: Tue, 15 May 2012 14:54:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
CC: David Rientjes <rientjes@google.com>, a.p.zijlstra@chello.nl,
        mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com>
In-Reply-To: <20120515014042.GA9774@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051509-5564-0000-0000-000002BA0CCE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 07:10 AM, Nishanth Aravamudan wrote:

> On 14.05.2012 [17:37:50 -0700], David Rientjes wrote:
>> On Mon, 14 May 2012, Srivatsa S. Bhat wrote:
>>
>>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>>> index 0723183..671bf26 100644
>>> --- a/kernel/cpuset.c
>>> +++ b/kernel/cpuset.c
>>> @@ -93,6 +93,13 @@ struct cpuset {
>>>  
>>>  	unsigned long flags;		/* "unsigned long" so bitops work */
>>>  	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
>>> +
>>> +	/*
>>> +	 * used to save cpuset's cpus_allowed mask during suspend and restore
>>> +	 * it during resume.
>>> +	 */
>>> +	cpumask_var_t suspend_cpus_allowed;
>>> +
>>>  	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
>>>  
>>>  	struct cpuset *parent;		/* my parent */
>>
>> I see what you're doing with this and think it will fix the problem that 
>> you're trying to address, but I think it could become much more general 
>> to just the suspend case: if an admin sets a cpuset to have cpus 4-6, for 
>> example, and cpu 5 goes offline, then I believe the cpuset should once 
>> again become 4-6 if cpu 5 comes back online.  So I think this should be 
>> implemented like mempolicies are which save the user intended nodemask 
>> that may become restricted by cpuset placement but will be rebound if the 
>> cpuset includes the intended nodes.
> 
> Heh, please read the thread at
> http://marc.info/?l=linux-kernel&m=133615922717112&w=2 ... subject is
> "[PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets handling
> upon CPU hotplug". That was effectively the same solution Srivatsa
> originally posted. But after lengthy discussions with PeterZ and others,
> it was decided that suspend/resume is a special case where it makes
> sense to save "policy" but that generally cpu/memory hotplug is a
> destructive operation and nothing is required to be retained (that
> certain policies are retained is unfortunately now expected, but isn't
> guaranteed for cpusets, at least).
> 
>> If that's done, then it takes care of the suspend case as well and adds 
>> generic cpu hotplug support, not just for suspend/resume.
> 
> Yeah ... but that's not the intent here (to add generic cpu hotplug
> support).
> 
> Srivatsa, perhaps a reference to some summary of why it's not good to
> support the general hotplug case would have been good in 0/5?
> 


Yep, I forgot to add that..

Anyway, here is the summary, for the benefit of reviewers:

CPU hotplug, by definition, is a destructive operation. As a result, there
is no guarantee that after a hot-unplug, the cpu will ever get hot-replugged.
And hence, in the event of a hotplug operation, remembering the state
doesn't make much sense.

However, suspend/resume is a special case in which, it uses CPU hotplug
reversibly - all nonboot cpus are hot-removed during suspend, and hot-added
back during resume.. *every one of them*!

So during suspend/resume, we are 100% sure that whatever we hot-removed
will be added back, because the goal of suspend/resume is to bring things
to the same state anyway. So, we are forced to remember the state for CPU
hotplug done in the suspend/resume path, so that we can restore it back.

And for the regular CPU hotplug case, Peter Zijlstra also gave the example
of sched_setaffinity(), whose implementation differs slightly from that
of cpusets, but in the end, it also respects hotplug semantics and doesn't
remember the state after hotplug.

So, the bottomline is, in Peter's own words:
"Generic hotplug is a destructive operation. And hence, no state should be
remembered. No ifs and buts about that!"

But Peter agreed (in an off-list discussion) to a special case handling of
cpusets during suspend/resume alone, without altering how it is dealt with
during regular CPU hotplug. And this patchset (v3) implements that design.

Regards,
Srivatsa S. Bhat

