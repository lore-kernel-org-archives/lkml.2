Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1ECVgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:36:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755372Ab1ECVgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:36:41 -0400
Date: Tue, 3 May 2011 14:36:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lasse Collin <lasse.collin@tukaani.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] XZ decompressor: Fix decoding of empty LZMA2 streams
Message-Id: <20110503143620.c6b4d272.akpm@linux-foundation.org>
In-Reply-To: <201105011938.42851.lasse.collin@tukaani.org>
References: <201105011938.42851.lasse.collin@tukaani.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 May 2011 19:38:42 +0300
Lasse Collin <lasse.collin@tukaani.org> wrote:

> From: Lasse Collin <lasse.collin@tukaani.org>
> 
> The old code considered valid empty LZMA2 streams to be corrupt.
> Note that a typical empty .xz file has no LZMA2 data at all,
> and thus most .xz files having no uncompressed data are handled
> correctly even without this fix.
> 
> Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>

The patch didn't have the cc:stable tag, but appears to be needed in
2.6.38.x and perhaps earlier, yes?

It's commit 646032e3b05b32d3f20cb108a030593d9d792eb5 in mainline.

> 
>  lib/xz/xz_dec_lzma2.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -uprN linux-2.6.39-rc5-git5.orig/lib/xz/xz_dec_lzma2.c linux-2.6.39-rc5-git5/lib/xz/xz_dec_lzma2.c
> --- linux-2.6.39-rc5-git5.orig/lib/xz/xz_dec_lzma2.c	2011-05-01 17:56:38.000000000 +0300
> +++ linux-2.6.39-rc5-git5/lib/xz/xz_dec_lzma2.c	2011-05-01 18:06:03.000000000 +0300
> @@ -969,6 +969,9 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(s
>  			 */
>  			tmp = b->in[b->in_pos++];
>  
> +			if (tmp == 0x00)
> +				return XZ_STREAM_END;
> +
>  			if (tmp >= 0xE0 || tmp == 0x01) {
>  				s->lzma2.need_props = true;
>  				s->lzma2.need_dict_reset = false;
> @@ -1001,9 +1004,6 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(s
>  						lzma_reset(s);
>  				}
>  			} else {
> -				if (tmp == 0x00)
> -					return XZ_STREAM_END;
> -
>  				if (tmp > 0x02)
>  					return XZ_DATA_ERROR;
>  
