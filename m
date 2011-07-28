Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1G1WRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:17:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352Ab1G1WRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:17:42 -0400
Date: Thu, 28 Jul 2011 15:16:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: frank zago <fzago@systemfabricworks.com>
Cc: linux-kernel@vger.kernel.org, Bob Pearson <rpearson@systemfabricworks.com>,
        Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
Message-Id: <20110728151619.8b4cc4e3.akpm@linux-foundation.org>
In-Reply-To: <4E27547E.4000100@systemfabricworks.com>
References: <4E27547E.4000100@systemfabricworks.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(I don't think rdreier@cisco.com exists any more)

On Wed, 20 Jul 2011 17:19:42 -0500
frank zago <fzago@systemfabricworks.com> wrote:

> Hello,
> 
> Added support for slice by 8 to existing crc32 algorithm. Also
> modified gen_crc32table.c to only produce table entries that are
> actually used. The parameters CRC_LE_BITS and CRC_BE_BITS determine
> the number of bits in the input array that are processed during each
> step. Generally the more bits the faster the algorithm is but the
> more table data required.
> 
> Using an x86_64 Opteron machine running at 2100MHz the following table
> was collected with a pre-warmed cache by computing the crc 1000 times
> on a buffer of 4096 bytes.
> 
> 	BITS	Size	LE Cycles/byte	BE Cycles/byte
> 	----------------------------------------------
> 	1	873	41.65		34.60
> 	2	1097	25.43		29.61
> 	4	1057	13.29		15.28
> 	8	2913	7.13		8.19
> 	32	9684	2.80		2.82
> 	64	18178	1.53		1.53
> 
> 	BITS is the value of CRC_LE_BITS or CRC_BE_BITS. The old
> 	default was 8 which actually selected the 32 bit algorithm. In
> 	this version the value 8 is used to select the standard
> 	8 bit algorithm and two new values: 32 and 64 are introduced
> 	to select the slice by 4 and slice by 8 algorithms respectively.
> 
> 	Where Size is the size of crc32.o's text segment which includes
> 	code and table data when both LE and BE versions are set to BITS.
> 
> The current version of crc32.c by default uses the slice by 4 algorithm
> which requires about 2.8 cycles per byte. The slice by 8 algorithm is
> roughly 2X faster and enables packet processing at over 1GB/sec on a typical
> 2-3GHz system.

Are you sure that the code doesn't add any unaligned accesses?  Those
are very bad on some non-x86 architectures.

> --- lib/crc32.c
> +++ lib/crc32.c

Please prepare patches in `patch -p1' form.  So that should have been

--- a/lib/crc32.c
+++ a/lib/crc32.c

>
> ...
>
> @@ -28,14 +31,17 @@
>  #include <linux/init.h>
>  #include <asm/atomic.h>
>  #include "crc32defs.h"
> -#if CRC_LE_BITS == 8
> -# define tole(x) __constant_cpu_to_le32(x)
> +
> +#include <asm/msr.h>

That breaks the build on all non-x86.  Fortunately the inclusion
appears to be unnecessary.

> +#if CRC_LE_BITS > 8
> +# define tole(x) (__force u32) __constant_cpu_to_le32(x)
>  #else
>  # define tole(x) (x)
>  #endif
>  
> -#if CRC_BE_BITS == 8
> -# define tobe(x) __constant_cpu_to_be32(x)
> +#if CRC_BE_BITS > 8
> +# define tobe(x) (__force u32) __constant_cpu_to_be32(x)
>  #else
>  # define tobe(x) (x)
>  #endif
> @@ -45,54 +51,228 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch@
>  MODULE_DESCRIPTION("Ethernet CRC32 calculations");
>  MODULE_LICENSE("GPL");
>  
> -#if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
> +#if CRC_LE_BITS > 8
> +static inline u32 crc32_le_body(u32 crc, u8 const *buf, size_t len)

`inline' is largely ignored by gcc, with gcc-version dependencies. 
__always_inline is more likely to succeed.  But the compiler would
inline this all by itself anyway.

> +{
> +	const u8 *p8;
> +	const u32 *p32;
> +	int init_bytes, end_bytes;
> +	size_t words;
> +	int i;
> +	u32 q;
> +	u8 i0, i1, i2, i3;
> +
> +	crc = (__force u32) __cpu_to_le32(crc);
> +
> +#if CRC_LE_BITS == 64
> +	p8 = buf;
> +	p32 = (u32 *)(((uintptr_t)p8 + 7) & ~7);

Perhaps using ALIGN() would be clearer.

> +
> +	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;

Please take a look at the types of init_bytes and end_bytes. 
ptrdiff_t, size_t and uint would all eb more appropriate than `int'.

> +	if (init_bytes > len)
> +		init_bytes = len;
> +	words = (len - init_bytes) >> 3;
> +	end_bytes = (len - init_bytes) & 7;
> +#else
> +	p8 = buf;
> +	p32 = (u32 *)(((uintptr_t)p8 + 3) & ~3);

ALIGN()?

> +	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
> +	if (init_bytes > len)
> +		init_bytes = len;

max()?

> +	words = (len - init_bytes) >> 2;
> +	end_bytes = (len - init_bytes) & 3;
> +#endif
> +
> +	for (i = 0; i < init_bytes; i++) {
> +#ifdef __LITTLE_ENDIAN
> +		i0 = *p8++ ^ crc;
> +		crc = t0_le[i0] ^ (crc >> 8);
> +#else
> +		i0 = *p8++ ^ (crc >> 24);
> +		crc = t0_le[i0] ^ (crc << 8);
> +#endif
> +	}

All the ifdeffing in here bursts my brain.

Has this code been carefully tested in LE and BE?

>
> ...
>
> +#if CRC_LE_BITS == 64
> +	p8 = buf;
> +	p32 = (u32 *)(((uintptr_t)p8 + 7) & ~7);
> +
> +	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
> +	if (init_bytes > len)
> +		init_bytes = len;
> +	words = (len - init_bytes) >> 3;
> +	end_bytes = (len - init_bytes) & 7;

Various dittoes.

> +#else
> +	p8 = buf;
> +	p32 = (u32 *)(((uintptr_t)p8 + 3) & ~3);
> +
> +	init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
> +	if (init_bytes > len)
> +		init_bytes = len;
> +	words = (len - init_bytes) >> 2;
> +	end_bytes = (len - init_bytes) & 3;
> +#endif
> +
> +	for (i = 0; i < init_bytes; i++) {
> +#ifdef __LITTLE_ENDIAN
> +		i0 = *p8++ ^ crc;
> +		crc = t0_be[i0] ^ (crc >> 8);
> +#else
> +		i0 = *p8++ ^ (crc >> 24);
> +		crc = t0_be[i0] ^ (crc << 8);
> +#endif
> +	}
>  

