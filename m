Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0GEIX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:23:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab0GEIX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:23:57 -0400
Message-ID: <4C319699.9000104@redhat.com>
Date: Mon, 05 Jul 2010 11:23:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com> <4C2F2835.5060508@redhat.com> <4C2F2A0C.90704@cn.fujitsu.com> <4C2F2C5B.9020503@redhat.com> <4C2F2DBB.50904@cn.fujitsu.com> <4C2F30BD.7050702@redhat.com> <4C2F31D9.5010104@redhat.com> <4C2F3527.3020307@cn.fujitsu.com> <4C309B23.9060808@redhat.com> <4C3148FF.3030209@cn.fujitsu.com>
In-Reply-To: <4C3148FF.3030209@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 05:52 AM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>
>    
>>> Umm, if we move the check before the judgment, it'll check every level,
>>> actually, only the opened mapping and the laster level need checked, so
>>> for the performance reason, maybe it's better to keep two check-point.
>>>
>>>        
>> What exactly are the conditions when you want to check?
>>
>> Perhaps we do need to check every level.  A write to a PDE (or higher
>> level) will clear the corresponding spte, but a fault immediately
>> afterwards can re-establish the spte to point to the new page.
>>
>>      
> Looks into the code more carefully, maybe this code is wrong:
>
>
>               if (!direct) {
>                       r = kvm_read_guest_atomic(vcpu->kvm,
> -                                          gw->pte_gpa[level - 2],
> +                                          gw->pte_gpa[level - 1],
>                                        &curr_pte, sizeof(curr_pte));
> -                    if (r || curr_pte != gw->ptes[level - 2]) {
> +                    if (r || curr_pte != gw->ptes[level - 1]) {
>                                  kvm_mmu_put_page(sp, sptep);
>                                  kvm_release_pfn_clean(pfn);
>                                  sptep = NULL;
>
> It should check the 'level' mapping not 'level - 1', in the later description
> i'll explain it.
>    

Right, this fixes the check for the top level, but it removes a check 
from the bottom level.

We need to move this to the top of the loop so we check all levels.  I 
guess this is why you needed to add a new check point.  But since we 
loop at least glevels times, we don't need two check points.

> Since the 'walk_addr' functions is out of mmu_lock protection, we should
> handle the guest modify its mapping between 'walk_addr' and 'fetch'.
> Now, let's consider every case may be happened while handle guest #PF.
>
> One case is host handle guest written after 'fetch', just like this order:
>
> VCPU 0		VCPU 1
> walk_addr
>                  guest modify its mapping
> fetch
>                  host handle this written(pte_write or invlpg)
>
> This case is not broken anything, even if 'fetch' setup the wrong mapping, the
> later written handler will fix it.
>    

Ok.

> Another case is host handle guest written before 'fetch', like this:
>
> CPU 0		VCPU 1
> walk_addr
>                  guest modify its mapping
>                  host handle this written(pte_write or invlpg)
> fetch
>
> We should notice this case, since the later 'fetch' will setup the wrong mapping.
>
> For example, the guest mapping which 'walk_addr' got is:
>
> GPML4E ->  GPDPE ->  GPDE ->  GPTE ->  GFNA
> (Just take small page for example, other mapping way is also applied)
>
> And, for good to describe, we abstract 'fetch''s work:
>
> for_each_shadow_entry(vcpu, addr, iterator) {
> 	if (iterator.level == hlevel)
> 		Mapping the later level
>
> 	if (is_shadow_present_pte(*sptep)&&
> 		!is_large_pte(*sptep))		<------ Point A
> 		continue;
>
> 	/* handle the non-present/wrong  middle level */
>
> 	find/create the corresponding sp<----- Point B
>
> 	if (the guest mapping is modified)<----- Point C
> 		break;
> 	setup this level's mapping<----- Point D
>
> }
>
> [
>   Note: the later level means PTE, PDE if 2M page size, PDPE if 1G page size
>   the middle level means PDE, PDPE if not using large page size / PML4E
> ]
>
> There are two cases:
>
> 1: Guest modify the middle level, for example, guest modify the GPDE.
>     a: the GPDE has corresponding sp entry, after VCPU1 handle this written,
>        the corresponding host mapping is like this:
>        HPML4E ->  HPDPE ->  HPDE
>        [ HPDE.P = 0 since VCPU1 written handler zapped it in pte_wirte ]
>
>        Under this case, it can broke Point A's judgment and Point C can detect
>        the guest mapping is modified, so it exits this function without setup the
>        mapping.
>
>        And, we should check the guest mapping at GPDE not GPTE since it's GPDE
>        modified not GPTE, it's the explanation for the front fix.
>    

Agree.

>    b: the GPDE not has corresponding sp entry(the area is firstly accessed),
>       corresponding host mapping is like this:
>       HPML4E ->  HPDPE
>       [ HPDPE.P = 0]
>
>       under this case, VCPU1 happily write GPDE without #PF since the GPDE not has shadow
>       page, it's not write-protected.
>
>       while we handle HPDPE, we will create the shadow page for GPDE
>       at Point B, then the host mapping is like this:
>       HPML4E ->  HPDPE ->  HPDE
>       [ HPDE.P = 0 ]
>       it's the same as 1.a, so do the same work as 1.a
>
>       Note: there is a trick: we should put 'Point C' behind of 'Point B', since after we
>             create sp for GPDE, the later modify GPDE will cause #PF, it can ensure later
>             check is valid
>
> 2: Guest modify the later level.
>     Form 'fetch''s abstract, we can see the late level is not checked by 'Point C', if
>     guest modified the GPTE's mapping, the wrong-mapping will be setup by 'fetch', this
>     is just this path does
>
>    

Ok.   So moving the check to before point A, and s/level - 2/level - 1/ 
should work, yes?

Should be slightly simpler since we don't need to kvm_mmu_put_page(sp, 
sptep) any more.

Thanks for the detailed explanation.

-- 
error compiling committee.c: too many arguments to function

