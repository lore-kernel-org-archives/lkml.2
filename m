Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab1JEIdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:33:40 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:47862 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab1JEIdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:33:37 -0400
Message-ID: <4E8C1659.6040208@linux.vnet.ibm.com>
Date: Wed, 05 Oct 2011 14:03:29 +0530
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
References: <4E88B5E0.6080503@linux.vnet.ibm.com> <20111002195023.GC31799@mtj.dyndns.org> <4E88C3D4.2020300@linux.vnet.ibm.com> <20111003004051.GD31799@mtj.dyndns.org> <4E894D75.808@linux.vnet.ibm.com>
In-Reply-To: <4E894D75.808@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 11:21 AM, Srivatsa S. Bhat wrote:
> Hi,
> 
> First of all, thank you for your invaluable inputs.
> 
> On 10/03/2011 06:10 AM, Tejun Heo wrote:
>> Hello,
[...]
>>
>> Can't one take a cpu offline, hot unplug it from the board and put in
>> a new one and then bring it online?  That's usually what "hot
>> [un]plug" stands for.  I don't think one would be able to put in a
>> very different processor but maybe, say, revision difference is
>> allowed and microcode should be looked up again?  Assuming that the
>> same microcode can always be applied after the actual CPU is swapped
>> could be dangerous.  Again, I'm not sure about how this is supposed to
>> be managed so I could be wrong.
>>
[...]
>> If I'm not wrong, can't we add synchronization between cpu hotplug and
>> freezer so that they don't happen in parallel?
>>
> 
> I have posted another patch related to CPU hotplug and freezer here:
> https://lkml.org/lkml/2011/10/2/163
> That patch aims to sync up the CPU hotplug infrastructure with the activity of the 
> freezer and hence ensure that the right notifications are sent. Maybe I could easily
> modify that patch to disable CPU hotplugging when the freezer is active.
> 
> But still, that would not solve our problem due to the following possible scenario:
> 
> [Let us assume that we go ahead and invalidate the microcode upon a CPU_DEAD notification,
> like you suggested.] Then, consider this scenario:
> 
> * Take a CPU offline (a pure CPU hotplug operation, not related to suspend).
>   Let us call this CPU X.
>   - This would involve a CPU_DEAD notification, upon which the microcode is invalidated.
> 
> * Start freezing tasks (due to a suspend operation in progress). Now we disable
>   CPU hotplugging.
>  
> * Disable (offline) the non-boot CPUs as part of suspend operation. This sends the
> CPU_DEAD_FROZEN notification, upon which the microcode is NOT invalidated for the other CPUs.
> 
> * Enable (online) the non-boot CPUs as part of resume operation. Please note that the tasks
> are still frozen. This is where we hit the same issue again! When trying to bring that CPU X
> back online, it finds that the microcode has been invalidated and hence tries to request the
> userspace for the microcode, but alas, the userspace is still frozen at that moment.
> This is the exact problem we were trying to solve earlier, which remains unsolved by disabling
> CPU hotplug during freezer operations!
> 

Sorry, my understanding was wrong in this part. After digging some more into
the code, I found that disable_nonboot_cpus() will only offline the currently
online cpus, and enable_nonboot_cpus() will only online those cpus that were
offlined during the disable_nonboot_cpus() phase (which it keeps track by using
a frozen_cpus mask).

So the problem I mentioned above wouldn't arise because during resume,
enable_nonboot_cpus() wouldn't try to online CPU X.

I also found that both disable_nonboot_cpus() and enable_nonboot_cpus() will
disable cpu hotplugging when they are active.

So a suspend/resume on a high level with reference to only freezer and cpu
hotplug, would look something like:


Freeze -> Disable nonboot cpus -> do suspend -> Enable nonboot cpus -> Thaw
         |<------------ CPU hotplugging disabled ----------------->|


So now as we can see, if we just prevent freezer and cpu hotplug from occurring
in parallel (like what Tejun had suggested above), we could solve this whole
issue properly. We wouldn't need anything complicated such as special callbacks
etc which I was proposing in some of my other mails (which anyway wouldn't work
as it is, due to some race conditions that I figured out later)...

So if we go by the above solution, then the situation would look like:

Freeze -> Disable nonboot cpus -> do suspend -> Enable nonboot cpus -> Thaw
|<---------------------- CPU hotplugging disabled ----------------------->|


Let me summarize how this solution works:
1. Any CPU that was offline (either because it was never brought up during
   booting or because due to a cpu hotplug operation, we had offlined it)
   before suspend starts, will never be onlined (or even tried to online)
   till resume is complete. After resume, a suitable cpu hotplug operation
   would put such a cpu online, if necessary.
   So, it doesn't matter whether the kernel has already got the microcode
   for that cpu or not, because it will be onlined only when the resume is
   complete (ie., userspace is thawed).

2. Physical cpu hotplugging or any scenario which needs us to apply a revised
   microcode:
   Here, since we hotplug cpus (online or offline) only when the freezer is not
   active, we won't have any trouble getting microcode from userspace upon cpu
   online.


But then, will introducing this restriction that "freezer and cpu hotplug must
be mutually exclusive", create any problems? (I am asking this question because
I have heard that the freezer is used in some cases other than in suspend/resume
too). I don't seem to find anything obvious... So I guess that restriction
should be quite acceptable...
Any comments?

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
