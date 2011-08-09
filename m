Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1HIGVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 02:21:41 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:45784 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696Ab1HIGVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 02:21:40 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=wzY9NJouJbkA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=GsJbbCf-cH9O1XzAk2IA:9 a=wOGM8WdVIRTzxVLw1-gA:7 a=CjuIK1q_8ugA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: <linux-kernel@vger.kernel.org>, <linux@horizon.com>,
        <joakim.tjernlund@transmode.se>, <fzago@systemfabricworks.com>,
        <akpm@linux-foundation.org>
References: <4E40C5C7.2050609@systemfabricworks.com>
In-Reply-To: <4E40C5C7.2050609@systemfabricworks.com>
Subject: RE: [patch v3 7/7] crc32: final-cleanup.diff
Date: Tue, 9 Aug 2011 01:21:38 -0500
Message-ID: <00d401cc565c$98eeab60$cacc0220$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFUJhJtE0E7wgc4id8VkXG2Xj6UAJYEaynA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional comments.

 
> Some final cleanup changes
> 
> 	- added a comment at the top of crc32.c
> 	- moved macros ahead of function prototype
> 	- replaced loops with for (i = 0; i < xxx; i++) which
> 	  requires fewer instructions on x86 since the
> 	  buffer lookups can use i as an index.
> 
> -/* implements slicing-by-4 or slicing-by-8 algorithm */
> -static inline u32
> -crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32
> (*tab)[256])

After careful measurements and looking at asm code I figured out that there
was no penalty for using 2D array. That allowed me to go back to the
original form.

> -{
>  # ifdef __LITTLE_ENDIAN
>  #  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
> -#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
> -		tab[2][(crc >> 8) & 255] ^ \
> -		tab[1][(crc >> 16) & 255] ^ \
> -		tab[0][(crc >> 24) & 255]
> -#  define DO_CRC8a (tab[7][(q) & 255] ^ \
> -		tab[6][(q >> 8) & 255] ^ \
> -		tab[5][(q >> 16) & 255] ^ \
> -		tab[4][(q >> 24) & 255])
> -#  define DO_CRC8b (tab[3][(q) & 255] ^ \
> +#  define DO_CRC4 (tab[3][(q) & 255] ^ \
>  		tab[2][(q >> 8) & 255] ^ \
>  		tab[1][(q >> 16) & 255] ^ \
>  		tab[0][(q >> 24) & 255])

By changing the syntax a little so that the assignment is done down below
the 4 byte and 8 byte algorithms can share DO_CRC4.

> +#  define DO_CRC8 (tab[7][(q) & 255] ^ \
> +		tab[6][(q >> 8) & 255] ^ \
> +		tab[5][(q >> 16) & 255] ^ \
> +		tab[4][(q >> 24) & 255])
>  # else
>  #  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
> -#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
> -		tab[1][(crc >> 8) & 255] ^ \
> -		tab[2][(crc >> 16) & 255] ^ \
> -		tab[3][(crc >> 24) & 255]
> -#  define DO_CRC8a (tab[4][(q) & 255] ^ \
> -		tab[5][(q >> 8) & 255] ^ \
> -		tab[6][(q >> 16) & 255] ^ \
> -		tab[8][(q >> 24) & 255])
> -#  define DO_CRC8b (tab[0][(q) & 255] ^ \
> +#  define DO_CRC4 (tab[0][(q) & 255] ^ \
>  		tab[1][(q >> 8) & 255] ^ \
>  		tab[2][(q >> 16) & 255] ^ \
>  		tab[3][(q >> 24) & 255])
> +#  define DO_CRC8 (tab[4][(q) & 255] ^ \
> +		tab[5][(q >> 8) & 255] ^ \
> +		tab[6][(q >> 16) & 255] ^ \
> +		tab[7][(q >> 24) & 255])
>  # endif
> +
> +/* implements slicing-by-4 or slicing-by-8 algorithm */
> +static inline u32 crc32_body(u32 crc, unsigned char const *buf,
> +			     size_t len, const u32 (*tab)[256])
> +{
>  	const u32 *b;
> +	u8 *p;
> +	u32 q;
>  	size_t init_len;
>  	size_t middle_len;
>  	size_t rem_len;
> +	size_t i;
> 
>  	/* break buf into init_len bytes before and
>  	 * rem_len bytes after a middle section with
> @@ -96,37 +96,34 @@ crc32_body(u32 crc, unsigned char const
>  	rem_len = (len - init_len) & 7;
>  # endif
> 
> -	/* Align it */
> -	if (unlikely(init_len)) {
> -		do {
> -			DO_CRC(*buf++);
> -		} while (--init_len);
> -	}
> -	b = (const u32 *)buf;
> -	for (--b; middle_len; --middle_len) {
> +	/* process unaligned initial bytes */
> +	for (i = 0; i < init_len; i++)
> +		DO_CRC(*buf++);
> +
> +	/* process aligned words */
> +	b = (const u32 *)(buf - 4);
> +
> +	for (i = 0; i < middle_len; i++) {
>  # if CRC_LE_BITS == 32
> -		crc ^= *++b; /* use pre increment for speed */
> -		DO_CRC4;
> +		/* slicing-by-4 algorithm */
> +		q = crc ^ *++b; /* use pre increment for speed */
> +		crc = DO_CRC4;
>  # else
> -		u32 q;
> +		/* slicing-by-8 algorithm */
>  		q = crc ^ *++b;
> -		crc = DO_CRC8a;
> +		crc = DO_CRC8;
>  		q = *++b;
> -		crc ^= DO_CRC8b;
> +		crc ^= DO_CRC4;
>  # endif

This really shows how close the two algorithms are.

>  	}
> -	/* And the last few bytes */
> -	if (rem_len) {
> -		u8 *p = (u8 *)(b + 1) - 1;
> -		do {
> -			DO_CRC(*++p); /* use pre increment for speed */
> -		} while (--rem_len);
> -	}
> +
> +	/* process unaligned remaining bytes */
> +	p = (u8 *)(b + 1) - 1;
> +
> +	for (i = 0; i < rem_len; i++)
> +		DO_CRC(*++p); /* use pre increment for speed */
> +
>  	return crc;
> -#undef DO_CRC
> -#undef DO_CRC4
> -#undef DO_CRC8a
> -#undef DO_CRC8b
>  }
>  #endif


