Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab0GEC4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 22:56:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62105 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab0GEC4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 22:56:39 -0400
Message-ID: <4C3148FF.3030209@cn.fujitsu.com>
Date: Mon, 05 Jul 2010 10:52:47 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com> <4C2F2835.5060508@redhat.com> <4C2F2A0C.90704@cn.fujitsu.com> <4C2F2C5B.9020503@redhat.com> <4C2F2DBB.50904@cn.fujitsu.com> <4C2F30BD.7050702@redhat.com> <4C2F31D9.5010104@redhat.com> <4C2F3527.3020307@cn.fujitsu.com> <4C309B23.9060808@redhat.com>
In-Reply-To: <4C309B23.9060808@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>> Umm, if we move the check before the judgment, it'll check every level,
>> actually, only the opened mapping and the laster level need checked, so
>> for the performance reason, maybe it's better to keep two check-point.
>>    
> 
> What exactly are the conditions when you want to check?
> 
> Perhaps we do need to check every level.  A write to a PDE (or higher
> level) will clear the corresponding spte, but a fault immediately
> afterwards can re-establish the spte to point to the new page.
> 

Looks into the code more carefully, maybe this code is wrong:


             if (!direct) {
                     r = kvm_read_guest_atomic(vcpu->kvm,
-                                          gw->pte_gpa[level - 2],
+                                          gw->pte_gpa[level - 1],
                                      &curr_pte, sizeof(curr_pte));
-                    if (r || curr_pte != gw->ptes[level - 2]) {
+                    if (r || curr_pte != gw->ptes[level - 1]) {
                                kvm_mmu_put_page(sp, sptep);
                                kvm_release_pfn_clean(pfn);
                                sptep = NULL;

It should check the 'level' mapping not 'level - 1', in the later description
i'll explain it.

Since the 'walk_addr' functions is out of mmu_lock protection, we should
handle the guest modify its mapping between 'walk_addr' and 'fetch'.
Now, let's consider every case may be happened while handle guest #PF.

One case is host handle guest written after 'fetch', just like this order:

VCPU 0		VCPU 1
walk_addr
                guest modify its mapping
fetch
                host handle this written(pte_write or invlpg)

This case is not broken anything, even if 'fetch' setup the wrong mapping, the
later written handler will fix it.

Another case is host handle guest written before 'fetch', like this:

CPU 0		VCPU 1
walk_addr
                guest modify its mapping
                host handle this written(pte_write or invlpg)
fetch

We should notice this case, since the later 'fetch' will setup the wrong mapping.

For example, the guest mapping which 'walk_addr' got is:

GPML4E -> GPDPE -> GPDE -> GPTE -> GFNA
(Just take small page for example, other mapping way is also applied)

And, for good to describe, we abstract 'fetch''s work:

for_each_shadow_entry(vcpu, addr, iterator) {
	if (iterator.level == hlevel)
		Mapping the later level

	if (is_shadow_present_pte(*sptep) &&
		!is_large_pte(*sptep))		   <------ Point A
		continue;

	/* handle the non-present/wrong  middle level */

	find/create the corresponding sp            <----- Point B

	if (the guest mapping is modified)          <----- Point C
		break;
	setup this level's mapping                  <----- Point D

}

[
 Note: the later level means PTE, PDE if 2M page size, PDPE if 1G page size
 the middle level means PDE, PDPE if not using large page size / PML4E
]

There are two cases:

1: Guest modify the middle level, for example, guest modify the GPDE.
   a: the GPDE has corresponding sp entry, after VCPU1 handle this written,
      the corresponding host mapping is like this:
      HPML4E -> HPDPE -> HPDE
      [ HPDE.P = 0 since VCPU1 written handler zapped it in pte_wirte ]

      Under this case, it can broke Point A's judgment and Point C can detect
      the guest mapping is modified, so it exits this function without setup the
      mapping.

      And, we should check the guest mapping at GPDE not GPTE since it's GPDE
      modified not GPTE, it's the explanation for the front fix.

  b: the GPDE not has corresponding sp entry(the area is firstly accessed),
     corresponding host mapping is like this:
     HPML4E -> HPDPE
     [ HPDPE.P = 0]

     under this case, VCPU1 happily write GPDE without #PF since the GPDE not has shadow
     page, it's not write-protected.

     while we handle HPDPE, we will create the shadow page for GPDE
     at Point B, then the host mapping is like this:
     HPML4E -> HPDPE -> HPDE
     [ HPDE.P = 0 ]
     it's the same as 1.a, so do the same work as 1.a

     Note: there is a trick: we should put 'Point C' behind of 'Point B', since after we
           create sp for GPDE, the later modify GPDE will cause #PF, it can ensure later
           check is valid

2: Guest modify the later level.
   Form 'fetch''s abstract, we can see the late level is not checked by 'Point C', if
   guest modified the GPTE's mapping, the wrong-mapping will be setup by 'fetch', this
   is just this path does




     
