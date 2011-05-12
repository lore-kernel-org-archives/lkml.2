Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1ELKzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:55:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52226 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab1ELKze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:55:34 -0400
Message-ID: <4DCBBC9D.7020908@linux.vnet.ibm.com>
Date: Thu, 12 May 2011 18:55:25 +0800
From: Cheng Xu <chengxu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mckenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: rt_rq runtime leakage bug fix
References: <4DCA3C0C.3080901@linux.vnet.ibm.com> <1305105711.2914.205.camel@laptop>  <4DCAC79A.7050505@linux.vnet.ibm.com> <1305195150.2914.268.camel@laptop>
In-Reply-To: <1305195150.2914.268.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/2011 18:12, Peter Zijlstra wrote:
> On Thu, 2011-05-12 at 01:30 +0800, Cheng Xu wrote:
>>
>> I tried but hit a boot-time error "Unable to handle kernel paging
>> request for data at address 0x100000008", and therefore would like to
>> propose an alternative patch like,
>>
> I probably made a silly mistake somehwere, it was after all something
> quickly typed in an email :-)
> 
>> #define for_each_rt_rq(rt_rq, iter, rq) \
>>         for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
>>              (&iter->list != &task_groups) && (rt_rq = iter->rt_rq[cpu_of(rq)]); \
>>              iter = list_entry_rcu(iter->list.next, typeof(*iter), list))
>>
>> This worked, it seems to pass the tests.  Is this correct from a scheduler perspective?
> 
> Creative ;-), it would be nice to know why the , operator version
> doesn't work though, since that looks to be the more conventional way to
> write it.

Yes I am also wondering why it doesn't work. will look into it and get
back to you later.

> 
> That said, I don't see a problem with using your existing on.
> 
>> For the not CONFIG_RT_GROUP_SCHED part, I used 
>>
>> typedef struct rt_rq *rt_rq_iter_t;
>>
>> #define for_each_rt_rq(rt_rq, iter, rq) \
>>         (void) iter; \
>>         for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
>>
>> An alternative is 
>> #define for_each_rt_rq(rt_rq, iter, rq) \
>>         for (rt_rq = iter = &rq->rt; iter; rt_rq = iter = NULL)
> 
> Tough call that, the first has a multi-statement macro, which is
> generally discouraged because then:
> 
>   for()
>    for_each_rt_rq() {
>    }
> 
> will not work as expected, so I think we want the second version.

Agree, I realized this problem soon after sending out the email
yesterday, :) and improved it to be

#define for_each_rt_rq(rt_rq, iter, rq) \
	for ((void) iter, rt_rq = &rq->rt; rt_rq; rt_rq = NULL)

maybe we can still use it?

> 
>> The patch is attached below. Could you check whether it is workable? Thank you. 
> 
> Yes, given how things are I can't really see it getting any better,
> thanks!
> 

I have updated the patch content according to the comments, and done
part of the test. will send out the complete second version for your
review soon.

Thank you very much!

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


