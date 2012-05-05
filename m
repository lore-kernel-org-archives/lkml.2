Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2EERQh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 13:16:37 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36195 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab2EERQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 13:16:35 -0400
Message-ID: <4FA56047.9090405@linux.vnet.ibm.com>
Date: Sat, 05 May 2012 22:45:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
References: <20120504191535.4603.83236.stgit@srivatsabhat> <1336159496.6509.51.camel@twins> <4FA434E9.6000305@linux.vnet.ibm.com> <1336162456.6509.63.camel@twins> <20120504204627.GB18177@linux.vnet.ibm.com>
In-Reply-To: <20120504204627.GB18177@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050517-5564-0000-0000-0000027AB58E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 02:16 AM, Nishanth Aravamudan wrote:

> On 04.05.2012 [22:14:16 +0200], Peter Zijlstra wrote:
>> On Sat, 2012-05-05 at 01:28 +0530, Srivatsa S. Bhat wrote:
>>> On 05/05/2012 12:54 AM, Peter Zijlstra wrote:
>>>
>>>>
>>>>>   Documentation/cgroups/cpusets.txt |   43 +++--
>>>>>  include/linux/cpuset.h            |    4 
>>>>>  kernel/cpuset.c                   |  317 ++++++++++++++++++++++++++++---------
>>>>>  kernel/sched/core.c               |    4 
>>>>>  4 files changed, 274 insertions(+), 94 deletions(-)
>>>>
>>>> Bah, I really hate this complexity you've created for a problem that
>>>> really doesn't exist.
>>>>
>>>
>>>
>>> Doesn't exist? Well, I believe we do have a problem and a serious one
>>> at that too!
>>
>> Still not convinced,..
>>
>>> The heart of the problem can be summarized in 2 sentences:
>>>
>>> o	During a CPU hotplug, tasks can move between cpusets, and never
>>> 	come back to their original cpuset.
>>
>> This is a feature! You cannot say a task is part of a cpuset and then
>> run it elsewhere just because things don't work out.
>>
>> That's actively violating the meaning of cpusets.
> 
> Tbh, I agree with you Peter, as I think that's how cpusets *should*
> work.


I agree that that's how cpusets must and should work in usual scenarios.
Otherwise, the whole concept of cpusets wouldn't make much sense.

However, in the face of hotplug, there are examples in the existing kernel
itself, where that principle is 'violated' in the strictest sense.

sched_setaffinity():
It calls cpuset_cpus_allowed() to find out what cpus are allowed for that
task (looking at the cpuset it is attached to), so that it can validate or
reduce the newly requested mask keeping the allowed cpus in mind.

But how does cpuset_cpus_allowed() calculate the "allowed cpus" for this task?
It calls guarantee_online_cpus(), which does exactly what I tried to do in
this patchset! That is, if the task's cpuset doesn't have any online cpus,
it goes up the cpuset hierarchy, trying to find a parent cpuset that does
have some online cpus and returns that mask! That too, without complaining!

So it looks like the kernel already has relaxations with respect to cpusets
or allowed cpus when it is faced with hotplug..

> But I'll also reference `man cpuset`:
> 
>        Not all allocations of system memory are constrained by cpusets,
>        for the following reasons.
> 
>        If  hot-plug  functionality is used to remove all the CPUs that
>        are currently assigned to a cpuset, then the kernel will
>        automatically update the cpus_allowed of all processes attached
>        to CPUs in that cpuset to allow all CPUs.  When memory hot-plug
>        function- ality  for  removing  memory  nodes  is available, a
>        similar exception is expected to apply there as well.  In
>        general, the kernel prefers to violate cpuset placement, rather
>        than starving a process that has had all its allowed CPUs or
>        memory nodes  taken  off- line.   User  code  should  reconfigure
>        cpusets to only refer to online CPUs and memory nodes when using
>        hot-plug to add or remove such resources.
> 
> So cpusets are, per their own documentation, not hard-limits in the face
> of hotplug.
> 


Right. So it is up to us to strike a balance in whatever way we choose -
o	just kill those tasks and be done with it
o	or come up with nice variants (it is worth noting that the documentation
	is flexible in the sense that it doesn't imply any hard-and-fast rule
	as to how exactly we should implement the nice variants.)

> I, personally, think we should just kill of tasks in cpuset-constrained
> environments that are nonsensical (no memory, no cpus, etc.). 


Even I think just killing the tasks or maybe even preventing such destructive
hotplug (last cpu in a cpuset going offline) would have been way more
easier to handle and also logical.. and userspace would have been more
cautious while dealing with cpusets, from the beginning....

> But, it
> would seem we've already supported this (inherit the parent in the face
> of hotplug) behavior in the past. Not sure we should break it ... at
> least on the surface.
> 


Yes. Now that the kernel already sported a nice variant from a long time,
it wouldn't be good to break that, IMHO. But the question is, is that particular
nice variant/feature (move tasks to another cpuset, so that we strictly follow
the cpuset concept no matter what) really that good of a compromise?
IOW, if we came up with such a nice variant to be good/accommodating to users,
have we really achieved that goal, or have we created more woes instead?

So, I think, considering the following 2 factors, namely:
o	cpusets are not hard-limits in the face of hotplug, as per their own
	documentation, and the doc itself promises flexible nice variants,
	whose implementation we are free to choose.
o	sched_setaffinity() already does what I intended to do for cpusets
	with this patchset.

Considering these, I think it is OK to revisit and rework how we deal with
cpusets during hotplug...

Oh by the way, my patchset also exposes a new file that shows exactly what
cpus the tasks in a cpuset are allowed to run on - so that we are not doing
anything sneaky under the hood, without the user's knowledge. So it is also
easy for userspace to check if things deviated from the original configuration,
and establish a new configuration if needed, by writing to cpuset.cpus file,
which the kernel will immediately honour.

>>> o	Tasks might get pinned to lesser number of cpus, unreasonably.
>>
>> -ENOPARSE, are you trying to say that when the set contains 4 cpus and
>> you unplug one its left with 3? Sounds like pretty damn obvious, that's
>> what unplug does, it takes a cpu away.
> 
> I think he's saying that it's pinned to 3 forever, even if that 4th CPU
> is re-plugged.
> 


Yes, I meant that. Sorry for not being clear.

<snip>

> 
> So I can see several solutions:
> 
> - Rework cpusets to not be so nice to the user and kill of tasks that
>   run in stupid cpusets. (to be written)
> - Keep current behavior to be nice to the user, but make it much noisier
>   when the cpuset rules are being broken because they are stupid (do
>   nothing choice)
> - Track/restore the user's setup when it's possible to do so. (this
>   patchset)
> 
> I'm not sure any of these is "better" than the rest, but they probably
> all have distinct merits.
> 


Yep, and it makes sense to choose the one which the kernel is willing
to support, within its constraints. And if that happens to be a nice variant
anyway, why not choose the one which actually helps...?

Regards,
Srivatsa S. Bhat

