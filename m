Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab1JEIvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:51:07 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:50812 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab1JEIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:51:06 -0400
Message-ID: <4E8C1A74.5090601@linux.vnet.ibm.com>
Date: Wed, 05 Oct 2011 14:21:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
References: <20111002195023.GC31799@mtj.dyndns.org> <4E88C3D4.2020300@linux.vnet.ibm.com> <20111003004051.GD31799@mtj.dyndns.org> <4E894D75.808@linux.vnet.ibm.com> <20111003084754.GB4411@liondog.tnic> <20111004071508.GA15637@dhcp-172-17-108-109.mtv.corp.google.com> <4E8B06E0.2090501@linux.vnet.ibm.com> <20111004134653.GC3148@gere.osrc.amd.com> <20111004171415.GB3915@gere.osrc.amd.com> <4E8B7326.6000606@linux.vnet.ibm.com> <20111005072102.GA11172@aftab>
In-Reply-To: <20111005072102.GA11172@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 12:51 PM, Borislav Petkov wrote:
> On Tue, Oct 04, 2011 at 04:57:10PM -0400, Srivatsa S. Bhat wrote:
>> 1. Since we never invalidate the microcode once we get it from userspace, it
>>    also means that we will never be able to update the microcode for that cpu
>>    ever again! (since we will continue to reuse the same old microcode over and
>>    over again on every cpu online operation for that cpu).
>>    This restriction introduced by my patch seems bad, isn't it?
> 
> Well, if you have a new microcode image, you are supposed to place it
> under /lib/firmware/.. or where the kernel has been configured to find
> it and then reload the microcode module.
>
Oh well, then we can update the microcode after all...
 
>> 2. Suppose we have a 16 cpu machine and we boot it with only 8 cpus (ie., we online
>>    only 8 of the 16 cpus while booting). So it means that the kernel gets a copy
>>    of the microcode for each of these 8 cpus, but not for the ones that were not
>>    onlined while booting.
>>    [Let us assume that cpu number 10 was one among the 8 cpus that were not onlined
>>     while booting].
>>
>>    Later on, let's say we start our cpu hotplug + suspend/resume tests simultaneously.
>>    Now consider this possible scenario:
>>    
>>    * Userspace is not frozen
>>    * We initiate a cpu online operation on cpu 10. At the same time, since suspend
>>      is in progress, lets say the freezing begins.
>>    * Just before cpu 10 could be brought up online, userspace gets frozen.
>>    * Now while bringing up cpu 10, due to the CPU_ONLINE_FROZEN notification, the
>>      microcode core tries to apply the microcode to the cpu. But unfortunately, it
>>      doesn't have the microcode! (because this cpu is coming up for the first time
>>      and hence we never got its microcode from userspace...)
>>
>>      Now, again the same problem ensues: microcode core calls request_firmware and
>>      depends on the (frozen) userspace to get the microcode.
> 
> Ok, but is this a real-life scenario you expect to happen somewhere or
> is it something that happens only during test? IOW, if you have root
> there are many ways to shoot yourself in the foot, right?
> 

Well, honestly I was just trying to see in which all scenarios the patch
would probably not work well... In real-life I don't expect to hit such
a corner case!

> [..]
> 
>> I am still wondering if the approach I proposed earlier (the one in
>> which we defer applying microcode and queue up a callback function
>> etc) could solve all these issues. I am also playing around with the
>> idea of coupling that with mutual exclusion between cpu hotplug and
>> freezer to handle any problematic scenarios.
> 
> Well, all those solutions seem like they're not worth the trouble and
> complexity if those cases are only conjecture - if you still trigger
> them during your testing then probably mutually excluding freezer and
> CPU hotplug is something I would lean towards but I could be wrong.
>

Even I felt the same (moreover, that complex solution was not foolproof
either!). Please see my other mail which talks about how just mutually
excluding freezer and cpu hotplugging would solve everything.
 
> There's of course a much better fix which has been on the table for a
> while now involving loading the ucode from the bootloader and applying
> it much earlier than what we have now and keeping the ucode image in
> memory. This would solve the CPU hotplug deal completely. Maybe it's
> time I looked into it :-).
> 

Assuming I understood this correctly, I can see some issues in this
approach as well (since it is quite similar to the approach used in my
one-line patch), but yeah, definitely they are all very much corner
cases...

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
