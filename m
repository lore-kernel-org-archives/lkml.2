Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2I0Rt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:49:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35035 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2I0Rt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:49:56 -0400
Message-ID: <506491C1.7060807@suse.cz>
Date: Thu, 27 Sep 2012 19:49:53 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
        gregkh@linuxfoundation.org, xemul@parallels.com
Subject: Re: [patch 2/2] tty: Add get- ioctls to fetch tty status v2
References: <20120927165958.287690622@openvz.org> <20120927170137.805935065@openvz.org>
In-Reply-To: <20120927170137.805935065@openvz.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 07:00 PM, Cyrill Gorcunov wrote:
> @@ -199,6 +207,25 @@ static int pty_set_pktmode(struct tty_st
>  	return 0;
>  }
>  
> +/* Get the packet mode of a pty */
> +static int pty_get_pktmode(struct tty_struct *tty, int __user *arg)
> +{
> +	unsigned long flags;
> +	int pktmode;
> +
> +	if (tty->driver->subtype != PTY_TYPE_MASTER)
> +		return -ENOTTY;

The same as for 1/2^UFixed in v3 ;).

> +	spin_lock_irqsave(&tty->ctrl_lock, flags);

I believe the lock is not the right one. It protects ctrl_status in
TIOCPKT, not the packet. And it very seems that packet is unprotected at
all over the code => the lock does not improve anything and is redundant.

> +	pktmode = tty->packet;
> +	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
> +
> +	if (put_user(pktmode, arg))
> +		return -EFAULT;
> +
> +	return 0;

This can be just
  return put_user(pktmode, arg);
Right?

> +}
> +
...
> --- tty.git.orig/include/asm-generic/ioctls.h
> +++ tty.git/include/asm-generic/ioctls.h
> @@ -74,6 +74,9 @@
>  #define TCSETXW		0x5435
>  #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
>  #define TIOCVHANGUP	0x5437
> +#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
> +#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
> +#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */

This is not enough. Some arches do not include this file in their
ioctls.h. You need to update them all.

thanks,
-- 
js
suse labs
