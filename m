Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0LISdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:33:31 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:42449 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab0LISd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:33:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OP0sqwaHB5T5ohggd+L2ufGnmRxrDE+t/XHMTmzHLJi8avVBEhn8bcFVjO2yZA0UEM
         P98L4j/W2oOHmAuiRipUPKgDhxC3eJXTEths68XrL07F8p4DXorTTR5uOnuVrFCkRBMC
         Ze+PZkD7YQne/EmS1J7rKNrlzQqVX3IcmUUss=
MIME-Version: 1.0
In-Reply-To: <01da01cb9784$d44c0460$7ce40d20$@mprc.pku.edu.cn>
References: <01da01cb9784$d44c0460$7ce40d20$@mprc.pku.edu.cn>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 9 Dec 2010 19:33:26 +0100
Message-ID: <AANLkTimDWHGsL+1H_VSevSjpFW0-h53NzRynANnayTRm@mail.gmail.com>
Subject: Re: [PATCHv1 008/211] unicore32: new file arch/unicore32/boot/compressed/misc.c
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, some trivial tips...

On Thu, Dec 9, 2010 at 10:38 AM, Guan Xuetao <guanxuetao@mprc.pku.edu.cn> wrote:
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
>
>        decompress_kernel call wrapper in c function
>
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> ---
>  arch/unicore32/boot/compressed/misc.c |  143
> +++++++++++++++++++++++++++++++++
>  1 files changed, 143 insertions(+), 0 deletions(-)
>
> diff --git a/arch/unicore32/boot/compressed/misc.c
> b/arch/unicore32/boot/compressed/misc.c
> new file mode 100644
> index 0000000..28dda37
> --- /dev/null
> +++ b/arch/unicore32/boot/compressed/misc.c
> @@ -0,0 +1,143 @@
> +/*
> + * linux/arch/unicore32/boot/compressed/misc.c
> + *
> + * Code specific to PKUnity SoC and UniCore ISA
> + *
> + * Copyright (C) 2001-2010 GUAN Xue-tao
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <asm/unaligned.h>
> +#include <asm/mach/uncompress.h>
> +
> +/*
> + * gzip delarations
> + */
> +unsigned char *output_data;
> +unsigned long output_ptr;
> +
> +unsigned int free_mem_ptr;
> +unsigned int free_mem_end_ptr;
> +
> +#define STATIC static
> +#define STATIC_RW_DATA /* non-static please */
> +
> +/*
> + * arch-dependent implementations
> + */
> +#ifndef ARCH_HAVE_DECOMP_ERROR
> +#define arch_decomp_error(x)
> +#endif
> +
> +#ifndef ARCH_HAVE_DECOMP_SETUP
> +#define        arch_decomp_setup()

Whitespace

> +#endif
> +
> +#ifndef ARCH_HAVE_DECOMP_PUTS
> +#define arch_decomp_puts(p)
> +#endif
> +
> +/* Diagnostic functions */
> +#ifdef DEBUG
> +#  define Assert(cond, msg)    { if (!(cond)) error(msg); }
> +#  define Trace(x)             fprintf x
> +#  define Tracev(x)            { if (verbose)                  fprintf x; }
> +#  define Tracevv(x)           { if (verbose > 1)              fprintf x; }
> +#  define Tracec(c, x)         { if (verbose && (c))           fprintf x; }
> +#  define Tracecv(c, x)                { if ((verbose > 1) && (c))
> fprintf x; }

Maybe uppercase? Maybe do { ... } while(0)?

> +#else
> +#  define Assert(cond, msg)
> +#  define Trace(x)
> +#  define Tracev(x)
> +#  define Tracevv(x)
> +#  define Tracec(c, x)
> +#  define Tracecv(c, x)
> +#endif
> +
> +void *memcpy(void *__dest, __const void *__src, size_t __n)

Why are they underscored?

> +{
> +       int i = 0;
> +       unsigned char *d = (unsigned char *)__dest, *s = (unsigned char
> *)__src;
> +
> +       for (i = __n >> 3; i > 0; i--) {
> +               *d++ = *s++;
> +               *d++ = *s++;
> +               *d++ = *s++;
> +               *d++ = *s++;
> +               *d++ = *s++;
> +               *d++ = *s++;
> +               *d++ = *s++;
> +               *d++ = *s++;
> +       }
> +
> +       if (__n & 1 << 2) {
> +               *d++ = *s++;
> +               *d++ = *s++;
> +               *d++ = *s++;
> +               *d++ = *s++;
> +       }
> +
> +       if (__n & 1 << 1) {
> +               *d++ = *s++;
> +               *d++ = *s++;
> +       }
> +
> +       if (__n & 1)
> +               *d++ = *s++;
> +
> +       return __dest;
> +}
> +
> +void error(char *x)
> +{
> +

Newline

> +       arch_decomp_puts("\n\n");
> +       arch_decomp_puts(x);
> +       arch_decomp_puts("\n\n -- System halted");
> +
> +       arch_decomp_error(x);
> +
> +       do { } while (1); /* Halt */

for (;;);?

> +}
> +
> +/* Heap size should be adjusted for different decompress method */
> +#ifdef CONFIG_KERNEL_GZIP
> +#include "../../../../lib/decompress_inflate.c"
> +#endif
> +
> +#ifdef CONFIG_KERNEL_BZIP2
> +#include "../../../../lib/decompress_bunzip2.c"
> +#endif
> +
> +#ifdef CONFIG_KERNEL_LZO
> +#include "../../../../lib/decompress_unlzo.c"
> +#endif
> +
> +#ifdef CONFIG_KERNEL_LZMA
> +#include "../../../../lib/decompress_unlzma.c"
> +#endif
> +
> +unsigned long

I think that, for new code, no newlines should be written after the return type.

> +decompress_kernel(unsigned long output_start, unsigned long free_mem_ptr_p,
> +               unsigned long free_mem_ptr_end_p)
> +{
> +       unsigned char *tmp;
> +
> +       output_data             = (unsigned char *)output_start;
> +       free_mem_ptr            = free_mem_ptr_p;
> +       free_mem_end_ptr        = free_mem_ptr_end_p;
> +
> +       arch_decomp_setup();
> +
> +       tmp = (unsigned char *) (((unsigned long)input_data_end) - 4);
> +       output_ptr = get_unaligned_le32(tmp);
> +
> +       arch_decomp_puts("Uncompressing Linux...");
> +       decompress(input_data, input_data_end - input_data, NULL, NULL,
> +                       output_data, NULL, error);
> +       arch_decomp_puts(" done, booting the kernel.\n");
> +       return output_ptr;
> +}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
