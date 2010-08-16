Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0HPD3n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 23:29:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43281 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab0HPD3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 23:29:42 -0400
X-User-Agent: K-9 Mail for Android
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com> <AANLkTimM0H0ryre3pXsXQ6c0e3=v_36-h0TsXzriMWXe@mail.gmail.com>
In-Reply-To: <AANLkTimM0H0ryre3pXsXQ6c0e3=v_36-h0TsXzriMWXe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][EFI] Run EFI in physical mode
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 15 Aug 2010 20:27:49 -0700
To: huang ying <huang.ying.caritas@gmail.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, tglx@linutronix.de, mingo@redhat.com,
        vgoyal@redhat.com, nhorman@tuxdriver.com
Message-ID: <faf83501-1e53-459d-88ed-2ac5963a37f2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, it should not be dynamic; rather we should unify all the users who need a 1:1 map and just keep that page table set around.

"huang ying" <huang.ying.caritas@gmail.com> wrote:

>On Sat, Aug 14, 2010 at 3:18 AM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
>> diff -Nurp linux-2.6.35.org/arch/x86/kernel/efi_64.c linux-2.6.35/arch/x86/kernel/efi_64.c
>> --- linux-2.6.35.org/arch/x86/kernel/efi_64.c   2010-08-01 18:11:14.000000000 -0400
>> +++ linux-2.6.35/arch/x86/kernel/efi_64.c       2010-08-13 14:39:25.819105004 -0400
>> @@ -39,7 +39,9 @@
>>  #include <asm/fixmap.h>
>>
>>  static pgd_t save_pgd __initdata;
>> -static unsigned long efi_flags __initdata;
>> +static unsigned long efi_flags;
>> +static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
>> +static unsigned long save_cr3;
>>
>>  static void __init early_mapping_set_exec(unsigned long start,
>>                                          unsigned long end,
>> @@ -98,6 +100,19 @@ void __init efi_call_phys_epilog(void)
>>        early_runtime_code_mapping_set_exec(0);
>>  }
>>
>> +void efi_call_phys_prelog_in_physmode(void)
>> +{
>> +       local_irq_save(efi_flags);
>> +       save_cr3 = read_cr3();
>> +       write_cr3(virt_to_phys(efi_pgd));
>> +}
>> +
>> +void efi_call_phys_epilog_in_physmode(void)
>> +{
>> +       write_cr3(save_cr3);
>> +       local_irq_restore(efi_flags);
>> +}
>
>efi_flags and save_cr3 should be per-CPU, because they now will be
>used after SMP is enabled.
>
>efi_pgd should be dynamically allocated instead of statically
>allocated, because EFI may be not enabled on some platform.
>
>And I think it is better to unify early physical mode with run-time
>physical mode. Just allocate the page table with early page allocator
>(lmb?).
>
>Best Regards,
>Huang Ying
>

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
