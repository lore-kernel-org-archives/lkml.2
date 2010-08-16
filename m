Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0HPBn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 21:43:58 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48158 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab0HPBn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 21:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X9xg3N3RMoUjR3NJD8TNLlQ6i23oNrCVROcmgKVP8qrW2kRjCoUk75F5E3EL9l6uxR
         LSr+Uh28S0d+rupwQ+i8TalxodKASkn0J2PrS1Y+/TWi4kVpvnpQSiVa0x54L9OEntO8
         S++v/GsdbaJaeEaNSgck9cvaQ0y9hMlCeN9SY=
MIME-Version: 1.0
In-Reply-To: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
Date: Mon, 16 Aug 2010 09:43:56 +0800
Message-ID: <AANLkTimM0H0ryre3pXsXQ6c0e3=v_36-h0TsXzriMWXe@mail.gmail.com>
Subject: Re: [PATCH][EFI] Run EFI in physical mode
From: huang ying <huang.ying.caritas@gmail.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, vgoyal@redhat.com, nhorman@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 3:18 AM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
> diff -Nurp linux-2.6.35.org/arch/x86/kernel/efi_64.c linux-2.6.35/arch/x86/kernel/efi_64.c
> --- linux-2.6.35.org/arch/x86/kernel/efi_64.c   2010-08-01 18:11:14.000000000 -0400
> +++ linux-2.6.35/arch/x86/kernel/efi_64.c       2010-08-13 14:39:25.819105004 -0400
> @@ -39,7 +39,9 @@
>  #include <asm/fixmap.h>
>
>  static pgd_t save_pgd __initdata;
> -static unsigned long efi_flags __initdata;
> +static unsigned long efi_flags;
> +static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
> +static unsigned long save_cr3;
>
>  static void __init early_mapping_set_exec(unsigned long start,
>                                          unsigned long end,
> @@ -98,6 +100,19 @@ void __init efi_call_phys_epilog(void)
>        early_runtime_code_mapping_set_exec(0);
>  }
>
> +void efi_call_phys_prelog_in_physmode(void)
> +{
> +       local_irq_save(efi_flags);
> +       save_cr3 = read_cr3();
> +       write_cr3(virt_to_phys(efi_pgd));
> +}
> +
> +void efi_call_phys_epilog_in_physmode(void)
> +{
> +       write_cr3(save_cr3);
> +       local_irq_restore(efi_flags);
> +}

efi_flags and save_cr3 should be per-CPU, because they now will be
used after SMP is enabled.

efi_pgd should be dynamically allocated instead of statically
allocated, because EFI may be not enabled on some platform.

And I think it is better to unify early physical mode with run-time
physical mode. Just allocate the page table with early page allocator
(lmb?).

Best Regards,
Huang Ying
