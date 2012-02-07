Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab2BGO1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:27:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab2BGO0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:26:52 -0500
Message-ID: <4F313354.4080401@redhat.com>
Date: Tue, 07 Feb 2012 16:21:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de>
In-Reply-To: <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 03:40 PM, Alexander Graf wrote:
> >>
> >>  Not sure we'll ever get there. For PPC, it will probably take another 1-2 years until we get the 32-bit targets stabilized. By then we will have new 64-bit support though. And then the next gen will come out giving us even more new constraints.
> >
> >  I would expect that newer archs have less constraints, not more.
>
> Heh. I doubt it :). The 64-bit booke stuff is pretty similar to what we have today on 32-bit, but extends a bunch of registers to 64-bit. So what if we laid out stuff wrong before?

That's not what I mean by constraints.  It's easy to accommodate 
different register layouts.  Constraints (for me) are like requiring 
gang scheduling.  But you introduced the subject - what did you mean?

Let's take for example the software-controlled TLB on some ppc.  It's 
tempting to call them all "registers" and use the register interface to 
access them.  Is it workable?

Or let's look at SMM on x86.  To implement it memory slots need an 
additional attribute "SMM/non-SMM/either".  These sort of things, if you 
don't think of them beforehand, break your interface.

>
> I don't even want to imagine what v7 arm vs v8 arm looks like. It's a completely new architecture.
>
> And what if MIPS comes along? I hear they also work on hw accelerated virtualization.

If it's just a matter of different register names and sizes, no 
problem.  From what I've seen of v8, it doesn't introduce new wierdnesses.

>
> >
> >>  The same goes for ARM, where we will get v7 support for now, but very soon we will also want to get v8. Stabilizing a target so far takes ~1-2 years from what I've seen. And that stabilizing to a point where we don't find major ABI issues anymore.
> >
> >  The trick is to get the ABI to be flexible, like a generalized ABI for state.  But it's true that it's really hard to nail it down.
>
> Yup, and I think what we have today is a pretty good approach to this. I'm trying to mostly add "generalized" ioctls whenever I see that something can be handled generically, like ONE_REG or ENABLE_CAP. If we keep moving that direction, we are extensible with a reasonably stable ABI. Even without syscalls.

Syscalls are orthogonal to that - they're to avoid the fget_light() and 
to tighten the vcpu/thread and vm/process relationship.

> , keep the rest in user space.
> >
> >
> >  When a device is fully in the kernel, we have a good specification of the ABI: it just implements the spec, and the ABI provides the interface from the device to the rest of the world.  Partially accelerated devices means a much greater effort in specifying exactly what it does.  It's also vulnerable to changes in how the guest uses the device.
>
> Why? For the HPET timer register for example, we could have a simple MMIO hook that says
>
>    on_read:
>      return read_current_time() - shared_page.offset;
>    on_write:
>      handle_in_user_space();

It works for the really simple cases, yes, but if the guest wants to set 
up one-shot timers, it fails.  Also look at the PIT which latches on read.

