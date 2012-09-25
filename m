Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2IYCh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 22:37:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42975 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab2IYChZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 22:37:25 -0400
X-IronPort-AV: E=Sophos;i="4.80,479,1344182400"; 
   d="scan'208";a="5909668"
Message-ID: <50611946.9080601@cn.fujitsu.com>
Date: Tue, 25 Sep 2012 10:39:02 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, linux-numa@vger.kernel.org,
        wency@cn.fujitsu.com, mingo@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Update sched_domains_numa_masks when new cpus are onlined.
References: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com> <1348479536.11847.25.camel@twins>
In-Reply-To: <1348479536.11847.25.camel@twins>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 10:37:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 10:37:37,
	Serialize complete at 2012/09/25 10:37:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter:

Thanks for commenting this patch. :)

On 09/24/2012 05:38 PM, Peter Zijlstra wrote:
> Why are you cc'ing x86 and numa folks but not a single scheduler person
> when you're patching scheduler stuff?

First of all, I'm sorry for this. I thought it was a NUMA or memory
related problem. And I get your address from the get_maintainer.pl
script.

>
> On Tue, 2012-09-18 at 18:12 +0800, Tang Chen wrote:
>> Once array sched_domains_numa_masks is defined, it is never updated.
>> When a new cpu on a new node is onlined,
>
> Hmm, so there's hardware where you can boot with smaller nr_node_ids
> than possible.. I guess that makes sense.

Yes. nr_node_ids represents the max number of nodes the sustem supports.
And usually, we don't have that many.

>
>>   the coincident member in
>> sched_domains_numa_masks is not initialized, and all the masks are 0.
>> As a result, the build_overlap_sched_groups() will initialize a NULL
>> sched_group for the new cpu on the new node, which will lead to kernel panic.
>
> <snip>
>
>> This patch registers a new notifier for cpu hotplug notify chain, and
>> updates sched_domains_numa_masks every time a new cpu is onlined or offlined.
>
> Urgh, more hotplug notifiers.. a well.
>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> ---
>>   kernel/sched/core.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 62 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index fbf1fd0..66b36ab 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -6711,6 +6711,14 @@ static void sched_init_numa(void)
>>   	 * numbers.
>>   	 */
>>
>> +	/*
>> +	 * Since sched_domains_numa_levels is also used in other functions as
>> +	 * an index for sched_domains_numa_masks[][], we should reset it here in
>> +	 * case sched_domains_numa_masks[][] fails to be initialized. And set it
>> +	 * to 'level' when sched_domains_numa_masks[][] is fully initialized.
>> +	 */
>> +	sched_domains_numa_levels = 0;
>
> This isn't strictly needed for this patch right? I don't see anybody
> calling sched_init_numa() a second time (although they should)..

Indeed, sched_init_numa() won't be called by anyone else. But I clear it
here in case the following memory allocation fail.

Actually, I want to use sched_domains_numa_levels to iterate all the
numa levels, such as in sched_domains_numa_masks_set().

Suppose sched_domains_numa_levels is 10. If allocating memory for
sched_domains_numa_masks[5] fails in sched_init_numa(), it will just 
return, but sched_domains_numa_masks[] only has 4 members. It
could be dangerous.

So I set sched_domains_numa_levels to 0, and reset it to level in the
end of sched_init_numa(), see below.

>
>>   	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
>>   	if (!sched_domains_numa_masks)
>>   		return;
>> @@ -6765,11 +6773,64 @@ static void sched_init_numa(void)
>>   	}
>>
>>   	sched_domain_topology = tl;
>> +
>> +	sched_domains_numa_levels = level;

And I set it to level here again.

>> +}
>> +
>> +static void sched_domains_numa_masks_set(int cpu)
>> +{
>> +	int i, j;
>> +	int node = cpu_to_node(cpu);
>> +
>> +	for (i = 0; i<  sched_domains_numa_levels; i++)
>> +		for (j = 0; j<  nr_node_ids; j++)
>> +			if (node_distance(j, node)<= sched_domains_numa_distance[i])
>> +				cpumask_set_cpu(cpu, sched_domains_numa_masks[i][j]);
>> +}
>> +
>> +static void sched_domains_numa_masks_clear(int cpu)
>> +{
>> +	int i, j;
>> +	for (i = 0; i<  sched_domains_numa_levels; i++)
>> +		for (j = 0; j<  nr_node_ids; j++)
>> +			cpumask_clear_cpu(cpu, sched_domains_numa_masks[i][j]);
>> +}
>
> Aside from the coding style nit of wanting braces over multi-line
> statements even though not strictly required, I really don't see how
> this could possibly be right..

Thanks for telling me that. I'll fix the coding style. :)

>
> We do this because nr_node_ids changed, right? This means the entire
> distance table grew/shrunk, which means we should do the level scan
> again.

It seems that nr_node_ids will not change once the system is up.
I'm not quite sure. If I am wrong, please tell me. :)

I found that nr_node_ids is defined as MAX_NUMNODES in mm/page_alloc.c

int nr_node_ids __read_mostly = MAX_NUMNODES;

And all the functions change this value are __init functions. So I think
nr_node_ids is just the possible nodes in the system, and it won't be
changed after the system initialization finished.

>
>> @@ -7218,6 +7279,7 @@ void __init sched_init_smp(void)
>>          mutex_unlock(&sched_domains_mutex);
>>          put_online_cpus();
>>
>> +       hotcpu_notifier(sched_domains_numa_masks_update, CPU_PRI_SCHED_ACTIVE);
>>          hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
>>          hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
>
> OK, so you really want your notifier to run before cpuset_cpu_active
> because otherwise you get that crash, yet you fail with the whole order
> thing.. You should not _ever_ rely on registration order.
>
>

