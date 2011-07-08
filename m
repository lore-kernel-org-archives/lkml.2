Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1GHFiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:38:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47296 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab1GHFiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:38:20 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1107071511010.26083@router.home>
References: <alpine.DEB.2.00.1107071314320.21719@router.home>
	<1310064771.21902.55.camel@jaguar>
	<alpine.DEB.2.00.1107071402490.24248@router.home>
	<20110707.122151.314840355798805828.davem@davemloft.net>
	<CAOJsxLFsX3Q84QAeyRt5dZOdRxb3TiABPrP-YrWc91+BmR8ZBg@mail.gmail.com>
	<alpine.DEB.2.00.1107071511010.26083@router.home>
Date: Fri, 8 Jul 2011 08:38:19 +0300
X-Google-Sender-Auth: kxPUnJ8F5icHgpVPEceYi_KH2Rs
Message-ID: <CAOJsxLFpqUD_TBbbdv8S6WPtZFbChv4cvNTv220cAeeOTRoUVw@mail.gmail.com>
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: David Miller <davem@davemloft.net>, marcin.slusarz@gmail.com,
        mpm@selenic.com, linux-kernel@vger.kernel.org, rientjes@google.com,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 11:12 PM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 7 Jul 2011, Pekka Enberg wrote:
>
>> I applied the patch. I think a follow up patch that moves the function
>> to lib/string.c with proper generic name would be in order. Thanks!
>
> Well this is really straightforward. Hasnt seen much testing yet and
> needs refinement but it would be like this:
>
>
> ---
>  arch/x86/include/asm/string_32.h |    2 ++
>  arch/x86/lib/string_32.c         |   17 +++++++++++++++++
>  include/linux/string.h           |    3 +++
>  lib/string.c                     |   25 +++++++++++++++++++++++++
>  mm/slub.c                        |   13 ++++++-------
>  5 files changed, 53 insertions(+), 7 deletions(-)
>
> Index: linux-2.6/arch/x86/lib/string_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/lib/string_32.c     2011-07-07 15:03:46.000000000 -0500
> +++ linux-2.6/arch/x86/lib/string_32.c  2011-07-07 15:03:56.000000000 -0500
> @@ -214,6 +214,23 @@ void *memscan(void *addr, int c, size_t
>  EXPORT_SYMBOL(memscan);
>  #endif
>
> +#ifdef __HAVE_ARCH_INV_MEMSCAN
> +void *inv_memscan(void *addr, int c, size_t size)
> +{
> +       if (!size)
> +               return addr;
> +       asm volatile("repz; scasb\n\t"
> +           "jz 1f\n\t"
> +           "dec %%edi\n"
> +           "1:"
> +           : "=D" (addr), "=c" (size)
> +           : "0" (addr), "1" (size), "a" (c)
> +           : "memory");
> +       return addr;
> +}
> +EXPORT_SYMBOL(memscan);
> +#endif
> +
>  #ifdef __HAVE_ARCH_STRNLEN
>  size_t strnlen(const char *s, size_t count)
>  {
> Index: linux-2.6/include/linux/string.h
> ===================================================================
> --- linux-2.6.orig/include/linux/string.h       2011-07-07 15:03:46.000000000 -0500
> +++ linux-2.6/include/linux/string.h    2011-07-07 15:03:56.000000000 -0500
> @@ -108,6 +108,9 @@ extern void * memmove(void *,const void
>  #ifndef __HAVE_ARCH_MEMSCAN
>  extern void * memscan(void *,int,__kernel_size_t);
>  #endif
> +#ifndef __HAVE_ARCH_INV_MEMSCAN
> +extern void * inv_memscan(void *,int,__kernel_size_t);
> +#endif
>  #ifndef __HAVE_ARCH_MEMCMP
>  extern int memcmp(const void *,const void *,__kernel_size_t);
>  #endif
> Index: linux-2.6/lib/string.c
> ===================================================================
> --- linux-2.6.orig/lib/string.c 2011-07-07 15:03:46.000000000 -0500
> +++ linux-2.6/lib/string.c      2011-07-07 15:03:56.000000000 -0500
> @@ -684,6 +684,31 @@ void *memscan(void *addr, int c, size_t
>  EXPORT_SYMBOL(memscan);
>  #endif
>
> +#ifndef __HAVE_ARCH_INV_MEMSCAN
> +/**
> + * memscan - Skip characters in an area of memory.
> + * @addr: The memory area
> + * @c: The byte to skip
> + * @size: The size of the area.
> + *
> + * returns the address of the first mismatch of @c, or 1 byte past
> + * the area if @c matches to the end
> + */
> +void *inv_memscan(void *addr, int c, size_t size)

I think this needs a better name. My suggestion is memskip().
