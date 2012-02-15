Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab2BONiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:38:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246Ab2BONiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:38:17 -0500
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4F3BB33C.1000908@redhat.com>
Date: Wed, 15 Feb 2012 14:37:55 +0100
Cc: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <1FE08D00-49E8-4371-9F23-C5D2EE568FA8@suse.de>
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de> <4F3B9497.4020700@redhat.com> <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de> <4F3BB33C.1000908@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 15.02.2012, at 14:29, Avi Kivity wrote:

> On 02/15/2012 01:57 PM, Alexander Graf wrote:
>>> 
>>> Is an extra syscall for copying TLB entries to user space prohibitively
>>> expensive?
>> 
>> The copying can be very expensive, yes. We want to have the possibility of exposing a very large TLB to the guest, in the order of multiple kentries. Every entry is a struct of 24 bytes.
> 
> You don't need to copy the entire TLB, just the way that maps the
> address you're interested in.

Yeah, unless we do migration in which case we need to introduce another special case to fetch the whole thing :(.

> btw, why are you interested in virtual addresses in userspace at all?

We need them for gdb and monitor introspection.

> 
>>>>> 
>>>>> It works for the really simple cases, yes, but if the guest wants to set up one-shot timers, it fails.  
>>>> 
>>>> I don't understand. Why would anything fail here? 
>>> 
>>> It fails to provide a benefit, I didn't mean it causes guest failures.
>>> 
>>> You also have to make sure the kernel part and the user part use exactly
>>> the same time bases.
>> 
>> Right. It's an optional performance accelerator. If anything doesn't align, don't use it. But if you happen to have a system where everything's cool, you're faster. Sounds like a good deal to me ;).
> 
> Depends on how much the alignment relies on guest knowledge.  I guess
> with a simple device like HPET, it's simple, but with a complex device,
> different guests (or different versions of the same guest) could drive
> it very differently.

Right. But accelerating simple devices > not accelerating any devices. No? :)

> 
>>>>>> 
>>>>>> Because not every guest supports them. Virtio-blk needs 3rd party drivers. AHCI needs 3rd party drivers on w2k3 and wxp. 
>>> 
>>> 3rd party drivers are a way of life for Windows users; and the
>>> incremental benefits of IDE acceleration are still far behind virtio.
>> 
>> The typical way of life for Windows users are all-included drivers. Which is the case for AHCI, where we're getting awesome performance for Vista and above guests. The iDE thing was just an idea for legacy ones.
>> 
>> It'd be great to simply try and see how fast we could get by handling a few special registers in kernel space vs heavyweight exiting to QEMU. If it's only 10%, I wouldn't even bother with creating an interface for it. I'd bet the benefits are a lot bigger though.
>> 
>> And the main point was that specific partial device emulation buys us more than pseudo-generic accelerators like coalesced mmio, which are also only used by 1 or 2 devices.
> 
> Ok.
> 
>>> 
>>>> I'm pretty sure non-Linux non-Windows systems won't get QXL drivers. 
>>> 
>>> Cirrus or vesa should be okay for them, I don't see what we could do for
>>> them in the kernel, or why.
>> 
>> That's my point. You need fast emulation of standard devices to get a good baseline. Do PV on top, but keep the baseline as fast as is reasonable.
>> 
>>> 
>>>> Same for virtio.
>>>>>> 
>>>>>> Please don't do the Xen mistake again of claiming that all we care about is Linux as a guest.
>>>>> 
>>>>> Rest easy, there's no chance of that.  But if a guest is important enough, virtio drivers will get written.  IDE has no chance in hell of approaching virtio-blk performance, no matter how much effort we put into it.
>>>> 
>>>> Ever used VMware? They basically get virtio-blk performance out of ordinary IDE for linear workloads.
>>> 
>>> For linear loads, so should we, perhaps with greater cpu utliization.
>>> 
>>> If we DMA 64 kB at a time, then 128 MB/sec (to keep the numbers simple)
>>> means 0.5 msec/transaction.  Spending 30 usec on some heavyweight exits
>>> shouldn't matter.
>> 
>> *shrug* last time I checked we were a lot slower. But maybe there's more stuff making things slow than the exit path ;).
> 
> One thing that's different is that virtio offloads itself to a thread
> very quickly, while IDE does a lot of work in vcpu thread context.

