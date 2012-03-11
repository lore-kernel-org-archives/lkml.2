Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2CKJzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 05:55:35 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:46077 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2CKJzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 05:55:32 -0400
Date: Sun, 11 Mar 2012 10:55:28 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
cc: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        herbert@gondor.hengli.com.au, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH v2.2 2/7] crypto: GnuPG based MPI lib - header files
 (part 2)
In-Reply-To: <af9b876508ebc83431312aef67b3ae920780bd5c.1319025009.git.dmitry.kasatkin@intel.com>
Message-ID: <alpine.DEB.2.00.1203111046110.4778@ayla.of.borg>
References: <cover.1319025009.git.dmitry.kasatkin@intel.com> <af9b876508ebc83431312aef67b3ae920780bd5c.1319025009.git.dmitry.kasatkin@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Dmitry Kasatkin wrote:
> Adds the multi-precision-integer maths library which was originally taken
> from GnuPG and ported to the kernel by (among others) David Howells.
> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
> The difference is that checkpatch reported errors and warnings have been fixed.
> 
> This library is used to implemenet RSA digital signature verification
> used in IMA/EVM integrity protection subsystem.

> --- /dev/null
> +++ b/lib/mpi/longlong.h

> +	/* If udiv_qrnnd was not defined for this processor, use __udiv_qrnnd_c.  */
> +#if !defined(udiv_qrnnd)
> +#define UDIV_NEEDS_NORMALIZATION 1
> +#define udiv_qrnnd __udiv_qrnnd_c
> +#endif
> +
> +#undef count_leading_zeros

Why is this #undef here? It's not present in mpi/longlong.h from Ubuntu's
gnupg-1.4.10, and causing ...

> +#if !defined(count_leading_zeros)
> +	extern
> +#ifdef __STDC__
> +			const
> +#endif
> +			unsigned char __clz_tab[];
> +#define count_leading_zeros(count, x) \
> +do { \
> +	UWtype __xr = (x); \
> +	UWtype __a; \
> +	\
> +	if (W_TYPE_SIZE <= 32) { \
> +		__a = __xr < ((UWtype) 1 << 2*__BITS4) \
> +		? (__xr < ((UWtype) 1 << __BITS4) ? 0 : __BITS4) \
> +		: (__xr < ((UWtype) 1 << 3*__BITS4) ?  2*__BITS4 : 3*__BITS4); \
> +	} \
> +	else { \
> +		for (__a = W_TYPE_SIZE - 8; __a > 0; __a -= 8) \
> +			if (((__xr >> __a) & 0xff) != 0) \
> +				break; \
> +	} \
> +	\
> +	(count) = W_TYPE_SIZE - (__clz_tab[__xr >> __a] + __a); \
> +} while (0)
> +	/* This version gives a well-defined value for zero. */
> +#define COUNT_LEADING_ZEROS_0 W_TYPE_SIZE

lib/mpi/longlong.h:1483:1: warning: "COUNT_LEADING_ZEROS_0" redefined
lib/mpi/longlong.h:610:1: warning: this is the location of the previous definition

on m68k/allmodconfig.

I'm also wondering why this warning is not seen on other arches, e.g. PPC
#defines COUNT_LEADING_ZEROS_0 to 32, just like m68k.

> +#endif

I suppose the plan is to clean up this header file, as lots of its
functionality is already present in the kernel sources in some other way
(e.g. arch/m68k/lib/muldi3.c)?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
