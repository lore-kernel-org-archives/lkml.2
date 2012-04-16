Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab2DPDZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:25:19 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56881 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2DPDZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:25:17 -0400
Message-ID: <4F8B9115.2030807@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:25:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/16] KVM: MMU: fask check whether page is writable
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FC82.2050302@linux.vnet.ibm.com> <4F8AE64F.7080909@redhat.com>
In-Reply-To: <4F8AE64F.7080909@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041603-3864-0000-0000-000002470438
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2012 11:16 PM, Avi Kivity wrote:

> On 04/13/2012 01:14 PM, Xiao Guangrong wrote:
>> Using bit 1 (PTE_LIST_WP_BIT) in rmap store the write-protect status
>> to avoid unnecessary shadow page walking
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |   40 ++++++++++++++++++++++++++++++++++------
>>  1 files changed, 34 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 0c6e92d..8b71908 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -796,7 +796,9 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
>>  	return level - 1;
>>  }
>>
>> -#define PTE_LIST_DESC		(0x1ull)
>> +#define PTE_LIST_DESC_BIT	0
>> +#define PTE_LIST_WP_BIT	1
>> +#define PTE_LIST_DESC		(1 << PTE_LIST_DESC_BIT)
>>  #define PTE_LIST_FLAG_MASK	(0x3ull)
>>
>>  static void
>> @@ -1067,6 +1069,12 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
>>  	return mmu_memory_cache_free_objects(cache);
>>  }
>>
>> +static void host_page_write_protect(u64 *spte, unsigned long *rmapp)
>> +{
>> +	if (!(*spte & SPTE_HOST_WRITEABLE))
>> +		__test_and_set_bit(PTE_LIST_WP_BIT, rmapp);
>> +}
>>
> 
> Why is this needed, in addition to spte.SPTE_WRITE_PROTECT?
> 


It is used to avoid the unnecessary overload for fast page fault if
KSM is enabled. On the fast check path, it can see the gfn is write-protected
by host, then the fast page fault path is not called.

