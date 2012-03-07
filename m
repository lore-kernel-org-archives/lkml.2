Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964986Ab2CGSFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:05:25 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50408 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab2CGSFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:05:23 -0500
MIME-Version: 1.0
In-Reply-To: <1331116250.3539.35.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	<tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	<CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
	<4F45B35D.1010702@zytor.com>
	<CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com>
	<4F471651.3080609@zytor.com>
	<4F4C3BA2.1070708@kernel.org>
	<1331116250.3539.35.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Wed, 7 Mar 2012 10:05:20 -0800
X-Google-Sender-Auth: TJm0GpmcfkjoqBwt1yJkud-dblo
Message-ID: <CAE9FiQUoRMA_PYnOEt0ZUYXLq=hNZtDuLifT=+R72HtrwfF6AA@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 2:30 AM, Matt Fleming <matt.fleming@intel.com> wrote:
> On Mon, 2012-02-27 at 18:27 -0800, H. Peter Anvin wrote:
>> On 02/23/2012 08:47 PM, H. Peter Anvin wrote:
>> >>
>> >> please check attach patch for tip/efi branch.
>> >
>> > That doesn't do anything like what I noted above.
>> >
>> > We should get rid of dependencies on legacy PC memory layouts, not add
>> > more hacks.  What is so hard about "when we create the initial mappings,
>> > only create for RAM/ACPI/EFI regions" (if we even need to do so for
>> > ACPI, I think ACPI might use ioremap() already)?
>> >
>>
>> Hi Yinghai,
>>
>> Can you please answer my question?
>
> Did you have something like this in mind? Note that it doesn't go all
> the way to removing the add_do_memmap boot parameter because I'm not
> sure how to do that for GPL exported symbols.
>
> The only testing I've done with this is to ensure that it boots under
> qemu (both for EFI and BIOS) on 32/64-bit.
>
> This is on top of tip/x86/efi.
>
> diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
> index bce688d..4f95f23 100644
> --- a/arch/x86/include/asm/page_types.h
> +++ b/arch/x86/include/asm/page_types.h
> @@ -51,8 +51,9 @@ static inline phys_addr_t get_max_mapped(void)
>        return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
>  }
>
> -extern unsigned long init_memory_mapping(unsigned long start,
> -                                        unsigned long end);
> +extern unsigned long init_memory_mapping(void);
> +extern unsigned long __init_memory_mapping(unsigned long start,
> +                                          unsigned long end);
>
>  extern void initmem_init(void);
>  extern void free_initmem(void);
> diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
> index b1e7c7f..f52ced2 100644
> --- a/arch/x86/kernel/amd_gart_64.c
> +++ b/arch/x86/kernel/amd_gart_64.c
> @@ -769,7 +769,7 @@ int __init gart_iommu_init(void)
>
>        if (end_pfn > max_low_pfn_mapped) {
>                start_pfn = (aper_base>>PAGE_SHIFT);
> -               init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
> +               __init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
>        }
>
>        pr_info("PCI-DMA: using GART IOMMU.\n");
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index e22bb08..b65d287 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -690,8 +690,6 @@ early_param("reservelow", parse_reservelow);
>
>  void __init setup_arch(char **cmdline_p)
>  {
> -       unsigned long end_pfn;
> -
>  #ifdef CONFIG_X86_32
>        memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
>        visws_early_detect();
> @@ -927,31 +925,11 @@ void __init setup_arch(char **cmdline_p)
>
>        init_gbpages();
>
> -       /* max_pfn_mapped is updated here */
> -       end_pfn = max_low_pfn;
> -
> -#ifdef CONFIG_X86_64
> -       /*
> -        * There may be regions after the last E820_RAM region that we
> -        * want to include in the kernel direct mapping because their
> -        * contents are needed at runtime.
> -        */
> -       if (efi_enabled) {
> -               unsigned long efi_end;
> -
> -               efi_end = e820_end_pfn(MAXMEM>>PAGE_SHIFT, E820_RESERVED_EFI);
> -               if (efi_end > end_pfn)
> -                       end_pfn = efi_end;
> -       }
> -#endif
> -
> -       max_low_pfn_mapped = init_memory_mapping(0, end_pfn << PAGE_SHIFT);
> -       max_pfn_mapped = max_low_pfn_mapped;
> +       /* max_low_pfn_mapped is updated here */
> +       max_pfn_mapped = init_memory_mapping();
>
>  #ifdef CONFIG_X86_64
>        if (max_pfn > max_low_pfn) {
> -               max_pfn_mapped = init_memory_mapping(1UL<<32,
> -                                                    max_pfn<<PAGE_SHIFT);
>                /* can we preseve max_low_pfn ?*/
>                max_low_pfn = max_pfn;
>        }

you may need to move those three lines before
max_pfn_mapped = init_memory_mapping()

otherwise for x86_64, memory from [4G, TOMH) will not be directly mapped.

Yinghai
