Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab2HDGQB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 02:16:01 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38022 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2HDGP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 02:15:59 -0400
Date: Sat, 4 Aug 2012 02:15:56 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, linux@arm.linux.org.uk,
        will.deacon@arm.com
Subject: Re: [PATCH 02/22] ARM: use late patch framework for phys-virt
 patching
In-Reply-To: <1343775898-28345-3-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208040138560.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-3-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Cyril Chemparathy wrote:

> This patch replaces the original physical offset patching implementation
> with one that uses the newly added patching framework.  In the process, we now
> unconditionally initialize the __pv_phys_offset and __pv_offset globals in the
> head.S code.

Why unconditionally initializing those?  There is no reason for that.

> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

Comments below.

> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 835898e..d165896 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
[...]
>  	.data
>  	.globl	__pv_phys_offset
>  	.type	__pv_phys_offset, %object
>  __pv_phys_offset:
>  	.long	0
>  	.size	__pv_phys_offset, . - __pv_phys_offset
> +
> +	.globl	__pv_offset
> +	.type	__pv_offset, %object
>  __pv_offset:
>  	.long	0
> -#endif
> +	.size	__pv_offset, . - __pv_offset

Please move those to C code.  They aren't of much use in this file 
anymore.  This will allow you to use pphys_addr_t for them as well in 
your subsequent patch. And more importantly get rid of that ugly 
pv_offset_high that you introduced iin another patch.

> diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
> index df5e897..39f8fce 100644
> --- a/arch/arm/kernel/module.c
> +++ b/arch/arm/kernel/module.c
> @@ -317,11 +317,6 @@ int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
>  					         maps[i].txt_sec->sh_addr,
>  					         maps[i].txt_sec->sh_size);
>  #endif
> -#ifdef CONFIG_ARM_PATCH_PHYS_VIRT
> -	s = find_mod_section(hdr, sechdrs, ".pv_table");
> -	if (s)
> -		fixup_pv_table((void *)s->sh_addr, s->sh_size);
> -#endif
>  	s = find_mod_section(hdr, sechdrs, ".patch.table");
>  	if (s)
>  		patch_kernel((void *)s->sh_addr, s->sh_size);

The patch_kernel code and its invokation should still be conditional on 
CONFIG_ARM_PATCH_PHYS_VIRT.  This ability may still be configured out 
irrespective of the implementation used.

> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index bacb275..13731e3 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -162,11 +162,6 @@ SECTIONS
>  		__smpalt_end = .;
>  	}
>  #endif
> -	.init.pv_table : {
> -		__pv_table_begin = .;
> -		*(.pv_table)
> -		__pv_table_end = .;
> -	}
>  	.init.patch_table : {
>  		__patch_table_begin = .;
>  		*(.patch.table)

Since you're changing the module ABI,it is important to also modify the 
module vermagic string in asm/module.h to prevent the loading of 
incompatible kernel modules.


Nicolas
