Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2BOL5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:57:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab2BOL5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:57:09 -0500
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4F3B9497.4020700@redhat.com>
Date: Wed, 15 Feb 2012 12:57:07 +0100
Cc: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de>
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de> <4F3B9497.4020700@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 15.02.2012, at 12:18, Avi Kivity wrote:

> On 02/07/2012 04:39 PM, Alexander Graf wrote:
>>> 
>>> Syscalls are orthogonal to that - they're to avoid the fget_light() and to tighten the vcpu/thread and vm/process relationship.
>> 
>> How about keeping the ioctl interface but moving vcpu_run to a syscall then?
> 
> I dislike half-and-half interfaces even more.  And it's not like the
> fget_light() is really painful - it's just that I see it occasionally in
> perf top so it annoys me.
> 
>> That should really be the only thing that belongs into the fast path, right? Every time we do a register sync in user space, we do something wrong. Instead, user space should either
>> 
>>  a) have wrappers around register accesses, so it can directly ask for specific registers that it needs
>> or
>>  b) keep everything that would be requested by the register synchronization in shared memory
> 
> Always-synced shared memory is a liability, since newer hardware might
> introduce on-chip caches for that state, making synchronization
> expensive.  Or we may choose to keep some of the registers loaded, if we
> have a way to trap on their use from userspace - for example we can
> return to userspace with the guest fpu loaded, and trap if userspace
> tries to use it.
> 
> Is an extra syscall for copying TLB entries to user space prohibitively
> expensive?

The copying can be very expensive, yes. We want to have the possibility of exposing a very large TLB to the guest, in the order of multiple kentries. Every entry is a struct of 24 bytes.

> 
>>> 
>>>> , keep the rest in user space.
>>>>> 
>>>>> 
>>>>> When a device is fully in the kernel, we have a good specification of the ABI: it just implements the spec, and the ABI provides the interface from the device to the rest of the world.  Partially accelerated devices means a much greater effort in specifying exactly what it does.  It's also vulnerable to changes in how the guest uses the device.
>>>> 
>>>> Why? For the HPET timer register for example, we could have a simple MMIO hook that says
>>>> 
>>>>  on_read:
>>>>    return read_current_time() - shared_page.offset;
>>>>  on_write:
>>>>    handle_in_user_space();
>>> 
>>> It works for the really simple cases, yes, but if the guest wants to set up one-shot timers, it fails.  
>> 
>> I don't understand. Why would anything fail here? 
> 
> It fails to provide a benefit, I didn't mean it causes guest failures.
> 
> You also have to make sure the kernel part and the user part use exactly
> the same time bases.

Right. It's an optional performance accelerator. If anything doesn't align, don't use it. But if you happen to have a system where everything's cool, you're faster. Sounds like a good deal to me ;).

