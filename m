Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab2HPQDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:03:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab2HPQDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:03:47 -0400
Date: Thu, 16 Aug 2012 13:03:07 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/12] KVM: introduce readonly memslot
Message-ID: <20120816160307.GA24376@amt.cnet>
References: <5020E423.9080004@linux.vnet.ibm.com>
 <20120810181422.GA14892@amt.cnet>
 <5025D334.9070503@linux.vnet.ibm.com>
 <20120813173900.GA25268@amt.cnet>
 <5029BEBF.4030709@linux.vnet.ibm.com>
 <20120814152542.GB14582@amt.cnet>
 <502C89D7.6040906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502C89D7.6040906@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 01:49:11PM +0800, Xiao Guangrong wrote:
> On 08/14/2012 11:25 PM, Marcelo Tosatti wrote:
> > On Tue, Aug 14, 2012 at 10:58:07AM +0800, Xiao Guangrong wrote:
> >> On 08/14/2012 01:39 AM, Marcelo Tosatti wrote:
> >>> On Sat, Aug 11, 2012 at 11:36:20AM +0800, Xiao Guangrong wrote:
> >>>> On 08/11/2012 02:14 AM, Marcelo Tosatti wrote:
> >>>>> On Tue, Aug 07, 2012 at 05:47:15PM +0800, Xiao Guangrong wrote:
> >>>>>> Changelog:
> >>>>>> - introduce KVM_PFN_ERR_RO_FAULT instead of dummy page
> >>>>>> - introduce KVM_HVA_ERR_BAD and optimize error hva indicators
> >>>>>>
> >>>>>> The test case can be found at:
> >>>>>> http://lkml.indiana.edu/hypermail/linux/kernel/1207.2/00819/migrate-perf.tar.bz2
> >>>>>>
> >>>>>> In current code, if we map a readonly memory space from host to guest
> >>>>>> and the page is not currently mapped in the host, we will get a fault-pfn
> >>>>>> and async is not allowed, then the vm will crash.
> >>>>>>
> >>>>>> As Avi's suggestion, We introduce readonly memory region to map ROM/ROMD
> >>>>>> to the guest, read access is happy for readonly memslot, write access on
> >>>>>> readonly memslot will cause KVM_EXIT_MMIO exit.
> >>>>>
> >>>>> Memory slots whose QEMU mapping is write protected is supported
> >>>>> today, as long as there are no write faults.
> >>>>>
> >>>>> What prevents the use of mmap(!MAP_WRITE) to handle read-only memslots
> >>>>> again?
> >>>>>
> >>>>
> >>>> It is happy to map !write host memory space to the readonly memslot,
> >>>> and they can coexist as well.
> >>>>
> >>>> readonly memslot checks the write-permission by seeing slot->flags and
> >>>> !write memory checks the write-permission in hva_to_pfn() function
> >>>> which checks vma->flags. It is no conflict.
> >>>
> >>> Yes, there is no conflict. The point is, if you can use the
> >>> mmap(PROT_READ) interface (supporting read faults on read-only slots)
> >>> for this behavior, what is the advantage of a new memslot flag?
> >>>
> >>
> >> You can get the discussion at:
> >> https://lkml.org/lkml/2012/5/22/228
> >>
> >>> I'm not saying mmap(PROT_READ) is the best interface, i am just asking
> >>> why it is not.
> >>
> >> My fault. :(
> >>
> >>>
> >>>>> The initial objective was to fix a vm crash, can you explain that
> >>>>> initial problem?
> >>>>>
> >>>>
> >>>> The issue was trigged by this code:
> >>>>
> >>>>                 } else {
> >>>>                         if (async && (vma->vm_flags & VM_WRITE))
> >>>>                                 *async = true;
> >>>>                         pfn = KVM_PFN_ERR_FAULT;
> >>>>                 }
> >>>>
> >>>> If the host memory region is readonly (!vma->vm_flags & VM_WRITE) and
> >>>> its physical page is swapped out (or the file data does not be read in),
> >>>> get_user_page_nowait will fail, above code reject to set async,
> >>>> then we will get a fault pfn and async=false.
> >>>>
> >>>> I guess this issue also exists in "QEMU write protected mapping" as
> >>>> you mentioned above.
> >>>
> >>> Yes, it does. As far as i understand, what that check does from a high
> >>> level pov is:
> >>>
> >>> - Did get_user_pages_nowait() fail due to a swapped out page (in which 
> >>> case we should try to swappin the page asynchronously), or due to 
> >>> another reason (for which case an error should be returned).
> >>>
> >>> Using vma->vm_flags VM_WRITE for that is trying to guess why
> >>> get_user_pages_nowait() failed, because it (gup_nowait return values) 
> >>> does not provide sufficient information by itself.
> >>>
> >>
> >> That is exactly what i did in the first version. :)
> >>
> >> You can see it and the reason why it switched to the new way (readonly memslot)
> >> in the above website (the first message in thread).
> > 
> > Userspace can create multiple mappings for the same memory region, for
> > example via shared memory (shm_open), and have different protections for
> > the two (or more) regions. I had old patch doing this, its attached.
> > 
> 
> In this way, if guest try to write a readonly gfn, the vm will be crashed since
> it will return FAULT_PFN on the page-fault path. VMM can not detect this kind
> of fault, we have these problems:
> - even if guest try to write ROM on a PCI device, the guest will die, but
>   we'd ignore this write, it looks more like the real machine.
> 
> - can not implement ROMD beacuse write to a ROMD is MMIO access
> 
> Yes, we can rework get_user_page_nowait and get_user_pages_fast, let them
> tell us the fault reason, but it is more complex i think.
> 
> >>> Can't that be fixed separately? 
> >>>
> >>> Another issue which is also present with the mmap(PROT_READ) scheme is
> >>> interaction with reexecute_instruction. That is, unless i am mistaken,
> >>> reexecute_instruction can succeed (return true) on a region that is
> >>> write protected. This breaks the "write faults on read-only slots exit
> >>> to userspace via EXIT_MMIO" behaviour.
> >>
> >> Sorry, Why? After re-entry to the guest, it can not generate a correct MMIO?
> > 
> > reexecute_instruction validates presence of GPA by looking at registered
> > memslots. But if the access is a write, and userspace memory map is
> > read-only, reexecute_instruction should exit via MMIO.
> > 
> > That is, reexecute_instruction must validate GPA using registered
> > memslots AND additionaly userspace map permission, not only registered
> > memslot.
> > 
> 
> What will happen if we always retry a unhandleable instruction which try to write
> readonly memory? It will goto a endless loop (write-fault -> emulation fail ->
> write-fault...)? Right?

I think so... thats what would happen on real hardware.

> I do not think exit via MMIO is a good idea because the instructions can not be
> emulated, after the userspace finished the MMIO, the emulation will fail again.
> 
> I think we can simply exit via KVM_EXIT_INTERNAL_ERROR for all the access on
> readonly memory because:
> - it is fine for the read access since the read fault is always fixed on page-fault path,
>   it does not go to x86_emulate_instruction()
> 
> - for the write access, we can not emulate it. It is not bad since it only happen on
>   the instructions kvm unsupported.
> 
> Your idea?

Either KVM_EXIT_INTERNAL_ERROR or leave the guest looping. 

