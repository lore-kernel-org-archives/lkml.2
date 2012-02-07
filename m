Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab2BGNkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:40:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab2BGNkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:40:53 -0500
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4F31241C.70404@redhat.com>
Date: Tue, 7 Feb 2012 14:40:51 +0100
Cc: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de>
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07.02.2012, at 14:16, Avi Kivity wrote:

> On 02/07/2012 02:51 PM, Alexander Graf wrote:
>> On 07.02.2012, at 13:24, Avi Kivity wrote:
>> 
>> >  On 02/07/2012 03:08 AM, Alexander Graf wrote:
>> >>  I don't like the idea too much. On s390 and ppc we can set other vcpu's interrupt status. How would that work in this model?
>> >
>> >  It would be a "vm-wide syscall".  You can also do that on x86 (through KVM_IRQ_LINE).
>> >
>> >>
>> >>  I really do like the ioctl model btw. It's easily extensible and easy to understand.
>> >>
>> >>  I can also promise you that I have no idea what other extensions we will need in the next few years. The non-x86 targets are just really very moving. So having an interface that allows for easy extension is a must-have.
>> >
>> >  Good point.  If we ever go through with it, it will only be after we see the interface has stabilized.
>> 
>> Not sure we'll ever get there. For PPC, it will probably take another 1-2 years until we get the 32-bit targets stabilized. By then we will have new 64-bit support though. And then the next gen will come out giving us even more new constraints.
> 
> I would expect that newer archs have less constraints, not more.

Heh. I doubt it :). The 64-bit booke stuff is pretty similar to what we have today on 32-bit, but extends a bunch of registers to 64-bit. So what if we laid out stuff wrong before?

I don't even want to imagine what v7 arm vs v8 arm looks like. It's a completely new architecture.

And what if MIPS comes along? I hear they also work on hw accelerated virtualization.

> 
>> The same goes for ARM, where we will get v7 support for now, but very soon we will also want to get v8. Stabilizing a target so far takes ~1-2 years from what I've seen. And that stabilizing to a point where we don't find major ABI issues anymore.
> 
> The trick is to get the ABI to be flexible, like a generalized ABI for state.  But it's true that it's really hard to nail it down.

Yup, and I think what we have today is a pretty good approach to this. I'm trying to mostly add "generalized" ioctls whenever I see that something can be handled generically, like ONE_REG or ENABLE_CAP. If we keep moving that direction, we are extensible with a reasonably stable ABI. Even without syscalls.

> 
> 
>> >>
>> >>  The framework is in KVM today. It's called ONE_REG. So far only PPC implements a few registers. If you like it, just throw all the x86 ones in there and you have everything you need.
>> >
>> >  This is more like MANY_REG, where you scatter/gather a list of registers in userspace to the kernel or vice versa.
>> 
>> Well, yeah, to me MANY_REG is part of ONE_REG. The idea behind ONE_REG was to give every register a unique identifier that can be used to access it. Taking that logic to an array is trivial.
> 
> Definitely easy to extend.
> 
> 
>> >
>> >>
>> >>  >>   The communications between the local APIC and the IOAPIC/PIC will be
>> >>  >>   done over a socketpair, emulating the APIC bus protocol.
>> >>
>> >>  What is keeping us from moving there today?
>> >
>> >  The biggest problem with this proposal is that what we have today works reasonably well.  Nothing is keeping us from moving there, except the fear of performance regressions and lack of strong motivation.
>> 
>> So why bring it up in the "next-gen" api discussion?
> 
> One reason is to try to shape future changes to the current ABI in the same direction.  Another is that maybe someone will convince us that it is needed.
> 
>> >
>> >  There's no way a patch with 'VGA' in it would be accepted.
>> 
>> Why not? I think the natural step forward is hybrid acceleration. Take a minimal subset of device emulation into kernel land, keep the rest in user space.
> 
> 
> When a device is fully in the kernel, we have a good specification of the ABI: it just implements the spec, and the ABI provides the interface from the device to the rest of the world.  Partially accelerated devices means a much greater effort in specifying exactly what it does.  It's also vulnerable to changes in how the guest uses the device.

Why? For the HPET timer register for example, we could have a simple MMIO hook that says

  on_read:
    return read_current_time() - shared_page.offset;
  on_write:
    handle_in_user_space();

