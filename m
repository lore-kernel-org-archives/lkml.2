Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1JCFwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:52:05 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54211 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab1JCFv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:51:56 -0400
Message-ID: <4E894D75.808@linux.vnet.ibm.com>
Date: Mon, 03 Oct 2011 11:21:49 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, tigran@aivazian.fsnet.co.uk,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
References: <4E88B5E0.6080503@linux.vnet.ibm.com> <20111002195023.GC31799@mtj.dyndns.org> <4E88C3D4.2020300@linux.vnet.ibm.com> <20111003004051.GD31799@mtj.dyndns.org>
In-Reply-To: <20111003004051.GD31799@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First of all, thank you for your invaluable inputs.

On 10/03/2011 06:10 AM, Tejun Heo wrote:
> Hello,
> 
> On Mon, Oct 03, 2011 at 01:34:36AM +0530, Srivatsa S. Bhat wrote:
>> So when a CPU goes offline and comes back online, I don't see why the kernel
>> should not reuse the microcode that it already has. Anyhow the microcode will
>> not change. The same microcode would be requested from userspace again if the
>> kernel has freed its copy.
> 
> Can't one take a cpu offline, hot unplug it from the board and put in
> a new one and then bring it online?  That's usually what "hot
> [un]plug" stands for.  I don't think one would be able to put in a
> very different processor but maybe, say, revision difference is
> allowed and microcode should be looked up again?  Assuming that the
> same microcode can always be applied after the actual CPU is swapped
> could be dangerous.  Again, I'm not sure about how this is supposed to
> be managed so I could be wrong.
>

I see your point here. However it is also true that quite a lot of CPU hotplug
operations are done with use-cases other than physically plugging out and plugging in
CPUs. For example, the disabling and enabling of CPUs during suspend and resume,
the offlining of CPUs when the system is idle (in some architectures) to reduce
idle power consumption etc. Moreover physically hotplugging CPUs also demands that
the electrical wiring to the CPUs are specially designed in such a way as to support
physical CPU hotplugging - a feature which is supported by only very few hardware
manufacturers, if what I have heard is right.

Another related fact to consider would be how the disabling and enabling of non-boot
CPUs are done during system suspend and resume. Since the tasks are frozen at those
points, a different notification is sent i.e.,CPU_[ONLINE|DEAD]_FROZEN instead of the
usual CPU_[ONLINE|DEAD] notification. 
And upon the CPU_DEAD_FROZEN notification, the microcode core doesn't invalidate the
microcode! Hence, it won't have trouble applying the microcode to the CPU during the
phase of enabling the non-boot CPUs. But a valid point here would be that during suspend
and resume, nobody expects to plug out and plug in a new CPU!

But in any case, suppose we need a revised microcode (due to the usecase you have
described, for example), then I agree that it would definitely be not good to forcefully
apply the same old microcode that the kernel has.

> If I'm not wrong, can't we add synchronization between cpu hotplug and
> freezer so that they don't happen in parallel?
> 

I have posted another patch related to CPU hotplug and freezer here:
https://lkml.org/lkml/2011/10/2/163
That patch aims to sync up the CPU hotplug infrastructure with the activity of the 
freezer and hence ensure that the right notifications are sent. Maybe I could easily
modify that patch to disable CPU hotplugging when the freezer is active.

But still, that would not solve our problem due to the following possible scenario:

[Let us assume that we go ahead and invalidate the microcode upon a CPU_DEAD notification,
like you suggested.] Then, consider this scenario:

* Take a CPU offline (a pure CPU hotplug operation, not related to suspend).
  Let us call this CPU X.
  - This would involve a CPU_DEAD notification, upon which the microcode is invalidated.

* Start freezing tasks (due to a suspend operation in progress). Now we disable
  CPU hotplugging.
 
* Disable (offline) the non-boot CPUs as part of suspend operation. This sends the
CPU_DEAD_FROZEN notification, upon which the microcode is NOT invalidated for the other CPUs.

* Enable (online) the non-boot CPUs as part of resume operation. Please note that the tasks
are still frozen. This is where we hit the same issue again! When trying to bring that CPU X
back online, it finds that the microcode has been invalidated and hence tries to request the
userspace for the microcode, but alas, the userspace is still frozen at that moment.
This is the exact problem we were trying to solve earlier, which remains unsolved by disabling
CPU hotplug during freezer operations!


So my one-liner patch here tries to solve this problem by not invalidating the microcode at all,
to handle the corner case of a CPU hotplug going on in parallel with freezer operations.
But it creates issues with the usecase you described.

At the moment I can't think of any clean solution that solves both these problems - 
  a. The problem of requesting microcode from userspace when it is frozen (which can be individually
     solved by my patch).
  b. The possible need for a revised microcode during CPU online (due to the remote usecase of 
     physically plugging-out and plugging-in a new CPU), when the tasks are frozen.

To address both problems 'a' and 'b' in one shot, I can think of a rather ugly workaround such as:
* Go ahead and invalidate the microcode upon a CPU_DEAD notification.
* During CPU onlining, if we find that the userspace is frozen, defer applying microcode for now
  and register a callback function to be executed immediately when the userspace gets thawed.
  Also, prevent any task from executing on this CPU until the proper microcode is applied to it.
* When the userspace finally gets thawed, run the registered callback function, get the revised
  microcode from userspace, apply it to the CPU and then go ahead and run tasks on that CPU.

Any ideas?

Summary:
My patch solves the problem that is most likely hit, while there are some corner cases
which it doesn't handle, such as physical CPU hotplugging which might require revised microcode to be
loaded. The idea proposed above could solve both issues, but it doesn't seem very elegant, or does it?

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
