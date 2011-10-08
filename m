Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab1JHItl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 04:49:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37295 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1JHItj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 04:49:39 -0400
Message-ID: <4E900E9E.2070604@gmail.com>
Date: Sat, 08 Oct 2011 10:49:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: serial_core: Fix crash if agetty() run on non-console
 serial port
References: <1318024753-15336-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1318024753-15336-1-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2011 11:59 PM, Doug Anderson wrote:
> The symptoms of the bug showed up if you were running agetty on ttyS0
> but not using ttyS0 as the console= port on the kernel command
> line.  In this case, if you suspended the system you'd get a crash
> on resume.
>
> The specific order of operations that were running:
> * uart_suspend_port() would be called to put the uart in suspend mode
> * a tty hangup would be processed
> * the hangup would call uart_shutdown()
> * ... suspend / resume happens ...
> * uart_resume_port() would be called and run the code in the
>   (port->flags & ASYNC_SUSPENDED) block, which would startup the port
>   (and enable tx again).
> * Since the UART would be available for tx, we'd immediately get
>   an interrupt, eventually calling transmit_chars()
> * The transmit_chars() function would crash.  The first crash would
>   be a dereference of a NULL tty member, but since the port has been
>   shutdown that was just a symptom.

I cannot reproduce this. What uart driver is this with? And where does
it call uart_suspend_port from? Basically, it would mean that it calls
uart_suspend_port while userspace is still running? Or who HUPs the port
(the second point in your list)?

> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/tty/serial/serial_core.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index a3efbea..668e56a 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -255,6 +255,14 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
>  	}
>  
>  	/*
> +	 * It's possible for shutdown to be called after suspend.  Specifically
> +	 * if agetty() is listening to the serial port we get a HUP after the
> +	 * suspend happend (and HUP calls shutdown).  Clear suspended bit so
> +	 * we don't try to resume a port that has been shutdown.
> +	 */
> +	clear_bit(ASYNCB_SUSPENDED, &port->flags);
> +
> +	/*
>  	 * kill off our tasklet
>  	 */
>  	tasklet_kill(&state->tlet);

thanks,
-- 
js
