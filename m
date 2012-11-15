Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992614Ab2KOCxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 21:53:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45399 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992461Ab2KOCxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 21:53:13 -0500
Date: Wed, 14 Nov 2012 18:49:46 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Colin King <colin.king@canonical.com>
Cc: Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] pstore: fix NULL pointer dereference in console
 writes
Message-ID: <20121115024946.GA12232@lizard>
References: <1352893793-25260-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1352893793-25260-1-git-send-email-colin.king@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 11:49:53AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Passing a NULL id causes a NULL pointer deference in writers
> such as erst_writer and efi_pstore_write because they expect
> to update this id.  Pass a dummy id instead.
> 
> This avoids a cascade of oopses caused when the initial
> pstore_console_write passes a null which in turn causes
> writes to the console causing further oopses in subsequent
> pstore_console_write calls.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> ---

Ugh. Thanks for the reminder, I completely forgot that I had this bit for
v3.7.

Applied, thanks! (I also added Cc: stable.)

>  fs/pstore/platform.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index a40da07..947fbe0 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -161,6 +161,7 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
>  
>  	while (s < e) {
>  		unsigned long flags;
> +		u64 id;
>  
>  		if (c > psinfo->bufsize)
>  			c = psinfo->bufsize;
> @@ -172,7 +173,7 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
>  			spin_lock_irqsave(&psinfo->buf_lock, flags);
>  		}
>  		memcpy(psinfo->buf, s, c);
> -		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, c, psinfo);
> +		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, c, psinfo);
>  		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
>  		s += c;
>  		c = e - s;
> -- 
> 1.7.10.4
