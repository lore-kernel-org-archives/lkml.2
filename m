Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0E2Mrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 08:47:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59745 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab0E2Mrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 08:47:39 -0400
Date: Sat, 29 May 2010 14:47:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fs: optimize mpage_bio_submit()
Message-ID: <20100529124735.GB25092@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Changli Gao <xiaosuo@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1275095966-18382-1-git-send-email-xiaosuo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1275095966-18382-1-git-send-email-xiaosuo@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, May 29, 2010 at 09:19:26AM +0800

> optimize mpage_bio_submit()
> 
> check rw, then initialize bio->bi_end_io.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  fs/mpage.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 94ff0d1..632681c 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -85,9 +85,7 @@ static void mpage_end_io_write(struct bio *bio, int err)
>  
>  static struct bio *mpage_bio_submit(int rw, struct bio *bio)
>  {
> -	bio->bi_end_io = mpage_end_io_read;
> -	if (rw == WRITE)
> -		bio->bi_end_io = mpage_end_io_write;
> +	bio->bi_end_io = rw != WRITE ? mpage_end_io_read : mpage_end_io_write;
>  	submit_bio(rw, bio);
>  	return NULL;

ok, can you sincerely tell me that your change makes the code more
readable? And have you checked to see what the compiler actually
"optimizes"?

original code:

	movq	$mpage_end_io_read, %rdx	#, tmp65
	movq	$mpage_end_io_write, %rax	#, tmp64
	cmpl	$1, %edi	#, rw
	cmovne	%rdx, %rax	# tmp65,, tmp64
	movq	%rax, 80(%rsi)	# tmp64, <variable>.bi_end_io
	.loc 1 91 0
	call	submit_bio	#

your change:

	movq	$mpage_end_io_read, %rdx	#, tmp63
	movq	$mpage_end_io_write, %rax	#, iftmp.561
	cmpl	$1, %edi	#, rw
	cmovne	%rdx, %rax	# tmp63,, iftmp.561
	movq	%rax, 80(%rsi)	# iftmp.561, <variable>.bi_end_io
	.loc 1 90 0
	call	submit_bio	#

so that change does nothing except obfuscating the source a bit more so
that you get more headaches whenever you look at it.

-- 
Regards/Gruss,
    Boris.
