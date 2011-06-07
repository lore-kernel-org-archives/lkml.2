Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1FGIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:25:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62659 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1FGIZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=seX2muQeJbiPMnUd2SaDmIjzmmuft/HV8lA1YPJeI92CHTPjXGFrTyL5cItsm0Pjd8
         ws5a6IzZFk/mkUVUxFvxPTuj8Sg8P4NaCh7JMuYM/Em8ATHStOJFe7/+ehMvUaL1ZydI
         fG5WcGSydsRLA3B6UGO2qdiAJMbLXL/XuB//M=
Message-ID: <4DEDE071.4020401@gmail.com>
Date: Tue, 07 Jun 2011 10:25:21 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com> <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com> <4CE1968D.3050706@xs4all.nl> <4DE8DC16.6030308@xs4all.nl> <20110603133351.GA25130@srcf.ucam.org> <4DE8EF13.9030609@xs4all.nl> <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com> <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org>
In-Reply-To: <4DED8752.5070005@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Op 07-06-11 04:05, Yinghai Lu schreef:
> On 06/06/2011 06:41 PM, Matthew Garrett wrote:
>> On Mon, Jun 06, 2011 at 05:19:17PM -0700, Yinghai Lu wrote:
>>
>>> assume EFI in ram is not page-aligned?
>> They'll be 4K aligned at least.
>>
>
> can you get boot log with "memblock=debug"?
>
> wonder if 
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 4be9b39..c6724e4 100644 (file)
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -912,6 +912,13 @@ void __init setup_arch(char **cmdline_p)
>         memblock.current_limit = get_max_mapped();
>         memblock_x86_fill();
>  
> +       /*
> +        * The EFI specification says that boot service code won't be called
> +        * after ExitBootServices(). This is, in fact, a lie.
> +        */
> +       if (efi_enabled)
> +               efi_reserve_boot_services(
>
> wonder if double memblock ram array in memblock_x86_fill() that is overlapping with boot services.
Seems that numa's NODE_DATA beats the boot services to reserving the boot block, and it's already being reserved. Kinda makes my previous patch miss the point. :-)

Is moving efi_reserve_boot_memory to inside efi_init(); allowed?

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc1-patser+ (mlankhorst@patser.local) (gcc version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu4) ) #27 SMP PREEMPT Tue Jun 7 09:49:18 CEST 2011
[    0.000000] Command line: ro rootflags=ssd,discard root=/dev/sdb2 devtmpfs.mount=1 video=efifb reboot=a,e,p init=/init quiet splash vt.handoff=7 memblock=debug
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000100 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000befa5000 (usable)
[    0.000000]  BIOS-e820: 00000000befa5000 - 00000000bf2c0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf2c0000 - 00000000bf311000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf311000 - 00000000bf60c000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf60c000 - 00000000bf60d000 (usable)
[    0.000000]  BIOS-e820: 00000000bf60d000 - 00000000bf60e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf60e000 - 00000000bf618000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf618000 - 00000000bf63d000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf63d000 - 00000000bf680000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf680000 - 00000000bf800000 (usable)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed40000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000023f800000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x23f800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 base 23F800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fcf50] fcf50
[    0.000000]     memblock_x86_reserve_range: [0x000fcf50-0x000fcf5f]   * MP-table mpf
[    0.000000]     memblock_x86_reserve_range: [0x000fcbf0-0x000fced3]   * MP-table mpc
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x1fe8b6000
[    0.000000]  memory.cnt  = 0x5
[    0.000000]  memory[0x0]    [0x00000000010000-0x0000000009ffff], 0x90000 bytes
[    0.000000]  memory[0x1]    [0x00000000100000-0x000000befa4fff], 0xbeea5000 bytes
[    0.000000]  memory[0x2]    [0x000000bf60c000-0x000000bf60cfff], 0x1000 bytes
[    0.000000]  memory[0x3]    [0x000000bf680000-0x000000bf7fffff], 0x180000 bytes
[    0.000000]  memory[0x4]    [0x00000100000000-0x0000023f7fffff], 0x13f800000 bytes
[    0.000000]  reserved.cnt  = 0x2
[    0.000000]  reserved[0x0]    [0x0000000009d800-0x000000000fffff], 0x62800 bytes
[    0.000000]  reserved[0x1]    [0x00000001000000-0x00000001c67fff], 0xc68000 bytes
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000]     memblock_x86_reserve_range: [0x00098000-0x0009cfff]       TRAMPOLINE
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
[    0.000000]  0000000000 - 00bf800000 page 2M
[    0.000000] kernel direct mapping tables up to bf800000 @ bf7fc000-bf800000
[    0.000000]     memblock_x86_reserve_range: [0xbf7fc000-0xbf7fdfff]          PGTABLE
[    0.000000] init_memory_mapping: 0000000100000000-000000023f800000
[    0.000000]  0100000000 - 023f800000 page 2M
[    0.000000] kernel direct mapping tables up to 23f800000 @ 23f7f6000-23f800000
[    0.000000]     memblock_x86_reserve_range: [0x23f7f6000-0x23f7fafff]          PGTABLE
[    0.000000] ACPI: RSDP 00000000000fcf60 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000bf309070 0005C (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000bf310048 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000bf309158 06EED (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf60ff80 00040
[    0.000000] ACPI: APIC 00000000bf310140 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000bf3101b8 00102 (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000bf3102c0 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
[    0.000000] ACPI: AAFT 00000000bf310300 0006F (v01 ALASKA OEMAAFT  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf310370 00038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
[    0.000000] ACPI: DMAR 00000000bf3103a8 000B0 (v01 ALASKA    A M I 00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000023f800000
[    0.000000] Initmem setup node 0 0000000000000000-000000023f800000
[    0.000000]     memblock_x86_reserve_range: [0x23f7fb000-0x23f7fffff]        NODE_DATA
[    0.000000]   NODE_DATA [000000023f7fb000 - 000000023f7fffff]
[    0.000000]     memblock_x86_reserve_range: [0x23f7f5000-0x23f7f5fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x23f3f5000-0x23f7f4fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x23f3f4a00-0x23f3f4fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x23eff4a00-0x23f3f49ff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x236e00000-0x23edfffff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x23eff3000-0x23eff3fff]          BOOTMEM
[    0.000000]     memblock_x86_reserve_range: [0x23eff2000-0x23eff2fff]          BOOTMEM
[    0.000000]        memblock_x86_free_range: [0x23de00000-0x23edfffff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880236e00000-ffff88023ddfffff] on node 0
[    0.000000]        memblock_x86_free_range: [0x23eff4a00-0x23f3f49ff]
[    0.000000]        memblock_x86_free_range: [0x23f3f5000-0x23f7f4fff]

~Maarten