So it's all about latencies again, which could be reduced at least a fair bit with the scheme I described above. But really, this needs to be prototyped and benchmarked to actually give us data on how fast it would get us.

> 
>>> 
>>>>> 
>>>>>> KVM's strength has always been its close resemblance to hardware.
>>>>> 
>>>>> This will remain.  But we can't optimize everything.
>>>> 
>>>> That's my point. Let's optimize the hot paths and be good. As long as we default to IDE for disk, we should have that be fast, no?
>>> 
>>> We should make sure that we don't default to IDE.  Qemu has no knowledge
>>> of the guest, so it can't default to virtio, but higher level tools can
>>> and should.
>> 
>> You can only default to virtio on recent Linux. Windows, BSD, etc don't include drivers, so you can't assume it working. You can default to AHCI for basically any recent guest, but that still won't work for XP and the likes :(.
> 
> The all-knowing management tool can provide a virtio driver disk, or
> even slip-stream the driver into the installation CD.

One management tool might do that, another one might now. We can't assume that all management tools are all-knowing. Some times you also want to run guest OSs that the management tool doesn't know (yet).

> 
> 
>> 
>>>> Ah, because you're on NPT and you can have MMIO hints in the nested page table. Nifty. Yeah, we don't have that luxury :).
>>> 
>>> Well the real reason is we have an extra bit reported by page faults
>>> that we can control.  Can't you set up a hashed pte that is configured
>>> in a way that it will fault, no matter what type of access the guest
>>> does, and see it in your page fault handler?
>> 
>> I might be able to synthesize a PTE that is !readable and might throw a permission exception instead of a miss exception. I might be able to synthesize something similar for booke. I don't however get any indication on why things failed.
>> 
>> So for MMIO reads, I can assume that this is an MMIO because I would never write a non-readable entry. For writes, I'm overloading the bit that also means "guest entry is not readable" so there I'd have to walk the guest PTEs/TLBs and check if I find a read-only entry. Right now I can just forward write faults to the guest. Since COW is probably a hotter path for the guest than MMIO, this might end up being ineffective.
> 
> COWs usually happen from guest userspace, while mmio is usually from the
> guest kernel, so you can switch on that, maybe.

Hrm, nice idea. That might fall apart with user space drivers that we might eventually have once vfio turns out to work well, but for the time being it's a nice hack :).

> 
>>>> 
>>>> I think we're talking about the same thing really.
>>> 
>>> So what's your objection to slots?
>> 
>> I was merely saying that having slots internally keeps us from speeding things up. I don't mind the external interface though.
> 
> Ah, but it doesn't.  We can sort them, convert them to a radix tree,
> basically do anything with them.

That's perfectly fine then :).

> 
>> 
>>> 
>>>>>> http://www.mail-archive.com/kvm@vger.kernel.org/msg66155.html
>>>>>> 
>>>>> 
>>>>> Yeah - s390 is always different.  On the current interface synchronous registers are easy, so why not.  But I wonder if it's really critical.
>>>> 
>>>> It's certainly slick :). We do the same for the TLB on e500, just with a separate ioctl to set the sharing up.
>>> 
>>> It's also dangerous wrt future hardware, as noted above.
>> 
>> Yes and no. I see the capability system as two things in one:
>> 
>>  1) indicate features we learn later
>>  2) indicate missing features in our current model
>> 
>> So if a new model comes out that can't do something, just scratch off the CAP and be good ;). If somehow you ended up with multiple bits in a single CAP, remove the CAP, create a new one with the subset, set that for the new hardware.
>> 
>> We will have the same situation when we get nested TLBs for booke. We just unlearn a CAP then. User space needs to cope with its unavailability anyways.
>> 
> 
> At least qemu tends to assume a certain baseline and won't run without
> it.  We also need to make sure that the feature is available in some
> other way (non-shared memory), which means duplication to begin with.

Yes, but that's the nature of accelerating things in other layers. If we move registers from ioctl get/set to shared pages, we need to keep the ioctls around. We also need to keep the ioctl access functions in qemu around. Unless we move up the baseline, but then we'd kill our backwards compatibility, which isn't all that great of an idea.

So yes, that's exactly what happens. And it's good that it does :). Gives us the chance to roll back when we realized we did something stupid.


Alex

