Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab0EAK6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 06:58:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55494 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751718Ab0EAK6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 06:58:42 -0400
Date: Sat, 1 May 2010 12:04:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console logging detour via printk
Message-ID: <20100501120418.6fca2aad@lxorguk.ukuu.org.uk>
In-Reply-To: <1272664980.10241.77.camel@itpsd6lap>
References: <1272664980.10241.77.camel@itpsd6lap>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> while i was searching for effective logging of complete console output
> produced by the kernel and user phase of the boot process, it turned out
> that only kernel messages imho get systematically cached and stored into
> log files (if needed). All userspace processes are on their own to use
> syslog, which is fine, but there are also many console messages
> reporting the boot status via init scripts, .... I came across the
> bootlogd daemo, which handles the job of redirecting console output into
> a log file, but i find it problematic to use especialy, when using
> initial ram disk image.

So you want to patch the kernel because you can't work out how to do this
in userspace ? The distributions seem to have no problem doing this in
user space that I can see. It doesn't seem to be a hard user space
problem, and there are a ton of things you want to do with this sort of
stuff (like network logging) that you can't do in kernel space.

> --- a_linux-2.6.33.3/drivers/char/vt.c
> +++ b_linux-2.6.33.3/drivers/char/vt.c
> @@ -2696,6 +2696,16 @@ static int con_write(struct tty_struct *tty, const unsigned char *buf, int count
>  {
>  	int	retval;
>  
> +#ifdef CONFIG_VT_CONSOLE_DETOUR
> +	if (console_detour) {
> +		int idx = vt_console_driver.index - 1;
> + 
> +		if ((idx >= 0) && (idx == tty->index)) {
> +			console_printk_detour(buf, count);
> +			return count;
> +		}
> +	}
> +#endif

This requires you go around hacking up each device which is not a good
idea and becomes rapidly unmaintainable.

I suspect what you actually need for such logging might be to write a
very simple tty driver whose write method is implemented as printk. That
works in the general case and doesn't require hacking up the code
everywhere else.

However given your init stuff can trivially use openpty to set up a logged
console I am not sure I see the point in doing this in kernel in the
first place.

Alan