>
> For IDE, it would be as simple as
>
>    register_pio_hook_ptr_r(PIO_IDE, SIZE_BYTE,&s->cmd[0]);
>    for (i = 1; i<  7; i++) {
>      register_pio_hook_ptr_r(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>      register_pio_hook_ptr_w(PIO_IDE + i, SIZE_BYTE,&s->cmd[i]);
>    }
>
> and we should have reduced overhead of IDE by quite a bit already. All the other 2k LOC in hw/ide/core.c don't matter for us really.


Just use virtio.

>
> >
> >>  Similar to how vhost works, where we keep device enumeration and configuration in user space, but ring processing in kernel space.
> >
> >  vhost-net was a massive effort, I hope we don't have to replicate it.
>
> Was it harder than the in-kernel io-apic?

Much, much harder.

>
> >
> >>
> >>  Good candidates for in-kernel acceleration are:
> >>
> >>    - HPET
> >
> >  Yes
> >
> >>    - VGA
> >>    - IDE
> >
> >  Why?  There are perfectly good replacements for these (qxl, virtio-blk, virtio-scsi).
>
> Because not every guest supports them. Virtio-blk needs 3rd party drivers. AHCI needs 3rd party drivers on w2k3 and wxp. I'm pretty sure non-Linux non-Windows systems won't get QXL drivers. Same for virtio.
>
> Please don't do the Xen mistake again of claiming that all we care about is Linux as a guest.

Rest easy, there's no chance of that.  But if a guest is important 
enough, virtio drivers will get written.  IDE has no chance in hell of 
approaching virtio-blk performance, no matter how much effort we put 
into it.

> KVM's strength has always been its close resemblance to hardware.

This will remain.  But we can't optimize everything.

> >
> >>
> >>  We will run into the same thing with the MPIC though. On e500v2, IPIs are done through the MPIC. So if we want any SMP performance on those, we need to shove that part into the kernel. I don't really want to have all of the MPIC code in there however. So a hybrid approach sounds like a great fit.
> >
> >  Pointer to the qemu code?
>
> hw/openpic.c

I see what you mean.

>
> >
> >>  The problem with in-kernel device emulation the way we have it today is that it's an all-or-nothing choice. Either we push the device into kernel space or we keep it in user space. That adds a lot of code in kernel land where it doesn't belong.
> >
> >  Like I mentioned, I see that as a good thing.
>
> I don't. And we don't do it for hypercall handling on book3s hv either for example. There we have a 3 level handling system. Very hot path hypercalls get handled in real mode. Reasonably hot path hypercalls get handled in kernel space. Everything else goes to user land.

Well, the MPIC thing really supports your point.

> >
> >>  >
> >>  >   No, slots still exist.  Only the API is "replace slot list" instead of "add slot" and "remove slot".
> >>
> >>  Why?
> >
> >  Physical memory is discontiguous, and includes aliases (two gpas referencing the same backing page).  How else would you describe it.
> >
> >>  On PPC we walk the slots on every fault (incl. mmio), so fast lookup times there would be great. I was thinking of something page table like here.
> >
> >  We can certainly convert the slots to a tree internally.  I'm doing the same thing for qemu now, maybe we can do it for kvm too.  No need to involve the ABI at all.
>
> Hrm, true.
>
> >  Slot searching is quite fast since there's a small number of slots, and we sort the larger ones to be in the front, so positive lookups are fast.  We cache negative lookups in the shadow page tables (an spte can be either "not mapped", "mapped to RAM", or "not mapped and known to be mmio") so we rarely need to walk the entire list.
>
> Well, we don't always have shadow page tables. Having hints for unmapped guest memory like this is pretty tricky.
> We're currently running into issues with device assignment though, where we get a lot of small slots mapped to real hardware. I'm sure that will hit us on x86 sooner or later too.

For x86 that's not a problem, since once you map a page, it stays mapped 
(on modern hardware).

>
> >
> >>  That only works when then internal slot structure is hidden from user space though.
> >
> >  Why?
>
> Because if user space thinks it's slots and in reality it's a tree that doesn't match. If you decouple the external view from the internal view, it works again.

Userspace needs to provide a function hva = f(gpa).  Why does it matter 
how the function is spelled out?  Slots happen to be a concise 
representation.  Transform the function all you like in the kernel, as 
long as you preserve all the mappings.

>
> >
> >>
> >>  >>   I would actually rather like to see the amount of page sharing between kernel and user space increased, no decreased. I don't care if I can throw strace on KVM. I want speed.
> >>  >
> >>  >   Something really critical should be handled in the kernel.  Care to provide examples?
> >>
> >>  Just look at the s390 patches Christian posted recently.
> >
> >  Which ones?
>
>    http://www.mail-archive.com/kvm@vger.kernel.org/msg66155.html
>

Yeah - s390 is always different.  On the current interface synchronous 
registers are easy, so why not.  But I wonder if it's really critical.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

