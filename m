Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab1GSRcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 13:32:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51781 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1GSRcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 13:32:05 -0400
MIME-Version: 1.0
In-Reply-To: <4E257E33020000780004E319@nat28.tlf.novell.com>
References: <4E257E33020000780004E319@nat28.tlf.novell.com>
Date: Tue, 19 Jul 2011 23:32:05 +0600
Message-ID: <CADZ9YHiBkfcM3jjjJVh_Ydn+uJxjYM6SnDZ=5J3Mmki7fp3NbQ@mail.gmail.com>
Subject: Re: [PATCH] x86: serialize EFI time accesses on rtc_lock
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 4:53 PM, Jan Beulich <JBeulich@novell.com> wrote:
> The EFI specification requires that callers of the time related runtime
> functions serialize with other CMOS accesses in the kernel, as the EFI
> time functions may choose to also use the legacy CMOS RTC.
>
> Besides fixing a latent bug, this is a prerequisite to safely enable
> the rtc-efi driver for x86, which ought to be preferred over rtc-cmos
> on all EFI platforms.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Matthew Garrett <mjg@redhat.com>
>
> ---
>  arch/x86/platform/efi/efi.c |   39 +++++++++++++++++++++++++++++++++------
>  1 file changed, 33 insertions(+), 6 deletions(-)
>
> --- 3.0-rc7/arch/x86/platform/efi/efi.c
> +++ 3.0-rc7-x86-rtc-lock-EFI/arch/x86/platform/efi/efi.c
> @@ -79,26 +79,50 @@ early_param("add_efi_memmap", setup_add_
>
>  static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
>  {
> -       return efi_call_virt2(get_time, tm, tc);
> +       unsigned long flags;
> +       efi_status_t status;
> +
> +       spin_lock_irqsave(&rtc_lock, flags);
> +       status = efi_call_virt2(get_time, tm, tc);
> +       spin_unlock_irqrestore(&rtc_lock, flags);
> +       return status;
>  }
>
>  static efi_status_t virt_efi_set_time(efi_time_t *tm)
>  {
> -       return efi_call_virt1(set_time, tm);
> +       unsigned long flags;
> +       efi_status_t status;
> +
> +       spin_lock_irqsave(&rtc_lock, flags);
> +       status = efi_call_virt1(set_time, tm);
> +       spin_unlock_irqrestore(&rtc_lock, flags);
> +       return status;
>  }
>
>  static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
>                                             efi_bool_t *pending,
>                                             efi_time_t *tm)
>  {
> -       return efi_call_virt3(get_wakeup_time,
> -                             enabled, pending, tm);
> +       unsigned long flags;
> +       efi_status_t status;
> +
> +       spin_lock_irqsave(&rtc_lock, flags);
> +       status = efi_call_virt3(get_wakeup_time,
> +                               enabled, pending, tm);
> +       spin_unlock_irqrestore(&rtc_lock, flags);
> +       return status;
>  }
>
>  static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
>  {
> -       return efi_call_virt2(set_wakeup_time,
> -                             enabled, tm);
> +       unsigned long flags;
> +       efi_status_t status;
> +
> +       spin_lock_irqsave(&rtc_lock, flags);
> +       status = efi_call_virt2(set_wakeup_time,
> +                               enabled, tm);
> +       spin_unlock_irqrestore(&rtc_lock, flags);
> +       return status;
>  }
>
>  static efi_status_t virt_efi_get_variable(efi_char16_t *name,
> @@ -164,11 +188,14 @@ static efi_status_t __init phys_efi_set_
>  static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
>                                             efi_time_cap_t *tc)
>  {
> +       unsigned long flags;
>        efi_status_t status;
>
> +       spin_lock_irqsave(&rtc_lock, flags);
>        efi_call_phys_prelog();
>        status = efi_call_phys2(efi_phys.get_time, tm, tc);
>        efi_call_phys_epilog();
> +       spin_unlock_irqrestore(&rtc_lock, flags);
>        return status;
>  }
>
If I'm not missing anything, this implementation (serialization) could
be simpler by holding rtc_lock at the time of calling those functions.
I mean, holding rtc_lock before calling EFI services
virt_efi_get/set_time and virt_efi_get/set_wakeup_time - something
like below:

             spin_lock_irqsave(&rtc_lock, flags);
             efi.get_time = virt_efi_get_time;
             efi.set_time = virt_efi_set_time;
             efi.get_wakeup_time = virt_efi_get_wakeup_time;
             efi.set_wakeup_time = virt_efi_set_wakeup_time;
            spin_unlock_irqrestore(&rtc_lock, flags);


Thanks,
Rakib
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
