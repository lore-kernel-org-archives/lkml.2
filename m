Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1IGToI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:44:08 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:44782 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161Ab1IGToG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:44:06 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=xO0yJxRua38A:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=Z4Rwk6OoAAAA:8 a=YORvzBCaAAAA:8 a=VwQbUJbxAAAA:8 a=EezHunaUZ7hFXId9htQA:9 a=h9OX2j0IclOK23BT_yAA:7 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=VV2__AUApEoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        "'George Spelvin'" <linux@horizon.com>, <linux-kernel@vger.kernel.org>
References: <20110831213729.395283830@systemfabricworks.com> <4E5EB608.3000905@systemfabricworks.com> <OF3D37A60B.7A33B855-ONC1257904.00276B5B-C1257904.002951AF@transmode.se>
In-Reply-To: <OF3D37A60B.7A33B855-ONC1257904.00276B5B-C1257904.002951AF@transmode.se>
Subject: RE: [PATCH v6 08/10] crc32-add-slicing-by-8.diff
Date: Wed, 7 Sep 2011 14:44:02 -0500
Message-ID: <03bc01cc6d96$7f3cba30$7db62e90$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJdND57YfohkECc5nAnrPUtKDDU5gJXC2PMAiY/az+T/NewsA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joakim Tjernlund [mailto:joakim.tjernlund@transmode.se]
> Sent: Wednesday, September 07, 2011 2:31 AM
> To: Bob Pearson
> Cc: akpm@linux-foundation.org; fzago@systemfabricworks.com; George
> Spelvin; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v6 08/10] crc32-add-slicing-by-8.diff
> 
> Bob Pearson <rpearson@systemfabricworks.com> wrote on 2011/09/01
> 00:30:32:
> >
> > add slicing-by-8 algorithm to the existing
> > slicing-by-4 algorithm. This consists of:
> >    - extend largest BITS size from 32 to 64
> >    - extend tables from tab[4][256] to up to tab[8][256]
> >    - Add code for inner loop.
> >
> > Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
> >
> > ---
> >  lib/crc32.c          |   40 ++++++++++++++++++++++++++++------------
> >  lib/crc32defs.h      |   29 +++++++++++++++++++++--------
> >  lib/gen_crc32table.c |   43 +++++++++++++++++++++++++++----------------
> >  3 files changed, 76 insertions(+), 36 deletions(-)
> >
> > Index: for-next/lib/crc32.c
> >
> ==========================================================
> =========
> > --- for-next.orig/lib/crc32.c
> > +++ for-next/lib/crc32.c
> > @@ -47,25 +47,28 @@ MODULE_LICENSE("GPL");
> >
> >  #if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
> >
> > +/* implements slicing-by-4 or slicing-by-8 algorithm */
> >  static inline u32
> >  crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32
> (*tab)[256])
> >  {
> >  # ifdef __LITTLE_ENDIAN
> >  #  define DO_CRC(x) (crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8))
> > -#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
> > -         t2[(crc >> 8) & 255] ^ \
> > -         t1[(crc >> 16) & 255] ^ \
> > -         t0[(crc >> 24) & 255]
> > +#  define DO_CRC4 (t3[(q) & 255] ^ t2[(q >> 8) & 255] ^ \
> > +         t1[(q >> 16) & 255] ^ t0[(q >> 24) & 255])
> > +#  define DO_CRC8 (t7[(q) & 255] ^ t6[(q >> 8) & 255] ^ \
> > +         t5[(q >> 16) & 255] ^ t4[(q >> 24) & 255])
> >  # else
> >  #  define DO_CRC(x) (crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8))
> > -#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
> > -         t1[(crc >> 8) & 255] ^ \
> > -         t2[(crc >> 16) & 255] ^ \
> > -         t3[(crc >> 24) & 255]
> > +#  define DO_CRC4 (t0[(q) & 255] ^ t1[(q >> 8) & 255] ^ \
> > +         t2[(q >> 16) & 255] ^ t3[(q >> 24) & 255])
> > +#  define DO_CRC8 (t4[(q) & 255] ^ t5[(q >> 8) & 255] ^ \
> > +         t6[(q >> 16) & 255] ^ t7[(q >> 24) & 255])
> 
> Don't like the new DO_CRC8 macro. You could get by with my earlier
> suggestion:
> #  define DO_CRC4(crc, x0, x1, x2, x3) \
> 		x3[(crc) & 255] ^		\
> 		x2[(crc >> 8) & 255] ^	\
> 		x1[(crc >> 16) & 255] ^ \
> 		x0[(crc >> 24) & 255]
> 
> Then the code becomes something like
> if (bits == 64) {
> 		crc = DO_CRC4(crc, t4, t5, t6, t7);
> 		++b;
> 		crc ^= DO_CRC4(*b, t0, t1, t2, t3);
> } else
> 		crc = DO_CRC4(crc, t0, t1, t2, t3);

