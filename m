Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab0KYSWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 13:22:38 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:8968 "EHLO mailfw02.zoner.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab0KYSWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 13:22:37 -0500
From: Lasse Collin <lasse.collin@tukaani.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH RFC 2/3] Decompressors: Add boot-time XZ support
Date: Thu, 25 Nov 2010 20:22:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-ARCH; KDE/4.5.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <201011242254.41176.lasse.collin@tukaani.org> <4CEE02EE.1050102@lougher.demon.co.uk>
In-Reply-To: <4CEE02EE.1050102@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011252022.53497.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-25 Phillip Lougher wrote:
> On 24/11/10 20:54, Lasse Collin wrote:
> > @@ -176,10 +179,20 @@ config KERNEL_LZMA
> > 
> >   	bool "LZMA"
> >   	depends on HAVE_KERNEL_LZMA
> >   	help
> > 
> > +	  This is the predecessor of XZ.
> > +
> 
> You seem to have moved the help text from LZMA into the entry for XZ,
> leaving LZMA merely with the observation it's the predecessor of XZ.
> I think LZMA should keep it's help text describing what it is.

OK. It needs some updating though with a separate patch. E.g. it 
currently says "decompression speed is between the other two" while 
there are already four supported kernel compression methods (LZO is 
the fourth).

> > +config KERNEL_XZ
> > +	bool "XZ"
> > +	depends on HAVE_KERNEL_XZ
> > +	help
> > 
> >   	  The most recent compression algorithm.
> 
> This sounds odd, "The most recent compression algorithm" to what?

Yes, it needs to be improved.

