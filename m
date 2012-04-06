Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2DFFZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 01:25:26 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52720 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2DFFZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 01:25:25 -0400
Message-ID: <4F7E7E1A.3000807@linux.vnet.ibm.com>
Date: Fri, 06 Apr 2012 13:24:42 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7436FB.9000004@redhat.com> <4F744A43.4060600@linux.vnet.ibm.com> <4F745C4F.4060404@redhat.com> <4F757A7C.6020109@linux.vnet.ibm.com> <4F7850EA.3080203@redhat.com> <4F7E1531.5020307@gmail.com>
In-Reply-To: <4F7E1531.5020307@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12040605-4790-0000-0000-00000218ABAE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 05:57 AM, Xiao Guangrong wrote:


>>>>
>>>> What's the difference between this and
>>>>
>>>>
>>>>   if test_and_set_bit(spte.lock)
>>>>        return_to_guest
>>>>   else
>>>>        do checks and cmpxchg
>>>>
>>>> ?
>>>>
>>>
>>>
>>> test_and_set_bit is a atomic operation that is i want to avoid.
>>
>> Right.  Can you check what the effect is (with say
>> test_and_set_bit(spte, 0) in the same path).
>>
>> I'm not convinced it's significant.
>>
> 
> 
> Okay, if you prefer to test_and_set_bit, we may introduce two bits:
> fast_pf and write_protect, do things like this:
> 
> on fast page fault path:
> 
> 	old_spte = *spte
> 
> 	if (test_and_set_bit(spte.fast_pf))
> 		return_to_guest
> 
> 	old_spte |= fast_pf
> 
> 	if (old_spte.wp)
> 		clear-fast-pf bit and return_to_guest
> 
> 	if (!rmap.PTE_LIST_WRITE_PROTECT)
> 		cmpxchg(spte, old_spte, old_spte +w - fast_pf)
> 	else
> 		clear-fast-pf bit
> 
> on page write-protect path:
> 	lock mmu-lock
> 	set rmap.PTE_LIST_WRITE_PROTECT
>         smp_mb()
>         if (spte.w || spte.fast_pf)
>                 spte -w -fast_pf + write_protect
> 
>         unlock mmu-lock
> 
> I think it works but can not make page fault fast for unsync sp (
> e.g: two sptes point to the gfn, a page fault on one of the spte
> make gfn's sp become unsync.), it is not too bad since we can cache
> access bits in spte and properly make all sptes become writable on
> mmu_need_write_protect path in a new patchset.
> 


Foolish me, i should be crazy. Sorry for my mistake. :(

Unfortunately, it can not work, we can not get a stable gfn from gpte or
sp->gfns[]. For example:

beginning:
Gpte = Gfn1
gfn_to_pfn(Gfn1) = Pfn
Spte = Pfn
Gfn1 is write-free
Gfn2 is write-protected


VCPU 0                              VCPU 1                     VCPU 2

fault on gpte
fast page fault path:
  set Spte.fast_pf
  get Gfn1 from Gpte/sp->gfns[]
  if (Gfn1 is writable)
                                Pfn is swapped out:
					Spte = 0
				Gpte is modified to Gfn2,
                                and Pfn is realloced and remapped
                                to Gfn2, so:
                                        Spte = Pfn

                                                          fast page fault path:
                                                             set Spte.fast_pf

         cmpxchg  Spte+w
            OOPS!!!
  <we see Spte is not changed and
   happily make it writable, so gfn2 can be writable>

It seems only a unique identification can prevent this. :(