> 
>> Once the logic that's implemented by the kernel accelerator doesn't fit anymore, unregister it.
> 
> Yeah.
> 
>> 
>>> Also look at the PIT which latches on read.
>>> 
>>>> 
>>>> For IDE, it would be as simple as
>>>> 
>>>>  register_pio_hook_ptr_r(PIO_IDE, SIZE_BYTE,&s->cmd[0]);
>>>>  for (i = 1; i<  7; i++) {
>>>>    register_pio_hook_ptr_r(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>>>>    register_pio_hook_ptr_w(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>>>>  }
>>>> 
>>>> and we should have reduced overhead of IDE by quite a bit already. All the other 2k LOC in hw/ide/core.c don't matter for us really.
>>> 
>>> 
>>> Just use virtio.
>> 
>> Just use xenbus. Seriously, this is not an answer.
> 
> Why not?  We invested effort in making it as fast as possible, and in
> writing the drivers.  IDE will never, ever, get anything close to virtio
> performance, even if we put all of it in the kernel.
> 
> However, after these examples, I'm more open to partial acceleration
> now.  I won't ever like it though.
> 
>>>>> 
>>>>>>   - VGA
>>>>>>   - IDE
>>>>> 
>>>>> Why?  There are perfectly good replacements for these (qxl, virtio-blk, virtio-scsi).
>>>> 
>>>> Because not every guest supports them. Virtio-blk needs 3rd party drivers. AHCI needs 3rd party drivers on w2k3 and wxp. 
> 
> 3rd party drivers are a way of life for Windows users; and the
> incremental benefits of IDE acceleration are still far behind virtio.

The typical way of life for Windows users are all-included drivers. Which is the case for AHCI, where we're getting awesome performance for Vista and above guests. The iDE thing was just an idea for legacy ones.

It'd be great to simply try and see how fast we could get by handling a few special registers in kernel space vs heavyweight exiting to QEMU. If it's only 10%, I wouldn't even bother with creating an interface for it. I'd bet the benefits are a lot bigger though.

And the main point was that specific partial device emulation buys us more than pseudo-generic accelerators like coalesced mmio, which are also only used by 1 or 2 devices.

> 
>> I'm pretty sure non-Linux non-Windows systems won't get QXL drivers. 
> 
> Cirrus or vesa should be okay for them, I don't see what we could do for
> them in the kernel, or why.

That's my point. You need fast emulation of standard devices to get a good baseline. Do PV on top, but keep the baseline as fast as is reasonable.

> 
>> Same for virtio.
>>>> 
>>>> Please don't do the Xen mistake again of claiming that all we care about is Linux as a guest.
>>> 
>>> Rest easy, there's no chance of that.  But if a guest is important enough, virtio drivers will get written.  IDE has no chance in hell of approaching virtio-blk performance, no matter how much effort we put into it.
>> 
>> Ever used VMware? They basically get virtio-blk performance out of ordinary IDE for linear workloads.
> 
> For linear loads, so should we, perhaps with greater cpu utliization.
> 
> If we DMA 64 kB at a time, then 128 MB/sec (to keep the numbers simple)
> means 0.5 msec/transaction.  Spending 30 usec on some heavyweight exits
> shouldn't matter.

*shrug* last time I checked we were a lot slower. But maybe there's more stuff making things slow than the exit path ;).

> 
>>> 
>>>> KVM's strength has always been its close resemblance to hardware.
>>> 
>>> This will remain.  But we can't optimize everything.
>> 
>> That's my point. Let's optimize the hot paths and be good. As long as we default to IDE for disk, we should have that be fast, no?
> 
> We should make sure that we don't default to IDE.  Qemu has no knowledge
> of the guest, so it can't default to virtio, but higher level tools can
> and should.

You can only default to virtio on recent Linux. Windows, BSD, etc don't include drivers, so you can't assume it working. You can default to AHCI for basically any recent guest, but that still won't work for XP and the likes :(.

> 
>>>> 
>>>> Well, we don't always have shadow page tables. Having hints for unmapped guest memory like this is pretty tricky.
>>>> We're currently running into issues with device assignment though, where we get a lot of small slots mapped to real hardware. I'm sure that will hit us on x86 sooner or later too.
>>> 
>>> For x86 that's not a problem, since once you map a page, it stays mapped (on modern hardware).
>> 
>> Ah, because you're on NPT and you can have MMIO hints in the nested page table. Nifty. Yeah, we don't have that luxury :).
> 
> Well the real reason is we have an extra bit reported by page faults
> that we can control.  Can't you set up a hashed pte that is configured
> in a way that it will fault, no matter what type of access the guest
> does, and see it in your page fault handler?

I might be able to synthesize a PTE that is !readable and might throw a permission exception instead of a miss exception. I might be able to synthesize something similar for booke. I don't however get any indication on why things failed.

So for MMIO reads, I can assume that this is an MMIO because I would never write a non-readable entry. For writes, I'm overloading the bit that also means "guest entry is not readable" so there I'd have to walk the guest PTEs/TLBs and check if I find a read-only entry. Right now I can just forward write faults to the guest. Since COW is probably a hotter path for the guest than MMIO, this might end up being ineffective.

But it's certainly an interesting idea.

> I'm guessing guest kernel ptes don't get evicted often.

Yeah, depends on the model you're running on ;). It's not the most common thing though, I agree.

> 
>>> 
>>>> 
>>>>> 
>>>>>> That only works when then internal slot structure is hidden from user space though.
>>>>> 
>>>>> Why?
>>>> 
>>>> Because if user space thinks it's slots and in reality it's a tree that doesn't match. If you decouple the external view from the internal view, it works again.
>>> 
>>> Userspace needs to provide a function hva = f(gpa).  Why does it matter how the function is spelled out?  Slots happen to be a concise representation.  Transform the function all you like in the kernel, as long as you preserve all the mappings.
>> 
>> I think we're talking about the same thing really.
> 
> So what's your objection to slots?

I was merely saying that having slots internally keeps us from speeding things up. I don't mind the external interface though.

> 
>>>>  http://www.mail-archive.com/kvm@vger.kernel.org/msg66155.html
>>>> 
>>> 
>>> Yeah - s390 is always different.  On the current interface synchronous registers are easy, so why not.  But I wonder if it's really critical.
>> 
>> It's certainly slick :). We do the same for the TLB on e500, just with a separate ioctl to set the sharing up.
> 
> It's also dangerous wrt future hardware, as noted above.

Yes and no. I see the capability system as two things in one:

  1) indicate features we learn later
  2) indicate missing features in our current model

So if a new model comes out that can't do something, just scratch off the CAP and be good ;). If somehow you ended up with multiple bits in a single CAP, remove the CAP, create a new one with the subset, set that for the new hardware.

We will have the same situation when we get nested TLBs for booke. We just unlearn a CAP then. User space needs to cope with its unavailability anyways.


Alex