> > diff -uprN linux-2.6.37-rc3.orig/lib/decompress_unxz.c linux-2.6.37-rc3/lib/decompress_unxz.c
> > --- linux-2.6.37-rc3.orig/lib/decompress_unxz.c       1970-01-01 02:00:00.000000000 +0200
> > +++ linux-2.6.37-rc3/lib/decompress_unxz.c    2010-11-24 18:18:37.000000000 +0200
> > @@ -0,0 +1,390 @@
> > +/*
> > + * XZ decoder as a single file for uncompressing the kernel and initramfs
> 
> Does "Single file XZ decoder for ..." sound better?

Thanks. I have fixed it in the git repository of XZ Embedded. 
Nowadays decompress_unxz.c uses xz_dec module for initramfs and 
initrd decompression, so it's not a single-file decompressor anymore. 
"Wrapper for decompressing XZ-compressed kernel, initramfs, and 
initrd" sounds more correct.

> > +#ifndef memzero
> > +static void memzero(void *buf, size_t size)
> > +{
> > +	uint8_t *b = buf;
> > +	uint8_t *e = b + size;
> 
> New line here

Fixed.

> > +/*
> > + * This function implements the API defined in<linux/decompress/generic.h>.
> > + *
> 
> Not completely, see below.  Your wrapper behaves correctly (bar one
> respect) for the restricted use cases of initramfs/initrd, but for
> other inputs it will behave differently to the other decompressors,
> and differently to that described in generic.h, and it is broken for
> some inputs.

There is a problem but I think it's a little more complex than it 
seems at first. I asked Alain Knaff for clarification about the API 
in 2009-05-26 (that discussion was CC'ed to H. Peter Anvin). I got 
an excellent answer. I wrote decompress_unxz.c based on that, and 
unxz() hasn't changed much since then.

I also wrote improved documentation for <linux/decompress/generic.h> 
on the same day. I got some feedback about it from H. Peter Anvin and 
I think the final version was good. Unfortunately the patch got 
forgotten and didn't end up in Linux. I understood that Alain Knaff 
was busy back then and I didn't pay attention to the patch later either.

Your documentation improvement to generic.h got into Linux in 
2009-08-07.

> Is this a problem?  Depends on your viewpoint.  One viewpoint is all
> the decompressors/wrappers should behave the same (as realistically
> possible) given the same inputs, so code can switch between
> compressors and get the same behaviour.  The other viewpoint is to
> just say that the decompressors give the same behaviour for the
> restricted inittramfs/initrd use cases and state all other usage is
> unpredictable.

I think all decompressors should behave the same as long as the 
specified API is followed, the rest being undefined. So my code is 
broken with the current API specification from generic.h.

> > +		b.out = out;
> > +		b.out_size = (size_t)-1;
> > +		ret = xz_dec_run(s,&b);
> > +	} else {
> > +		b.out_size = XZ_IOBUF_SIZE;
> > +		b.out = malloc(XZ_IOBUF_SIZE);
> 
> You're assuming here that flush != NULL.  The API as described in
> generic.h allows for the situation where fill != NULL && flush ==
> NULL, in which case out is assumed to be != NULL and large enough to
> hold the entire output data without flushing.
> 
>  From generic.h: "If flush = NULL, outbuf must be large enough to
> buffer all the expected output"

The docs in generic.h allow it but I would like to get a 
clarification if this is really what is wanted the API to be. Alain 
Knaff said in 2009 that there are only three use cases:
  - pre-boot (buffer to buffer)
  - initramfs (buffer to callback)
  - initrd (callback to callback)

In these cases it's impossible to have fill != NULL && flush == NULL.

> > +		if (b.out == NULL)
> > +			goto error_alloc_out;
> > +
> > +		if (fill != NULL) {
> > +			in = malloc(XZ_IOBUF_SIZE);
> 
>  From generic.h: "inbuf can be NULL, in which case the decompressor
> will allocate the input buffer.  If inbuf != NULL it must be at
> least XXX_IOBUF_SIZE bytes. fill will be called (repeatedly...) to
> read data"
> 
> If in != NULL, you'll discard the passed in buffer.

You are right again. On the other hand, Alain Knaff made it very 
clear to me in 2009 that the situation you describe should not occur, 
and indeed it does not occur with anything in the kernel now.

XXX_IOBUF_SIZE are defined in lib/decompress_*.c instead of 
decompressor headers in include/linux/decompress/. So those constants 
are practically available only in the pre-boot code which doesn't use 
them. Now I see that include/linux/decompress/inflate.h does define 
INBUFSIZ to 4096, but INBUFSIZ is not used by any file in the kernel, 
and decompress_inflate.c defines GZIP_IOBUF_SIZE to 16 KiB.

It also doesn't sound so great that each decompressor specifies its 
own XXX_IOBUF_SIZE. Something like 4 KiB or 8 KiB would be OK for 
gunzip, bunzip2, unlzma, and unxz. Now each of them specify their own 
different XXX_IOBUF_SIZE. decompress_unlzo.c is the only one that 
truly cares about the XXX_IOBUF_SIZE and needs about 256 KiB, but that 
code doesn't currently support callback-to-callback mode at all, and 
even with my patches in the -mm tree there's no LZO_IOBUF_SIZE.

I want to emphasize that I'm not against fixing my code to comply 
with the API specification in generic.h. I just want to be sure if 
that API is really what is wanted; it requires more than that is 
currently needed by any code in the kernel. Naturally I should have 
brought this up in my earlier emails.

> > +			if (in == NULL)
> > +				goto error_alloc_in;
> > +
> > +			b.in = in;
> > +		}
> > +
> > +		do {
> > +			if (b.in_pos == b.in_size&&  fill != NULL) {
> 
> If fill != NULL you're relying on the caller to have passed
> in_size == 0, so first time around the loop the fill function is
> called to fill your empty malloced buffer.  If in_size is passed in
> != 0, you won't call fill and therefore you will pass an empty buffer
> to the decompressor.

If fill != NULL, the caller must have passed in_size = 0. generic.h 
says: "If len != 0, inbuf should contain all the necessary input 
data, and fill should be NULL".

> > +			if (b.out_pos == b.out_size || ret != XZ_OK) {
> > +				/*
> > +				 * Setting ret here may hide an error
> > +				 * returned by xz_dec_run(), but probably
> > +				 * it's not too bad.
> > +				 */
> > +				if (flush(b.out, b.out_pos) != (int)b.out_pos)
> > +					ret = XZ_BUF_ERROR;
> > +
> 
> If flush is NULL, this will OOPs.
> 
> This is the else part of "if (fill == NULL&&  flush == NULL)" which
> will execute if fill != NULL && flush == NULL

Yes. I covered "fill != NULL && flush == NULL" earlier in this email 
already.

> Also (and this applies to the restricted use case of initramfs/initrd
> too) as you're checking for ret != XZ_OK, flush will be called even
> if the decompressor has returned error, and there hasn't been any
> data produced (flushing an empty buffer), which may confuse code.

I didn't think that this could be a problem (and generic.h doesn't 
tell either). The buffer might be empty also when finishing 
successfully (XZ_STREAM_END). I have fixed it now.

decompress_unlzma.c can call flush() with an empty buffer at the end 
of successful decompression too. I will make an updated version of 
decompressors-check-for-write-errors-in-decompress_unlzmac.patch that 
is currently in the -mm tree.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
