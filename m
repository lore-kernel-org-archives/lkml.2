Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0GCMI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 08:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab0GCMI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 08:08:27 -0400
Message-ID: <4C2F2835.5060508@redhat.com>
Date: Sat, 03 Jul 2010 15:08:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet> <4C2F117C.2000006@cn.fujitsu.com>
In-Reply-To: <4C2F117C.2000006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2010 01:31 PM, Xiao Guangrong wrote:
>
>> See how the pte is reread inside fetch with mmu_lock held.
>>
>>      
> It looks like something is broken in 'fetch' functions, this patch will
> fix it.
>
> Subject: [PATCH] KVM: MMU: fix last level broken in FNAME(fetch)
>
> We read the guest level out of 'mmu_lock', sometimes, the host mapping is
> confusion. Consider this case:
>
> VCPU0:                                              VCPU1
>
> Read guest mapping, assume the mapping is:
> GLV3 ->  GLV2 ->  GLV1 ->  GFNA,
> And in the host, the corresponding mapping is
> HLV3 ->  HLV2 ->  HLV1(P=0)
>
>                                                     Write GLV1 and cause the
>                                                     mapping point to GFNB
>                                                     (May occur in pte_write or
>                                                        invlpg path)
>
> Mapping GLV1 to GFNA
>
> This issue only occurs in the last indirect mapping, since if the middle
> mapping is changed, the mapping will be zapped, then it will be detected
> in the FNAME(fetch) path, but when it map the last level, it not checked.
>
> Fixed by also check the last level.
>
>    

I don't really see what is fixed.  We already check the gpte.  What's 
special about the new scenario?

> @@ -322,6 +334,12 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>   		level = iterator.level;
>   		sptep = iterator.sptep;
>   		if (iterator.level == hlevel) {
> +			if (check&&  level == gw->level&&
> +			      !FNAME(check_level_mapping)(vcpu, gw, hlevel)) {
> +				kvm_release_pfn_clean(pfn);
> +				break;
> +			}
> +
>    

Now we check here...

>   			mmu_set_spte(vcpu, sptep, access,
>   				     gw->pte_access&  access,
>   				     user_fault, write_fault,
> @@ -376,10 +394,10 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>   		sp = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
>   					       direct, access, sptep);
>   		if (!direct) {
> -			r = kvm_read_guest_atomic(vcpu->kvm,
> -						  gw->pte_gpa[level - 2],
> -						&curr_pte, sizeof(curr_pte));
> -			if (r || curr_pte != gw->ptes[level - 2]) {
> +			if (hlevel == level - 1)
> +				check = false;
> +
> +			if (!FNAME(check_level_mapping)(vcpu, gw, level - 1)) {
>    

... and here?  Why?


(looking at the code, we have a call to kvm_host_page_size() on every 
page fault, that takes mmap_sem... that's got to impact scaling)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

