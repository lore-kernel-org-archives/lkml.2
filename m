Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1IUSqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:46:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47561 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1IUSqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:46:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: S4 resume broken since 2.6.39 (3.1, too)
Date: Wed, 21 Sep 2011 20:48:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, oneukum@suse.de, x86@kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
References: <s5hmxdzyyzx.wl%tiwai@suse.de>
In-Reply-To: <s5hmxdzyyzx.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109212048.23074.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, September 20, 2011, Takashi Iwai wrote:
> Hi,
> 
> during testing 3.0.4 kernels, I found that the S4 is broken in recent
> kernels since 2.6.39.  The symptom is that the machine suddenly
> reboots after the S4 resume image is read.  This happens only
> occasionally, usually within 10 or 20 S4 cycles.  The problem is still
> found in 3.1-rc6.

Well, this sounds like a serious regression to me.

> After a bisection, the likely culprit is:
>     commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e
>     Author: Yinghai Lu <yinghai@kernel.org>
>     Date:   Fri Dec 17 16:58:28 2010 -0800
> 
>     x86-64, mm: Put early page table high
>
> And the essential revert to fix the problem is like below.
> It reverts the memory assignment in the old way, and the diff of dmesg
> is something like:
> 
> @@ -49,10 +49,10 @@
>  Base memory trampoline at [ffff880000098000] 98000 size 20480
>  init_memory_mapping: 0000000000000000-000000007a000000
>   0000000000 - 007a000000 page 2M
> -kernel direct mapping tables up to 7a000000 @ 7913f000-79142000
> +kernel direct mapping tables up to 7a000000 @ 1fffd000-20000000
>  init_memory_mapping: 0000000100000000-0000000100600000
>   0100000000 - 0100600000 page 2M
> -kernel direct mapping tables up to 100600000 @ 1005fa000-100600000
> +kernel direct mapping tables up to 100600000 @ 7913c000-79142000
>  RAMDISK: 36d36000 - 37ff0000
>  ACPI: RSDP 00000000000f2f10 00024 (v02 HPQOEM)
>  ACPI: XSDT 0000000079ffe120 00094 (v01 HPQOEM SLIC-MPC 00000004      01000013)
> @@ -76,7 +76,7 @@
>  No NUMA configuration found
>  Faking a node at 0000000000000000-0000000100600000
>  Initmem setup node 0 0000000000000000-0000000100600000
> -  NODE_DATA [00000001005d3000 - 00000001005f9fff]
> +  NODE_DATA [00000001005d9000 - 00000001005fffff]
>   [ffffea0000000000-ffffea00039fffff] PMD -> [ffff880076a00000-ffff8800787fffff] on node 0
>  Zone PFN ranges:
>    DMA      0x00000010 -> 0x00001000
> 
> And S4 seems working more stably now.
> 
> I still have no idea why the commit above introduced the buggy
> behavior.  Through a quick look at the output above, the assigned
> areas look OK...
> 
> Can anyone give a deeper insight?
> 
> 
> thanks,
> 
> Takashi
> 
> ---
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 3032644..87488b9 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -63,9 +63,8 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
>  #ifdef CONFIG_X86_32
>  	/* for fixmap */
>  	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
> -
> -	good_end = max_pfn_mapped << PAGE_SHIFT;
>  #endif
> +	good_end = max_pfn_mapped << PAGE_SHIFT;
>  
>  	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
>  	if (base == MEMBLOCK_ERROR)

It looks like init_memory_mapping() is sometimes called with "end"
beyond the last mapped PFN and it explodes when we try to write stuff to
that address during image restoration.

IOW, the Yinghai's assumption that init_memory_mapping() would always be
called with a "good end" on x86_64 was overomptimistic.

Thanks,
Rafael
