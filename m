Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab0KYGcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:32:21 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:41903 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab0KYGcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:32:20 -0500
Message-ID: <4CEE02EE.1050102@lougher.demon.co.uk>
Date: Thu, 25 Nov 2010 06:32:14 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux armv7l; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Lasse Collin <lasse.collin@tukaani.org>
CC: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC 2/3] Decompressors: Add boot-time XZ support
References: <201011242254.41176.lasse.collin@tukaani.org>
In-Reply-To: <201011242254.41176.lasse.collin@tukaani.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/11/10 20:54, Lasse Collin wrote:

> @@ -176,10 +179,20 @@ config KERNEL_LZMA
>   	bool "LZMA"
>   	depends on HAVE_KERNEL_LZMA
>   	help
> +	  This is the predecessor of XZ.
> +

You seem to have moved the help text from LZMA into the entry for XZ,
leaving LZMA merely with the observation it's the predecessor of XZ. I
think LZMA should keep it's help text describing what it is.

> +config KERNEL_XZ
> +	bool "XZ"
> +	depends on HAVE_KERNEL_XZ
> +	help
>   	  The most recent compression algorithm.

This sounds odd, "The most recent compression algorithm" to what? The
most recent compression algorithm in the world, the most recent open
source compression algorithm, or the most recently added compression
algorithm to the Linux kernel?

These statements can become quickly out of date, especially if they're
vague as to what they mean - if someone added another compression
algorithm to the Linux kernel in the future, should they change this
statement?

BTW I appreciate that you've merely kept the original poorly worded
description from the LZMA help text.

> diff -uprN linux-2.6.37-rc3.orig/lib/decompress_unxz.c linux-2.6.37-rc3/lib/decompress_unxz.c
> --- linux-2.6.37-rc3.orig/lib/decompress_unxz.c	1970-01-01 02:00:00.000000000 +0200
> +++ linux-2.6.37-rc3/lib/decompress_unxz.c	2010-11-24 18:18:37.000000000 +0200
> @@ -0,0 +1,390 @@
> +/*
> + * XZ decoder as a single file for uncompressing the kernel and initramfs

Does "Single file XZ decoder for ..." sound better?

> +#ifndef memeq
> +static bool memeq(const void *a, const void *b, size_t size)
> +{
> +	const uint8_t *x = a;
> +	const uint8_t *y = b;
> +	size_t i;
> +
> +	for (i = 0; i<  size; ++i)

The kernel uses either "i < size" or "i<size" ...

lots of these ...

> +		if (x[i] != y[i])
> +			return false;
> +
> +	return true;
> +}
> +#endif
> +
> +#ifndef memzero
> +static void memzero(void *buf, size_t size)
> +{
> +	uint8_t *b = buf;
> +	uint8_t *e = b + size;

New line here

> +	while (b != e)
> +		*b++ = '\0';
> +}
> +#endif


> +
> +/*
> + * This function implements the API defined in<linux/decompress/generic.h>.
> + *

Not completely, see below.  Your wrapper behaves correctly (bar one
respect) for the restricted use cases of initramfs/initrd, but for
other inputs it will behave differently to the other decompressors, and
differently to that described in generic.h, and it is broken for some
inputs.

Is this a problem?  Depends on your viewpoint.  One viewpoint is all
the decompressors/wrappers should behave the same (as realistically
possible) given the same inputs, so code can switch between compressors
and get the same behaviour.  The other viewpoint is to just say that
the decompressors give the same behaviour for the restricted
inittramfs/initrd use cases and state all other usage is unpredictable.

> +	if (in != NULL&&  out != NULL)
> +		s = xz_dec_init(XZ_SINGLE, 0);
> +	else
> +		s = xz_dec_init(XZ_DYNALLOC, (uint32_t)-1);
> +
> +	if (s == NULL)
> +		goto error_alloc_state;
> +
> +	b.in = in;
> +	b.in_pos = 0;
> +	b.in_size = in_size;
> +	b.out_pos = 0;
> +
> +	if (in_used != NULL)
> +		*in_used = 0;
> +
> +	if (fill == NULL&&  flush == NULL) {

Space before &&

> +		b.out = out;
> +		b.out_size = (size_t)-1;
> +		ret = xz_dec_run(s,&b);
> +	} else {
> +		b.out_size = XZ_IOBUF_SIZE;
> +		b.out = malloc(XZ_IOBUF_SIZE);

You're assuming here that flush != NULL.  The API as described in
generic.h allows for the situation where fill != NULL && flush == NULL,
in which case out is assumed to be != NULL and large enough to hold the
entire output data without flushing.

 From generic.h: "If flush = NULL, outbuf must be large enough to buffer
all the expected output"


> +		if (b.out == NULL)
> +			goto error_alloc_out;
> +
> +		if (fill != NULL) {
> +			in = malloc(XZ_IOBUF_SIZE);

 From generic.h: "inbuf can be NULL, in which case the decompressor will
allocate the input buffer.  If inbuf != NULL it must be at least
XXX_IOBUF_SIZE bytes. fill will be called (repeatedly...) to read data"

If in != NULL, you'll discard the passed in buffer.


> +			if (in == NULL)
> +				goto error_alloc_in;
> +
> +			b.in = in;
> +		}
> +
> +		do {
> +			if (b.in_pos == b.in_size&&  fill != NULL) {

Space before &&

If fill != NULL you're relying on the caller to have passed
in_size == 0, so first time around the loop the fill function is
called to fill your empty malloced buffer.  If in_size is passed in
!= 0, you won't call fill and therefore you will pass an empty buffer
to the decompressor.

> +				if (in_used != NULL)
> +					*in_used += b.in_pos;
> +


> +
> +			if (b.out_pos == b.out_size || ret != XZ_OK) {
> +				/*
> +				 * Setting ret here may hide an error
> +				 * returned by xz_dec_run(), but probably
> +				 * it's not too bad.
> +				 */
> +				if (flush(b.out, b.out_pos) != (int)b.out_pos)
> +					ret = XZ_BUF_ERROR;
> +

If flush is NULL, this will OOPs.

This is the else part of "if (fill == NULL&&  flush == NULL)" which will
execute if fill != NULL && flush == NULL

Also (and this applies to the restricted use case of initramfs/initrd
too) as you're checking for ret != XZ_OK, flush will be called even if
the decompressor has returned error, and there hasn't been any data
produced (flushing an empty buffer), which may confuse code.

Phillip


