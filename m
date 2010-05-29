Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0E2MK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 08:10:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57610 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254Ab0E2MKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 08:10:25 -0400
Date: Sat, 29 May 2010 14:10:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: optimize mpage_readpage()
Message-ID: <20100529121019.GA25092@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Changli Gao <xiaosuo@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1275095926-18345-1-git-send-email-xiaosuo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1275095926-18345-1-git-send-email-xiaosuo@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, May 29, 2010 at 09:18:46AM +0800

> optimize mpage_readpage()
> 
> we don't need to initialize bio, and pass it to do_mpage_readpage() as
> parameter, as it is returned by do_mpage_readpage().
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  fs/mpage.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> diff --git a/fs/mpage.c b/fs/mpage.c
> index fd56ca2..94ff0d1 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -409,14 +409,14 @@ EXPORT_SYMBOL(mpage_readpages);
>   */
>  int mpage_readpage(struct page *page, get_block_t get_block)
>  {
> -	struct bio *bio = NULL;
> +	struct bio *bio;
>  	sector_t last_block_in_bio = 0;
>  	struct buffer_head map_bh;
>  	unsigned long first_logical_block = 0;
>  
>  	map_bh.b_state = 0;
>  	map_bh.b_size = 0;
> -	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
> +	bio = do_mpage_readpage(NULL, page, 1, &last_block_in_bio,
>  			&map_bh, &first_logical_block, get_block);
>  	if (bio)
>  		mpage_bio_submit(READ, bio);

Nope, I don't think that's a good idea.

On the one hand, this is a trick to shut up gcc:

fs/mpage.c: In function ‘mpage_readpage’:
fs/mpage.c:419: warning: ‘bio’ is used uninitialized in this function

and, on the other hand, make sure bio is NULL and not some random stack
value since bio is explicitly checked for NULL in do_mpage_readpage().

-- 
Regards/Gruss,
    Boris.
