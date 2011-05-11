Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1EKRaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:30:55 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49566 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1EKRaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:30:52 -0400
Message-ID: <4DCAC79A.7050505@linux.vnet.ibm.com>
Date: Thu, 12 May 2011 01:30:02 +0800
From: Cheng Xu <chengxu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mckenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: rt_rq runtime leakage bug fix
References: <4DCA3C0C.3080901@linux.vnet.ibm.com> <1305105711.2914.205.camel@laptop>
In-Reply-To: <1305105711.2914.205.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I tried but hit a boot-time error "Unable to handle kernel paging request for data at address 0x100000008", and therefore would like to propose an alternative patch like,

#define for_each_rt_rq(rt_rq, iter, rq) \
        for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
             (&iter->list != &task_groups) && (rt_rq = iter->rt_rq[cpu_of(rq)]); \
             iter = list_entry_rcu(iter->list.next, typeof(*iter), list))

This worked, it seems to pass the tests.  Is this correct from a scheduler perspective?

For the not CONFIG_RT_GROUP_SCHED part, I used 

typedef struct rt_rq *rt_rq_iter_t;

#define for_each_rt_rq(rt_rq, iter, rq) \
	(void) iter; \
	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)

An alternative is 
#define for_each_rt_rq(rt_rq, iter, rq) \
	for (rt_rq = iter = &rq->rt; iter; rt_rq = iter = NULL)

The patch is attached below. Could you check whether it is workable? Thank you. 

---
 kernel/sched_rt.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index e7cebdc..f9e621a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -183,6 +183,13 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
 }
 
+typedef struct task_group *rt_rq_iter_t;
+
+#define for_each_rt_rq(rt_rq, iter, rq) \
+	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
+	     (&iter->list != &task_groups) && (rt_rq = iter->rt_rq[cpu_of(rq)]); \
+	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list))
+
 static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
 {
 	list_add_rcu(&rt_rq->leaf_rt_rq_list,
@@ -288,6 +295,12 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 	return ktime_to_ns(def_rt_bandwidth.rt_period);
 }
 
+typedef struct rt_rq *rt_rq_iter_t;
+
+#define for_each_rt_rq(rt_rq, iter, rq) \
+	(void) iter; \
+	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
+
 static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
 {
 }
@@ -402,12 +415,13 @@ next:
 static void __disable_runtime(struct rq *rq)
 {
 	struct root_domain *rd = rq->rd;
+	rt_rq_iter_t iter;
 	struct rt_rq *rt_rq;
 
 	if (unlikely(!scheduler_running))
 		return;
 
-	for_each_leaf_rt_rq(rt_rq, rq) {
+	for_each_rt_rq(rt_rq, iter, rq) {
 		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 		s64 want;
 		int i;
@@ -487,6 +501,7 @@ static void disable_runtime(struct rq *rq)
 
 static void __enable_runtime(struct rq *rq)
 {
+	rt_rq_iter_t iter;
 	struct rt_rq *rt_rq;
 
 	if (unlikely(!scheduler_running))
@@ -495,7 +510,7 @@ static void __enable_runtime(struct rq *rq)
 	/*
 	 * Reset each runqueue's bandwidth settings
 	 */
-	for_each_leaf_rt_rq(rt_rq, rq) {
+	for_each_rt_rq(rt_rq, iter, rq) {
 		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 
 		raw_spin_lock(&rt_b->rt_runtime_lock);
@@ -1796,10 +1811,11 @@ extern void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq);
 
 static void print_rt_stats(struct seq_file *m, int cpu)
 {
+	rt_rq_iter_t iter;
 	struct rt_rq *rt_rq;
 
 	rcu_read_lock();
-	for_each_leaf_rt_rq(rt_rq, cpu_rq(cpu))
+	for_each_rt_rq(rt_rq, iter, cpu_rq(cpu))
 		print_rt_rq(m, cpu, rt_rq);
 	rcu_read_unlock();
 }
-- 
1.7.1




On 2011-5-11 17:21, Peter Zijlstra wrote:
> On Wed, 2011-05-11 at 15:34 +0800, Cheng Xu wrote:
>> This patch is to fix bug report https://lkml.org/lkml/2011/4/26/13
> 
> This really doesn't tell me anything, please restate the relevant
> information.
> 
>> Function __disable_runtime() reports leakage of rt_rq runtime. The
>> root cause is __disable_runtime() assumes it iterates through all the
>> existing rt_rq's while walking rq->leaf_rt_rq_list, which actually
>> contains only runnable rt_rq's. This problem also applies to
>> __enable_runtime() and print_rt_stats().
> 
> Teach your mailer to wrap at 78 characters for changelogs.
> 
>> The patch is based on above analysis, appears to fix the problem, but is only lightly tested.
>>
>>
>> Signed-off-by: Cheng Xu <chengxu@linux.vnet.ibm.com>
>> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>
> 
> Don't leave whitespace between the tags and the tripple-dash. Also, I'm
> suspecting you're missing a Reported-by: paulmck tag.
> 
>> ---
>>  kernel/sched_rt.c |   31 ++++++++++++++++++++++++-------
>>  1 files changed, 24 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>> index e7cebdc..7f478ff 100644
>> --- a/kernel/sched_rt.c
>> +++ b/kernel/sched_rt.c
>> @@ -183,6 +183,13 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
>>  	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
>>  }
>>  
>> +#define rt_rq_of_rq_decls(name) struct task_group *name
>> +
>> +#define list_for_rt_rq_of_rq(iterator, rq) \
>> +	list_for_each_entry_rcu(iterator, &task_groups, list)
>> +
>> +#define rt_rq_of_rq_deref(iterator, rq) (iterator->rt_rq[cpu_of(rq)])
>> +
>>  static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
>>  {
>>  	list_add_rcu(&rt_rq->leaf_rt_rq_list,
>> @@ -288,6 +295,13 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
>>  	return ktime_to_ns(def_rt_bandwidth.rt_period);
>>  }
>>  
>> +#define rt_rq_of_rq_decls(name) struct rt_rq *name
>> +
>> +#define list_for_rt_rq_of_rq(iterator, rq) \
>> +	for (iterator = &rq->rt; iterator; iterator = NULL)
>> +
>> +#define rt_rq_of_rq_deref(iterator, rq) (iterator)
>> +
>>  static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
>>  {
>>  }
> 
> So I see why you did that, I just don't much like it.. esp the decls
> macros, C has typedef to deal with that problem, also you can get rid of
> the deref macros (now if we were allowed C99 we could avoid the whole
> iter thing and declare a for-scope variable).
> 
> How about something like:
> 
> typedef struct task_group *rt_rq_iter_t;
> 
> #define for_each_rt_rq(rt_rq, iter, rq)                                     \
> 	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list),  \
> 	     rt_rq = iter->rt_rq[cpu_of(rq)]; &iter->list != &task_groups;  \
> 	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list),   \
> 	     rt_rq = iter->rt_rq[cpu_of(rq)])
> 
> 	    
> which is then used like:
> 
> 	rt_rq_iter_t iter;
> 	struct rt_rq *rt_rq;
> 
> 	for_each_rt_rq(rt_rq, iter, rq) {
> 		/* do something with rt_rq */
> 	}
> 
> 

