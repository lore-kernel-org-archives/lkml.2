Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab0F1JSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:18:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0F1JSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:18:06 -0400
Message-ID: <4C2868C9.8040302@redhat.com>
Date: Mon, 28 Jun 2010 12:18:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/10] KVM: MMU: fix writable sync sp mapping
References: <4C249B84.4080703@cn.fujitsu.com> <4C2704CF.6040401@cn.fujitsu.com>
In-Reply-To: <4C2704CF.6040401@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2010 10:59 AM, Xiao Guangrong wrote:
>
> Xiao Guangrong wrote:
>
>    
>>
>> -		/*
>> -		 * Optimization: for pte sync, if spte was writable the hash
>> -		 * lookup is unnecessary (and expensive). Write protection
>> -		 * is responsibility of mmu_get_page / kvm_sync_page.
>> -		 * Same reasoning can be applied to dirty page accounting.
>> -		 */
>> -		if (!can_unsync&&  is_writable_pte(*sptep))
>> -			goto set_pte;
>> -
>>      
> Sorry, this optimization not broken anything, just my mistake, please review
> this.
>
> Subject: [PATCH v2 1/10] KVM: MMU: fix writable sync sp mapping
>
> While we sync the unsync sp, we may mapping the spte writable, it's
> dangerous, if one unsync sp's mapping gfn is another unsync page's gfn.
>
> For example:
> have two unsync pages SP1, SP2 and:
>
> SP1.pte[0] = P
> SP2.gfn's pfn = P
> [SP1.pte[0] = SP2.gfn's pfn]
>
> First, we unsync SP2, it will write protect for SP2.gfn since
>    

Do you mean we sync SP2 here?

> SP1.pte[0] is mapping to this page, it will mark read only.
>
> Then, we unsync SP1, SP1.pte[0] may mark to writable.
>    

How can unsyncing SP1 change SP1.pte[0]?

When we unsync SP2 by a fault through SP1.pte[0], that can cause 
SP1.pte[0] to become writable.  But unsyncing SP1 shouldn't have an 
effect on its sptes.

> Now, we will write SP2.gfn by SP1.pte[0] mapping
>
> This bug will corrupt guest's page table, fixed by mark read-only mapping
> if the mapped gfn has shadow page
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 045a0f9..24290f8 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1810,11 +1810,14 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>   	bool need_unsync = false;
>
>   	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
> +		if (!can_unsync)
> +			return 1;
> +
>    

What if the page is already unsync?  We don't need write protection in 
this case.

>   		if (s->role.level != PT_PAGE_TABLE_LEVEL)
>   			return 1;
>
>   		if (!need_unsync&&  !s->unsync) {
> -			if (!can_unsync || !oos_shadow)
> +			if (!oos_shadow)
>   				return 1;
>   			need_unsync = true;
>   		}
>    

How can this change anything?  On the first pass, need_unsync  = false, 
so we will check can_unsync and return.

-- 
error compiling committee.c: too many arguments to function

