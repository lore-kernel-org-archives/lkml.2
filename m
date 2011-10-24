Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab1JXNLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:11:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46015 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab1JXNLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:11:08 -0400
Message-ID: <4EA563E6.3040205@suse.cz>
Date: Mon, 24 Oct 2011 15:11:02 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ilya Zykov <ilya@ilyx.ru>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] TTY: pty, fix pty counting
References: <4EA48094.8020508@ilyx.ru>
In-Reply-To: <4EA48094.8020508@ilyx.ru>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2011 11:01 PM, Ilya Zykov wrote:
> New version for commit: 24d406a6bf736f7aebdc8fa0f0ec86e0890c6d24

Although it will work, as ptms are not allowed to be reopen, it doesn't
look correct. We should decrement the count in ->remove, because we are
incrementing in install.

Now, when I understand ptm+devpts layer a bit more, instead of the
current hackish approach introduced by 24d406a6b (TTY: pty, fix pty
counting), I think we may introduce a ->remove hook specific to ptms. In
that one we could decrement the count and don't bother with the
pty_count macros anymore. Right?

BTW you cannot remove ->remove hook of pty layer. It would cause an OOPS
because driver->ttys is not allocated for ptys.

> diff -uprN a/drivers/tty/pty.c b/drivers/tty/pty.c
> --- a/drivers/tty/pty.c	2011-05-19 08:06:34.000000000 +0400
> +++ b/drivers/tty/pty.c	2011-10-23 18:01:20.000000000 +0400
> @@ -36,13 +36,15 @@
>  static struct tty_driver *ptm_driver;
>  static struct tty_driver *pts_driver;
>  #endif
> +static int pty_count;
>  
>  static void pty_close(struct tty_struct *tty, struct file *filp)
>  {
>  	BUG_ON(!tty);
> -	if (tty->driver->subtype == PTY_TYPE_MASTER)
> +	if (tty->driver->subtype == PTY_TYPE_MASTER) {
>  		WARN_ON(tty->count > 1);
> -	else {
> +		pty_count--;
> +	} else {
>  		if (tty->count > 2)
>  			return;
>  	}
> @@ -446,7 +448,6 @@ static inline void legacy_pty_init(void)
>  int pty_limit = NR_UNIX98_PTY_DEFAULT;
>  static int pty_limit_min;
>  static int pty_limit_max = NR_UNIX98_PTY_MAX;
> -static int pty_count;
>  
>  static struct cdev ptmx_cdev;
>  
> @@ -599,15 +600,9 @@ free_mem_out:
>  	return -ENOMEM;
>  }
>  
> -static void pty_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
> -{
> -	pty_count--;
> -}
> -
>  static const struct tty_operations ptm_unix98_ops = {
>  	.lookup = ptm_unix98_lookup,
>  	.install = pty_unix98_install,
> -	.remove = pty_unix98_remove,
>  	.open = pty_open,
>  	.close = pty_close,
>  	.write = pty_write,
> @@ -624,7 +619,6 @@ static const struct tty_operations ptm_u
>  static const struct tty_operations pty_unix98_ops = {
>  	.lookup = pts_unix98_lookup,
>  	.install = pty_unix98_install,
> -	.remove = pty_unix98_remove,
>  	.open = pty_open,
>  	.close = pty_close,
>  	.write = pty_write,

thanks,
-- 
js
suse labs
