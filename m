Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab1ETW15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:27:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:54386 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab1ETW1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:27:51 -0400
Subject: Re: [PATCH]powerpc: Force page alignment for early reserved memory
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Carroll <dcarroll@astekcorp.com>
Cc: "Paul Mackerras (E-mail)" <paulus@samba.org>,
        "Grant Likely (E-mail)" <grant.likely@secretlab.ca>,
        "LPPC (E-mail)" <linuxppc-dev@lists.ozlabs.org>,
        "LKML (E-mail)" <linux-kernel@vger.kernel.org>
In-Reply-To: <522F24EF533FC546962ECFA2054FF777373072AB71@MAILSERVER2.cos.astekcorp.com>
References: <522F24EF533FC546962ECFA2054FF777373072AB71@MAILSERVER2.cos.astekcorp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 08:27:39 +1000
Message-ID: <1305930459.7481.194.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 15:26 -0600, Dave Carroll wrote:
> When using 64K pages with a separate cpio rootfs, U-Boot will align the rootfs on a 4K
> page boundary. When the memory is reserved, and subsequent early memblock_alloc
> is called, it will allocate memory between the 64K page alignment and reserved
> memory. When the reserved memory is subsequently freed, it is done so by pages,
> causing the early memblock_alloc requests to be re-used, which in my case, caused
> the device-tree to be clobbered.
> 
> This patch forces all early reserved memory to be kernel page aligned, to match
> the mechanism used to free reserved memory.

Hrm...

Reserved memory isn't normally freed. The rootfs is a special case here,
shouldn't we special case it and thus align that specific reserve at the
call site ?

Not a huge deal either way now that I fixed memblock_reserve() to cope
with overlaps but could be a problem if we want to backport your patch.

Cheers,
Ben.

> Signed-off-by: Dave Carroll <dcarroll@astekcorp.com>
> ---
>  arch/powerpc/kernel/prom.c |   21 +++++++++++++++++----
>  1 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index e74fa12..2744792 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -534,6 +534,19 @@ void __init early_init_dt_setup_initrd_arch(unsigned long start,
>  }
>  #endif
> 
> +static void __init reserve_mem(u64 base, u64 size)
> +{
> +       u64 top = base + size;
> +       if (size == 0)
> +               return;
> +
> +       base = _ALIGN_DOWN(base, PAGE_SIZE);
> +       top = _ALIGN_UP(top, PAGE_SIZE);
> +       size = top - base;
> +       memblock_reserve(base, size);
> +
> +}
> +
>  static void __init early_reserve_mem(void)
>  {
>         u64 base, size;
> @@ -547,12 +560,12 @@ static void __init early_reserve_mem(void)
>         /* before we do anything, lets reserve the dt blob */
>         self_base = __pa((unsigned long)initial_boot_params);
>         self_size = initial_boot_params->totalsize;
> -       memblock_reserve(self_base, self_size);
> +       reserve_mem(self_base, self_size);
> 
>  #ifdef CONFIG_BLK_DEV_INITRD
>         /* then reserve the initrd, if any */
>         if (initrd_start && (initrd_end > initrd_start))
> -               memblock_reserve(__pa(initrd_start), initrd_end - initrd_start);
> +               reserve_mem(__pa(initrd_start), initrd_end - initrd_start);
>  #endif /* CONFIG_BLK_DEV_INITRD */
> 
>  #ifdef CONFIG_PPC32
> @@ -573,7 +586,7 @@ static void __init early_reserve_mem(void)
>                         if (base_32 == self_base && size_32 == self_size)
>                                 continue;
>                         DBG("reserving: %x -> %x\n", base_32, size_32);
> -                       memblock_reserve(base_32, size_32);
> +                       reserve_mem(base_32, size_32);
>                 }
>                 return;
>         }
> @@ -584,7 +597,7 @@ static void __init early_reserve_mem(void)
>                 if (size == 0)
>                         break;
>                 DBG("reserving: %llx -> %llx\n", base, size);
> -               memblock_reserve(base, size);
> +               reserve_mem(base, size);
>         }
>  }
> 
> --
> 1.7.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


