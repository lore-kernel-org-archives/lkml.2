Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1GFT5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:57:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54103 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1GFT5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:57:17 -0400
Message-ID: <4E14BE90.8070508@cn.fujitsu.com>
Date: Thu, 07 Jul 2011 03:59:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 18/19] KVM: MMU: mmio page fault support
References: <4E0C3178.2080603@cn.fujitsu.com> <4E0C3375.6010500@cn.fujitsu.com> <20110706185252.GC9820@amt.cnet>
In-Reply-To: <20110706185252.GC9820@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 03:56:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 03:56:37,
	Serialize complete at 2011-07-07 03:56:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 02:52 AM, Marcelo Tosatti wrote:

>> +/*
>> + * If it is a real mmio page fault, return 1 and emulat the instruction
>> + * directly, return 0 to let CPU fault again on the address, -1 is
>> + * returned if bug is detected.
>> + */
>> +int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>> +{
>> +	u64 spte;
>> +
>> +	if (quickly_check_mmio_pf(vcpu, addr, direct))
>> +		return 1;
>> +
>> +	spte = walk_shadow_page_get_mmio_spte(vcpu, addr);
>> +
>> +	if (is_mmio_spte(spte)) {
>> +		gfn_t gfn = get_mmio_spte_gfn(spte);
>> +		unsigned access = get_mmio_spte_access(spte);
>> +
>> +		if (direct)
>> +			addr = 0;
>> +		vcpu_cache_mmio_info(vcpu, addr, gfn, access);
>> +		return 1;
>> +	}
>> +
>> +	/*
>> +	 * It's ok if the gva is remapped by other cpus on shadow guest,
>> +	 * it's a BUG if the gfn is not a mmio page.
>> +	 */
>> +	if (direct && is_shadow_present_pte(spte))
>> +		return -1;
> 

Marcelo,

> This is only going to generate an spte dump, for a genuine EPT
> misconfig, if the present bit is set.
> 
> Should be:
> 
> /*
>  * Page table zapped by other cpus, let CPU fault again on
>  * the address.
>  */
> if (*spte == 0ull)
>     return 0;

Can not use "*spte == 0ull" here, it should use !is_shadow_present_pte(spte)
instead, since on x86-32 host, we can get the high 32 bit is set, and the present
bit is cleared.

> /* BUG if gfn is not an mmio page */
> return -1;

We can not detect bug for soft-mmu, since the shadow page can be changed anytime,
for example:

VCPU 0                            VCPU1
mmio page is intercepted
                              change the guest page table and map the virtual
                              address to the RAM region
walk shadow page table, and
detect the gfn is RAM, spurious
BUG is reported

In theory, it can be happened.

> 
>> +static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
>> +			   int *nr_present)
>> +{
>> +	if (unlikely(is_mmio_spte(*sptep))) {
>> +		if (gfn != get_mmio_spte_gfn(*sptep)) {
>> +			mmu_spte_clear_no_track(sptep);
>> +			return true;
>> +		}
>> +
>> +		(*nr_present)++;
> 
> Can increase nr_present in the caller.
> 

Yes, we should increase it to avoid the unsync shadow page to be freed.

>> @@ -6481,6 +6506,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>  	if (!kvm->arch.n_requested_mmu_pages)
>>  		nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
>>  
>> +	/*
>> +	 * If the new memory slot is created, we need to clear all
>> +	 * mmio sptes.
>> +	 */
>> +	if (npages && old.base_gfn != mem->guest_phys_addr >> PAGE_SHIFT)
>> +		kvm_arch_flush_shadow(kvm);
>> +
> 
> This should be in __kvm_set_memory_region.
> 

Um, __kvm_set_memory_region is a common function, and only x86 support mmio spte,
it seems no need to do this for all architecture?

