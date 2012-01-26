Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2AZKm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:42:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60763 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2AZKmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:42:55 -0500
Message-ID: <4F212DFF.8060802@kernel.dk>
Date: Thu, 26 Jan 2012 11:42:07 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs tunable
References: <20120116161740.29759.4679.stgit@localhost>  <20120116162241.29759.13220.stgit@localhost> <1327503181.2614.76.camel@laptop>
In-Reply-To: <1327503181.2614.76.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 03:53 PM, Peter Zijlstra wrote:
> On Mon, 2012-01-16 at 21:52 +0530, Vaidyanathan Srinivasan wrote:
>> +++ b/block/blk.h
>> @@ -167,14 +167,15 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
>>  static inline int blk_cpu_to_group(int cpu)
>>  {
>>         int group = NR_CPUS;
>> -#ifdef CONFIG_SCHED_MC
>> -       const struct cpumask *mask = cpu_coregroup_mask(cpu);
>> -       group = cpumask_first(mask);
>> -#elif defined(CONFIG_SCHED_SMT)
>> -       group = cpumask_first(topology_thread_cpumask(cpu));
>> +#ifdef CONFIG_SCHED_POWERSAVE
>> +       if (smt_capable())
>> +               group = cpumask_first(topology_thread_cpumask(cpu));
>> +       else    
>> +               group = cpumask_first(cpu_coregroup_mask(cpu));
>>  #else
>>         return cpu;
>>  #endif
>> +       /* Possible dead code?? */
>>         if (likely(group < NR_CPUS))
>>                 return group;
>>         return cpu; 
> 
> After going, WTF is block doing! I had a closer look and this doesn't
> seem right at all. The old code would use coregroup_mask when SCHED_MC
> && SCHED_SMT, the new code does something else.
> 
> Jens, what is this thing trying to do?

Not surprised that it's broken for some configs. The intent of the code
is to return the first CPU in the "group" that the passed in core/thread
belongs to. This is used to decide whether to perform a completion
locally, or to send it off to a different "group".

-- 
Jens Axboe

