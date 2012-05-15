Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab2EOM0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:26:01 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51794 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516Ab2EOM0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:26:00 -0400
Message-ID: <4FB24B2E.4010000@linux.vnet.ibm.com>
Date: Tue, 15 May 2012 17:55:18 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, Andrew Morton <akpm@linux-foundation.org>,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 2/5] cpusets, hotplug: Restructure functions that are
 invoked during hotplug
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231531.3566.75965.stgit@srivatsabhat> <alpine.DEB.2.00.1205141705180.25235@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205141705180.25235@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051502-0260-0000-0000-000001201251
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 05:57 AM, David Rientjes wrote:

> On Mon, 14 May 2012, Srivatsa S. Bhat wrote:
> 
>> Separate out the cpuset related handling for CPU/Memory online/offline.
>> This also helps us exploit the most obvious and basic level of optimization
>> that any notification mechanism (CPU/Mem online/offline) has to offer us:
>> "We *know* why we have been invoked. So stop pretending that we are lost,
>> and do only the necessary amount of processing!".
>>
>> And while at it, rename scan_for_empty_cpusets() to
>> scan_cpusets_upon_hotplug(), which will be more appropriate, considering
>> the upcoming changes.
>>
> 
> If it's more appropriate in upcoming changes, then change it in the 
> upcoming changes that make it more appropriate?
> 


Well, I wanted to split out the core of the fix from the rest of the cleanup,
so that the fix patch can be more focussed, thereby easing review.

And I think renaming this function is more of a noise, when compared with the
fix being implemented in the later patches.. So I thought I'll get it out of
the way by doing it here itself.

Moreover, that renaming is justified in this patch itself, IMHO.. It doesn't
really have to wait till the later ones, because considering the restructuring
that this patch does, the renaming is in order too..

>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> Cc: stable@vger.kernel.org
>> ---
[...]
>> +
>> +	case CPUSET_MEM_OFFLINE:
>> +		while (!list_empty(&queue)) {
>> +			cp = traverse_cpusets(&queue);
>> +
>> +			/* Continue past cpusets with all mems online */
>> +			if (nodes_subset(cp->mems_allowed,
>> +					node_states[N_HIGH_MEMORY]))
>> +				continue;
>> +
>> +			oldmems = cp->mems_allowed;
>> +
>> +			/* Remove offline mems from this cpuset. */
>> +			mutex_lock(&callback_mutex);
>> +			nodes_and(cp->mems_allowed, cp->mems_allowed,
>>  						node_states[N_HIGH_MEMORY]);
>> -		mutex_unlock(&callback_mutex);
>> +			mutex_unlock(&callback_mutex);
>>  
>> -		/* Move tasks from the empty cpuset to a parent */
>> -		if (cpumask_empty(cp->cpus_allowed) ||
>> -		     nodes_empty(cp->mems_allowed))
>> -			remove_tasks_in_empty_cpuset(cp);
>> -		else {
>> -			update_tasks_cpumask(cp, NULL);
>> -			update_tasks_nodemask(cp, &oldmems, NULL);
>> +			/* Move tasks from the empty cpuset to a parent */
>> +			if (nodes_empty(cp->mems_allowed))
>> +				remove_tasks_in_empty_cpuset(cp);
>> +			else
>> +				update_tasks_nodemask(cp, &oldmems, NULL);
>>  		}
>>  	}
>>  }
> 
> This looks like a good optimization, but the existing comment for 
> scan_for_empty_cpusets() is wrong: we certainly do not lack memory 
> hot-unplug and it will remove nodes from N_HIGH_MEMORY if all present 
> pages from a node are offlined.  I had a patch that emulated node 
> hot-remove on x86 and this worked fine.  So perhaps update that existing 
> comment as well (not shown in this diff)?
> 


Sure, will do.

> Otherwise, looks good.


Thanks a lot!
 
Regards,
Srivatsa S. Bhat

