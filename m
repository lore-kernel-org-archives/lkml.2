Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1JMPmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:42:32 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39496 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1JMPma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:42:30 -0400
Message-ID: <4E9706D8.5040105@linux.vnet.ibm.com>
Date: Thu, 13 Oct 2011 21:12:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, bp@amd64.org, pavel@ucw.cz,
        len.brown@intel.com, tj@kernel.org, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, hpa@zytor.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com> <201110122131.08811.rjw@sisk.pl> <4E9605C7.5070203@linux.vnet.ibm.com> <201110130009.26552.rjw@sisk.pl>
In-Reply-To: <201110130009.26552.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 03:39 AM, Rafael J. Wysocki wrote:
> On Wednesday, October 12, 2011, Srivatsa S. Bhat wrote:
>> On 10/13/2011 01:01 AM, Rafael J. Wysocki wrote:
>>> On Wednesday, October 12, 2011, Srivatsa S. Bhat wrote:
>>>> On 10/12/2011 03:26 AM, Rafael J. Wysocki wrote:
>>>>> On Tuesday, October 11, 2011, Srivatsa S. Bhat wrote:
>>>>>> On 10/10/2011 08:46 PM, Srivatsa S. Bhat wrote:
>>>>>>> On 10/10/2011 07:56 PM, Peter Zijlstra wrote:
>>>>>>>> On Mon, 2011-10-10 at 18:15 +0530, Srivatsa S. Bhat wrote:
>>>>>>>>>> +     /*
>>>>>>>>>> +      * Prevent cpu online and suspend/hibernate (including freezer)
>>>>>>>>>> +      * operations from running in parallel. Fail cpu online if suspend or
>>>>>>>>>> +      * hibernate has already started.
>>>>>>>>>> +      */
>>>>>>>>>> +     if (!trylock_pm_sleep())
>>>>>>>>>
>>>>>>>>> Would it be better to hook into the suspend/hibernate notifiers and
>>>>>>>>> use them to exclude cpu hotplug from suspend/hibernate, instead of
>>>>>>>>> trying to take pm_mutex lock like this?
>>>>>>>>> Peter, I remember you pointing out in another patch's review
>>>>>>>>> (http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1199087)
>>>>>>>>> that introducing more locks in cpu hotplug would be a bad idea. Does that
>>>>>>>>> comment hold here as well, or is this fine? 
>>>>>>>>
>>>>>>>> Arguably pm_mutex is already involved in the whole hotplug dance due to
>>>>>>>> suspend using it, that said, I'm not at all familiar with the whole
>>>>>>>> suspend/hibernate side of things.
>>>>>>>>
>>>>>>>> I tried having a quick look this morning but failed to find the actual
>>>>>>>> code.
>>>>>>>>
>>>>>>>> I think it would be good to have an overview of the various locks and a
>>>>>>>> small description of how they interact/nest.
>>>>>>>>
>>>>>>>
>>>>>>> Sure. I'll put together whatever I have understood, in the form of a patch
>>>>>>> to Documentation/power directory and post it tomorrow, for the benefit of
>>>>>>> all.
>>>>>>>
>>>>>>
>>>>>> Here it is, just as promised :-)
>>>>>> http://lkml.org/lkml/2011/10/11/393
>>>>>
>>>>> Well, I have an idea.
>>>>>
>>>>> Why don't we make drivers/base/cpu.c:store_online() take pm_mutex
>>>>> in addition to calling cpu_hotplug_driver_lock()?  This at least
>>>>> will make the interface mutually exclusive with suspend/hibernation.
>>>>>
>>>>
>>>> Oh, no no.. We shouldn't be doing that even though it seems very
>>>> innocuous, because of a subtle reason: the memory hotplug code called
>>>> in cpu_up() tries to acquire pm_mutex! So we will end up deadlocking
>>>> ourselves, due to recursive locking!
>>>
>>> So, you're referring to mem_online_node().  Is it actually used
>>> from any place other than cpu_up()?  Perhaps we can remove the
>>> lock_system_sleep() from lock_memory_hotplug() if store_online()
>>> acquires pm_mutex?  And if we can't, then why exactly?
>>>
>>
>> I didn't find any other place where mem_online_node() is called. But I'll
>> check it more thoroughly to be sure. If cpu_up() is the only place where
>> it is called, then I think we can do what you said above. But doesn't it
>> seem to be more intrusive than what my patch does? I mean, what if something
>> breaks because of that avoidable modification to memory hotplug code?
> 
> We'll need to fix it. :-)
> 
> The current locking in the memory hotplug code and the way it's used
> by the CPU hotplug code seems to be a bit too ad hoc to me, so IMHO
> it makes sense to make it more straightforward anyway.
> 
>>>> See kernel/cpu.c: cpu_up() calls mem_online_node() [defined in
>>>> mm/memory_hotplug.c/mem_online_node() which calls lock_memory_hotplug()
>>>> which internally calls lock_system_sleep(), which is where it tries
>>>> to get pm_mutex].
>>>>
>>>> So this patchset implements the mutual exclusion in the cpu_up() function
>>>> (i.e., a little bit deeper down the road than store_online() ) and solves
>>>> the problem.
>>>
>>> Which is not exactly the right place to do that as Peter has already
>>> indicated.  What you want is really the CPU hotplug interface to be
>>> mutually exclusive with the suspend/hibernation interface, not the
>>> CPU hotplug itself to be mutually exclusive with suspend/hibernation.
>>>
>>
>> Oh, is that what Peter meant? I didn't derive that meaning from what
>> he said...
>> Making the interfaces themselves mutually exclusive is also a good idea.
>> But please see my concerns above, about its implementation aspect.
>>
>> Since my patch solves the problem with less intrusion, and produces
>> roughly the same effect as this interface exclusion idea, why not go with
>> it?
>>
>> Or am I missing something here?
> 
> Your approach may seem to be less intrusive, but it adds locking rules
> to the CPU hotplug code whose locking is complicated enough already.
> IMO it's better to avoid that.
> 

Hi,

Warning: What I am going to say next might be confusing, because I am trying
to map different solutions to different problems, because I think its worth
it, considering the current situation!

Given that the microcode update hotplug optimization is going upstream,
(https://lkml.org/lkml/2011/10/13/258), we know that whether we want to call
it a bugfix or optimization, either way it *is* going to fix this bug.
And this current patchset's mutual exclusion approach was also aimed at fixing
the same bug since at the time it was written, discussion was still going on
about which solution would be better.

So considering the current situation, do we really need 2 solutions for the
same problem? I don't think so.
That said, this patchset is not going to go waste. There is another problem
with cpu hotplug path when freezer is involved, which I was trying to solve
in another thread [1],[2]. Based on Peter's suggestion [3] to avoid introducing
yet another new mutex to the cpu hotplug path, this current patchset, with
minor modifications, seems to be a possible solution to that problem.

So, to summarize, since the objective of this current patchset has been
already taken care of by the microcode update optimization, it doesn't make
much sense to push this patchset with the same old motivation.
However, it so happens that this patchset is useful to solve another problem.
So I feel adapting this patchset to that problem would be a good way to go
forward.

Ideas/comments?

[1] http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1198312
[2] http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1200691
[3] http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1201141

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
