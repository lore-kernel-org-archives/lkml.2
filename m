Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab0DLLRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 07:17:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50851 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab0DLLRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 07:17:16 -0400
Message-ID: <4BC300A2.5050508@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 19:14:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM MMU: optimize synchronization shadow pages
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D481.9060101@cn.fujitsu.com> <4BC2DD1B.1030903@redhat.com>
In-Reply-To: <4BC2DD1B.1030903@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 04/12/2010 11:06 AM, Xiao Guangrong wrote:
>> - chain all unsync shadow pages then we can fetch them quickly
>> - flush local/remote tlb after all shadow page synced
>>
>> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |    1 +
>>   arch/x86/kvm/mmu.c              |   82
>> ++++++++++++++++++---------------------
>>   2 files changed, 39 insertions(+), 44 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h
>> b/arch/x86/include/asm/kvm_host.h
>> index d463bc6..ae543fb 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -207,6 +207,7 @@ struct kvm_mmu_page {
>>       #define MMU_PAGE_UNSYNC 0x2
>>       unsigned int flags;
>>       unsigned int unsync_children;
>> +    struct list_head unsync_link;
>>       union {
>>           u64 *parent_pte;               /* !multimapped */
>>           struct hlist_head parent_ptes; /* multimapped, kvm_pte_chain */
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 18eceb2..fcb6299 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -177,6 +177,8 @@ typedef int (*mmu_parent_walk_fn) (struct
>> kvm_mmu_page *sp, u64 *spte);
>>   static struct kmem_cache *pte_chain_cache;
>>   static struct kmem_cache *rmap_desc_cache;
>>   static struct kmem_cache *mmu_page_header_cache;
>> +static struct list_head unsync_mmu_page_list =
>> +            LIST_HEAD_INIT(unsync_mmu_page_list);
>>
>>    
> 
> Does this really need to be global?  Should be per guest.
> 

Ah... this patch need more cooking, i'll improve it... thanks for you point it out.

Xiao
