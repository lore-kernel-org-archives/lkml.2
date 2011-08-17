Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1HQUjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:39:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55551 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1HQUjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 07/36] Hexagon: Add threadinfo
Date: Wed, 17 Aug 2011 21:37:18 +0200
Message-ID: <3022109.uYnQ9M7cUS@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163520.513397876@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163520.513397876@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Jds3ReLKOrbQ6SJ7Nh9JkgW411MiYam+rf6OlqTwcfH
 hiPNpqDAhfPUryPTIaLks+TfzUPz0f9Ee9gfSs55Cw8nHmGOEu
 4tct7/BHZ0UXIcRG0IJHDv4x7MZNRXYRBJJWDkim0woBOAop/f
 OP0eDtCIUHRO5s0XTJj0YAMK2aZU2BrV2SZHJxGnmvJcwfU+LG
 wvhtncdp7S/eXD3SSE3Bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:04 Richard Kuo wrote:

> +/*
> + * order is for __get_free_pages; see get_order()
> + */
> +
> +#ifdef CONFIG_PAGE_SIZE_4KB
> +#define THREAD_SIZE	(1<<13)
> +#define THREAD_SIZE_ORDER 1
> +#endif
> +
> +#ifdef CONFIG_PAGE_SIZE_16KB
> +#define THREAD_SIZE	(1<<14)
> +#define THREAD_SIZE_ORDER 0
> +#endif
> +
> +#ifdef CONFIG_PAGE_SIZE_64KB
> +#define THREAD_SIZE	(1<<16)
> +#define THREAD_SIZE_ORDER 0
> +#endif
> +
> +#ifdef CONFIG_PAGE_SIZE_256KB
> +#define THREAD_SIZE	(1<<18)
> +#define THREAD_SIZE_ORDER 0
> +#endif
>

If you use pages larger than 16KB, you probably want to use less than
a page for the kernel stack and use kmalloc to get it.
See arch/powerpc/include/asm/thread_info.h

> +
> +/*
> + * kmalloc is probably not appropriate because alignment seems
> + * not guaranteed out of kmalloc at all, and we assume thread_info
> + * is aligned to THREAD_SIZE all over the place, notably the switch and
> + * entry/exit routines.
> + */
> +
> +#if 0
> +#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
> +#ifdef CONFIG_DEBUG_STACK_USAGE
> +#define alloc_thread_info(tsk) \
> +	((struct thread_info *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, \
> +	THREAD_SIZE_ORDER))
> +
> +#else   /*  CONFIG_DEBUG_STACK_USAGE  */
> +#define alloc_thread_info(tsk) \
> +	((struct thread_info *)__get_free_pages(GFP_KERNEL, \
> +	THREAD_SIZE_ORDER))
> +#endif  /*  ! CONFIG_DEBUG_STACK_USAGE  */
> +

You don't have to align the thread_info if you use different implementation
of current_thread_info. One way to do it would be to have a per-cpu
variable pointing to the current thread_info and use the TLS mechanism
to point to percpu data, instead of getting the percpu offset from thread_info.

	Arnd
