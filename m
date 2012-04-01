Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2DAM6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 08:58:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2DAM6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 08:58:22 -0400
Message-ID: <4F7850EA.3080203@redhat.com>
Date: Sun, 01 Apr 2012 15:58:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7436FB.9000004@redhat.com> <4F744A43.4060600@linux.vnet.ibm.com> <4F745C4F.4060404@redhat.com> <4F757A7C.6020109@linux.vnet.ibm.com>
In-Reply-To: <4F757A7C.6020109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 12:18 PM, Xiao Guangrong wrote:
> On 03/29/2012 08:57 PM, Avi Kivity wrote:
>
> > On 03/29/2012 01:40 PM, Xiao Guangrong wrote:
> >>>> * Implementation
> >>>> We can freely walk the page between walk_shadow_page_lockless_begin and
> >>>> walk_shadow_page_lockless_end, it can ensure all the shadow page is valid.
> >>>>
> >>>> In the most case, cmpxchg is fair enough to change the access bit of spte,
> >>>> but the write-protect path on softmmu/nested mmu is a especial case: it is
> >>>> a read-check-modify path: read spte, check W bit, then clear W bit.
> >>>
> >>> We also set gpte.D and gpte.A, no? How do you handle that?
> >>>
> >>
> >>
> >> We still need walk gust page table before fast page fault to check
> >> whether the access is valid.
> > 
> > Ok.  But that's outside the mmu lock.
> > 
> > We can also skip that: if !sp->unsync, copy access rights and gpte.A/D
> > into spare bits in the spte, and use that to check.
> > 
>
>
> Great!
>
> gpte.A need not be copied into spte since EFEC.P = 1 means the shadow page
> table is present, gpte.A must be set in this case.
>
> And, we do not need to cache gpte access rights into spte, instead of it,
> we can atomicly read gpte to get these information (anyway, we need read gpte
> to get the gfn.)

Why do we need the gfn?  If !sp->unsync then it is unchanged (it's also
in sp->gfns).

Oh, needed for mark_page_dirty().

Caching gpte access in the spte will save decoding the access buts and
sp->role.access.

>
> I will do it in the next version.
>
> >>
> >>>>  In order
> >>>> to avoid marking spte writable after/during page write-protect, we do the
> >>>> trick like below:
> >>>>
> >>>>       fast page fault path:
> >>>>             lock RCU
> >>>>             set identification in the spte
> >>>
> >>> What if you can't (already taken)?  Spin?  Slow path?
> >>
> >>
> >> In this patch, it allows to concurrently access on the same spte:
> >> it freely set its identification on the spte, because i did not
> >> want to introduce other atomic operations.
> >>
> >> You remind me that there may be a risk: if many vcpu fault on the
> >> same spte, it will retry the spte forever. Hmm, how about fix it
> >> like this:
> >>
> >> if ( spte.identification = 0) {
> >> 	set spte.identification = vcpu.id
> >> 	goto cmpxchg-path
> >> }
> >>
> >> if (spte.identification == vcpu.id)
> >> 	goto cmpxchg-path
> >>
> >> return to guest and retry the address again;
> >>
> >> cmpxchg-path:
> >> 	do checks and cmpxchg
> >>
> >> It can ensure the spte can be updated.
> > 
> > What's the difference between this and
> > 
> > 
> >   if test_and_set_bit(spte.lock)
> >        return_to_guest
> >   else
> >        do checks and cmpxchg
> > 
> > ?
> > 
>
>
> test_and_set_bit is a atomic operation that is i want to avoid.

Right.  Can you check what the effect is (with say
test_and_set_bit(spte, 0) in the same path).

I'm not convinced it's significant.

>
> >>
> >>>> The identification should be unique to avoid the below race:
> >>>>
> >>>>      VCPU 0                VCPU 1            VCPU 2
> >>>>       lock RCU
> >>>>    spte + identification
> >>>>    check conditions
> >>>>                        do write-protect, clear
> >>>>                           identification
> >>>>                                               lock RCU
> >>>>                                         set identification
> >>>>      cmpxchg + w - identification
> >>>>         OOPS!!!
> >>>
> >>> Is it not sufficient to use just two bits?
> >>>
> >>> pf_lock - taken by page fault path
> >>> wp_lock - taken by write protect path
> >>>
> >>> pf cmpxchg checks both bits.
> >>>
> >>
> >>
> >> If we just use two byte as identification, it has to use atomic
> >> operations to maintain these bits? or i misunderstood?
> > 
> > Ah, you're using byte writes to set the identification? remember I
> > didn't read the patches yet.
> > 
>
>
> Yes.
>
> > Please check the optimization manual, I remember there are warnings
> > there about using different sized accesses for the same location,
> > particularly when locked ops are involved.
>
>
> "using different sized accesses for the same location" is OK i guess,
> anyway, we can have the data struct of this style:
>
> union {
> 	struct	{
> 		char byte1,
> 		char byte2,
> 		char byte3,
> 		char byte4
>       	} foo;
>
> 	int bar;
> }
>
> Access .bar and .foo.byte1 is allowed.
>
> And for the LOCK operation, i find these descriptions in the manual:
>
> "Locked operations are atomic with respect to all other memory operations and all
> externally visible events"
>
> And there is a warning:
> Software should access semaphores (shared memory used for signalling between
> multiple processors) using identical addresses and operand lengths. For example, if
> one processor accesses a semaphore using a word access, other processors should
> not access the semaphore using a byte access.
>
> It is the warning you remember?

No, it should be safe, but performance is degraded if you mix loads and
stores of different sizes to the same location.

See for example "2.1.5.2 L1 DCache", Store Forwarding section in the
optimization guide.


>
> In our case, we do not treat it as "semaphores": the "byte writes" does not
> need be atomic.
>
> > Maybe bitops are cheaper. 
> > If the cost is similar, they're at least more similar to the rest of the
> > kernel.
> > 
>
>
> The "bitops" you mentioned is the atomic-style bitops? It is cheaper that
> byte writes?

They're not cheaper in general but may be compared to mixing byte writes
and word loads.

-- 
error compiling committee.c: too many arguments to function

