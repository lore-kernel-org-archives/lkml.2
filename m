Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2LLSxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:53:43 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:39853 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2LLSxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:53:42 -0500
Message-ID: <50C8D2AD.4030707@linux.vnet.ibm.com>
Date: Thu, 13 Dec 2012 02:53:33 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] KVM: MMU: move adjusting pte access for softmmu
 to FNAME(page_fault)
References: <50C5A747.1020105@linux.vnet.ibm.com> <50C5A774.1050601@linux.vnet.ibm.com> <20121211234751.GB14520@amt.cnet>
In-Reply-To: <20121211234751.GB14520@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121218-6102-0000-0000-000002B4B974
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 07:47 AM, Marcelo Tosatti wrote:

>> +	if (write_fault && !(walker.pte_access & ACC_WRITE_MASK) &&
>> +		  !is_write_protection(vcpu) && !user_fault) {
>> +		walker.pte_access |= ACC_WRITE_MASK;
>> +		walker.pte_access &= ~ACC_USER_MASK;
>> +
>> +		/*
>> +		 * If we converted a user page to a kernel page,
>> +		 * so that the kernel can write to it when cr0.wp=0,
>> +		 * then we should prevent the kernel from executing it
>> +		 * if SMEP is enabled.
>> +		 */
>> +		if (kvm_read_cr4_bits(vcpu, X86_CR4_SMEP))
>> +			walker.pte_access &= ~ACC_EXEC_MASK;
>> +	}
> 
> Don't think you should modify walker.pte_access here, since it can be
> used afterwards (eg for handle_abnormal_pfn). 

Yes, you're right. It will cache !U+W instead of U+!W into mmio spte.
It causes the mmio access from userspace always fail. I will recheck it
carefully.

Hmm, the current code seems buggy if CR0.WP = 0. Say if two mappings
map to the same gfn, both of them use large page and small page size
is used on kvm. If guest write fault on the first mapping, kvm will
create a writable spte(!U + W) in the readonly sp
(sp.role.access = readonly). Then, read fault on the second mapping,
it will establish shadow page table by using the readonly sp which is
created by first mapping, so the second mapping has writable spte
even if Dirty bit in the second mapping is not set.

> 
> BTW, your patch is fixing a bug: 
> 
> host_writable is ignored for CR0.WP emulation:
> 
>         if (host_writable)
>                 spte |= SPTE_HOST_WRITEABLE;
>         else
>                 pte_access &= ~ACC_WRITE_MASK;
> 
>         spte |= (u64)pfn << PAGE_SHIFT;
> 
>         if ((pte_access & ACC_WRITE_MASK)
>             || (!vcpu->arch.mmu.direct_map && write_fault
>                 && !is_write_protection(vcpu) && !user_fault)) {

I noticed it too but it is not a bug, because the access is adjusted only
if it is a write fault. For the write #PF, the pfn is always writeable on
host.


