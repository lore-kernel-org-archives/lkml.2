Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab1JDU5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:57:20 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43024 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933569Ab1JDU5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:57:19 -0400
Message-ID: <4E8B7326.6000606@linux.vnet.ibm.com>
Date: Wed, 05 Oct 2011 02:27:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, tigran@aivazian.fsnet.co.uk,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
References: <4E88B5E0.6080503@linux.vnet.ibm.com> <20111002195023.GC31799@mtj.dyndns.org> <4E88C3D4.2020300@linux.vnet.ibm.com> <20111003004051.GD31799@mtj.dyndns.org> <4E894D75.808@linux.vnet.ibm.com> <20111003084754.GB4411@liondog.tnic> <20111004071508.GA15637@dhcp-172-17-108-109.mtv.corp.google.com> <4E8B06E0.2090501@linux.vnet.ibm.com> <20111004134653.GC3148@gere.osrc.amd.com> <20111004171415.GB3915@gere.osrc.amd.com>
In-Reply-To: <20111004171415.GB3915@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 10:44 PM, Borislav Petkov wrote:
> On Tue, Oct 04, 2011 at 03:46:53PM +0200, Borislav Petkov wrote:
>> On Tue, Oct 04, 2011 at 06:45:12PM +0530, Srivatsa S. Bhat wrote:
>>> I would like to propose a modified solution to the problem:
>>>
>>> Taking a CPU offline:
>>> * Upon a CPU_DEAD notification, just like the code originally did, we free
>>>   the kernel's copy of the microcode and invalidate it. So no changes here.
>>>  
>>> Bringing a CPU online:
>>> * When a CPU_ONLINE or CPU_ONLINE_FROZEN notification is received, 
>>>   a. If the userspace is not frozen, we request microcode from userspace and
>>>      apply it to the cpu.
>>>
>>>   b. However if we find that the userspace is frozen at that moment, we defer
>>>      applying microcode now and register a callback function to be executed
>>>      immediately when the userspace gets thawed. This callback function would
>>>      request microcode from userspace and apply it to the cpu.
>>
>> No need for that if we can drop the whole re-requesting of ucode on
>> CPU_ONLINE* (see my other mail). Let me run some tests before though.
> 
> Ok, it looks good. I had one issue with what happens when there's no
> ucode image but the ucode driver is a bit-hmm... and that case actually
> magically works.
> 
> So you can have my Acked- and Tested-by:'s for the AMD side - you still
> need to test it on Intel with both microcode_ctl and the module un- and
> loading so that you make sure you're not introducing regressions, if you
> haven't done so yet, of course.

Hi Borislav,
I went through all your mails. Thank you very much for your reviews, Ack
and for testing my patch.

But I am still a bit concerned about the following issues with my patch:

1. Since we never invalidate the microcode once we get it from userspace, it
   also means that we will never be able to update the microcode for that cpu
   ever again! (since we will continue to reuse the same old microcode over and
   over again on every cpu online operation for that cpu).
   This restriction introduced by my patch seems bad, isn't it?

2. Suppose we have a 16 cpu machine and we boot it with only 8 cpus (ie., we online
   only 8 of the 16 cpus while booting). So it means that the kernel gets a copy
   of the microcode for each of these 8 cpus, but not for the ones that were not
   onlined while booting.
   [Let us assume that cpu number 10 was one among the 8 cpus that were not onlined
    while booting].

   Later on, let's say we start our cpu hotplug + suspend/resume tests simultaneously.
   Now consider this possible scenario:
   
   * Userspace is not frozen
   * We initiate a cpu online operation on cpu 10. At the same time, since suspend
     is in progress, lets say the freezing begins.
   * Just before cpu 10 could be brought up online, userspace gets frozen.
   * Now while bringing up cpu 10, due to the CPU_ONLINE_FROZEN notification, the
     microcode core tries to apply the microcode to the cpu. But unfortunately, it
     doesn't have the microcode! (because this cpu is coming up for the first time
     and hence we never got its microcode from userspace...)

     Now, again the same problem ensues: microcode core calls request_firmware and
     depends on the (frozen) userspace to get the microcode.



Let us now consider other possible solutions:
To implement our intent of not depending on userspace when it is frozen, another
approach would be to modify the code that is run in that scenario : namely CPU_ONLINE_FROZEN.
Do nothing upon a CPU_ONLINE_FROZEN notification (while still invalidating the
microcode upon CPU_DEAD just as in the original code):

--- microcode_core.c	2011-08-23 18:52:07.062729098 +0530
+++ microcode_core.c	2011-10-05 01:41:59.024888447 +0530
@@ -469,7 +469,6 @@ mc_cpu_callback(struct notifier_block *n
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		microcode_update_cpu(cpu);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:

However, this also has problems:
1. Consider scenario 2 mentioned above.
   In that scenario, while bringing up cpu 10, since userspace is frozen, we get
   a CPU_ONLINE_FROZEN notification and hence we do nothing: in particular, we don't even
   try to get microcode (please note that we have never got microcode for this cpu from
   userspace at all, till now). What is worse, suppose we stop cpu hotplugging after that,
   the kernel would never ever get or apply microcode on that cpu and still continue to run
   tasks on that cpu!

[In the usual cases, doing nothing upon CPU_ONLINE_FROZEN (ie., not applying the microcode
when the cpu comes online) won't do harm since a cpu hotplug operation doesn't actually
remove the microcode from the cpu since the cpu is not electrically powered off during
cpu hotplug, unless we do physical cpu hotplug.]

2. Suppose upon a CPU_ONLINE notification, we try to get microcode from userspace. Now,
   just before we call request_firmware, lets say the userspace got frozen due to suspend
   operation in progress. Now again, we hit the same problem: request_firmware fails!

[By the way, as Tejun suggested in one of the previous mails, if we add synchronization
 between cpu hotplug and freezing so that they don't happen in parallel, then this problem
 will not arise because while cpu onlining is going on, freezing will never occur.]

So this approach of removing the 'case CPU_ONLINE_FROZEN' statement doesn't seem right as well.

I am still wondering if the approach I proposed earlier (the one in which we defer applying
microcode and queue up a callback function etc) could solve all these issues. I am also playing
around with the idea of coupling that with mutual exclusion between cpu hotplug and freezer to
handle any problematic scenarios.

On a slightly different note, I am also working on fixing the CPU hotplug notifications
here: http://comments.gmane.org/gmane.linux.kernel/1198312
Ultimately that fix might also become necessary to make this whole thing work reliably.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
