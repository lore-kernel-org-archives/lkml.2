Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2EYIrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:47:48 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58853 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2EYIrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:47:43 -0400
Message-ID: <4FBF471E.9080809@linux.vnet.ibm.com>
Date: Fri, 25 May 2012 16:47:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: introduce readonly memory region
References: <4FBDFE52.5090902@linux.vnet.ibm.com> <4FBE2521.1050800@redhat.com>
In-Reply-To: <4FBE2521.1050800@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052422-5490-0000-0000-00000176A6FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 08:10 PM, Avi Kivity wrote:


>>  /* for kvm_memory_region::flags */
>> -#define KVM_MEM_LOG_DIRTY_PAGES  1UL
>> +#define KVM_MEM_LOG_DIRTY_PAGES		1UL
>> +#define KVM_MEM_READ_ONLY		(1UL << 2)
> 
> Bit 1 should be fine too, see below.


Okay.

> 
>>
>>  This ioctl allows the user to create or modify a guest physical memory
>>  slot.  When changing an existing slot, it may be moved in the guest
>> @@ -873,9 +874,11 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>>  be identical.  This allows large pages in the guest to be backed by large
>>  pages in the host.
>>
>> -The flags field supports just one flag, KVM_MEM_LOG_DIRTY_PAGES, which
>> +The flags field supports two flags, KVM_MEM_LOG_DIRTY_PAGES, which
>>  instructs kvm to keep track of writes to memory within the slot.  See
>> -the KVM_GET_DIRTY_LOG ioctl.
>> +the KVM_GET_DIRTY_LOG ioctl. Another flag is KVM_MEM_READ_ONLY, which
>> +indicates the guest memory is read-only, that means, guest is only allowed
>> +to read it.
> 
> + Writes will be posted to userspace as KVM_EXIT_MMIO exits.


Okay.

> 
>>
>>  /* for kvm_memory_region::flags */
>> -#define KVM_MEM_LOG_DIRTY_PAGES  1UL
>> -#define KVM_MEMSLOT_INVALID      (1UL << 1)
>> +#define KVM_MEM_LOG_DIRTY_PAGES		1UL
>> +#define KVM_MEMSLOT_INVALID		(1UL << 1)
>> +#define KVM_MEM_READ_ONLY		(1UL << 2)
> 
> KVM_MEMSLOT_INVALID is actually an internal symbol, not used by
> userspace.  Please move it to kvm_host.h.
> 
> I see that we don't check flags for validity.  Please add a check that
> we don't use undefined flags and return -EINVAL.  Should be a separate
> patch since we may want to backport it.
> 


Okay, will do.

> We need a KVM_CAP_ so userspace knows it can use the feature.  Only x86
> should respond to it now, until (or if) other archs are updated.
> 


Right.

>>
>> +static bool vma_is_avalid(struct vm_area_struct *vma, bool write_fault)
> 
> s/avalid/valid/.


Oops, thanks for you pointing it out.

> 
>> +{
>> +	if (write_fault) {
>> +		if (unlikely(!(vma->vm_flags & VM_WRITE)))
>> +			return false;
>> +
>> +		return true;
>> +	}
>> +
>> +	if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))))
>> +		return false;
>> +
> 
> Strange check.  VM_EXEC doesn't concern us at all.  Maybe we should
> check for VM_READ always, and VM_WRITE for write faults.
> 


I do not know if some process's vma only has VM_EXTC that hopes to
protect the text/stack section, and we want to map the text section
to guest for writing test case.

But i do not have strong opinion about it, since checking VM_READ
works fine for my test case.

I will remove the VM_EXEC in the next version.

>> +	return true;
>> +}
>> +
>>  static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
>>  			bool *async, bool write_fault, bool *writable)
>>  {
>> @@ -1076,7 +1103,6 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
>>
>>  		if (writable)
>>  			*writable = write_fault;
>> -
>>  		if (async) {
>>  			down_read(&current->mm->mmap_sem);
>>  			npages = get_user_page_nowait(current, current->mm,
>> @@ -1123,8 +1149,9 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
>>  				vma->vm_pgoff;
>>  			BUG_ON(!kvm_is_mmio_pfn(pfn));
>>  		} else {
>> -			if (async && (vma->vm_flags & VM_WRITE))
>> +			if (async && vma_is_avalid(vma, write_fault))
>>  				*async = true;
>> +
> 
> 
> This checks based on the fault type, not memslot type.  So we have the
> risk of the pfn later used for writes?
> 


Yes, but we can not export hva_to_pfn which is only allowed to be used in
kvm_main.c. (it is only the help function for gfn_to_pfn_*().)

>>  			pfn = get_fault_pfn();
>>  		}
>>  		up_read(&current->mm->mmap_sem);
>> @@ -1148,7 +1175,7 @@ static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic, bool *async,
>>  	if (async)
>>  		*async = false;
>>
>> -	addr = gfn_to_hva(kvm, gfn);
>> +	addr = gfn_to_hva_prot(kvm, gfn, write_fault);
>>  	if (kvm_is_error_hva(addr)) {
>>  		get_page(bad_page);
>>  		return page_to_pfn(bad_page);
>> @@ -1293,7 +1320,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>>  	int r;
>>  	unsigned long addr;
>>
>> -	addr = gfn_to_hva(kvm, gfn);
>> +	addr = gfn_to_hva_prot(kvm, gfn, false);
>>  	if (kvm_is_error_hva(addr))
>>  		return -EFAULT;
>>  	r = __copy_from_user(data, (void __user *)addr + offset, len);
>> @@ -1331,7 +1358,7 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
>>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>>  	int offset = offset_in_page(gpa);
>>
>> -	addr = gfn_to_hva(kvm, gfn);
>> +	addr = gfn_to_hva_prot(kvm, gfn, false);
>>  	if (kvm_is_error_hva(addr))
>>  		return -EFAULT;
>>  	pagefault_disable();
> 
> Surprised only those places.
> 
> How do we make sure a pfn obtained with write = false isn't later used
> for writing?


Ah, i think it is hard to ensure it.

May be we can introduce two APIs:
- gfn_to_pfn_read(), kvm_read_gfn()
- gfn_to_pfn_write(), kvm_write_pfn()

They should be paired together by the developer.

By the way, a foolish question, what is ROMD?  i did not find any explanation
on google.

