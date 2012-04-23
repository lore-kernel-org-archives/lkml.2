Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2DWNPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:15:18 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50720 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2DWNPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:15:16 -0400
Message-ID: <4F9555C5.6040601@linux.vnet.ibm.com>
Date: Mon, 23 Apr 2012 18:44:45 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at suspend/resume
References: <20120306204357.13169.90791.stgit@zurg> <1331067743.11248.333.camel@twins> <CA+55aFxPiW=T8iNy=Fb_fuO2DYV9+sQL-mr8=Uc7cWymTyVt6A@mail.gmail.com> <1331084302.11248.338.camel@twins> <CA+55aFx6NXjLpAz_Bu1wvaxFB-2zrYGkfBeN_8rM5q7MkYuNEQ@mail.gmail.com> <4F5D00AE.8000602@openvz.org>
In-Reply-To: <4F5D00AE.8000602@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12042313-5564-0000-0000-000002527C9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 01:14 AM, Konstantin Khlebnikov wrote:

> Linus Torvalds wrote:
>> On Tue, Mar 6, 2012 at 5:38 PM, Peter
>> Zijlstra<a.p.zijlstra@chello.nl>  wrote:
>>> On Tue, 2012-03-06 at 16:54 -0800, Linus Torvalds wrote:
>>>> I do agree that reverting is probably safer at this point, but can we
>>>> get agreement on this?
>>>
>>> I agree with reverting, shoot it in the head :-) Do you want a git
>>> thingy?
>>
>> Well, it's less a "git thingy" and more that there are tons of people
>> involved with the original commit that haven't even piped up.
>>
>> Srivatsa, Ingo, Prashanth..
>>
>> In fact, I notice that Prashanth doesn't even seem to have been cc'd,
>> even if he's the original reporter of the commit that gets reverted.
>> Added (see lkml)
> 
> I forget to mention my kernel boot options. I live with them for a
> while, so I just forget about it.
> "debug threadirqs i915.i915_enable_rc6=1 i915.i915_enable_fbc=1
> i915.lvds_downclock=1 crashkernel=128M"
> 
> So, "threadirqs" is a lost piece of the puzzle -- without it I cannot
> reproduce the bug.
> However, I have no idea how this is connected to sched-domains. =)
> 


I know this is a pretty old thread now, but I managed to do some debugging
and get some insight on what might have gone wrong. (The original thread
can be found in [1]. Oh, by the way, this is no longer a problem in the
current mainline because commit 4293f20 (Revert "CPU hotplug, cpusets,
suspend: Don't touch cpusets during suspend/resume") reverted the buggy
commit. So what follows here, is just an analysis of why the original
commit caused suspend hangs in some cases.

The Problem :
  Commit 8f2f748b0656 (CPU hotplug, cpusets, suspend: Don't touch cpusets
  during suspend/resume) caused suspend hangs, and this hang was much more
  reproducible when "threadirqs" was passed as a kernel parameter.
  This hang was observed irrespective of whether cpusets was enabled or
  disabled at compile time. Also, this hang was always at the processors
  level of pm_test, that is, during the CPU Hotplug (offlining) in the
  suspend path.


Preliminary analysis (what we already knew):
  This commit had removed the call to partition_sched_domains() in the CPU
  Hotplug path that was initiated as part of the suspend/resume sequence.
  But this was done under the assumption that the scheduler would look up
  the cpu_active_mask (in which the dying cpu wouldn't be present) to
  make decisions and hence the lost call to partition_sched_domains()
  wouldn't really matter.

  However, Konstantin found experimentally that restoring the call to
  partition_sched_domains() fixed the suspend hang.


The unanswered questions (so far):
  o	Why is that call to partition_sched_domains() so important?
  o	What are those places in which the scheduler doesn't revalidate all
 	its decisions based on the cpu_active_mask, and hence having a stale
        sched domain around is troublesome and leads to hangs during CPU
        offlining?
  o	And why is the "threadirqs" parameter playing any role in all this
        business?


After some rounds of experiments and debugging, I believe I have found some
reasonable explanations to the above questions.

Basically, our assumption that we are good to go (even with stale sched
domains) as long as the dying cpu was not in the cpu_active_mask, was wrong.
There are several places where the scheduler code doesn't really check the
cpu_active_mask, but instead traverses the sched domains to do stuff.

Examples:
1. kernel/sched/core.c and fair.c:
   schedule()
	__schedule()
		idle_balance()


idle_balance() can end up doing:

for_each_domain(dying_cpu, sd) {
	...
}


2. kernel/sched/core.c and rt.c:

migration_call()
	sched_ttwu_pending()
		ttwu_do_activate()
			ttwu_do_wakeup()
				task_woken()
					task_woken_rt()
						push_rt_tasks()
							find_lowest_rq()


find_lowest_rq() can end up doing:

for_each_domain(dying_cpu, sd) {
	...
}


In the original (good) code, the call to partition_sched_domains in the
CPU offline path would set the cpu_rq(dying_cpu)->sd to NULL. And hence,
in both the examples above, the for_each_domain() traversal simply wouldn't
occur because the sched domain pointer is NULL.


However, with commit 8f2f748b0656 applied, since the sd pointer would be
non-NULL, the above code paths would go into the for_each_domain() path and
get confused.

Specifically, in example 1, it would result in the dying cpu having trouble
going to idle in some circumstances, because it does:

__schedule():
        if (unlikely(!rq->nr_running))
	        idle_balance(cpu, rq); 

And we have the following code in the cpu_down path:
	while(!idle_cpu(dying_cpu))
		cpu_relax();

[One such schedule() invocation is from the workqueues' trustee_thread in
the cpu_down path - I saw this in the hung task panic stack trace.]


And example 2 becomes more and more prominent as the number of RT tasks
in the system increases - and "threadirqs" parameter does exactly that, as
far as this scenario is concerned - it force-threads irq handlers and
makes them as RT tasks. And hence the chances that we end up in the code
shown in example 2 increases.

I have experimentally verified some of these things:

1. With commit 8f2f748b0656, suspend and CPU Hotplug almost always hung.

2. I altered the above 2 code paths to ensure we don't do the traversal of
   the sched domains of the dying cpu and found that suspend and CPU hotplug
   work without hang with much higher probability than plain commit 8f2f748b.

3. Then I set cpu_rq(dying_cpu)->sd to NULL on top of commit 8f2f748b (still
   without calling partition_sched_domains) and observed that suspend and
   CPU hotplug worked beautifully, with *absolutely* no hangs. 

So I think the above 2 examples are only _some_ of the many more places where
stale sched domains can mean trouble to CPU hotplug (offlining). [If these
were the only 2 places, then 2 would have worked as good as 3, but it did not.]

So, now that we have a reasonably convincing explanation (I hope) to some of
the previously unanswered questions, I think I can go back to implementing a
proper fix for the cpusets/cpu hotplug issue :-) [which commit 8f2f748b set
out to solve in the first place.] This time, I think I have a better solution
in mind ;-)

[1]. http://thread.gmane.org/gmane.linux.kernel/1262802

Regards,
Srivatsa S. Bhat

