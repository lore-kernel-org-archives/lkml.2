Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab2GEXuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:50:37 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39756 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab2GEXug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:50:36 -0400
Message-ID: <4FF62843.4010305@linux.vnet.ibm.com>
Date: Fri, 06 Jul 2012 07:50:27 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC BUG] There is a potential bug in "yield_to"
References: <4FF526BF.7030000@linux.vnet.ibm.com> <1341477343.7709.4.camel@twins>
In-Reply-To: <1341477343.7709.4.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12070513-9264-0000-0000-000001DB36F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 04:35 PM, Peter Zijlstra wrote:
> On Thu, 2012-07-05 at 13:31 +0800, Michael Wang wrote:
>> Hi, All
>>
>> I found there may be a potential bug in "yield_to":
>>
>>         local_irq_save(flags);
>>         rq = this_rq();
>>
>> again:	
>>
>> //task's rq may already changed in "sched_move_task"
>>
>>         p_rq = task_rq(p);
>>         double_rq_lock(rq, p_rq);
>>         while (task_rq(p) != p_rq) {
>>                 double_rq_unlock(rq, p_rq);
>>                 goto again;
>>         }
>>
>> I think it may happen in this scene:
>>
>> 	cpu 0				cpu 1(task a)
>>
>> 					yield_to {
>> 					disable_irq
>> 	sched_move_task {		rq = this_rq();
>> 	task_rq_lock(task a)		double_rq_lock
>>
>> 	hold lock of rq 1			
>> 	set_task_rq			//task rq changed
>> 	release lock of rq 1
>>
>> 					hold lock of rq 1
>> 					but task b no longer
>> 					there
>>
>> 					set rq 1's current to
>> 					skip which is not task a
>>
>> which means we hold a rq's lock but it's current is not the one should
>> do yield.
>>
>> Only "sched_move_task" will cause this issue as it will move the task
>> which is still running.
>>
>> The bug will make the task who want to do yield failed to set skip buddy
>> to himself, but to a innocent task instead, not very harmful and almost
>> impossible to occur in normal, but should we fix it with another check
>> "rq == this_rq()"?
> 
> Uhm, what?!
> 
> We've got interrupts disabled, this_rq() cannot ever possibly change, so
> rq is always correct.
> 
I know I should have missed some thing, the schedule won't happen until
enable the irq later, so even that scene happen, nothing will change on rq.

Thanks for your explain :)

Regards,
Michael Wang

> Only p_rq can change, and we have an again loop on that, so what's the
> problem again?
> 


