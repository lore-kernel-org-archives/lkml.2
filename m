Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab1AFWiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:38:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:56090 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab1AFWiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:38:21 -0500
Subject: Re: [KVM TSC trapping / migration 1/2] Add TSC trapping for SVM and VMX
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4D2624FF.1010801@redhat.com>
Date: Thu, 6 Jan 2011 23:38:18 +0100
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5E3AD4FB-2D25-4586-88C8-05330E1AACD3@suse.de>
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-2-git-send-email-zamsden@redhat.com> <9EEA19E7-668A-4CD0-B006-6B494D9FD242@suse.de> <4D25A7E3.4090101@redhat.com> <BE843088-8070-40F5-A030-2FD051332838@suse.de> <4D2624FF.1010801@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06.01.2011, at 21:24, Zachary Amsden wrote:

> On 01/06/2011 01:38 AM, Alexander Graf wrote:
>> On 06.01.2011, at 12:30, Zachary Amsden wrote:
>> 
>>   
>>> On 01/06/2011 12:41 AM, Alexander Graf wrote:
>>>     
>>>> Am 06.01.2011 um 11:10 schrieb Zachary Amsden<zamsden@redhat.com>:
>>>> 
>>>> 
>>>>       
>>>>> Reasons to trap the TSC are numerous, but we want to avoid it as much
>>>>> as possible for performance reasons.
>>>>> 
>>>>> We provide two conservative modes via modules parameters and userspace
>>>>> hinting.  First, the module can be loaded with "tsc_auto=1" as a module
>>>>> parameter, which turns on conservative TSC trapping only when it is
>>>>> required (when unstable TSC or faster KHZ CPU is detected).
>>>>> 
>>>>> For userspace hinting, we enable trapping only if necessary.  Userspace
>>>>> can hint that a VM needs a fixed frequency TSC, and also that SMP
>>>>> stability will be required.  In that case, we conservatively turn on
>>>>> trapping when it is needed.  In addition, users may now specify the
>>>>> desired TSC rate at which to run.  If this rate differs significantly
>>>>> from the host rate, trapping will be enabled.
>>>>> 
>>>>> There is also an override control to allow TSC trapping to be turned on
>>>>> or off unconditionally for testing.
>>>>> 
>>>>> We indicate to pvclock users that the TSC is being trapped, to allow
>>>>> avoiding overhead and directly using RDTSCP (only for SVM).  This
>>>>> optimization is not yet implemented.
>>>>> 
>>>>>         
>>>> When migrating, the implementation could switch from non-trapped to trapped, making it less attractive. The guest however does not get notified about this change. Same for the other way around.
>>>> 
>>>>       
>>> That's a policy decision to be made by the userspace agent.  It's better than the current situation, where there is no control at all of TSC rate.  Here, we're flexible either way.
>>> 
>>> Also note, moving to a faster processor, trapping kicks in... but the processor is faster, so no actual loss is noticed, and the problem corrects when the VM is power cycled.
>>>     
>> Hrm. But even then the guest should be notified to enable it to act accordingly and just recalibrate instead of reboot, no? I'm not saying this is particularly interesting for kvmclock enabled guests, but think of all the<  2.6.2x Linux, *BSD, Solaris, Windows etc. VMs out there that might have an easy means of triggering recalibration (or at least could introduce it), but writing a new clock source is a lot of work.
>>   
> 
> That's why I implemented trapping.  So they can migrate and we don't need to change the OS.
> 
>> Of course, sending the notification through a userspace agent would also work. That one would have to be notified about the change too though.
>>   
> 
> It's far too complex and far too small of a use case to be worth the effort.  Windows doesn't particularly care, and most HALs can be switched into a mode where TSC is not used.
> 
> Linux actually does support CPU frequency recalibration, but it is triggered differently based on the particular form of CPU frequency switching supported by the platform / chipset.  Since that isn't universal, and we pass through many features of the hardware (CPUID and such), there is no reliable way I know of to emulate CPU frequency switching for the guest without kernel modifications.  The best bet there would be a kernel module providing a KVM cpufreq driver, which could be ported to the relevant non-clocksource kernels.
> 
> This amount of effort, however, begs the question - if you are going to all this trouble, why not port kvmclock support to those kernel?
> 
> Solaris 10 and later do have some better virtualization friendly clock support.  BSD - we'd probably have to trap.
> 
> Again, if the overhead is significant, blah.  Today you have no choice but to accept sloppy timekeeping.  You lose nothing with this patch, but do gain the flexibility to choose either correct TSC timekeeping or native speed TSC.  There are scenarios where both of those can be met (uniform speed deployment / virt friendly guest), there are scenarios where sloppy timekeeping is appropriate (KVM clock used), and there are scenarios where correct timekeeping is appropriate (BSD, earlier TSC-based linux, or user-space TSC required).

Sure, I'm not saying your patch is bad or goes in the wrong direction. I'd just think it'd be awesome to have an easy way for the guest OS to know that something as crucial as TSC reading speed got changed, hopefully even TSC frequency. Having any form of notification leaves open doors for someone to implement something (think proprietary OSs or out-of-service OSs here). Having no notification leaves us with no choice but taking the penalty and keeping the guest less informed than it has to be.

> 
>>   
>>>> Would it make sense to add a kvmclock interrupt to notify the guest of such a change?
>>>>       
>>> kvmclock is immune to frequency changes, so it needs no interrupt, it just has a version controlled shared area, which is reset.
>>>     
>> 
>>   
>>>>> We indicate to pvclock users that the TSC is being trapped, to allow
>>>>> avoiding overhead and directly using RDTSCP (only for SVM).  This
>>>>> optimization is not yet implemented.
>>>>>         
>>>>       
>> That doesn't sound to me like they're unaffected?
>>   
> 
> On Intel RDTSCP traps along with RDTSC.  This means that you can't have a trapping, constant rate TSC for userspace without also paying the overhead for reading the TSC for kvmclock.  This is not true on SVM, where RDTSCP is a separate trap, allowing optimization.

So how does the guest know that something changed when it's migrated from an AMD machine to an Intel machine?


Alex

