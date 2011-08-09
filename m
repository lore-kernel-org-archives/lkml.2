Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1HIRWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:22:00 -0400
Received: from gw1.transmode.se ([195.58.98.146]:42950 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1HIRV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:21:59 -0400
In-Reply-To: <4E40C55F.8070703@systemfabricworks.com>
References: <4E40C55F.8070703@systemfabricworks.com>
Subject: Re: [patch v3 6/7] crc32: add-slicing-by-8.diff
X-KeepSent: BF50514E:82734B36-C12578E7:005E58EE;
 type=4; name=$KeepSent
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com, linux@horizon.com,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFBF50514E.82734B36-ONC12578E7.005E58EE-C12578E7.005F648F@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 9 Aug 2011 19:21:56 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/09/2011 19:21:56
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bob Pearson <rpearson@systemfabricworks.com> wrote on 2011/08/09 07:27:59:
>
> add slicing-by-8 algorithm to the existing
> slicing-by-4 algorithm. This consists of:
>
>    - extend largest BITS size from 32 to 64
>    - extend table from tab[4][256] to tab[8][256]
>    - change algorithm to align on 8 byte boundary
>      (it was noted that all that is really required
>      is that the inner loop must comsume 8 bytes.
>      As written it can start on even or odd 4 byte
>      boundary.)
So why not do that in the code too?

>    - Add code for inner loop.
>
> Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
>
> ---
>  lib/crc32.c          |   58 ++++++++++++++++++++++++++++++++++++++++++---------
>  lib/crc32defs.h      |   14 ++++++------
>  lib/gen_crc32table.c |   40 +++++++++++++++++++++--------------
>  3 files changed, 79 insertions(+), 33 deletions(-)
>
> Index: infiniband/lib/crc32.c
> ===================================================================
> --- infiniband.orig/lib/crc32.c
> +++ infiniband/lib/crc32.c
> @@ -45,6 +45,7 @@ MODULE_LICENSE("GPL");
>
>  #if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
>
> +/* implements slicing-by-4 or slicing-by-8 algorithm */
>  static inline u32
>  crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
>  {
> @@ -54,41 +55,78 @@ crc32_body(u32 crc, unsigned char const
>        tab[2][(crc >> 8) & 255] ^ \
>        tab[1][(crc >> 16) & 255] ^ \
>        tab[0][(crc >> 24) & 255]
> +#  define DO_CRC8a (tab[7][(q) & 255] ^ \
> +      tab[6][(q >> 8) & 255] ^ \
> +      tab[5][(q >> 16) & 255] ^ \
> +      tab[4][(q >> 24) & 255])
> +#  define DO_CRC8b (tab[3][(q) & 255] ^ \
> +      tab[2][(q >> 8) & 255] ^ \
> +      tab[1][(q >> 16) & 255] ^ \
> +      tab[0][(q >> 24) & 255])
>  # else
>  #  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
>  #  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
>        tab[1][(crc >> 8) & 255] ^ \
>        tab[2][(crc >> 16) & 255] ^ \
>        tab[3][(crc >> 24) & 255]
> +#  define DO_CRC8a (tab[4][(q) & 255] ^ \
> +      tab[5][(q >> 8) & 255] ^ \
> +      tab[6][(q >> 16) & 255] ^ \
> +      tab[8][(q >> 24) & 255])
> +#  define DO_CRC8b (tab[0][(q) & 255] ^ \
> +      tab[1][(q >> 8) & 255] ^ \
> +      tab[2][(q >> 16) & 255] ^ \
> +      tab[3][(q >> 24) & 255])
>  # endif
>     const u32 *b;
> -   size_t    rem_len;
> +   size_t init_len;
> +   size_t middle_len;
> +   size_t rem_len;
> +
> +   /* break buf into init_len bytes before and
> +    * rem_len bytes after a middle section with
> +    * middle_len properly aligned words */
> +# if CRC_LE_BITS == 32
> +   init_len = min((-((uintptr_t)buf)) & 3, len);
> +   middle_len = (len - init_len) >> 2;
> +   rem_len = (len - init_len) & 3;
> +# else
> +   init_len = min((-((uintptr_t)buf)) & 7, len);
> +   middle_len = (len - init_len) >> 3;
> +   rem_len = (len - init_len) & 7;
> +# endif
>
>     /* Align it */
> -   if (unlikely((long)buf & 3 && len)) {
> +   if (unlikely(init_len)) {
>        do {
>           DO_CRC(*buf++);
> -      } while ((--len) && ((long)buf)&3);
> +      } while (--init_len);
>     }

