Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2BGNQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:16:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab2BGNQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:16:22 -0500
Message-ID: <4F31241C.70404@redhat.com>
Date: Tue, 07 Feb 2012 15:16:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de>
In-Reply-To: <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 02:51 PM, Alexander Graf wrote:
> On 07.02.2012, at 13:24, Avi Kivity wrote:
>
> >  On 02/07/2012 03:08 AM, Alexander Graf wrote:
> >>  I don't like the idea too much. On s390 and ppc we can set other vcpu's interrupt status. How would that work in this model?
> >
> >  It would be a "vm-wide syscall".  You can also do that on x86 (through KVM_IRQ_LINE).
> >
> >>
> >>  I really do like the ioctl model btw. It's easily extensible and easy to understand.
> >>
> >>  I can also promise you that I have no idea what other extensions we will need in the next few years. The non-x86 targets are just really very moving. So having an interface that allows for easy extension is a must-have.
> >
> >  Good point.  If we ever go through with it, it will only be after we see the interface has stabilized.
>
> Not sure we'll ever get there. For PPC, it will probably take another 1-2 years until we get the 32-bit targets stabilized. By then we will have new 64-bit support though. And then the next gen will come out giving us even more new constraints.

I would expect that newer archs have less constraints, not more.

> The same goes for ARM, where we will get v7 support for now, but very soon we will also want to get v8. Stabilizing a target so far takes ~1-2 years from what I've seen. And that stabilizing to a point where we don't find major ABI issues anymore.

The trick is to get the ABI to be flexible, like a generalized ABI for 
state.  But it's true that it's really hard to nail it down.


> >>
> >>  The framework is in KVM today. It's called ONE_REG. So far only PPC implements a few registers. If you like it, just throw all the x86 ones in there and you have everything you need.
> >
> >  This is more like MANY_REG, where you scatter/gather a list of registers in userspace to the kernel or vice versa.
>
> Well, yeah, to me MANY_REG is part of ONE_REG. The idea behind ONE_REG was to give every register a unique identifier that can be used to access it. Taking that logic to an array is trivial.

Definitely easy to extend.


> >
> >>
> >>  >>   The communications between the local APIC and the IOAPIC/PIC will be
> >>  >>   done over a socketpair, emulating the APIC bus protocol.
> >>
> >>  What is keeping us from moving there today?
> >
> >  The biggest problem with this proposal is that what we have today works reasonably well.  Nothing is keeping us from moving there, except the fear of performance regressions and lack of strong motivation.
>
> So why bring it up in the "next-gen" api discussion?

One reason is to try to shape future changes to the current ABI in the 
same direction.  Another is that maybe someone will convince us that it 
is needed.

> >
> >  There's no way a patch with 'VGA' in it would be accepted.
>
> Why not? I think the natural step forward is hybrid acceleration. Take a minimal subset of device emulation into kernel land, keep the rest in user space.


When a device is fully in the kernel, we have a good specification of 
the ABI: it just implements the spec, and the ABI provides the interface 
from the device to the rest of the world.  Partially accelerated devices 
means a much greater effort in specifying exactly what it does.  It's 
also vulnerable to changes in how the guest uses the device.

> Similar to how vhost works, where we keep device enumeration and configuration in user space, but ring processing in kernel space.

vhost-net was a massive effort, I hope we don't have to replicate it.

>
> Good candidates for in-kernel acceleration are:
>
>    - HPET

Yes

>    - VGA
>    - IDE

Why?  There are perfectly good replacements for these (qxl, virtio-blk, 
virtio-scsi).

> I'm not sure how easy it would be to only partially accelerate the hot paths of the IO-APIC. I'm not too familiar with its details.

Pretty hard.

>
> We will run into the same thing with the MPIC though. On e500v2, IPIs are done through the MPIC. So if we want any SMP performance on those, we need to shove that part into the kernel. I don't really want to have all of the MPIC code in there however. So a hybrid approach sounds like a great fit.

Pointer to the qemu code?

> The problem with in-kernel device emulation the way we have it today is that it's an all-or-nothing choice. Either we push the device into kernel space or we keep it in user space. That adds a lot of code in kernel land where it doesn't belong.

Like I mentioned, I see that as a good thing.

> >
> >  No, slots still exist.  Only the API is "replace slot list" instead of "add slot" and "remove slot".
>
> Why?

Physical memory is discontiguous, and includes aliases (two gpas 
referencing the same backing page).  How else would you describe it.

> On PPC we walk the slots on every fault (incl. mmio), so fast lookup times there would be great. I was thinking of something page table like here.

We can certainly convert the slots to a tree internally.  I'm doing the 
same thing for qemu now, maybe we can do it for kvm too.  No need to 
involve the ABI at all.

Slot searching is quite fast since there's a small number of slots, and 
we sort the larger ones to be in the front, so positive lookups are 
fast.  We cache negative lookups in the shadow page tables (an spte can 
be either "not mapped", "mapped to RAM", or "not mapped and known to be 
mmio") so we rarely need to walk the entire list.

> That only works when then internal slot structure is hidden from user space though.

Why?

>
> >>  I would actually rather like to see the amount of page sharing between kernel and user space increased, no decreased. I don't care if I can throw strace on KVM. I want speed.
> >
> >  Something really critical should be handled in the kernel.  Care to provide examples?
>
> Just look at the s390 patches Christian posted recently.

Which ones?

> I think that's a very nice direction to walk towards.
> For permanently mapped space, the hybrid stuff above could fall into that category. We could however to it through copy_from/to_user with a user space pointer.
>
> So maybe you're right - the mmap'ed space isn't all that important. Having kernel space write into user space memory is however.
>
>

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

