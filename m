Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab0EGI0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:26:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57465 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab0EGIZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:25:44 -0400
Message-ID: <4BE3CE80.8050408@cn.fujitsu.com>
Date: Fri, 07 May 2010 16:25:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
References: <4BD8228D.7090708@cn.fujitsu.com> <20100429180955.GA17909@amt.cnet> <4BD9D35C.5090403@redhat.com> <20100430154427.GA32340@amt.cnet> <4BE269D4.9090108@cn.fujitsu.com> <20100506190402.GA3432@amt.cnet>
In-Reply-To: <20100506190402.GA3432@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti wrote:
> On Thu, May 06, 2010 at 03:03:48PM +0800, Lai Jiangshan wrote:
>> Marcelo Tosatti wrote:
>>> On Thu, Apr 29, 2010 at 09:43:40PM +0300, Avi Kivity wrote:
>>>> On 04/29/2010 09:09 PM, Marcelo Tosatti wrote:
>>>>> You missed quadrant on 4mb large page emulation with shadow (see updated
>>>>> patch below).
>>>> Good catch.
>>>>
>>>>> Also for some reason i can't understand the assumption
>>>>> does not hold for large sptes with TDP, so reverted for now.
>>>> It's unrelated to TDP, same issue with shadow.  I think the
>>>> calculation is correct.  For example the 4th spte for a level=2 page
>>>> will yield gfn=4*512.
>>> Under testing i see sp at level 2, with sp->gfn == 4096, mmu_set_spte
>>> setting index 8 to gfn 4096 (whereas kvm_mmu_page_get_gfn returns 4096 +
>>> 8*512).
>>>
>>> Lai, can you please take a look at it? You should see the
>>> kvm_mmu_page_set_gfn BUG_ON by using -mem-path on hugetlbfs.
>>>
>> Could you tell me how you test it? It will be better if I follow
>> your test steps.
> 
> mount -t hugetlbfs none /mnt/
> echo xyz > /proc/sys/vm/nr_hugepages
> qemu-kvm parameters -mem-path /mnt/
> 
>> I also hit the kvm_mmu_page_set_gfn BUG_ON, It is because
>> FNAME(fetch)() set sp->gfn wrong. The patch:
>> [PATCH] kvm: calculate correct gfn for small host pages which emulates large guest pages
>> fix it.
>>
>> I can not hit kvm_mmu_page_set_gfn BUG_ON after this patch also
>> applied.
>>
>> So could you tell me your test steps:
>> The host: ept/npt enabled? 64bit? testing codes in host?
> 
> Intel EPT enabled.
> 
>> The guest: OS? PAE? 32bit? 64bit? testing codes in guest?
> 
> FC12 guest.
> 


I forgot to check if the calculation of base gfn is correct
in __direct_map().

Subject: [PATCH] kvm, tdp: calculate correct base gfn for non-DIR level

the base gfn calculation is incorrect in __direct_map(),
it does not calculate correctly when level=3 or 4.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
---
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a5c6719..6986a6f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1955,7 +1956,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 		}
 
 		if (*iterator.sptep == shadow_trap_nonpresent_pte) {
-			pseudo_gfn = (iterator.addr & PT64_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
+			u64 base_addr = iterator.addr;
+
+			base_addr &= PT64_LVL_ADDR_MASK(iterator.level);
+			pseudo_gfn = base_addr >> PAGE_SHIFT;
 			sp = kvm_mmu_get_page(vcpu, pseudo_gfn, iterator.addr,
 					      iterator.level - 1,
 					      1, ACC_ALL, iterator.sptep);



