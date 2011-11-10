Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1KJAPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:15:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab1KJAPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:15:41 -0500
Date: Wed, 9 Nov 2011 16:15:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: <linux-kernel@vger.kernel.org>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Frank Zago <fzago@systemfabricworks.com>
Subject: Re: [PATCH] crc32: Optimize inner loop.
Message-Id: <20111109161539.b2cdf381.akpm@linux-foundation.org>
In-Reply-To: <1320312505-30612-1-git-send-email-Joakim.Tjernlund@transmode.se>
References: <1320312505-30612-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011 10:28:25 +0100
Joakim Tjernlund <Joakim.Tjernlund@transmode.se> wrote:

> taking a pointer reference to each row in the crc table matrix,
> one can reduce the inner loop with a few insn's
> 
> Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

As we have other developers who have previously shown an interest in
the crc32 code it is a good idea to cc them on future patches to get a
bit more review and perhaps testing input.

This patch seems fairly harmless.  Some runtime testing results would
have been appropriate.

Also, something like "reduce a few insns" is extremely easy to
substantiate, so why not do it?  With my compiler, the patch reduces
the crc32.o text by 22 bytes.

>  As the slice by 8 CRC32 optimizations seems stalled, I figured
>  I send in this generic one.

I meant to ask about that.  The discussion was fairly long and complex
and I'm now unsure whether the patch I have is a still up-to-date,
whether it is a good one, whether it has additional testing results,
etc.

So probably the best thing to do now is for me to drop it.  Please
resend when convenient.  Be sure to cc all previous reviewers and also
update the changelog to cover any important issues which were
brought up in the review.  This is to show what the issues were, how
they were addressed, etc.

Thanks.

> index 4855995..b06d1e7 100644
> --- a/lib/crc32.c
> +++ b/lib/crc32.c
> @@ -51,20 +51,21 @@ static inline u32
>  crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
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

