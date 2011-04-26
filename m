Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1DZKkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:40:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab1DZKk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:40:27 -0400
Message-ID: <4DB6A10A.3000704@redhat.com>
Date: Tue, 26 Apr 2011 18:40:10 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip v2] sched: more sched_domain iterations fix
References: <1303384893.2035.73.camel@laptop>	 <1303469634-11678-1-git-send-email-dfeng@redhat.com> <1303810039.20212.221.camel@twins>
In-Reply-To: <1303810039.20212.221.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 05:27 PM, Peter Zijlstra wrote:
> On Fri, 2011-04-22 at 18:53 +0800, Xiaotian feng wrote:
>> From: Xiaotian Feng<dfeng@redhat.com>
>>
>> sched_domain iterations needs to be protected by rcu_read_lock() now,
>> this patch adds another two places which needs the rcu lock, which is
>> spotted by following suspicious rcu_dereference_check() usage warnings.
>>
>> kernel/sched_rt.c:1244 invoked rcu_dereference_check() without protection!
>> kernel/sched_stats.h:41 invoked rcu_dereference_check() without protection!
>
> Much better, one worry:
>
>> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>> Cc: Ingo Molnar<mingo@elte.hu>
>> Cc: Peter Zijlstra<peterz@infradead.org>
>> ---
>
>> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
>> index 48ddf43..331e01b 100644
>> --- a/kernel/sched_stats.h
>> +++ b/kernel/sched_stats.h
>> @@ -37,7 +37,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
>>
>>   #ifdef CONFIG_SMP
>>   		/* domain-specific stats */
>> -		preempt_disable();
>> +		rcu_read_lock();
>>   		for_each_domain(cpu, sd) {
>>   			enum cpu_idle_type itype;
>>
>> @@ -64,7 +64,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
>>   			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
>>   			    sd->ttwu_move_balance);
>>   		}
>> -		preempt_enable();
>> +		rcu_read_unlock();
>>   #endif
>>   	}
>>   	kfree(mask_str);
>
> Did you indeed validate that the preempt_disable() wasn't needed for
> anything else? Your changelog doesn't mention and I didn't check, just
> noticed the possibility on the first posting.
>
Sorry, I just checked them, preempt_disable/enable was introduced by 
commit 674311d,
the rcu_read_lock_sched is not existed at that time.

btw, as for_each_domain is protected by rcu_read_lock() and 
preempt_disable is not suffice
any more, could we also update comments in for_each_domain?

/*
  * The domain tree (rq->sd) is protected by RCU's quiescent state 
transition.
  * See detach_destroy_domains: synchronize_sched for details.
  *
  * The domain tree of any CPU may only be accessed from within
  * preempt-disabled sections.
  */

