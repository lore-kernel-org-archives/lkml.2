Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab0JYXLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:11:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab0JYXLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:11:47 -0400
Date: Mon, 25 Oct 2010 16:11:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED] fs/buffer.c: call __block_write_begin() if we
 have page
Message-Id: <20101025161137.5f0b642d.akpm@linux-foundation.org>
In-Reply-To: <1287850314-13663-1-git-send-email-namhyung@gmail.com>
References: <1287848786-13347-1-git-send-email-namhyung@gmail.com>
	<1287850314-13663-1-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Oct 2010 01:11:54 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> If we have the appropriate page already, call __block_write_begin()
> directly instead of releasing and regrabbing it inside of
> block_write_begin().
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
> Fix error path.
> 
>  fs/buffer.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 7f0b9b0..f5755f7 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2466,11 +2466,13 @@ int nobh_write_begin(struct address_space *mapping,
>  	*fsdata = NULL;
>  
>  	if (page_has_buffers(page)) {
> -		unlock_page(page);
> -		page_cache_release(page);
> -		*pagep = NULL;
> -		return block_write_begin(mapping, pos, len, flags, pagep,
> -					 get_block);
> +		ret = __block_write_begin(page, pos, len, get_block);
> +		if (unlikely(ret)) {
> +			unlock_page(page);
> +			page_cache_release(page);
> +			*pagep = NULL;
> +		}
> +		return ret;
>  	}
>  
>  	if (PageMappedToDisk(page))

It looks OK.  Was it tested?  (ext2 mounted with -o nobh)
