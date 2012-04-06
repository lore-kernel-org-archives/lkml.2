Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab2DFTw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 15:52:56 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:59064 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab2DFTwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 15:52:54 -0400
Message-ID: <4F7F4977.4000302@linux.vnet.ibm.com>
Date: Sat, 07 Apr 2012 01:22:23 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: CPU Hotplug rework
References: <4F674649.2000300@linux.vnet.ibm.com> <4F67474A.20707@linux.vnet.ibm.com> <20120405173918.GC8194@linux.vnet.ibm.com>
In-Reply-To: <20120405173918.GC8194@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12040619-4790-0000-0000-0000021A9AB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 11:09 PM, Paul E. McKenney wrote:

> On Mon, Mar 19, 2012 at 08:18:42PM +0530, Srivatsa S. Bhat wrote:
>> On 03/19/2012 08:14 PM, Srivatsa S. Bhat wrote:
>>
>>> Hi,
>>>
>>> There had been some discussion on CPU Hotplug redesign/rework
>>> some time ago, but it was buried under a thread with a different
>>> subject.
>>> (http://thread.gmane.org/gmane.linux.kernel/1246208/focus=1246404)
>>>
>>> So I am opening a new thread with an appropriate subject to discuss
>>> what needs to be done and how to go about it, as part of the rework.
>>>
>>> Peter Zijlstra and Paul McKenney had come up with TODO lists for the
>>> rework, and here are their extracts from the previous discussion:
> 
> Finally getting around to looking at this in more detail...
> 
>> Additional things that I would like to add to the list:
>>
>> 1. Fix issues with CPU Hotplug callback registration. Currently there
>>    is no totally-race-free way to register callbacks and do setup
>>    for already online cpus.
>>
>>    I had posted an incomplete patchset some time ago regarding this,
>>    which gives an idea of the direction I had in mind.
>>    http://thread.gmane.org/gmane.linux.kernel/1258880/focus=15826
> 
> Another approach is to have the registration function return the
> CPU mask corresponding to the instant at which registration occurred,
> perhaps via an additional function argument that points to a
> cpumask_var_t that can be NULL if you don't care.  Then you can
> do setup for the CPUs indicated in the mask.
>



That would look something like this right?

	register_cpu_notifier(nb, mask);
	do_setup(mask);

If yes, then here is our problem:
1. A CPU hotplug operation can happen, in-between these 2 function calls.
2. No matter how we try to wrap these up with get/put_online_cpus(), it
   will still lead to either a race, or a deadlock, depending on how we
   do it.

Wrapping only do_setup() within get/put_online_cpus() wouldn't serve our
purpose, since the race with CPU Hotplug would still exist, just like
before. So, let's consider what happens when we wrap both the functions
within get/put_online_cpus():

	get_online_cpus();
	register_cpu_notifier(nb, mask);
	do_setup(mask);
	put_online_cpus();

Unfortunately this leads to an ABBA deadlock (see below).
 

> Or am I missing the race you had in mind?  Or is the point to make
> sure that the notifiers execute in order?
> 



No, I wasn't referring to the order of execution of the notifiers here.

Well, the race I was concerned about was the one between a CPU hotplug
operation and a callback registration operation, which might lead to an
ABBA deadlock, with the 2 locks in question being cpu hotplug lock and
cpu_add_remove_lock.

The heart of the problem is that, something as simple as the following
is prone to an ABBA deadlock (note that I am not even talking about
do_setup() here):

	get_online_cpus()
	register_cpu_notifier() or any other variant
	put_online_cpus()

In the above, the lock ordering is:
grab cpu_hotplug lock -> grab cpu_add_remove_lock.

But in a usual CPU hotplug operation, the lock ordering is the exact reverse:
grab cpu_add_remove_lock -> grab cpu_hotplug lock.

Hence, we have an ABBA deadlock possibility.

I had posted a pictorial representation of the deadlock condition here:
https://lkml.org/lkml/2012/3/19/289

So, to get rid of this deadlock, the approach I proposed came out of the
following observation:

A code such as:

	register_cpu_notifier();

	//Go on doing stuff that are irrelevant to CPU hotplug.

is totally safe from any kind of race or deadlock, the reason being that
CPU Hotplug operations begin by taking the cpu_add_remove_lock, and
callback registration functions like the above also take only this
particular lock. IOW, the mutex that protects a race between CPU hotplug
operation vs callback registration is the cpu_add_remove_lock. The
cpu_hotplug lock is actually irrelevant here!


	CPU0				CPU 1
register_cpu_notifier()			cpu_down()
----------------------------------------------------------------------

acquire cpu_add_remove_lock
					Blocked on cpu_add_remove_lock

do callback registration

release cpu_add_remove_lock

					Only now we can proceed and acquire
					the cpu_add_remove_lock.

					acquire cpu_hotplug lock
					do cpu_down related work
					release cpu_hotplug lock

					release cpu_add_remove_lock


So my approach is: consider whatever we want to do while registering our
callback, including doing setup for already online cpus; - and do *all of it*
within the section marked as "do callback registration". IOW, we piggyback
on something _known_ to be perfectly fine and hence avoid all races and
deadlocks.

>> 2. There is a mismatch between the code and the documentation around
>>    the difference between [un/register]_hotcpu_notifier and
>>    [un/register]_cpu_notifier. And I remember seeing several places in
>>    the code that uses them inconsistently. Not terribly important, but
>>    good to fix it up while we are at it.
> 
> The following lead me to believe that they were the same:
> 
> #define register_hotcpu_notifier(nb)    register_cpu_notifier(nb)
> #define unregister_hotcpu_notifier(nb)  unregister_cpu_notifier(nb)
> 

> What am I missing here?



At first, even I thought that they were exactly same. But then looking at the
#ifdef magic in include/linux/cpu.h, I realized that there is a subtle
difference between the two:

The register_cpu_notifier() family of functions are defined whenever:
a. CONFIG_HOTPLUG_CPU is set
b. or, CONFIG_HOTPLUG_CPU is not set, but we are in core code
   ie., !defined(MODULE)

The hotcpu family of functions are different in the sense that they are
defined only when CONFIG_HOTPLUG_CPU is set. However, if CONFIG_HOTPLUG_CPU
is not set, they are defined as pretty much empty functions, irrespective of
whether we are calling them from core code or from module code.

And the reasoning behind this difference is: strictly speaking,
CONFIG_HOTPLUG_CPU needs to be set only if we want to *offline* CPUs at
some point in time, like suspend/resume for example. Otherwise, we don't need
to set CONFIG_HOTPLUG_CPU.

But there are subsystems/arch specific stuff which need to take action even
during CPU online operations (like booting), and hence their callback
registrations must work even when CONFIG_HOTPLUG_CPU is not set. So they must
use the native register_cpu_notifier() family of functions.

If some code doesn't really care much when offlining of CPUs is not required,
then they can use the hotcpu_* family and optimize out for the !HOTPLUG_CPU
case.

None of this seems to be documented in Documentation/cpu-hotplug.txt. In fact
what that document explains (something about early init/late init) is actually
misleading because it is out-dated beyond recognition! :-(

Now coming to the inconsistent uses of these functions, if some core code which
needs to register its callback irrespective of CONFIG_HOTPLUG_CPU, uses
hotcpu* variants instead, it'll break stuff in the !HOTPLUG_CPU case.
The other case (using register_cpu* variants in every place) is less worrisome,
in fact harmless, but could have been optimized out in the !HOTPLUG_CPU case,
if the hotcpu* variants had been used.

> 
>> 3. There was another thread where stuff related to CPU hotplug had been
>>    discussed. It had exposed some new challenges to CPU hotplug, if we
>>    were to support asynchronous smp booting.
>>
>>    http://thread.gmane.org/gmane.linux.kernel/1246209/focus=48535
>>    http://thread.gmane.org/gmane.linux.kernel/1246209/focus=48542
>>    http://thread.gmane.org/gmane.linux.kernel/1246209/focus=1253241
>>    http://thread.gmane.org/gmane.linux.kernel/1246209/focus=1253267
> 
> Good points!  ;-)



Thank you :-)

