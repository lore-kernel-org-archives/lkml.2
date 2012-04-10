Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab2DJNmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:42:32 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55267 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2DJNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:42:30 -0400
Message-ID: <4F84389E.10600@linux.vnet.ibm.com>
Date: Tue, 10 Apr 2012 19:11:50 +0530
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
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        nikunj@linux.vnet.ibm.com
Subject: Re: CPU Hotplug rework
References: <4F674649.2000300@linux.vnet.ibm.com> <4F67474A.20707@linux.vnet.ibm.com> <20120405173918.GC8194@linux.vnet.ibm.com> <4F7F4977.4000302@linux.vnet.ibm.com> <20120409171348.GB2430@linux.vnet.ibm.com>
In-Reply-To: <20120409171348.GB2430@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041003-1396-0000-0000-000000F4E422
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 10:43 PM, Paul E. McKenney wrote:

> On Sat, Apr 07, 2012 at 01:22:23AM +0530, Srivatsa S. Bhat wrote:
>>>
>>>> Additional things that I would like to add to the list:
>>>>
>>>> 1. Fix issues with CPU Hotplug callback registration. Currently there
>>>>    is no totally-race-free way to register callbacks and do setup
>>>>    for already online cpus.
>>>>
>>>>    I had posted an incomplete patchset some time ago regarding this,
>>>>    which gives an idea of the direction I had in mind.
>>>>    http://thread.gmane.org/gmane.linux.kernel/1258880/focus=15826
>>>
>>> Another approach is to have the registration function return the
>>> CPU mask corresponding to the instant at which registration occurred,
>>> perhaps via an additional function argument that points to a
>>> cpumask_var_t that can be NULL if you don't care.  Then you can
>>> do setup for the CPUs indicated in the mask.
>>
>> That would look something like this right?
>>
>> 	register_cpu_notifier(nb, mask);
>> 	do_setup(mask);
>>
>> If yes, then here is our problem:
>> 1. A CPU hotplug operation can happen, in-between these 2 function calls.
>> 2. No matter how we try to wrap these up with get/put_online_cpus(), it
>>    will still lead to either a race, or a deadlock, depending on how we
>>    do it.
> 
> Hmmm...  The call to register_cpu_notifier() excludes CPU-hotplug
> operations, so any CPU-hotplug operation that happens after the
> register_cpu_notifier() will invoke the notifier. 


Right.

> This does mean that
> we can then see concurrent invocation of the notifier from do_setup()
> and from a CPU-hotplug operation,


Exactly!

> but it should not be hard to create
> a reasonably locking scheme to prevent this.
>


Ah, this is where our approach differs ;-)
My approach is to *avoid* the concurrent invocation. Yours seems to be to
*handle* the concurrent invocation. 

> BTW, I am assuming that it is OK for the notifiers to run out of order
> in this case.  Perhaps you are trying to preserve ordering?
> 


No, I am not worried about the ordering. Ordering is an issue only when we
allow concurrent invocations and try to handle them. If we prevent concurrent
invocation of notifiers, (mis)ordering of notifiers for subsequent CPU
hotplug operations won't even come into the picture, right?

> The reason that I believe that it should be OK to allow misordering of
> notifiers is that the subsystem in question is not fully initialized yet.
> It is therefore probably not yet actually servicing requests, for example,
> something like RCU would might be refusing to start grace periods.
> If it is not yet servicing requests, it should not matter what order
> it sees the CPUs come online.  Once do_setup() returns, it will see
> subsequent CPU-hotplug operations in order, so at that point it might
> be able to start servicing requests.
> 
> Or am I missing something else?
> 


Looks like the two of us are trying to solve the same problem in two different
ways, hence the difficulty in understanding each other ;-)

The problem:
During registration of notifier, CPU hotplug cannot happen - guaranteed.
Beyond that, CPU hotplug can happen, which includes the do_setup() phase.
Hence, concurrent invocations of notifiers might take place and mess up things.


Your solution/approach seems to be:
1. Register cpu hotplug notifiers.
2. Run setup for already online cpus, *knowing* that the notifier invocations
   can happen due to 2 sources (CPU hotplug and do_setup). Add appropriate
   locking to handle this. This raises a new issue: notifiers can get executed
   out-of-order, because there are 2 sources that are running the notifiers.
   Ignore this issue because it doesn't appear to be troublesome in any way.

My thoughts on this:
1. The extra locking needs to be added to every initialization code that does
   this "register + do_setup()" thing.
