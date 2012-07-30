Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2G3VvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 17:51:22 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:51617 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2G3VvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 17:51:20 -0400
Date: Mon, 30 Jul 2012 23:51:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] ARM: Sort exception table at compile time
Message-ID: <20120730215118.GA32670@merkur.ravnborg.org>
References: <1343683803-15507-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343683803-15507-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 02:30:03PM -0700, Stephen Boyd wrote:
> Add the ARM machine identifier to sortextable and select the
> config option so that we can sort the exception table at compile
> time. sortextable relies on a section named __ex_table existing
> in the vmlinux, but ARM's linker script places the exception
> table in the data section. Give the exception table its own
> section so that sortextable can find it.
> 
> This allows us to skip the runtime sorting step during boot.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: David Daney <david.daney@cavium.com>
> ---
> 
> I can't find any information on why the exception table lives in the data
> section. If there's a good reason for that, I'll look into changing
> sortextable to look for the __start___ex_table symbol.
> 
>  arch/arm/Kconfig              |  1 +
>  arch/arm/kernel/vmlinux.lds.S | 19 +++++++++----------
>  scripts/sortextable.c         |  1 +
>  3 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index b25c9d3..2af95e6 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1,6 +1,7 @@
>  config ARM
>  	bool
>  	default y
> +	select BUILDTIME_EXTABLE_SORT if MMU
>  	select ARCH_HAVE_CUSTOM_GPIO_H
>  	select HAVE_AOUT
>  	select HAVE_DMA_API_DEBUG
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index 36ff15b..0e3e8b4 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -220,16 +220,6 @@ SECTIONS
>  		READ_MOSTLY_DATA(L1_CACHE_BYTES)
>  
>  		/*
> -		 * The exception fixup table (might need resorting at runtime)
> -		 */
> -		. = ALIGN(4);
> -		__start___ex_table = .;
> -#ifdef CONFIG_MMU
> -		*(__ex_table)
> -#endif
> -		__stop___ex_table = .;
> -
> -		/*
>  		 * and the usual data section
>  		 */
>  		DATA_DATA
> @@ -239,6 +229,15 @@ SECTIONS
>  	}
>  	_edata_loc = __data_loc + SIZEOF(.data);
>  
> +	. = ALIGN(4);
> +	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
> +		__start___ex_table = .;
> +#ifdef CONFIG_MMU
> +		*(__ex_table)
> +#endif
> +		__stop___ex_table = .;
> +	}
> +

Here you should be able to use the macro EXCEPTION_TABLE from
vmlinux.lds.h.
I cannot see why the ifdef for not NON-MMU case is needed,
but if it is needed the macro is not good...

	Sam
