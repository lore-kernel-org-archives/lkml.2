Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab1IAIQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:16:11 -0400
Received: from gw1.transmode.se ([195.58.98.146]:60831 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab1IAIQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:16:08 -0400
In-Reply-To: <4E5EB5EE.806@systemfabricworks.com>
References: <20110831213729.395283830@systemfabricworks.com> <4E5EB5EE.806@systemfabricworks.com>
Subject: Re: [PATCH v6 04/10] crc32-add-pointer-to-tab.diff
X-KeepSent: 50A5C1AE:3C914FB7-C12578FE:002C31F1;
 type=4; name=$KeepSent
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF50A5C1AE.3C914FB7-ONC12578FE.002C31F1-C12578FE.002D6AFD@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Thu, 1 Sep 2011 10:16:05 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 09/01/2011 10:16:04
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Pearson <rpearson@systemfabricworks.com> wrote on 2011/09/01 00:30:06:

> From: Bob Pearson <rpearson@systemfabricworks.com>
> To: linux-kernel@vger.kernel.org
> Cc: fzago@systemfabricworks.com, rpearson@systemfabricworks.com, Joakim Tjernlund <joakim.tjernlund@transmode.se>, George Spelvin <linux@horizon.com>, akpm@linux-foundation.org
> Date: 2011/09/01 00:30
> Subject: [PATCH v6 04/10] crc32-add-pointer-to-tab.diff
>
> Replace 2D array references by pointer references in loops.
> This change has no effect on X86 code but improves PPC
> performance.
>
> Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

Yes, this makes a significant difference on ppc32, your self test
went from
  crc32: self tests passed, processed 225944 bytes in 2257673 nsec
to
  crc32: self tests passed, processed 225944 bytes in 1949869 nsec
About 15% faster.

Technically this is my patch so I am adding my SOB:

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>

>
> ---
>  lib/crc32.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>
> Index: for-next/lib/crc32.c
> ===================================================================
> --- for-next.orig/lib/crc32.c
> +++ for-next/lib/crc32.c
> @@ -53,20 +53,21 @@ static inline u32
>  crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
>  {
>  # ifdef __LITTLE_ENDIAN
> -#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
> -#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
> -      tab[2][(crc >> 8) & 255] ^ \
> -      tab[1][(crc >> 16) & 255] ^ \
> -      tab[0][(crc >> 24) & 255]
> +#  define DO_CRC(x) (crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8))
> +#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
> +         t2[(crc >> 8) & 255] ^ \
> +         t1[(crc >> 16) & 255] ^ \
> +         t0[(crc >> 24) & 255]
>  # else
> -#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
> -#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
> -      tab[1][(crc >> 8) & 255] ^ \
> -      tab[2][(crc >> 16) & 255] ^ \
> -      tab[3][(crc >> 24) & 255]
> +#  define DO_CRC(x) (crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8))
> +#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
> +         t1[(crc >> 8) & 255] ^ \
> +         t2[(crc >> 16) & 255] ^ \
> +         t3[(crc >> 24) & 255]
>  # endif
>     const u32 *b;
>     size_t    rem_len;
> +   const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];
>
>     /* Align it */
>     if (unlikely((long)buf & 3 && len)) {
>
>