2. Atleast I am not able to think of any simple locking scheme. Consider some
   of the problems it has to address:

   * do_setup is running for CPU 3 which is already online.
   * Now somebody happens to take CPU 3 offline. What happens to the notifiers?
     CPU_UP_PREPARE/CPU_ONLINE notifiers from do_setup() and CPU_DOWN_PREPARE/
     CPU_DEAD notifiers from the CPU Hotplug operation get interleaved?
     That would be bad, isn't it?

(CPUs getting offlined while do_setup() is running might look like a totally
theoretical or rather impractical scenario. But its not. Consider the fact
that the initialization of this kind happens in module_init() code of some
modules. And module load/unload racing with CPU hotplug is not that much of
a theoretical case).

My solution/approach is:
1. Register cpu hotplug notifiers. (we know CPU hotplug is disabled throughout
   this)
2. Run setup for already online cpus, but ensure that the "CPU hotplug
   disabled" phase which started in the previous step extends throughout this
   step too, without any gaps in between. This would *prevent* concurrent
   invocation of notifiers. This would also *prevent* misordering of notifiers,
   because when we re-enable CPU hotplug after our do_setup(), all the
   registered notifiers run in the right order for future CPU hotplug
   operations.

My thoughts on this:
1. No extra locking necessary. Also, no locking added to each call site/
   initialization code. Since all changes are made to the generic
   register_cpu_notifier() function, it simply boils down to all the
   initialization code adapting to the new form of callback registration by
   providing appropriate parameters.
2. This is immune to any sort of CPU Hotplug (offline/online) at any point
   in time, without assumptions such as 'CPU offline won't happen during early
   boot' or 'nobody will do CPU Hotplug when loading/unloading modules'.
3. Looks simple (atleast in my opinion) since no extra locking logic is
   necessary :-) We just piggyback on what is already in place.
   And also, no need to handle some arcanely complex scenarios like what
   I mentioned above (interleaving of online/offline notifiers), since that
   scenario simply won't occur here.

>> Wrapping only do_setup() within get/put_online_cpus() wouldn't serve our
>> purpose, since the race with CPU Hotplug would still exist, just like
>> before. So, let's consider what happens when we wrap both the functions
>> within get/put_online_cpus():
>>
>> 	get_online_cpus();
>> 	register_cpu_notifier(nb, mask);
>> 	do_setup(mask);
>> 	put_online_cpus();
>>
>> Unfortunately this leads to an ABBA deadlock (see below).
>>
>>
>>> Or am I missing the race you had in mind?  Or is the point to make
>>> sure that the notifiers execute in order?
>>
>> No, I wasn't referring to the order of execution of the notifiers here.
> 
> OK, then I am still missing something...
> 
>> Well, the race I was concerned about was the one between a CPU hotplug
>> operation and a callback registration operation, which might lead to an
>> ABBA deadlock, with the 2 locks in question being cpu hotplug lock and
>> cpu_add_remove_lock.
>>
>> The heart of the problem is that, something as simple as the following
>> is prone to an ABBA deadlock (note that I am not even talking about
>> do_setup() here):
>>
>> 	get_online_cpus()
>> 	register_cpu_notifier() or any other variant
>> 	put_online_cpus()
>>
>> In the above, the lock ordering is:
>> grab cpu_hotplug lock -> grab cpu_add_remove_lock.
> 
> But why do we need the get_online_cpus() in this case?  What would it be
> preventing from happening and why do we care?


It was a case of too much short-circuiting, I admit. I intended to show the
concept of "CPU hotplug disabled" phase as being persistent throughout callback
registration + do_setup(), using some known primitives for disabling CPU
hotplug, like get/put_online_cpus().

That is: get_online_cpus()
	register_cpu_notifier()
	do_setup()
	put_online_cpus()

Then I wanted to show that this can lead to an ABBA deadlock; and also point
out that do_setup() has got nothing to do with the deadlock - the interplay
between get/put_online_cpus and register_cpu_notifier() is the actual culprit.
So I short-circuited all this into the code above ;-)


> 
>> But in a usual CPU hotplug operation, the lock ordering is the exact reverse:
>> grab cpu_add_remove_lock -> grab cpu_hotplug lock.
>>
>> Hence, we have an ABBA deadlock possibility.
>>
>> I had posted a pictorial representation of the deadlock condition here:
>> https://lkml.org/lkml/2012/3/19/289
> 
> And Peter replied to this saying that he can remove the get_online_cpus()
> call, which gets rid of the ABBA deadlock condition, correct?
> 


