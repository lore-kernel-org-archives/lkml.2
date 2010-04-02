Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0DBV53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 17:57:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028Ab0DBV5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 17:57:23 -0400
Date: Fri, 2 Apr 2010 14:57:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-kernel@vger.kernel.org, hsweeten@visionengravers.com, hpa@zytor.com,
       eric.piel@tremplin-utc.net, stable <stable@kernel.org>
Subject: Re: [PATCH] initramfs: prevent buffer overflow when unpacking to
 rootfs
Message-Id: <20100402145702.fb9ccfdc.akpm@linux-foundation.org>
In-Reply-To: <1270115146-25342-1-git-send-email-aaro.koskinen@iki.fi>
References: <1270115146-25342-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Apr 2010 12:45:46 +0300
Aaro Koskinen <aaro.koskinen@iki.fi> wrote:

> Garbage in the initrd memory area may result in the unpack routine
> accessing memory outside the buffer. The patch adds a check that the
> specified area size is not exceeded.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: stable <stable@kernel.org>
> ---
> 
> The patch prevents the following kernel panic on Amstrad E3:
> 
> 	Unpacking initramfs...
> 	Unable to handle kernel paging request at virtual address c20121a7
>
> ...
>
> --- a/init/initramfs.c
> +++ b/init/initramfs.c
> @@ -460,6 +460,8 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
>  		}
>  		if (state != Reset)
>  			error("junk in compressed archive");
> +		if (my_inptr >= len)
> +			break;
>  		this_header = saved_offset + my_inptr;
>  		buf += my_inptr;
>  		len -= my_inptr;

OK, so if I'm understanding this right, the call to

	decompress(buf, len, NULL, flush_buffer, NULL, &my_inptr, error);

has gone and generated more output data than it was asked to generate?

If so, isn't that a bug in the decompressor?  Which one is your system using?

[ wonders why my_inptr is static, and why the sixth arg to decompress_fn
  takes an int* while callers are passing in an unsigned* ]

