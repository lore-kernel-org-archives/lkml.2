Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab2BYN4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 08:56:40 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53337 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab2BYN4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 08:56:38 -0500
Message-ID: <4F48E882.6090409@linux.vnet.ibm.com>
Date: Sat, 25 Feb 2012 21:56:18 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched: Avoid unnecessary work in reweight_entity
References: <4F2F9F6C.1090608@linux.vnet.ibm.com> <4F3089F9.6010609@linux.vnet.ibm.com> <4F308E25.7060101@linux.vnet.ibm.com> <4F31D9B2.5090501@linux.vnet.ibm.com> <4F3D0F41.1010205@linux.vnet.ibm.com> <1329402561.2293.225.camel@twins> <4F3DEDC3.4010004@linux.vnet.ibm.com> <4F3F025B.5010400@linux.vnet.ibm.com> <1329743311.2293.341.camel@twins> <4F4617AB.2080401@linux.vnet.ibm.com> <4F46F105.2000702@linux.vnet.ibm.com>
In-Reply-To: <4F46F105.2000702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12022513-5816-0000-0000-000001720E51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

I have collected more testing data, here is the test results:

Machine:	ThinkPad T420
OS:		Ubuntu 11.10
Benchmark:	time make -j14 (build kernel)

pre:

	real		user		sys
1.	38m32.274s	111m53.116s	15m31.866s
2.	38m36.775s	110m49.364s	16m40.927s
3.	38m48.107s	111m29.806s	16m35.794s
4.	38m35.009s	111m41.443s	16m9.705s
5	38m49.189s	112m14.973s	15m57.924s				
6.	38m34.523s	109m0.265s	17m6.584s
7.	38m38.986s	110m3.385s	16m52.735s

Avg	38m47.838s	111m1.765s	16m25.076s	

post:

	real		user		sys
1.	39m32.546s	113m28.918s	16m19.217s
2.	38m40.743s	112m9.057s	15m34.246s
3.	39m12.018s	113m9.192s	16m22.933s
4.	38m55.000s	113m56.203s	15m41.343s	
5.	38m53.893s	111m35.814s	15m45.303s
6.	38m48.234s	111m17.537s	15m41.287s
7.	39m11.803s	111m2.760s	16m0.012s

Avg	39m2.034s	112m22.783s	15m50.055s

Summary:
		real		user		sys		user + sys
pre	Avg	38m47.838s	111m1.765s	16m25.076s	127m26.841s
post	Avg	39m2.034s	112m22.783s	15m50.055s	128m12.838s
		+0.6%		+1.22%		-3.69%		+0.6%
	
The machine is dedicated, so I think the results should be accurate,
what we can see is the time cost in sys reduced obviously, I think this 
is caused by "reweight_entity"'s reduced execution time(which we can check 
in user space).

But I was confused that why the time 'user' and 'real' increased while the 
'sys' down, so I really want to know your opinion on the testing result, and
will be appreciate if some one willing to provide his point of view.

Regards,
Michael Wang

On 02/24/2012 10:08 AM, Michael Wang wrote:

