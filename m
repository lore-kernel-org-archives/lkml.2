Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1HJV5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:57:22 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:37756 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127Ab1HJV5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:57:21 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=wzY9NJouJbkA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=Z4Rwk6OoAAAA:8 a=YORvzBCaAAAA:8 a=VwQbUJbxAAAA:8 a=azj6Gt-4AAAA:8 a=UT8pOMVxlroJaoNtCIwA:9 a=KXzkv4ImL0BTdsDyQC4A:7 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=VV2__AUApEoA:10 a=eJ1lpvm07AkA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        "'George Spelvin'" <linux@horizon.com>, <linux-kernel@vger.kernel.org>
References: <4E40C5C7.2050609@systemfabricworks.com> <00d401cc565c$98eeab60$cacc0220$@systemfabricworks.com> <OF4E555F7A.DF08D1FB-ONC12578E7.005FA1A8-C12578E7.0060F7CA@transmode.se> <019701cc56e8$e606f9c0$b214ed40$@systemfabricworks.com> <OF3719A120.AE2CD7D2-ONC12578E8.00342C83-C12578E8.00402A3E@transmode.se> <002601cc576f$ff062180$fd126480$@systemfabricworks.com> <OFD6F63A43.07F043D9-ONC12578E8.00565019-C12578E8.0056DB9D@transmode.se>
In-Reply-To: <OFD6F63A43.07F043D9-ONC12578E8.00565019-C12578E8.0056DB9D@transmode.se>
Subject: RE: [patch v3 7/7] crc32: final-cleanup.diff
Date: Wed, 10 Aug 2011 16:57:18 -0500
Message-ID: <008301cc57a8$79d6e330$6d84a990$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFUJhJtE0E7wgc4id8VkXG2Xj6UAAJcT3PpAdqTgv0BwaAE6gHro1xjAoaGgiACeXWlC5WfyVXQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joakim Tjernlund [mailto:joakim.tjernlund@transmode.se]
> Sent: Wednesday, August 10, 2011 10:49 AM
> To: Bob Pearson
> Cc: akpm@linux-foundation.org; fzago@systemfabricworks.com; 'George
> Spelvin'; linux-kernel@vger.kernel.org
> Subject: RE: [patch v3 7/7] crc32: final-cleanup.diff
> 
> "Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/10
> 17:13:00:
> 
> > From: "Bob Pearson" <rpearson@systemfabricworks.com>
> > To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
> > Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
> "'George Spelvin'" <linux@horizon.com>, <linux-kernel@vger.kernel.org>
> > Date: 2011/08/10 17:13
> > Subject: RE: [patch v3 7/7] crc32: final-cleanup.diff
> >
> > OK. Can you post your current version of crc32.c? I'll try to merge them
> > together.
> 
> OK, here it comes again, prefably this should be the first patch
> in the series.
> 
> From f5268d74f1a81610820e92785397f1247946ce15 Mon Sep 17 00:00:00 2001
> From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> Date: Fri, 5 Aug 2011 17:49:42 +0200
> Subject: [PATCH] crc32: Optimize inner loop.
> 
> taking a pointer reference to each row in the crc table matrix,
> one can reduce the inner loop with a few insn's on RISC
> archs like PowerPC.
> ---
>  lib/crc32.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/lib/crc32.c b/lib/crc32.c
> index 4855995..b06d1e7 100644
> --- a/lib/crc32.c
> +++ b/lib/crc32.c
> @@ -51,20 +51,21 @@ static inline u32
>  crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32
> (*tab)[256])
>  {
>  # ifdef __LITTLE_ENDIAN
> -#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
> -#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
> -		tab[2][(crc >> 8) & 255] ^ \
> -		tab[1][(crc >> 16) & 255] ^ \
> -		tab[0][(crc >> 24) & 255]
> +#  define DO_CRC(x) crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8)
> +#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
> +		t2[(crc >> 8) & 255] ^ \
> +		t1[(crc >> 16) & 255] ^ \
> +		t0[(crc >> 24) & 255]
>  # else
> -#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
> -#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
> -		tab[1][(crc >> 8) & 255] ^ \
> -		tab[2][(crc >> 16) & 255] ^ \
> -		tab[3][(crc >> 24) & 255]
> +#  define DO_CRC(x) crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
> +#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
> +		t1[(crc >> 8) & 255] ^  \
> +		t2[(crc >> 16) & 255] ^	\
> +		t3[(crc >> 24) & 255]
>  # endif
>  	const u32 *b;
>  	size_t    rem_len;
> +	const u32 *t0=tab[0], *t1=tab[1], *t2=tab[2], *t3=tab[3];
> 
>  	/* Align it */
>  	if (unlikely((long)buf & 3 && len)) {
> --
> 1.7.3.4

I tried this on X86_64 and Sparc 64. Very small improvement for Intel and
significant improvement for Sparc. Here are the results based on current
self test which is a mix of crc32_le and crc32_be with random offsets and
lengths:
Results are 'best case' I.e. I picked the shortest time from a handful of
runs.

	Arch		CPU		Freq		BITS	bytes
nsec		cycles/byte
	
____________________________________________________________________________
Current proposed patch
	X86_64		Intel E5520	2.268G		64	225944
161294		1.619
	X86_64		Intel E5520	2.268G		32	225944
267795		2.688
	Sun		Sparc III+	900M		64	225944
757235		3.028
	Sun		Sparc III+	900M		32	225944
935558		3.727
With pointers instead of 2D array references
	X86_64		E5520		2.268G		64	225944
157975		1.584
	X86_64		E5520		2.268M		32	225944
273366		2.744
	Sun		Sparc III+	900M		64	225944
570724		2.273
 	Sun		Sparc III+	900M		32	225944
848897		3.381

The change doesn't really help or hurt for X86_64 but significantly helps
Sparc and you report gains for PPC so it looks good.