Yes, but that is a special case - his code is an early-initcall (pre-smp).
So there is no possibility of CPU hotplug at that point; only one CPU is up
and running. (Even the async booting patch[1] doesn't alter this behaviour and
hence we are safe.) This is not the case with initialization code that can
occur much later in the boot sequence or which can be triggered after booting
is complete, like module initialization code.

>> So, to get rid of this deadlock, the approach I proposed came out of the
>> following observation:
>>
>> A code such as:
>>
>> 	register_cpu_notifier();
>>
>> 	//Go on doing stuff that are irrelevant to CPU hotplug.
>>
>> is totally safe from any kind of race or deadlock, the reason being that
>> CPU Hotplug operations begin by taking the cpu_add_remove_lock, and
>> callback registration functions like the above also take only this
>> particular lock. IOW, the mutex that protects a race between CPU hotplug
>> operation vs callback registration is the cpu_add_remove_lock. The
>> cpu_hotplug lock is actually irrelevant here!
> 
> Yep, agreed, despite my confusion some weeks ago.
> 
>>
>> 	CPU0				CPU 1
>> register_cpu_notifier()			cpu_down()
>> ----------------------------------------------------------------------
>>
>> acquire cpu_add_remove_lock
>> 					Blocked on cpu_add_remove_lock
>>
>> do callback registration
>>
>> release cpu_add_remove_lock
>>
>> 					Only now we can proceed and acquire
>> 					the cpu_add_remove_lock.
>>
>> 					acquire cpu_hotplug lock
>> 					do cpu_down related work
>> 					release cpu_hotplug lock
>>
>> 					release cpu_add_remove_lock
>>
>>
>> So my approach is: consider whatever we want to do while registering our
>> callback, including doing setup for already online cpus; - and do *all of it*
>> within the section marked as "do callback registration". IOW, we piggyback
>> on something _known_ to be perfectly fine and hence avoid all races and
>> deadlocks.
> 
> OK, interesting approach.  But does this actually save anything in
> any real situation, given that CPU hotplug notifiers are run during
> initialization, before the subsystem being initialized is really doing
> anything?
> 


Yes - we know that if we run multiple instances of a non-reentrant code
simultaneously without locking, it will crash. Here the non-reentrant code
is the individual CPU hotplug notifiers/callbacks.

Why are they non-reentrant?
Because it is a given that notifiers are always run one after the other in
the CPU hotplug path. And hence none of the notifiers take care (locking)
to see that they don't race with themselves; which was perfectly OK previously.

What was the assumption earlier?
During bootup, the onlining of CPUs won't run in parallel with the rest of
the kernel initialization. IOW, when do_setup() is running (as part of
initcalls), no CPU hotplug (online/offline) operation can occur. [Even the
CPU onlining as part of booting wont happen in parallel with do_setup()]

What changed that?
The async boot patch[1]. It made CPU online during boot to run in parallel
with rest of the kernel initialization. (This didn't go upstream though,
because the kernel was not ready for such a change, as shown by these
problems).

What was the effect? 
Except early initcalls which are pre-smp, all other initcalls can race with
CPU Hotplug. That is, do_setup() can race with notifiers from ongoing CPU
hotplug (CPU online operations, as part of booting) and hence the notifiers
suddenly need extra locking or something to be reentrant.

Why does my approach help?
It ensures that do_setup() will never occur in parallel with CPU hotplug,
at any time. Hence the individual notifiers need not watch their back -
they can continue to be non-reentrant and still everything will work fine
because we fix it at the callback registration level itself.

Honestly, I wrote this patchset to fix issues opened up by the async booting
patch[1]. That patch caused boot failures in powerpc [2] because of CPU
Hotplug notifier races. And I believe the solution I proposed will fix it.

Without the async booting patch, this was more or less a theoretical race.
That patch made it not only real but also severe enough to cause boot
failures.

So, if the async booting design is not being pushed any further, then I
guess we can simply ignore this theoretical race altogether and focus on
more important issues (I am totally OK with that) ... and possibly revisit
this race whenever it bites us again ;-)

What do you think?

[1]. http://thread.gmane.org/gmane.linux.kernel/1246209
[2]. http://thread.gmane.org/gmane.linux.kernel.next/20726/focus=20757

Regards,
Srivatsa S. Bhat

