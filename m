Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0JNAKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:10:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:52036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab0JNAKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:10:23 -0400
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4F11F.4090104@goop.org> <4CB54640.4000003@kernel.org> <4CB5DEE8.2020400@goop.org> <4CB5F86C.9030900@zytor.com> <4CB6107F.4080908@goop.org> <4CB62D54.7000400@kernel.org> <4CB63D63.5040500@goop.org> <4CB63E57.2000300@zytor.com> <4CB641F7.9040103@goop.org>
In-Reply-To: <4CB641F7.9040103@goop.org>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <3149FE7E-AE5A-496D-8D54-03224C105015@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
X-Mailer: iPhone Mail (8B117)
From: Yinghai <yinghai@kernel.org>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
Date: Wed, 13 Oct 2010 17:08:18 -0700
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Thu, 14 Oct 2010 00:09:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Oct 13, 2010, at 4:34 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 10/13/2010 04:18 PM, H. Peter Anvin wrote:
>> On 10/13/2010 04:14 PM, Jeremy Fitzhardinge wrote:
>>> The Xen code is setting the max_pfn_mapped correctly, but it is just
>>> being overridden by:
>>> 
>>>    max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
>>> 
>>> in setup_arch() - and KERNEL_IMAGE_SIZE is hard-coded to 512MB...
>>> 
>>> How is this correct?  Does kernel/head_64.S map everything up to 512MB
>>> or something?
>>> 
>> Yes:
>>        /*
>>         * 512 MB kernel mapping. We spend a full page on this pagetable
>>         * anyway.
>>         *
>>         * The kernel code+data+bss must not be bigger than that.
>>         *
>>         * (NOTE: at +512MB starts the module area, see MODULES_VADDR.
>>         *  If you want to increase this then increase MODULES_VADDR
>>         *  too.)
>>         */
>>        PMDS(0, __PAGE_KERNEL_LARGE_EXEC,
>>                KERNEL_IMAGE_SIZE/PMD_SIZE)
>> 
>> This is, however, wrong in the sense that it obviously shouldn't be
>> getting executed on the Xen codepath.
> 
> I see.  head_32.S sets max_pfn_mapped for itself, so head_64.S should
> probably do that too.  Patch below, but I haven't checked to see if it
> fixes the original problem (but I don't see why the pagetable memory
> allocation should be limited to the mapped region, especially if you
> want to put it as high as possible, especially since the mm/init_64.c
> code doesn't expect it to be mapped).
> 
>    J
> 
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Date: Wed, 13 Oct 2010 16:31:11 -0700
> Subject: [PATCH] x86-64: don't force max_pfn_mapped to 512MB
> 
> head_64.S maps up to 512MB, but the Xen entry path doesn't necessarily
> map that high.  Set max_pfn_mapped in head_64.S accordingly.  (The Xen
> code already sets max_pfn_mapped correctly.)
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 239046b..b75c6f4 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -141,6 +141,8 @@ ident_complete:
>    addq    %rbp, trampoline_level4_pgt + (511*8)(%rip)
> #endif
> 
> +    movq    $KERNEL_IMAGE_SIZE / PAGE_SIZE, max_pfn_mapped(%rip)
> +
>    /* Due to ENTRY(), sometimes the empty space gets filled with
>     * zeros. Better take a jmp than relying on empty space being
>     * filled with 0x90 (nop)
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index b11a238..c3cebfe 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -932,7 +932,6 @@ void __init setup_arch(char **cmdline_p)
>        max_low_pfn = max_pfn;
> 
>    high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> -    max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
> #endif
> 
>    /*
> 

I like this one, can you check if only this one is needed ?

Thanks

Yinghai
