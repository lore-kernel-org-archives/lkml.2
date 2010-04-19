Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0DSDp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 23:45:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57906 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab0DSDp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 23:45:57 -0400
Message-ID: <4BCBD1D2.7090003@cn.fujitsu.com>
Date: Mon, 19 Apr 2010 11:45:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
CC: Eric Paris <eparis@parisplace.org>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: suspicious rcu_dereference_check() usage - include/linux/cgroup.h:492
 invoked rcu_dereference_check() without protection!
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com> <20100311032843.GE6767@linux.vnet.ibm.com> <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com> <1271098032.4807.137.camel@twins> <1271242058.32749.19.camel@laptop> <20100415154715.GI2471@linux.vnet.ibm.com>
In-Reply-To: <20100415154715.GI2471@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be [tip:core/urgent]

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Paul E. McKenney wrote:
> 
> Looks reasonable to me!
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> ---
>>  kernel/sched.c |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 3acf694..2e06d87 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -323,6 +323,15 @@ static inline struct task_group *task_group(struct task_struct *p)
>>  /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
>>  static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
>>  {
>> +	/*
>> +	 * Strictly speaking this rcu_read_lock() is not needed since the
>> +	 * task_group is tied to the cgroup, which in turn can never go away
>> +	 * as long as there are tasks attached to it.
>> +	 *
>> +	 * However since task_group() uses task_subsys_state() which is an
>> +	 * rcu_dereference() user, this quiets CONFIG_PROVE_RCU.
>> +	 */
>> +	rcu_read_lock();
>>  #ifdef CONFIG_FAIR_GROUP_SCHED
>>  	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
>>  	p->se.parent = task_group(p)->se[cpu];
>> @@ -332,6 +341,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
>>  	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
>>  	p->rt.parent = task_group(p)->rt_se[cpu];
>>  #endif
>> +	rcu_read_unlock();
>>  }
>>
>>  #else
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

