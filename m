Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1HIRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:09:59 -0400
Received: from gw1.transmode.se ([195.58.98.146]:37892 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab1HIRJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:09:58 -0400
In-Reply-To: <4E40C4DD.90109@systemfabricworks.com>
References: <4E40C4DD.90109@systemfabricworks.com>
Subject: Re: [patch v3 5/7] crc32: add-real-8-bit.diff
X-KeepSent: 7D1699A1:9B1BD547-C12578E7:005DB5FE;
 type=4; name=$KeepSent
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com, linux@horizon.com,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF7D1699A1.9B1BD547-ONC12578E7.005DB5FE-C12578E7.005E4AEB@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 9 Aug 2011 19:09:55 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/09/2011 19:09:56
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Bob Pearson <rpearson@systemfabricworks.com> wrote on 2011/08/09 07:25:49:

> From: Bob Pearson <rpearson@systemfabricworks.com>
> To: linux-kernel@vger.kernel.org, linux@horizon.com, joakim.tjernlund@transmode.se, fzago@systemfabricworks.com, rpearson@systemfabricworks.com, akpm@linux-foundation.org
> Date: 2011/08/09 07:25
> Subject: [patch v3 5/7] crc32: add-real-8-bit.diff
>
> crc32.c encodes an algorithm that processes 32 bits at a time
> with the value BITS = 8 and leaves out the most common 8 bit algorithm
> for computing the crc. This patch reencodes the 32 bit algorithm
> with the value 32 and adds back the 'standard' 8 bit algorithm.
>
> Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
>
> ---
>  lib/crc32.c          |   17 ++++++++++++++---
>  lib/crc32defs.h      |   18 ++++++++++--------
>  lib/gen_crc32table.c |   27 ++++++++++++++++++---------
>  3 files changed, 42 insertions(+), 20 deletions(-)
>

...

> ===================================================================
> --- infiniband.orig/lib/gen_crc32table.c
> +++ infiniband/lib/gen_crc32table.c
> @@ -4,11 +4,20 @@
>
>  #define ENTRIES_PER_LINE 4
>
> +#if CRC_LE_BITS <= 8
>  #define LE_TABLE_SIZE (1 << CRC_LE_BITS)
> +#else
> +#define LE_TABLE_SIZE 256
> +#endif
> +
> +#if CRC_BE_BITS <= 8
>  #define BE_TABLE_SIZE (1 << CRC_BE_BITS)
> +#else
> +#define BE_TABLE_SIZE 256
> +#endif
>
> -static uint32_t crc32table_le[4][LE_TABLE_SIZE];
> -static uint32_t crc32table_be[4][BE_TABLE_SIZE];
> +static uint32_t crc32table_le[8][256];
> +static uint32_t crc32table_be[8][256];

Above is wrong as only 32 bits is supported at this point.

>
>  /**
>   * crc32init_le() - allocate and initialize LE table data
> @@ -24,14 +33,14 @@ static void crc32init_le(void)
>
>     crc32table_le[0][0] = 0;
>
> -   for (i = 1 << (CRC_LE_BITS - 1); i; i >>= 1) {
> +   for (i = LE_TABLE_SIZE >> 1; i; i >>= 1) {
>        crc = (crc >> 1) ^ ((crc & 1) ? CRCPOLY_LE : 0);
>        for (j = 0; j < LE_TABLE_SIZE; j += 2 * i)
>           crc32table_le[0][i + j] = crc ^ crc32table_le[0][j];
>     }
>     for (i = 0; i < LE_TABLE_SIZE; i++) {
>        crc = crc32table_le[0][i];
> -      for (j = 1; j < 4; j++) {
> +      for (j = 1; j < 8; j++) {
>           crc = crc32table_le[0][crc & 0xff] ^ (crc >> 8);
>           crc32table_le[j][i] = crc;
>        }
> @@ -55,18 +64,18 @@ static void crc32init_be(void)
>     }
>     for (i = 0; i < BE_TABLE_SIZE; i++) {
>        crc = crc32table_be[0][i];
> -      for (j = 1; j < 4; j++) {
> +      for (j = 1; j < 8; j++) {
>           crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
>           crc32table_be[j][i] = crc;
>        }
>     }
>  }
>
> -static void output_table(uint32_t table[4][256], int len, char *trans)
> +static void output_table(uint32_t table[8][256], int len, char *trans)
>  {
>     int i, j;
>
> -   for (j = 0 ; j < 4; j++) {
> +   for (j = 0 ; j < 8; j++) {
>        printf("{");
>        for (i = 0; i < len - 1; i++) {
>           if (i % ENTRIES_PER_LINE == 0)
> @@ -83,14 +92,14 @@ int main(int argc, char** argv)
>
>     if (CRC_LE_BITS > 1) {
>        crc32init_le();
> -      printf("static const u32 crc32table_le[4][256] = {");
> +      printf("static const u32 crc32table_le[8][256] = {");

This makes the table way to big.

>        output_table(crc32table_le, LE_TABLE_SIZE, "tole");
>        printf("};\n");
>     }
>
>     if (CRC_BE_BITS > 1) {
>        crc32init_be();
> -      printf("static const u32 crc32table_be[4][256] = {");
> +      printf("static const u32 crc32table_be[8][256] = {");
Ditto.

>        output_table(crc32table_be, BE_TABLE_SIZE, "tobe");
>        printf("};\n");
>     }

