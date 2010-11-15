Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab0KOIAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:00:53 -0500
Received: from smtp.nokia.com ([147.243.128.24]:44346 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0KOIAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:00:51 -0500
Date: Mon, 15 Nov 2010 09:53:48 +0200
From: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
To: akpm@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@iki.fi>
Subject: Re: [PATCH 1/4] proc/vmcore: allow archs to override
	vmcore_elf_check_arch()
Message-ID: <20101115075348.GR17801@esdhcp04058.research.nokia.com>
References: <cover.1289292124.git.mika.westerberg@iki.fi> <df680f67f33d8b0ef815045b53f205b3ff35de63.1289292124.git.mika.westerberg@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <df680f67f33d8b0ef815045b53f205b3ff35de63.1289292124.git.mika.westerberg@iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Do you have any comments on this patch? If it is ok, could you consider picking
it up?

I should've probably sent it as a separate patch since it is now burried into
"ARM kdump fixes" -thread and thus harder to spot. Sorry about that.

Regards,
MW

On Tue, Nov 09, 2010 at 11:06:10AM +0200, ext Mika Westerberg wrote:
> From: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
> 
> Allow architectures to redefine this macro if needed. This is useful for
> example in architectures where 64-bit ELF vmcores are not supported.
> Specifying zero vmcore_elf64_check_arch() allows compiler to optimize
> away unnecessary parts of parse_crash_elf64_headers().
> 
> We also rename the macro to vmcore_elf64_check_arch() to reflect that it
> is used for 64-bit vmcores only.
> 
> Signed-off-by: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
> ---
>  fs/proc/vmcore.c           |    2 +-
>  include/linux/crash_dump.h |    9 ++++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 2367fb3..74802bc5 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -499,7 +499,7 @@ static int __init parse_crash_elf64_headers(void)
>  	/* Do some basic Verification. */
>  	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
>  		(ehdr.e_type != ET_CORE) ||
> -		!vmcore_elf_check_arch(&ehdr) ||
> +		!vmcore_elf64_check_arch(&ehdr) ||
>  		ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
>  		ehdr.e_ident[EI_VERSION] != EV_CURRENT ||
>  		ehdr.e_version != EV_CURRENT ||
> diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
> index 0026f26..088cd4a 100644
> --- a/include/linux/crash_dump.h
> +++ b/include/linux/crash_dump.h
> @@ -20,7 +20,14 @@ extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
>  #define vmcore_elf_check_arch_cross(x) 0
>  #endif
>  
> -#define vmcore_elf_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
> +/*
> + * Architecture code can redefine this if there are any special checks
> + * needed for 64-bit ELF vmcores. In case of 32-bit only architecture,
> + * this can be set to zero.
> + */
> +#ifndef vmcore_elf64_check_arch
> +#define vmcore_elf64_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
> +#endif
>  
>  /*
>   * is_kdump_kernel() checks whether this kernel is booting after a panic of
> -- 
> 1.7.2.3
