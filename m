Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2BXCIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 21:08:21 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50676 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab2BXCIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 21:08:19 -0500
Message-ID: <4F46F105.2000702@linux.vnet.ibm.com>
Date: Fri, 24 Feb 2012 10:08:05 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched: Avoid unnecessary work in reweight_entity
References: <4F2F9F6C.1090608@linux.vnet.ibm.com> <4F3089F9.6010609@linux.vnet.ibm.com> <4F308E25.7060101@linux.vnet.ibm.com> <4F31D9B2.5090501@linux.vnet.ibm.com> <4F3D0F41.1010205@linux.vnet.ibm.com> <1329402561.2293.225.camel@twins> <4F3DEDC3.4010004@linux.vnet.ibm.com> <4F3F025B.5010400@linux.vnet.ibm.com> <1329743311.2293.341.camel@twins> <4F4617AB.2080401@linux.vnet.ibm.com>
In-Reply-To: <4F4617AB.2080401@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12022402-4790-0000-0000-000001785B63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 06:40 PM, Michael Wang wrote:

> On 02/20/2012 09:08 PM, Peter Zijlstra wrote:
> 
> Hi, Peter
> 
> Sorry for reply so late, I was blocked by some issue army while setup the 
> testing environment.
> 
>> On Sat, 2012-02-18 at 09:43 +0800, Michael Wang wrote:
>>> And as reight_entity is invoked very often, I think this patch can do some help to the 
>>> performance, although there are no numbers, we can prove it logically :)  
>>
>> Well, you're probably right (although I think you completely ignored the
>> optimizing compiler), but still it would be good to get some numbers to
>> confirm reality :-)
> 
> 
> That's right, if consider the compiler's optimization, the logic improvements 
> I listed may not be true...
> 
>>
> 
>> Just pick your favourite cgroup workload/benchmark and run a pre/post
>> comparison, possible using perf record.
>>
>> If all squares up you should see an improvement in your benchmark score
>> as well as see a reduction in time spend in the function you're
>> patching.
> 
> 
> So I created a cpuset cgroup 'rg1' and his sub memory group 'sub',
> attached current shell to 'sub', then use 'time make kernel' as benchmark.
> 
> Below is the test result:
> 
> 'time make':
> old
> 	real: 87m53.804s	user: 66m41.886s	sys: 11m51.792s
> new
> 	real: 86m8.485s		user: 65m49.211s	sys: 11m47.264s
> 
> 'time make -j14':
> old:	
> 	real: 42m43.825s	user: 124m13.726s	sys: 17m57.183s
> new
> 	real: 39m0.072s		user: 114m33.258s	sys: 15m30.662s
> 


Hi, Peter

Someone notify me that this result is ridiculous, I should have done more test, 
not just once, this is really my fault, please give me more time, I will back 
with more data so we can use average number.

Regards,
Michael Wang

> I also try to use 'perf sched record', but I can only record few seconds time,
> otherwise it will be too big and report some error, as the record time is too 
> short, results are very different from each other, I failed to use them to prove 
> the patch:(
> 
> I also have try to use some other method, I moved 'reweight_entity' and related 
> functions to user space, and invoke it 10000000 times in 'main', I have append 
> part of the code (really raw...) in the end.
> 
> Three times output is:
> 
> old:
> 	real	0m0.715s	0m0.710s	0m0.739s
> 	user	0m0.716s	0m0.708s	0m0.736s
> 	sys	0m0.000s	0m0.000s	0m0.000s
> 
> new:
> 	real	0m0.318s	0m0.308s	0m0.317s
> 	user	0m0.316s	0m0.304s	0m0.316s
> 	sys	0m0.000s	0m0.000s	0m0.000s
> 
> It seems like that new code can save more then half execution time, but also we 
> can see, after calculation, what I have done can only save 0.04ns(too small...).
> 
> The user space test result is not accurate but at least we can know new code is
> faster then old.
> 
> Please tell me if we need to do some thing else, and thanks for your suggestion :)
> 
> Regards,
> Michael Wang
> 
> 
> 
> User space code:
> 
> void
> account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
> {
>         update_load_add(&cfs_rq->load, se->load.weight);
>         if (1)
>                 update_load_add(&cfs_rq->load, se->load.weight);
>         if (1) {
>                 add_cfs_task_weight(cfs_rq, se->load.weight);
>                 list_add(&se->group_node, &cfs_rq->tasks);
>         }
>         cfs_rq->nr_running++;
> }
> 
> void
> account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
> {
>         update_load_sub(&cfs_rq->load, se->load.weight);
>         if (1)
>                 update_load_sub(&cfs_rq->load, se->load.weight);
>         if (1) {
>                 add_cfs_task_weight(cfs_rq, -se->load.weight);
>                 list_del_init(&se->group_node);
>         }
>         cfs_rq->nr_running--;
> }
> 
> void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
>                             unsigned long weight)
> {
>         if (1) {
>                 account_entity_dequeue(cfs_rq, se);
>         }
> 
>         update_load_set(&se->load, weight);
> 
>         if (1)
>                 account_entity_enqueue(cfs_rq, se);
> }
> 
> void reweight_entity_new(struct cfs_rq *cfs_rq, struct sched_entity *se,
>                             unsigned long weight)
> {
>         if (1) {
>                 update_load_add(&cfs_rq->load, weight - se->load.weight);
>                 if(1)
>                         update_load_add(&cfs_rq->load, weight -
> se->load.weight);
>                 if(1)
>                         add_cfs_task_weight(cfs_rq, weight
> -se->load.weight);
>         }
>         update_load_set(&se->load, weight);
> }
> 
> int main()
> {
>         struct cfs_rq cfsrq;
>         struct sched_entity se;
>         memset(&cfsrq, 0, sizeof(struct cfs_rq));
>         memset(&se, 0, sizeof(struct sched_entity));
>         INIT_LIST_HEAD(&se.group_node);
>         INIT_LIST_HEAD(&cfsrq.tasks);
>         int i = 10000000;
>         while(i) {
>                 i--;
>                 reweight_entity_new(&cfsrq, &se, 10);
>                 //reweight_entity(&cfsrq, &se, 10);
>         }
> }
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