OK by me.

> 
> >  # endif
> >     const u32 *b;
> > -   size_t    rem_len;
> > +   size_t rem_len;
> >     const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];
> > +   const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
> 
> t4 to t7 is only used in 64 bit mode.

Yes but with the CEC_XX_BITS->bits change this point is moot.

> 
> BTW, it the 64 CRC bits on 32 bits BE arch bug fixed?

I have a 64 bit sparc machine and a bunch of x86 variants. As far as I am
able to tell these are working for  all the different algorithms.
If you have a 32 bit PPC machine please try to see if this is still a
problem.

> 
> > +   u32 q;
> >
> >     /* Align it */
> >     if (unlikely((long)buf & 3 && len)) {
> > @@ -73,13 +76,25 @@ crc32_body(u32 crc, unsigned char const
> >           DO_CRC(*buf++);
> >        } while ((--len) && ((long)buf)&3);
> >     }
> > +
> > +# if CRC_LE_BITS == 32
> >     rem_len = len & 3;
> > -   /* load data 32 bits wide, xor data 32 bits wide. */
> >     len = len >> 2;
> > +# else
> > +   rem_len = len & 7;
> > +   len = len >> 3;
> 
> I still fail to see why this is needed. You still do 32 bit loads so this
> only makes the code uglier, harder to maintain and makes small unaligned
crc
> bufs
> slower.

You suggested and I changed the initial alignment code to pick the first
available 4 byte boundary.
After that, the inner loop consumes respectively 4 or 8 bytes of data per
iteration for the 32/64 version of the algorithm. So the computation of len
and rem_len *must* be made differently in the two cases.

> 
> ....
> 
> > Index: for-next/lib/gen_crc32table.c
> >
> ==========================================================
> =========
> > --- for-next.orig/lib/gen_crc32table.c
> > +++ for-next/lib/gen_crc32table.c
> > @@ -1,23 +1,28 @@
> ..
> >
> > -static void output_table(uint32_t (*table)[256], int len, char *trans)
> > +static void output_table(uint32_t (*table)[256], int rows, int len,
char
> *trans)
> 
> This table is not always 256 entries. I suggested a cleaner impl. earlier.
> Something like this:
> 
> -static void output_table(uint32_t table[4][256], int len, char *trans)
> +static void output_table(uint32_t table[], int len, char *trans)
>  {
> -	int i, j;
> -
> -	for (j = 0 ; j < 4; j++) {
> -		printf("{");
> -		for (i = 0; i < len - 1; i++) {
> -			if (i % ENTRIES_PER_LINE == 0)
> -				printf("\n");
> -			printf("%s(0x%8.8xL), ", trans, table[j][i]);
> -		}
> -		printf("%s(0x%8.8xL)},\n", trans, table[j][len - 1]);
> +	int i;
> +
> +	printf("{");
> +	for (i = 0; i < len - 1; i++) {
> +		if (i % ENTRIES_PER_LINE == 0)
> +			printf("\n");
> +		printf("%s(0x%8.8xL), ", trans, table[i]);
>  	}
> +	printf("%s(0x%8.8xL)},\n", trans, table[len - 1]);
>  }
> 
>  int main(int argc, char** argv)
>  {
> +	int i;
> +
>  	printf("/* this file is generated - do not edit */\n\n");
> 
>  	if (CRC_LE_BITS > 1) {
>  		crc32init_le();
> -		printf("static const u32 crc32table_le[4][256] = {");
> -		output_table(crc32table_le, LE_TABLE_SIZE, "tole");
> +		printf("static const u32 crc32table_le[%d][%d] = {",
> +		       LE_TABLE_ROWS, LE_TABLE_SIZE);
> +		for (i = 0 ; i < LE_TABLE_ROWS; i++)
> +			output_table(crc32table_le[i], LE_TABLE_SIZE,
> "tole");
>  		printf("};\n");
>  	}
> 
>  	if (CRC_BE_BITS > 1) {
>  		crc32init_be();
> -		printf("static const u32 crc32table_be[4][256] = {");
> -		output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
> +		printf("static const u32 crc32table_be[%d][%d] = {",
> +		       BE_TABLE_ROWS, BE_TABLE_SIZE);
> +		for (i = 0 ; i < BE_TABLE_ROWS; i++)
> +			output_table(crc32table_be[i], BE_TABLE_SIZE,
> "tobe");
>  		printf("};\n");
>  	}
> 


