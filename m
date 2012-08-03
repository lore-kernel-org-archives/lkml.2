Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2HCHqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:46:19 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56960 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2HCHqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:46:14 -0400
Message-ID: <501B81BE.4070904@linux.vnet.ibm.com>
Date: Fri, 03 Aug 2012 15:46:06 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 8/9] KVM: do not release the error pfn
References: <5014F053.8020305@linux.vnet.ibm.com> <5014F1F2.3020202@linux.vnet.ibm.com> <20120802131401.GD25344@amt.cnet>
In-Reply-To: <20120802131401.GD25344@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080307-3864-0000-0000-000004070861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 09:14 PM, Marcelo Tosatti wrote:
> On Sun, Jul 29, 2012 at 04:18:58PM +0800, Xiao Guangrong wrote:
>> After commit a2766325cf9f9, the error pfn is replaced by the
>> error code, it need not be released anymore
>>
>> [ The patch is compiling tested for powerpc ]
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/powerpc/kvm/e500_tlb.c |    1 -
>>  arch/x86/kvm/mmu.c          |    6 +++---
>>  arch/x86/kvm/mmu_audit.c    |    4 +---
>>  arch/x86/kvm/paging_tmpl.h  |    8 ++------
>>  virt/kvm/iommu.c            |    1 -
>>  virt/kvm/kvm_main.c         |   14 ++++++++------
>>  6 files changed, 14 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
>> index c8f6c58..09ce5ac 100644
>> --- a/arch/powerpc/kvm/e500_tlb.c
>> +++ b/arch/powerpc/kvm/e500_tlb.c
>> @@ -524,7 +524,6 @@ static inline void kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
>>  		if (is_error_pfn(pfn)) {
>>  			printk(KERN_ERR "Couldn't get real page for gfn %lx!\n",
>>  					(long)gfn);
>> -			kvm_release_pfn_clean(pfn);
>>  			return;
>>  		}
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 320a781..949a5b8 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -2498,7 +2498,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>>  				rmap_recycle(vcpu, sptep, gfn);
>>  		}
>>  	}
>> -	kvm_release_pfn_clean(pfn);
>> +
>> +	if (!is_error_pfn(pfn))
>> +		kvm_release_pfn_clean(pfn);
>>  }
> 
> Can it ever be error_pfn? Seems a problem if so.
> 

Yes, the no-slot-pfn, we will cache the mmio access into spte.

