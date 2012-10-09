Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab2JII2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 04:28:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57690 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab2JII2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 04:28:43 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344182400"; 
   d="scan'208";a="5968057"
Message-ID: <5073E18A.2090203@cn.fujitsu.com>
Date: Tue, 09 Oct 2012 16:34:18 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, mingo@redhat.com,
        peterz@infradead.org, miaox@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.00.1210082308230.360@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210082308230.360@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 16:28:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 16:28:34,
	Serialize complete at 2012/10/09 16:28:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/09/2012 02:21 PM, David Rientjes Wrote:
> On Mon, 8 Oct 2012, Tang Chen wrote:
> 
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 66b36ab..e76dce9 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1263,18 +1263,24 @@ EXPORT_SYMBOL_GPL(kick_process);
>>   */
>>  static int select_fallback_rq(int cpu, struct task_struct *p)
>>  {
>> -	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
>> +	int nid = cpu_to_node(cpu);
>> +	const struct cpumask *nodemask = NULL;
>>  	enum { cpuset, possible, fail } state = cpuset;
>>  	int dest_cpu;
>>  
>> -	/* Look for allowed, online CPU in same node. */
>> -	for_each_cpu(dest_cpu, nodemask) {
>> -		if (!cpu_online(dest_cpu))
>> -			continue;
>> -		if (!cpu_active(dest_cpu))
>> -			continue;
>> -		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
>> -			return dest_cpu;
>> +	/* If the cpu has been offlined, its nid was set to -1. */
>> +	if (nid != -1) {
> 
> NUMA_NO_NODE.
> 
> Eek, the nid shouldn't be -1 yet, though, for cpu hotplug since this 
> should be called at CPU_DYING level and migrate_tasks() still sees a valid 
> cpu.

the cpu's node is set when the cpu is hotpluged(not online), and it will
be cleared when the cpu is hotremoved(This patch is in akpm tree):
https://lkml.org/lkml/2012/9/3/39

I guess the task is in sleep state when the cpu is offlined, and it doesn't
be migrated to another cpu.

Thanks
Wen Congyang

> 
> On x86, cpumask_of_node() is always guaranteed to return a valid cpumask 
> after boot so presumably this is a problem in some non-x86 arch code and 
> isn't actually a sched problem.
> 
>> +		nodemask = cpumask_of_node(nid);
>> +
>> +		/* Look for allowed, online CPU in same node. */
>> +		for_each_cpu(dest_cpu, nodemask) {
>> +			if (!cpu_online(dest_cpu))
>> +				continue;
>> +			if (!cpu_active(dest_cpu))
>> +				continue;
>> +			if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
>> +				return dest_cpu;
>> +		}
>>  	}
>>  
>>  	for (;;) {
> 