> 
>> 4. Because the current CPU offline code depends on stop_machine(), every
>>    online CPU must cooperate with the offline event. This means, whenever
>>    we do a preempt_disable(), it ensures not only that that particular
>>    CPU won't go offline, but also that *any* CPU cannot go offline. This
>>    is more like a side-effect of using stop_machine().
>>
>>    So when trying to move over to stop_one_cpu(), we have to carefully audit
>>    places where preempt_disable() has been used in that manner (ie.,
>>    preempt_disable used as a light-weight and non-blocking form of
>>    get_online_cpus()). Because when we move to stop_one_cpu() to do CPU offline,
>>    a preempt disabled section will prevent only that particular CPU from
>>    going offline.
>>
>>    I haven't audited preempt_disable() calls yet, but one such use was there
>>    in brlocks (include/linux/lglock.h) until quite recently.
> 
> I was thinking in terms of the offline code path doing a synchronize_sched()
> to allow preempt_disable() to retain a reasonable approximation of its
> current semantics.  This would require a pair of CPU masks, one for code
> using CPU-based primitives (e.g., sending IPIs) and another for code
> implementing those primitives.
> 
> Or is there some situation that makes this approach fail?
>



Oh, right, using synchronize_sched() in the offline path would pretty much
solve our problem.. I guess I overlooked that. Thanks for pointing it out!

Regards,
Srivatsa S. Bhat

