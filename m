Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750949Ab2LLF1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 00:27:22 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:55567 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2LLF1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 00:27:21 -0500
Message-ID: <50C81588.20901@linux.vnet.ibm.com>
Date: Wed, 12 Dec 2012 10:56:32 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: Re: [PATCH 01/18] sched: select_task_rq_fair clean up
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <1355127754-8444-2-git-send-email-alex.shi@intel.com> <50C6B530.3030307@linux.vnet.ibm.com> <50C6C462.6030808@intel.com> <50C6D31F.1030408@linux.vnet.ibm.com> <50C71EA9.3060507@intel.com>
In-Reply-To: <50C71EA9.3060507@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121205-2000-0000-0000-00000A39B0BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 05:23 PM, Alex Shi wrote:
> On 12/11/2012 02:30 PM, Preeti U Murthy wrote:
>> On 12/11/2012 10:58 AM, Alex Shi wrote:
>>> On 12/11/2012 12:23 PM, Preeti U Murthy wrote:
>>>> Hi Alex,
>>>>
>>>> On 12/10/2012 01:52 PM, Alex Shi wrote:
>>>>> It is impossible to miss a task allowed cpu in a eligible group.
>>>>
>>>> The one thing I am concerned with here is if there is a possibility of
>>>> the task changing its tsk_cpus_allowed() while this code is running.
>>>>
>>>> i.e find_idlest_group() finds an idle group,then the tsk_cpus_allowed()
>>>> for the task changes,perhaps by the user himself,which might not include
>>>> the cpus in the idle group.After this find_idlest_cpu() is called.I mean
>>>> a race condition in short.Then we might not have an eligible cpu in that
>>>> group right?
>>>
>>> your worry make sense, but the code handle the situation, in
>>> select_task_rq(), it will check the cpu allowed again. if the answer is
>>> no, it will fallback to old cpu.
>>>>
>>>>> And since find_idlest_group only return a different group which
>>>>> excludes old cpu, it's also imporissible to find a new cpu same as old
>>>>> cpu.
>>
>> I doubt this will work correctly.Consider the following situation:sched
>> domain begins with sd that encloses both socket1 and socket2
>>
>> cpu0 cpu1  | cpu2 cpu3
>> -----------|-------------
>>  socket1   |  socket2
>>
>> old cpu = cpu1
>>
>> Iteration1:
>> 1.find_idlest_group() returns socket2 to be idlest.
>> 2.task changes tsk_allowed_cpus to 0,1
>> 3.find_idlest_cpu() returns cpu2
>>
>> * without your patch
>>    1.the condition after find_idlest_cpu() returns -1,and sd->child is
>> chosen which happens to be socket1
>>    2.in the next iteration, find_idlest_group() and find_idlest_cpu()
>> will probably choose cpu0 which happens to be idler than cpu1,which is
>> in tsk_allowed_cpu.
> 
> Thanks for question Preeti! :)
> 
> Yes, with more iteration you has more possibility to get task allowed
> cpu in select_task_rq_fair. but how many opportunity the situation
> happened?  how much gain you get here?
> With LCPU increasing many many iterations cause scalability issue. that
> is the simplified forking patchset for. and that why 10% performance
> gain on hackbench process/thread.
> 
> and if you insist want not to miss your chance in strf(), the current
> iteration is still not enough. How you know the idlest cpu is still
> idlest after this function finished? how to ensure the allowed cpu won't
> be changed again?
> 
> A quick snapshot is enough in balancing here. we still has periodic
> balacning.

Hmm ok,let me look at this more closely.
> 
>>
>> * with your patch
>>    1.the condition after find_idlest_cpu() does not exist,therefore
>> a sched domain to which cpu2 belongs to is chosen.this is socket2.(under
>> the for_each_domain() loop).
>>    2.in the next iteration, find_idlest_group() return NULL,because
>> there is no cpu which intersects with tsk_allowed_cpus.
>>    3.in select task rq,the fallback cpu is chosen even when an idle cpu
>> existed.
>>
>> So my concern is though select_task_rq() checks the
>> tsk_allowed_cpus(),you might end up choosing a different path of
>> sched_domains compared to without this patch as shown above.
>>
>> In short without the "if(new_cpu==-1)" condition we might get misled
>> doing unnecessary iterations over the wrong sched domains in
>> select_task_rq_fair().(Think about situations when not all the cpus of
>> socket2 are disallowed by the task,then there will more iterations in
> 
> After read the first 4 patches, believe you will find the patchset is
> trying to reduce iterations, not increase them.

Right,sorry about not noticing this.
> 
>> the wrong path of sched_domains before exit,compared to what is shown
>> above.)
>>
Regards
Preeti U Murthy

