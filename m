Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1AXWou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:44:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556Ab1AXWot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:44:49 -0500
Date: Mon, 24 Jan 2011 14:43:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SquashFS, XZ: Don't use uninitialized variable in
 squashfs_xz_uncompress
Message-Id: <20110124144353.c04c77b4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1101202140070.11854@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101202140070.11854@swampdragon.chaosbits.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 21:53:23 +0100 (CET)
Jesper Juhl <jj@chaosbits.net> wrote:

> In fs/squashfs/xz_wrapper.c::squashfs_xz_uncompress() we have this code:
> 
> 	enum xz_ret xz_err;
> 	...
> 	do {
> 		if (stream->buf.in_pos == stream->buf.in_size && k < b) {
> 		... [nothing that assigns to 'xz_err'] ...
> 			if (avail == 0) {
> 				offset = 0;
> 				put_bh(bh[k++]);
> 				continue;
> 			}
> 		...
> 	} while (xz_err == XZ_OK);
> 
> If we hit that 'continue' statement the first time through, then the 
> 'while' condition will be testing an uninitialized 'xz_err' - not what we 
> want.
> 
> This patch should take care of the problem by making sure that 'xz_err' is 
> initialized to 'XZ_OK' at the start of the function.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  xz_wrapper.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
>   compile tested only.
> 
> diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
> index 856756c..daf76c3 100644
> --- a/fs/squashfs/xz_wrapper.c
> +++ b/fs/squashfs/xz_wrapper.c
> @@ -74,7 +74,7 @@ static int squashfs_xz_uncompress(struct squashfs_sb_info *msblk, void **buffer,
>  	struct buffer_head **bh, int b, int offset, int length, int srclength,
>  	int pages)
>  {
> -	enum xz_ret xz_err;
> +	enum xz_ret xz_err = XZ_OK;
>  	int avail, total = 0, k = 0, page = 0;
>  	struct squashfs_xz *stream = msblk->stream;
>  

hm, maybe.  The handling of the `avail == 0' case looks odd.  It sits
there in a loop doing wait_on_buffer() against buffers which it will
never use and possible reporting -EIO for a buffer which it didn't use,
which seems bogus.

Phillip, please check?
