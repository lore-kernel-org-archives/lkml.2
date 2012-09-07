Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab2IGKrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 06:47:18 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:59707 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab2IGKrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 06:47:15 -0400
Message-ID: <5049D0AA.2060202@linux.vnet.ibm.com>
Date: Fri, 07 Sep 2012 18:47:06 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 11/12] KVM: introduce readonly memslot
References: <5032F8FD.2020306@linux.vnet.ibm.com> <5032FA5B.5040308@linux.vnet.ibm.com> <5049CB36.4080000@siemens.com>
In-Reply-To: <5049CB36.4080000@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12090710-9264-0000-0000-0000024A6299
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 06:23 PM, Jan Kiszka wrote:
> On 2012-08-21 05:02, Xiao Guangrong wrote:
>> In current code, if we map a readonly memory space from host to guest
>> and the page is not currently mapped in the host, we will get a fault
>> pfn and async is not allowed, then the vm will crash
>>
>> We introduce readonly memory region to map ROM/ROMD to the guest, read access
>> is happy for readonly memslot, write access on readonly memslot will cause
>> KVM_EXIT_MMIO exit
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  Documentation/virtual/kvm/api.txt |   10 +++-
>>  arch/x86/include/asm/kvm.h        |    1 +
>>  arch/x86/kvm/mmu.c                |    9 ++++
>>  arch/x86/kvm/x86.c                |    1 +
>>  include/linux/kvm.h               |    6 ++-
>>  include/linux/kvm_host.h          |    7 +--
>>  virt/kvm/kvm_main.c               |   96 ++++++++++++++++++++++++++++++-------
>>  7 files changed, 102 insertions(+), 28 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index bf33aaa..b91bfd4 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -857,7 +857,8 @@ struct kvm_userspace_memory_region {
>>  };
>>
>>  /* for kvm_memory_region::flags */
>> -#define KVM_MEM_LOG_DIRTY_PAGES  1UL
>> +#define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>> +#define KVM_MEM_READONLY	(1UL << 1)
>>
>>  This ioctl allows the user to create or modify a guest physical memory
>>  slot.  When changing an existing slot, it may be moved in the guest
>> @@ -873,9 +874,12 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>>  be identical.  This allows large pages in the guest to be backed by large
>>  pages in the host.
>>
>> -The flags field supports just one flag, KVM_MEM_LOG_DIRTY_PAGES, which
>> +The flags field supports two flag, KVM_MEM_LOG_DIRTY_PAGES, which
>>  instructs kvm to keep track of writes to memory within the slot.  See
>> -the KVM_GET_DIRTY_LOG ioctl.
>> +the KVM_GET_DIRTY_LOG ioctl. Another flag is KVM_MEM_READONLY when the
>> +KVM_CAP_READONLY_MEM capability, it indicates the guest memory is read-only,
>> +that means, guest is only allowed to read it.
> 
> The last sentence requires some refactoring. :) How about: "The
> KVM_CAP_READONLY_MEM capability indicates the availability of the
> KVM_MEM_READONLY flag. When this flag is set for a memory region, KVM
> only allows read accesses."

Undoubtedly, your sentence is far better than mine. :)

By the way, this patchset has been applied on kvm -next branch, would
you mind to post a patch to do these works.

> 
>> Writes will be posted to
>> +userspace as KVM_EXIT_MMIO exits.
>>
>>  When the KVM_CAP_SYNC_MMU capability, changes in the backing of the memory
>>  region are automatically reflected into the guest.  For example, an mmap()
>> diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
>> index 246617e..521bf25 100644
>> --- a/arch/x86/include/asm/kvm.h
>> +++ b/arch/x86/include/asm/kvm.h
>> @@ -25,6 +25,7 @@
>>  #define __KVM_HAVE_DEBUGREGS
>>  #define __KVM_HAVE_XSAVE
>>  #define __KVM_HAVE_XCRS
>> +#define __KVM_HAVE_READONLY_MEM
>>
>>  /* Architectural interrupt line count. */
>>  #define KVM_NR_INTERRUPTS 256
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 5548971..8e312a2 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -2647,6 +2647,15 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
>>
>>  static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, pfn_t pfn)
>>  {
>> +	/*
>> +	 * Do not cache the mmio info caused by writing the readonly gfn
>> +	 * into the spte otherwise read access on readonly gfn also can
>> +	 * caused mmio page fault and treat it as mmio access.
>> +	 * Return 1 to tell kvm to emulate it.
>> +	 */
>> +	if (pfn == KVM_PFN_ERR_RO_FAULT)
>> +		return 1;
>> +
>>  	if (pfn == KVM_PFN_ERR_HWPOISON) {
>>  		kvm_send_hwpoison_signal(gfn_to_hva(vcpu->kvm, gfn), current);
>>  		return 0;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 704680d..42bbf41 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2175,6 +2175,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>>  	case KVM_CAP_GET_TSC_KHZ:
>>  	case KVM_CAP_PCI_2_3:
>>  	case KVM_CAP_KVMCLOCK_CTRL:
>> +	case KVM_CAP_READONLY_MEM:
>>  		r = 1;
>>  		break;
>>  	case KVM_CAP_COALESCED_MMIO:
>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>> index 2de335d..d808694 100644
>> --- a/include/linux/kvm.h
>> +++ b/include/linux/kvm.h
>> @@ -106,7 +106,8 @@ struct kvm_userspace_memory_region {
>>   * other bits are reserved for kvm internal use which are defined in
>>   * include/linux/kvm_host.h.
>>   */
>> -#define KVM_MEM_LOG_DIRTY_PAGES  1UL
>> +#define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>> +#define KVM_MEM_READONLY	(1UL << 1)
>>
>>  /* for KVM_IRQ_LINE */
>>  struct kvm_irq_level {
>> @@ -621,6 +622,9 @@ struct kvm_ppc_smmu_info {
>>  #define KVM_CAP_PPC_GET_SMMU_INFO 78
>>  #define KVM_CAP_S390_COW 79
>>  #define KVM_CAP_PPC_ALLOC_HTAB 80
>> +#ifdef __KVM_HAVE_READONLY_MEM
>> +#define KVM_CAP_READONLY_MEM 81
>> +#endif
> 
> See the discussion on the userspace patches: The CAP, as userspace API,
> should really be defined unconditionally, kernel code should depend on
> __KVM_HAVE_READONLY_MEM or a to-be-introduced CONFIG_KVM_HAVE_xxx
> switch. This allows for cleaner userspace code.

I see that using __KVM_HAVE_  around CAP in kvm.h is very popular:

$ grep __KVM_HAVE include/linux/kvm.h | wc -l
20

As your suggestion, userspace will always use the CAP even if the CAP
is not really supported. We do not need care the overload on other arches?

