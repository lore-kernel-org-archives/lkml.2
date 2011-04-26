Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1DZAlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:41:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45650 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab1DZAk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=riXLXKm5404JQnR+4jSonG/8sPs8QPiiseVmpRAYU1LoGPfXfFHfzKkTbj1EbKjMsB
         veoqjxCC3DQQFTNd7QXL0tZ0RXFuWcmJHz+bhbg2hP5qhgcD1p1s4EGZLlQ3PMdnT388
         5L4dpUZi1lep9My4L7e/0m83EKMfAhAKN4yVc=
MIME-Version: 1.0
In-Reply-To: <1303745473.18763.9.camel@gandalf.stny.rr.com>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
	<1303728272-11408-4-git-send-email-leemgs1@gmail.com>
	<1303745473.18763.9.camel@gandalf.stny.rr.com>
Date: Tue, 26 Apr 2011 09:40:58 +0900
Message-ID: <BANLkTi=CHQ39hQZuvUdZ0z2OZxy2jksE_w@mail.gmail.com>
Subject: Re: [PATCH 3/4] munmap: kbuild menu for munmap interface
From: Geunsik Lim <leemgs1@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>, Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 12:31 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-04-25 at 19:44 +0900, Geunsik Lim wrote:
>> From: Geunsik Lim <geunsik.lim@samsung.com>
>>
>> Support kbuild menu to select memory unmap operation size
>> at build time.
>
> The subject and this line are not quite the same. The subject looks like
> it only modifies the kbuild options, not mm/memory.c as well. Please
> fix.
You are right. I will fix it.
>
>>
>> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
>> Acked-by: Hyunjin Choi <hj89.choi@samsung.com>
>> ---
>>  init/Kconfig |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  mm/memory.c  |   21 +++++++++++-----
>>  2 files changed, 84 insertions(+), 7 deletions(-)
>>
>
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -57,6 +57,7 @@
>>  #include <linux/swapops.h>
>>  #include <linux/elf.h>
>>  #include <linux/gfp.h>
>> +#include <linux/munmap_unit_size.h>
>>
>>  #include <asm/io.h>
>>  #include <asm/pgalloc.h>
>> @@ -1079,6 +1080,10 @@ static unsigned long unmap_page_range(struct mmu_gather *tlb,
>>                       (*zap_work)--;
>>                       continue;
>>               }
>> +#if 0
>> +printk("DEBUG:munmap step2,(%s:%d), unmap range = current(%lu) + \
>> +zap_work(%lu bytes) \n", current->comm, current->pid, addr, *zap_work);
>> +#endif
>
> No #if 0 debug printing in mainline.
Thank you for your advice.
>
>>               next = zap_pud_range(tlb, vma, pgd, addr, next,
>>                                               zap_work, details);
>>       } while (pgd++, addr = next, (addr != end && *zap_work > 0));
>> @@ -1088,12 +1093,10 @@ static unsigned long unmap_page_range(struct mmu_gather *tlb,
>>       return addr;
>>  }
>>
>> -#ifdef CONFIG_PREEMPT
>> -# define ZAP_BLOCK_SIZE      (8 * PAGE_SIZE)
>> -#else
>> -/* No preempt: go for improved straight-line efficiency */
>> -# define ZAP_BLOCK_SIZE      (1024 * PAGE_SIZE)
>> -#endif
>> +/* No preempt: go for improved straight-line efficiency
>> + * on PREEMPT(preemption mode) this is not a critical latency-path.
>> + */
>> +# define ZAP_BLOCK_SIZE        (munmap_unit_size * PAGE_SIZE)
>>
>>  /**
>>   * unmap_vmas - unmap a range of memory covered by a list of vma's
>> @@ -1133,7 +1136,11 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
>>       spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
>>       int fullmm = (*tlbp)->fullmm;
>>       struct mm_struct *mm = vma->vm_mm;
>> -
>> +#if 0
>> +printk("DEBUG:munmap step1,(%s:%d), unit=zap_work(%ld)/ZAP_BLOCK(%ld), \
>> +vma:[%8lu]=%lu-%lu \n", current->comm, current->pid, zap_work, ZAP_BLOCK_SIZE, \
>> +vma->vm_end - vma->vm_start, vma->vm_end, vma->vm_start);
>> +#endif
>
> Get rid of this too.
>
> Either have pr_debug(...) or nothing at all.
In fact, I wondered about this debug messages for just debugging. :)
Yes. I will remove this debug messages because it is not necessary
as you commented.
>
> -- Steve
>
>>       mmu_notifier_invalidate_range_start(mm, start_addr, end_addr);
>>       for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next) {
>>               unsigned long end;
>
>
>



-- 
Regards,
Geunsik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