As discussed earlier, don't change initial loop. Best left alone unless
you have verified it generates better code.

> -   rem_len = len & 3;
> -   /* load data 32 bits wide, xor data 32 bits wide. */
> -   len = len >> 2;
>     b = (const u32 *)buf;
> -   for (--b; len; --len) {
> +   for (--b; middle_len; --middle_len) {
> +# if CRC_LE_BITS == 32
>        crc ^= *++b; /* use pre increment for speed */
>        DO_CRC4;
> +# else
> +      u32 q;
> +      q = crc ^ *++b;
> +      crc = DO_CRC8a;
> +      q = *++b;
> +      crc ^= DO_CRC8b;
> +# endif
>     }
> -   len = rem_len;
>     /* And the last few bytes */
> -   if (len) {
> +   if (rem_len) {
>        u8 *p = (u8 *)(b + 1) - 1;
>        do {
>           DO_CRC(*++p); /* use pre increment for speed */
> -      } while (--len);
> +      } while (--rem_len);
>     }
>     return crc;
>  #undef DO_CRC
>  #undef DO_CRC4
> +#undef DO_CRC8a
> +#undef DO_CRC8b
>  }
>  #endif
>
> Index: infiniband/lib/crc32defs.h
> ===================================================================
> --- infiniband.orig/lib/crc32defs.h
> +++ infiniband/lib/crc32defs.h
> @@ -6,29 +6,29 @@
>  #define CRCPOLY_LE 0xedb88320
>  #define CRCPOLY_BE 0x04c11db7
>
> -/* How many bits at a time to use.  Valid values are 1, 2, 4, 8, and 32. */
> +/* How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64. */
>  /* For less performance-sensitive, use 4 or 8 */
>  #ifndef CRC_LE_BITS
> -# define CRC_LE_BITS 32
> +# define CRC_LE_BITS 64

64 bits as default for all archs? Not very likely, especially
as I already told you that 64 bits made my ppc32 drop to
half the size.

>  #endif
>  #ifndef CRC_BE_BITS
> -# define CRC_BE_BITS 32
> +# define CRC_BE_BITS 64
>  #endif
>
>  /*
>   * Little-endian CRC computation.  Used with serial bit streams sent
>   * lsbit-first.  Be sure to use cpu_to_le32() to append the computed CRC.
>   */
> -#if CRC_LE_BITS > 32 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
> +#if CRC_LE_BITS > 64 || CRC_LE_BITS < 1 || CRC_LE_BITS == 16 || \
>     CRC_LE_BITS & CRC_LE_BITS-1
> -# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 32}"
> +# error "CRC_LE_BITS must be one of {1, 2, 4, 8, 64}"

32 is missing

>  #endif
>
>  /*
>   * Big-endian CRC computation.  Used with serial bit streams sent
>   * msbit-first.  Be sure to use cpu_to_be32() to append the computed CRC.
>   */
> -#if CRC_BE_BITS > 32 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
> +#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS == 16 || \
>     CRC_BE_BITS & CRC_BE_BITS-1
> -# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32}"
> +# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 64}"

Ditto.

