Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1IVSaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:30:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45779 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1IVSaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:30:08 -0400
Message-ID: <4E7B7EAA.50706@gmail.com>
Date: Thu, 22 Sep 2011 20:30:02 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110918 Thunderbird/7.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@suse.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] TTY: serial, fix locking imbalance
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 09:24 PM, Jiri Slaby wrote:
> Commit "TTY: serial, move locking in uart_close" moved the lock, but
> omitted to update branches which unlock the lock. Now they try to
> unlock the lock without holding it.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
> If possible, please, merge this into the patch mentioned above (it's
> not upstream yet).

Hi Greg, should I resend these?

>  drivers/tty/serial/serial_core.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 5c04cb9..c0fdbc5 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -1262,7 +1262,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
>  
>  	if (tty_hung_up_p(filp)) {
>  		spin_unlock_irqrestore(&port->lock, flags);
> -		goto done;
> +		return;
>  	}
>  
>  	if ((tty->count == 1) && (port->count != 1)) {
> @@ -1284,7 +1284,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
>  	}
>  	if (port->count) {
>  		spin_unlock_irqrestore(&port->lock, flags);
> -		goto done;
> +		return;
>  	}
>  
>  	/*
> @@ -1347,7 +1347,6 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
>  	wake_up_interruptible(&port->open_wait);
>  	wake_up_interruptible(&port->close_wait);
>  
> -done:
>  	mutex_unlock(&port->mutex);
>  }
>  


-- 
js
