Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab2BWCUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 21:20:04 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39224 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2BWCUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 21:20:01 -0500
MIME-Version: 1.0
In-Reply-To: <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	<tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
Date: Wed, 22 Feb 2012 18:20:01 -0800
X-Google-Sender-Auth: 80tXOEpfwoiNNhvfQKDebtbOclM
Message-ID: <CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Yinghai Lu <yinghai@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        matt.fleming@intel.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 5:16 PM, tip-bot for Matt Fleming
<matt.fleming@intel.com> wrote:
> Commit-ID:  f75bd1837564657b21431e44243e064a77276589
> Gitweb:     http://git.kernel.org/tip/f75bd1837564657b21431e44243e064a77276589
> Author:     Matt Fleming <matt.fleming@intel.com>
> AuthorDate: Mon, 20 Feb 2012 13:30:26 +0000
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Wed, 22 Feb 2012 14:49:55 -0800
>
> x86, efi: Delete efi_ioremap() and fix CONFIG_X86_32 oops
>
...
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index d7d5099..e22bb08 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -690,6 +690,8 @@ early_param("reservelow", parse_reservelow);
>
>  void __init setup_arch(char **cmdline_p)
>  {
> +       unsigned long end_pfn;
> +
>  #ifdef CONFIG_X86_32
>        memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
>        visws_early_detect();
> @@ -926,7 +928,24 @@ void __init setup_arch(char **cmdline_p)
>        init_gbpages();
>
>        /* max_pfn_mapped is updated here */
> -       max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
> +       end_pfn = max_low_pfn;
> +
> +#ifdef CONFIG_X86_64
> +       /*
> +        * There may be regions after the last E820_RAM region that we
> +        * want to include in the kernel direct mapping because their
> +        * contents are needed at runtime.
> +        */
> +       if (efi_enabled) {
> +               unsigned long efi_end;
> +
> +               efi_end = e820_end_pfn(MAXMEM>>PAGE_SHIFT, E820_RESERVED_EFI);

> +               if (efi_end > end_pfn)
> +                       end_pfn = efi_end;
> +       }
> +#endif
> +
> +       max_low_pfn_mapped = init_memory_mapping(0, end_pfn << PAGE_SHIFT);


Why is MAXMEM used here?

EFI reserved area could be above 4G?

if that is the case, you will map all mmio hole below 4g.

        Yinghai