>  #endif
> Index: infiniband/lib/gen_crc32table.c
> ===================================================================
> --- infiniband.orig/lib/gen_crc32table.c
> +++ infiniband/lib/gen_crc32table.c
> @@ -4,20 +4,24 @@
>
>  #define ENTRIES_PER_LINE 4
>
> -#if CRC_LE_BITS <= 8
> -#define LE_TABLE_SIZE (1 << CRC_LE_BITS)
> +#if CRC_LE_BITS > 8
> +# define LE_TABLE_ROWS (CRC_LE_BITS/8)
> +# define LE_TABLE_SIZE 256
>  #else
> -#define LE_TABLE_SIZE 256
> +# define LE_TABLE_ROWS 1
> +# define LE_TABLE_SIZE (1 << CRC_LE_BITS)
>  #endif
>
> -#if CRC_BE_BITS <= 8
> -#define BE_TABLE_SIZE (1 << CRC_BE_BITS)
> +#if CRC_BE_BITS > 8
> +# define BE_TABLE_ROWS (CRC_BE_BITS/8)
> +# define BE_TABLE_SIZE 256
>  #else
> -#define BE_TABLE_SIZE 256
> +# define BE_TABLE_ROWS 1
> +# define BE_TABLE_SIZE (1 << CRC_BE_BITS)
>  #endif
>
> -static uint32_t crc32table_le[8][256];
> -static uint32_t crc32table_be[8][256];
> +static uint32_t crc32table_le[LE_TABLE_ROWS][256];
> +static uint32_t crc32table_be[BE_TABLE_ROWS][256];

256 should be XX_TABLE_SIZE

>
>  /**
>   * crc32init_le() - allocate and initialize LE table data
> @@ -40,7 +44,7 @@ static void crc32init_le(void)
>     }
>     for (i = 0; i < LE_TABLE_SIZE; i++) {
>        crc = crc32table_le[0][i];
> -      for (j = 1; j < 8; j++) {
> +      for (j = 1; j < LE_TABLE_ROWS; j++) {
>           crc = crc32table_le[0][crc & 0xff] ^ (crc >> 8);
>           crc32table_le[j][i] = crc;
>        }
> @@ -64,18 +68,18 @@ static void crc32init_be(void)
>     }
>     for (i = 0; i < BE_TABLE_SIZE; i++) {
>        crc = crc32table_be[0][i];
> -      for (j = 1; j < 8; j++) {
> +      for (j = 1; j < BE_TABLE_ROWS; j++) {
>           crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
>           crc32table_be[j][i] = crc;
>        }
>     }
>  }
>
> -static void output_table(uint32_t table[8][256], int len, char *trans)
> +static void output_table(uint32_t (*table)[256], int rows, int len, char *trans)

Size is not always 256.

>  {
>     int i, j;
>
> -   for (j = 0 ; j < 8; j++) {
> +   for (j = 0 ; j < rows; j++) {
>        printf("{");
>        for (i = 0; i < len - 1; i++) {
>           if (i % ENTRIES_PER_LINE == 0)
> @@ -92,15 +96,19 @@ int main(int argc, char** argv)
>
>     if (CRC_LE_BITS > 1) {
>        crc32init_le();
> -      printf("static const u32 crc32table_le[8][256] = {");
> -      output_table(crc32table_le, LE_TABLE_SIZE, "tole");
> +      printf("static const u32 crc32table_le[%d][%d] = {",
> +             LE_TABLE_ROWS, LE_TABLE_SIZE);
> +      output_table(crc32table_le, LE_TABLE_ROWS,
> +              LE_TABLE_SIZE, "tole");
>        printf("};\n");
>     }
>
>     if (CRC_BE_BITS > 1) {
>        crc32init_be();
> -      printf("static const u32 crc32table_be[8][256] = {");
> -      output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
> +      printf("static const u32 crc32table_be[%d][%d] = {",
> +             BE_TABLE_ROWS, BE_TABLE_SIZE);
> +      output_table(crc32table_be, LE_TABLE_ROWS,
> +              BE_TABLE_SIZE, "tobe");
>        printf("};\n");
>     }
>