> On 02/23/2012 06:40 PM, Michael Wang wrote:
> 
>> On 02/20/2012 09:08 PM, Peter Zijlstra wrote:
>>
>> Hi, Peter
>>
>> Sorry for reply so late, I was blocked by some issue army while setup the 
>> testing environment.
>>
>>> On Sat, 2012-02-18 at 09:43 +0800, Michael Wang wrote:
>>>> And as reight_entity is invoked very often, I think this patch can do some help to the 
>>>> performance, although there are no numbers, we can prove it logically :)  
>>>
>>> Well, you're probably right (although I think you completely ignored the
>>> optimizing compiler), but still it would be good to get some numbers to
>>> confirm reality :-)
>>
>>
>> That's right, if consider the compiler's optimization, the logic improvements 
>> I listed may not be true...
>>
>>>
>>
>>> Just pick your favourite cgroup workload/benchmark and run a pre/post
>>> comparison, possible using perf record.
>>>
>>> If all squares up you should see an improvement in your benchmark score
>>> as well as see a reduction in time spend in the function you're
>>> patching.
>>
>>
>> So I created a cpuset cgroup 'rg1' and his sub memory group 'sub',
>> attached current shell to 'sub', then use 'time make kernel' as benchmark.
>>
>> Below is the test result:
>>
>> 'time make':
>> old
>> 	real: 87m53.804s	user: 66m41.886s	sys: 11m51.792s
>> new
>> 	real: 86m8.485s		user: 65m49.211s	sys: 11m47.264s
>>
>> 'time make -j14':
>> old:	
>> 	real: 42m43.825s	user: 124m13.726s	sys: 17m57.183s
>> new
>> 	real: 39m0.072s		user: 114m33.258s	sys: 15m30.662s
>>
> 
> 
> Hi, Peter
> 
> Someone notify me that this result is ridiculous, I should have done more test, 
> not just once, this is really my fault, please give me more time, I will back 
> with more data so we can use average number.
> 
> Regards,
> Michael Wang
> 
>> I also try to use 'perf sched record', but I can only record few seconds time,
>> otherwise it will be too big and report some error, as the record time is too 
>> short, results are very different from each other, I failed to use them to prove 
>> the patch:(
>>
>> I also have try to use some other method, I moved 'reweight_entity' and related 
>> functions to user space, and invoke it 10000000 times in 'main', I have append 
>> part of the code (really raw...) in the end.
>>
>> Three times output is:
>>
>> old:
>> 	real	0m0.715s	0m0.710s	0m0.739s
>> 	user	0m0.716s	0m0.708s	0m0.736s
>> 	sys	0m0.000s	0m0.000s	0m0.000s
>>
>> new:
>> 	real	0m0.318s	0m0.308s	0m0.317s
>> 	user	0m0.316s	0m0.304s	0m0.316s
>> 	sys	0m0.000s	0m0.000s	0m0.000s
>>
>> It seems like that new code can save more then half execution time, but also we 
>> can see, after calculation, what I have done can only save 0.04ns(too small...).
>>
>> The user space test result is not accurate but at least we can know new code is
>> faster then old.
>>
>> Please tell me if we need to do some thing else, and thanks for your suggestion :)
>>
>> Regards,
>> Michael Wang
>>
>>
>>
>> User space code:
>>
>> void
>> account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
>> {
>>         update_load_add(&cfs_rq->load, se->load.weight);
>>         if (1)
>>                 update_load_add(&cfs_rq->load, se->load.weight);
>>         if (1) {
>>                 add_cfs_task_weight(cfs_rq, se->load.weight);
>>                 list_add(&se->group_node, &cfs_rq->tasks);
>>         }
>>         cfs_rq->nr_running++;
>> }
>>
>> void
>> account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
>> {
>>         update_load_sub(&cfs_rq->load, se->load.weight);
>>         if (1)
>>                 update_load_sub(&cfs_rq->load, se->load.weight);
>>         if (1) {
>>                 add_cfs_task_weight(cfs_rq, -se->load.weight);
>>                 list_del_init(&se->group_node);
>>         }
>>         cfs_rq->nr_running--;
>> }
>>
>> void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
>>                             unsigned long weight)
>> {
>>         if (1) {
>>                 account_entity_dequeue(cfs_rq, se);
>>         }
>>
>>         update_load_set(&se->load, weight);
>>
>>         if (1)
>>                 account_entity_enqueue(cfs_rq, se);
>> }
>>
>> void reweight_entity_new(struct cfs_rq *cfs_rq, struct sched_entity *se,
>>                             unsigned long weight)
>> {
>>         if (1) {
>>                 update_load_add(&cfs_rq->load, weight - se->load.weight);
>>                 if(1)
>>                         update_load_add(&cfs_rq->load, weight -
>> se->load.weight);
>>                 if(1)
>>                         add_cfs_task_weight(cfs_rq, weight
>> -se->load.weight);
>>         }
>>         update_load_set(&se->load, weight);
>> }
>>
>> int main()
>> {
>>         struct cfs_rq cfsrq;
>>         struct sched_entity se;
>>         memset(&cfsrq, 0, sizeof(struct cfs_rq));
>>         memset(&se, 0, sizeof(struct sched_entity));
>>         INIT_LIST_HEAD(&se.group_node);
>>         INIT_LIST_HEAD(&cfsrq.tasks);
>>         int i = 10000000;
>>         while(i) {
>>                 i--;
>>                 reweight_entity_new(&cfsrq, &se, 10);
>>                 //reweight_entity(&cfsrq, &se, 10);
>>         }
>> }
>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
>>
>>
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


