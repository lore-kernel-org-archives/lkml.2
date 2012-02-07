Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2BGOju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:39:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2BGOjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:39:49 -0500
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4F313354.4080401@redhat.com>
Date: Tue, 7 Feb 2012 15:39:45 +0100
Cc: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de>
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07.02.2012, at 15:21, Avi Kivity wrote:

> On 02/07/2012 03:40 PM, Alexander Graf wrote:
>> >>
>> >>  Not sure we'll ever get there. For PPC, it will probably take another 1-2 years until we get the 32-bit targets stabilized. By then we will have new 64-bit support though. And then the next gen will come out giving us even more new constraints.
>> >
>> >  I would expect that newer archs have less constraints, not more.
>> 
>> Heh. I doubt it :). The 64-bit booke stuff is pretty similar to what we have today on 32-bit, but extends a bunch of registers to 64-bit. So what if we laid out stuff wrong before?
> 
> That's not what I mean by constraints.  It's easy to accommodate different register layouts.  Constraints (for me) are like requiring gang scheduling.  But you introduced the subject - what did you mean?

New extensions to architectures give us new challenges. Newer booke for example implements page tables in parallel to soft TLBs. We need to model that. My point was more that I can't predict the future :).

> Let's take for example the software-controlled TLB on some ppc.  It's tempting to call them all "registers" and use the register interface to access them.  Is it workable?

Workable, yes. Fast? No. Right now we share them between kernel and user space to have very fast access to them. That way we don't have to sync anything at all.

> Or let's look at SMM on x86.  To implement it memory slots need an additional attribute "SMM/non-SMM/either".  These sort of things, if you don't think of them beforehand, break your interface.

Yup. And we will never think of all the cases.

> 
>> 
>> I don't even want to imagine what v7 arm vs v8 arm looks like. It's a completely new architecture.
>> 
>> And what if MIPS comes along? I hear they also work on hw accelerated virtualization.
> 
> If it's just a matter of different register names and sizes, no problem.  From what I've seen of v8, it doesn't introduce new wierdnesses.

I haven't seen anything real yet, since the spec isn't out. So far only generic architecture documentation is available.

> 
>> 
>> >
>> >>  The same goes for ARM, where we will get v7 support for now, but very soon we will also want to get v8. Stabilizing a target so far takes ~1-2 years from what I've seen. And that stabilizing to a point where we don't find major ABI issues anymore.
>> >
>> >  The trick is to get the ABI to be flexible, like a generalized ABI for state.  But it's true that it's really hard to nail it down.
>> 
>> Yup, and I think what we have today is a pretty good approach to this. I'm trying to mostly add "generalized" ioctls whenever I see that something can be handled generically, like ONE_REG or ENABLE_CAP. If we keep moving that direction, we are extensible with a reasonably stable ABI. Even without syscalls.
> 
> Syscalls are orthogonal to that - they're to avoid the fget_light() and to tighten the vcpu/thread and vm/process relationship.

How about keeping the ioctl interface but moving vcpu_run to a syscall then? That should really be the only thing that belongs into the fast path, right? Every time we do a register sync in user space, we do something wrong. Instead, user space should either

  a) have wrappers around register accesses, so it can directly ask for specific registers that it needs
or
  b) keep everything that would be requested by the register synchronization in shared memory

> 
>> , keep the rest in user space.
>> >
>> >
>> >  When a device is fully in the kernel, we have a good specification of the ABI: it just implements the spec, and the ABI provides the interface from the device to the rest of the world.  Partially accelerated devices means a much greater effort in specifying exactly what it does.  It's also vulnerable to changes in how the guest uses the device.
>> 
>> Why? For the HPET timer register for example, we could have a simple MMIO hook that says
>> 
>>   on_read:
>>     return read_current_time() - shared_page.offset;
>>   on_write:
>>     handle_in_user_space();
> 
> It works for the really simple cases, yes, but if the guest wants to set up one-shot timers, it fails.  

I don't understand. Why would anything fail here? Once the logic that's implemented by the kernel accelerator doesn't fit anymore, unregister it.