For IDE, it would be as simple as

  register_pio_hook_ptr_r(PIO_IDE, SIZE_BYTE, &s->cmd[0]);
  for (i = 1; i < 7; i++) {
    register_pio_hook_ptr_r(PIO_IDE + i, SIZE_BYTE, &s->cmd[i]);
    register_pio_hook_ptr_w(PIO_IDE + i, SIZE_BYTE, &s->cmd[i]);
  }

and we should have reduced overhead of IDE by quite a bit already. All the other 2k LOC in hw/ide/core.c don't matter for us really.

> 
>> Similar to how vhost works, where we keep device enumeration and configuration in user space, but ring processing in kernel space.
> 
> vhost-net was a massive effort, I hope we don't have to replicate it.

Was it harder than the in-kernel io-apic?

> 
>> 
>> Good candidates for in-kernel acceleration are:
>> 
>>   - HPET
> 
> Yes
> 
>>   - VGA
>>   - IDE
> 
> Why?  There are perfectly good replacements for these (qxl, virtio-blk, virtio-scsi).

Because not every guest supports them. Virtio-blk needs 3rd party drivers. AHCI needs 3rd party drivers on w2k3 and wxp. I'm pretty sure non-Linux non-Windows systems won't get QXL drivers. Same for virtio.

Please don't do the Xen mistake again of claiming that all we care about is Linux as a guest. KVM's strength has always been its close resemblance to hardware.

> 
>> I'm not sure how easy it would be to only partially accelerate the hot paths of the IO-APIC. I'm not too familiar with its details.
> 
> Pretty hard.
> 
>> 
>> We will run into the same thing with the MPIC though. On e500v2, IPIs are done through the MPIC. So if we want any SMP performance on those, we need to shove that part into the kernel. I don't really want to have all of the MPIC code in there however. So a hybrid approach sounds like a great fit.
> 
> Pointer to the qemu code?

hw/openpic.c

> 
>> The problem with in-kernel device emulation the way we have it today is that it's an all-or-nothing choice. Either we push the device into kernel space or we keep it in user space. That adds a lot of code in kernel land where it doesn't belong.
> 
> Like I mentioned, I see that as a good thing.

I don't. And we don't do it for hypercall handling on book3s hv either for example. There we have a 3 level handling system. Very hot path hypercalls get handled in real mode. Reasonably hot path hypercalls get handled in kernel space. Everything else goes to user land.

> 
>> >
>> >  No, slots still exist.  Only the API is "replace slot list" instead of "add slot" and "remove slot".
>> 
>> Why?
> 
> Physical memory is discontiguous, and includes aliases (two gpas referencing the same backing page).  How else would you describe it.
> 
>> On PPC we walk the slots on every fault (incl. mmio), so fast lookup times there would be great. I was thinking of something page table like here.
> 
> We can certainly convert the slots to a tree internally.  I'm doing the same thing for qemu now, maybe we can do it for kvm too.  No need to involve the ABI at all.

Hrm, true.

> Slot searching is quite fast since there's a small number of slots, and we sort the larger ones to be in the front, so positive lookups are fast.  We cache negative lookups in the shadow page tables (an spte can be either "not mapped", "mapped to RAM", or "not mapped and known to be mmio") so we rarely need to walk the entire list.

Well, we don't always have shadow page tables. Having hints for unmapped guest memory like this is pretty tricky.
We're currently running into issues with device assignment though, where we get a lot of small slots mapped to real hardware. I'm sure that will hit us on x86 sooner or later too.

> 
>> That only works when then internal slot structure is hidden from user space though.
> 
> Why?

Because if user space thinks it's slots and in reality it's a tree that doesn't match. If you decouple the external view from the internal view, it works again.

> 
>> 
>> >>  I would actually rather like to see the amount of page sharing between kernel and user space increased, no decreased. I don't care if I can throw strace on KVM. I want speed.
>> >
>> >  Something really critical should be handled in the kernel.  Care to provide examples?
>> 
>> Just look at the s390 patches Christian posted recently.
> 
> Which ones?

  http://www.mail-archive.com/kvm@vger.kernel.org/msg66155.html


Alex

