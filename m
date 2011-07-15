Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1GOPTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:19:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43011 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab1GOPTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:19:14 -0400
Message-ID: <4E205A63.90401@gmail.com>
Date: Fri, 15 Jul 2011 11:18:59 -0400
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: benh@kernel.crashing.org, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, dhowells@redhat.com, cmetcalf@tilera.com,
        tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com> <1310725418.2586.309.camel@twins>
In-Reply-To: <1310725418.2586.309.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 06:23 AM, Peter Zijlstra wrote:
> On Fri, 2011-07-15 at 16:07 +0800, Shan Hai wrote:
>> The kernel has no write permission on COW pages by default on e500 core, this
>> will cause endless loop in futex_lock_pi, because futex code assumes the kernel
>> has write permission on COW pages. Grant write permission to the kernel on COW
>> pages when access violation page fault occurs.
>>
>> Signed-off-by: Shan Hai<haishan.bai@gmail.com>
>> ---
>>   arch/powerpc/include/asm/futex.h |   11 ++++++++++-
>>   arch/powerpc/include/asm/tlb.h   |   25 +++++++++++++++++++++++++
>>   2 files changed, 35 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/futex.h b/arch/powerpc/include/asm/futex.h
>> index c94e4a3..54c3e74 100644
>> --- a/arch/powerpc/include/asm/futex.h
>> +++ b/arch/powerpc/include/asm/futex.h
>> @@ -8,6 +8,7 @@
>>   #include<asm/errno.h>
>>   #include<asm/synch.h>
>>   #include<asm/asm-compat.h>
>> +#include<asm/tlb.h>
>>
>>   #define __futex_atomic_op(insn, ret, oldval, uaddr, oparg) \
>>     __asm__ __volatile ( \
>> @@ -113,7 +114,15 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
>>           : "cc", "memory");
>>
>>   	*uval = prev;
>> -        return ret;
>> +
>> +	/* Futex assumes the kernel has permission to write to
>> +	 * COW pages, grant the kernel write permission on COW
>> +	 * pages because it has none by default.
>> +	 */
>> +	if (ret == -EFAULT)
>> +		__tlb_fixup_write_permission(current->mm, (unsigned long)uaddr);
>> +
>> +	return ret;
>>   }
>>
>>   #endif /* __KERNEL__ */
>> diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/asm/tlb.h
>> index e2b428b..3863c6a 100644
>> --- a/arch/powerpc/include/asm/tlb.h
>> +++ b/arch/powerpc/include/asm/tlb.h
>> @@ -45,5 +45,30 @@ static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep,
>>   #endif
>>   }
>>
>> +/* Grant write permission to the kernel on a page. */
>> +static inline void __tlb_fixup_write_permission(struct mm_struct *mm,
>> +						unsigned long address)
>> +{
>> +#if defined(CONFIG_FSL_BOOKE)
>> +	/* Grant write permission to the kernel on a page by setting TLB.SW
>> +	 * bit, the bit setting operation is tricky here, calling
>> +	 * handle_mm_fault with FAULT_FLAG_WRITE causes _PAGE_DIRTY bit of
>> +	 * the pte to be set, the _PAGE_DIRTY of the pte is translated into
>> +	 * TLB.SW on Powerpc e500 core.
>> +	 */
>> +
>> +	struct vm_area_struct *vma;
>> +
>> +	vma = find_vma(mm, address);
> Uhm, find_vma() needs mmap_sem, and futex_atomic_cmpxchg_inatomic() is
> most certainly not called with that lock held.
>

My fault, that will be fixed in the V2 patch.

>> +	if (likely(vma)) {
>> +		/* only fixup present page */
>> +		if (follow_page(vma, address, FOLL_WRITE)) {
>> +			handle_mm_fault(mm, vma, address, FAULT_FLAG_WRITE);
> So how can this toggle your sw dirty/young tracking, that's pretty much
> what gup(.write=1) does too!
>

because of the kernel read only permission of the page is transparent
to the follow_page(),  the handle_mm_fault() is not to be activated
in the __get_use_pages(), so the gup(.write=1) could not help to fixup
the write permission.


Thanks
Shan Hai

>> +			flush_tlb_page(vma, address);
>> +		}
>> +	}
>> +#endif
>> +}
>> +
>>   #endif /* __KERNEL__ */
>>   #endif /* __ASM_POWERPC_TLB_H */