> Also look at the PIT which latches on read.
> 
>> 
>> For IDE, it would be as simple as
>> 
>>   register_pio_hook_ptr_r(PIO_IDE, SIZE_BYTE,&s->cmd[0]);
>>   for (i = 1; i<  7; i++) {
>>     register_pio_hook_ptr_r(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>>     register_pio_hook_ptr_w(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>>   }
>> 
>> and we should have reduced overhead of IDE by quite a bit already. All the other 2k LOC in hw/ide/core.c don't matter for us really.
> 
> 
> Just use virtio.

Just use xenbus. Seriously, this is not an answer.

> 
>> 
>> >
>> >>  Similar to how vhost works, where we keep device enumeration and configuration in user space, but ring processing in kernel space.
>> >
>> >  vhost-net was a massive effort, I hope we don't have to replicate it.
>> 
>> Was it harder than the in-kernel io-apic?
> 
> Much, much harder.
> 
>> 
>> >
>> >>
>> >>  Good candidates for in-kernel acceleration are:
>> >>
>> >>    - HPET
>> >
>> >  Yes
>> >
>> >>    - VGA
>> >>    - IDE
>> >
>> >  Why?  There are perfectly good replacements for these (qxl, virtio-blk, virtio-scsi).
>> 
>> Because not every guest supports them. Virtio-blk needs 3rd party drivers. AHCI needs 3rd party drivers on w2k3 and wxp. I'm pretty sure non-Linux non-Windows systems won't get QXL drivers. Same for virtio.
>> 
>> Please don't do the Xen mistake again of claiming that all we care about is Linux as a guest.
> 
> Rest easy, there's no chance of that.  But if a guest is important enough, virtio drivers will get written.  IDE has no chance in hell of approaching virtio-blk performance, no matter how much effort we put into it.

Ever used VMware? They basically get virtio-blk performance out of ordinary IDE for linear workloads.

> 
>> KVM's strength has always been its close resemblance to hardware.
> 
> This will remain.  But we can't optimize everything.

That's my point. Let's optimize the hot paths and be good. As long as we default to IDE for disk, we should have that be fast, no?

> 
>> >
>> >>
>> >>  We will run into the same thing with the MPIC though. On e500v2, IPIs are done through the MPIC. So if we want any SMP performance on those, we need to shove that part into the kernel. I don't really want to have all of the MPIC code in there however. So a hybrid approach sounds like a great fit.
>> >
>> >  Pointer to the qemu code?
>> 
>> hw/openpic.c
> 
> I see what you mean.
> 
>> 
>> >
>> >>  The problem with in-kernel device emulation the way we have it today is that it's an all-or-nothing choice. Either we push the device into kernel space or we keep it in user space. That adds a lot of code in kernel land where it doesn't belong.
>> >
>> >  Like I mentioned, I see that as a good thing.
>> 
>> I don't. And we don't do it for hypercall handling on book3s hv either for example. There we have a 3 level handling system. Very hot path hypercalls get handled in real mode. Reasonably hot path hypercalls get handled in kernel space. Everything else goes to user land.
> 
> Well, the MPIC thing really supports your point.

I'm sure we'll find more examples :)

> 
>> >
>> >>  >
>> >>  >   No, slots still exist.  Only the API is "replace slot list" instead of "add slot" and "remove slot".
>> >>
>> >>  Why?
>> >
>> >  Physical memory is discontiguous, and includes aliases (two gpas referencing the same backing page).  How else would you describe it.
>> >
>> >>  On PPC we walk the slots on every fault (incl. mmio), so fast lookup times there would be great. I was thinking of something page table like here.
>> >
>> >  We can certainly convert the slots to a tree internally.  I'm doing the same thing for qemu now, maybe we can do it for kvm too.  No need to involve the ABI at all.
>> 
>> Hrm, true.
>> 
>> >  Slot searching is quite fast since there's a small number of slots, and we sort the larger ones to be in the front, so positive lookups are fast.  We cache negative lookups in the shadow page tables (an spte can be either "not mapped", "mapped to RAM", or "not mapped and known to be mmio") so we rarely need to walk the entire list.
>> 
>> Well, we don't always have shadow page tables. Having hints for unmapped guest memory like this is pretty tricky.
>> We're currently running into issues with device assignment though, where we get a lot of small slots mapped to real hardware. I'm sure that will hit us on x86 sooner or later too.
> 
> For x86 that's not a problem, since once you map a page, it stays mapped (on modern hardware).

Ah, because you're on NPT and you can have MMIO hints in the nested page table. Nifty. Yeah, we don't have that luxury :).

> 
>> 
>> >
>> >>  That only works when then internal slot structure is hidden from user space though.
>> >
>> >  Why?
>> 
>> Because if user space thinks it's slots and in reality it's a tree that doesn't match. If you decouple the external view from the internal view, it works again.
> 
> Userspace needs to provide a function hva = f(gpa).  Why does it matter how the function is spelled out?  Slots happen to be a concise representation.  Transform the function all you like in the kernel, as long as you preserve all the mappings.

I think we're talking about the same thing really.

> 
>> 
>> >
>> >>
>> >>  >>   I would actually rather like to see the amount of page sharing between kernel and user space increased, no decreased. I don't care if I can throw strace on KVM. I want speed.
>> >>  >
>> >>  >   Something really critical should be handled in the kernel.  Care to provide examples?
>> >>
>> >>  Just look at the s390 patches Christian posted recently.
>> >
>> >  Which ones?
>> 
>>   http://www.mail-archive.com/kvm@vger.kernel.org/msg66155.html
>> 
> 
> Yeah - s390 is always different.  On the current interface synchronous registers are easy, so why not.  But I wonder if it's really critical.

It's certainly slick :). We do the same for the TLB on e500, just with a separate ioctl to set the sharing up.


Alex

