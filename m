Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab2C2M6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:58:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab2C2M54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:57:56 -0400
Message-ID: <4F745C4F.4060404@redhat.com>
Date: Thu, 29 Mar 2012 14:57:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7436FB.9000004@redhat.com> <4F744A43.4060600@linux.vnet.ibm.com>
In-Reply-To: <4F744A43.4060600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 01:40 PM, Xiao Guangrong wrote:
> >> * Implementation
> >> We can freely walk the page between walk_shadow_page_lockless_begin and
> >> walk_shadow_page_lockless_end, it can ensure all the shadow page is valid.
> >>
> >> In the most case, cmpxchg is fair enough to change the access bit of spte,
> >> but the write-protect path on softmmu/nested mmu is a especial case: it is
> >> a read-check-modify path: read spte, check W bit, then clear W bit.
> > 
> > We also set gpte.D and gpte.A, no? How do you handle that?
> > 
>
>
> We still need walk gust page table before fast page fault to check
> whether the access is valid.

Ok.  But that's outside the mmu lock.

We can also skip that: if !sp->unsync, copy access rights and gpte.A/D
into spare bits in the spte, and use that to check.

>
> >>  In order
> >> to avoid marking spte writable after/during page write-protect, we do the
> >> trick like below:
> >>
> >>       fast page fault path:
> >>             lock RCU
> >>             set identification in the spte
> > 
> > What if you can't (already taken)?  Spin?  Slow path?
>
>
> In this patch, it allows to concurrently access on the same spte:
> it freely set its identification on the spte, because i did not
> want to introduce other atomic operations.
>
> You remind me that there may be a risk: if many vcpu fault on the
> same spte, it will retry the spte forever. Hmm, how about fix it
> like this:
>
> if ( spte.identification = 0) {
> 	set spte.identification = vcpu.id
> 	goto cmpxchg-path
> }
>
> if (spte.identification == vcpu.id)
> 	goto cmpxchg-path
>
> return to guest and retry the address again;
>
> cmpxchg-path:
> 	do checks and cmpxchg
>
> It can ensure the spte can be updated.

What's the difference between this and


  if test_and_set_bit(spte.lock)
       return_to_guest
  else
       do checks and cmpxchg

?

>
> >> The identification should be unique to avoid the below race:
> >>
> >>      VCPU 0                VCPU 1            VCPU 2
> >>       lock RCU
> >>    spte + identification
> >>    check conditions
> >>                        do write-protect, clear
> >>                           identification
> >>                                               lock RCU
> >>                                         set identification
> >>      cmpxchg + w - identification
> >>         OOPS!!!
> > 
> > Is it not sufficient to use just two bits?
> > 
> > pf_lock - taken by page fault path
> > wp_lock - taken by write protect path
> > 
> > pf cmpxchg checks both bits.
> > 
>
>
> If we just use two byte as identification, it has to use atomic
> operations to maintain these bits? or i misunderstood?

Ah, you're using byte writes to set the identification? remember I
didn't read the patches yet.

Please check the optimization manual, I remember there are warnings
there about using different sized accesses for the same location,
particularly when locked ops are involved.  Maybe bitops are cheaper. 
If the cost is similar, they're at least more similar to the rest of the
kernel.

-- 
error compiling committee.c: too many arguments to function

