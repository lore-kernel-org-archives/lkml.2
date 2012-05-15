Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab2EOMQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:16:10 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:37880 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab2EOMQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:16:05 -0400
Message-ID: <4FB248DB.90000@linux.vnet.ibm.com>
Date: Tue, 15 May 2012 17:45:23 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 1/5] cpusets, hotplug: Implement cpuset tree traversal
 in a helper function
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231449.3566.70799.stgit@srivatsabhat> <alpine.DEB.2.00.1205141700480.25235@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205141700480.25235@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051512-2000-0000-0000-000007816306
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 05:33 AM, David Rientjes wrote:

> On Mon, 14 May 2012, Srivatsa S. Bhat wrote:
> 
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index 14f7070..23e5da6 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -2000,6 +2000,23 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
>>  	move_member_tasks_to_cpuset(cs, parent);
>>  }
>>  
>> +static struct cpuset *traverse_cpusets(struct list_head *queue)
> 
> I suggest a different name for this, traverse_cpusets() doesn't imply that 
> it will be returning struct cpuset *.


OK, I guess something like cpuset_next() or next_cpuset() should be fine?

> 
>> +{
>> +	struct cpuset *cp;
>> +	struct cpuset *child;	/* scans child cpusets of cp */
>> +	struct cgroup *cont;
>> +
>> +	cp = list_first_entry(queue, struct cpuset, stack_list);
>> +	list_del(queue->next);
>> +	list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
>> +		child = cgroup_cs(cont);
>> +		list_add_tail(&child->stack_list, queue);
>> +	}
>> +
>> +	return cp;
> 
> Eek, what happens if queue is empty?  It can't happen with only this 
> patch applied, but since you're doing this to be used in other places then 
> you'd need to check for list_empty().
> 


Actually, I didn't intend this to be used in other places because their
traversals are a little bit different anyway.. But yes, having a check for
list_empty() would be good. I'll add it and change the loop to something like:

while (cpuset_next(&queue) {
	...
}

Thanks for pointing this out!

>> +}
>> +
>> +
>>  /*
>>   * Walk the specified cpuset subtree and look for empty cpusets.
>>   * The tasks of such cpuset must be moved to a parent cpuset.
>> @@ -2019,19 +2036,12 @@ static void scan_for_empty_cpusets(struct cpuset *root)
>>  {
>>  	LIST_HEAD(queue);
>>  	struct cpuset *cp;	/* scans cpusets being updated */
>> -	struct cpuset *child;	/* scans child cpusets of cp */
>> -	struct cgroup *cont;
>>  	static nodemask_t oldmems;	/* protected by cgroup_mutex */
>>  
>>  	list_add_tail((struct list_head *)&root->stack_list, &queue);
>>  
>>  	while (!list_empty(&queue)) {
>> -		cp = list_first_entry(&queue, struct cpuset, stack_list);
>> -		list_del(queue.next);
>> -		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
>> -			child = cgroup_cs(cont);
>> -			list_add_tail(&child->stack_list, &queue);
>> -		}
>> +		cp = traverse_cpusets(&queue);
>>  
>>  		/* Continue past cpusets with all cpus, mems online */
>>  		if (cpumask_subset(cp->cpus_allowed, cpu_active_mask) &&
> 
> Otherwise, looks good.
> 


Thanks a lot!

Regards,
Srivatsa S. Bhat

