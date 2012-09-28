Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab2I1NBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:01:35 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60698 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab2I1NBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:01:33 -0400
Message-ID: <50659FA8.7020200@suse.cz>
Date: Fri, 28 Sep 2012 15:01:28 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0a2
MIME-Version: 1.0
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
CC: gregkh@suse.de, alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vineet.Gupta1@synopsys.com
Subject: Re: [PATCH] tty/8250_early: Prevent rounding error in uartclk to
 baud ratio
References: <1348833784-31385-1-git-send-email-abrodkin@synopsys.com>
In-Reply-To: <1348833784-31385-1-git-send-email-abrodkin@synopsys.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 02:03 PM, Alexey Brodkin wrote:
> Modify divisor to select the nearest baud rate divider rather than the
> lowest. It minimizes baud rate errors especially on low UART clock
> frequencies.
> 
> For example, if uartclk is 33000000 and baud is 115200 the ratio is
> about 17.9 The current code selects 17 (5% error) but should select 18
> (0.5% error).
> 
> On the same lines as following:
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.9-rc3/2.6.9-rc3-mm2/broken-out/serial-pick-nearest-baud-rate-divider.patch
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> ---
>  drivers/tty/serial/8250_early.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/8250_early.c b/drivers/tty/serial/8250_early.c
> index eaafb98..cfc46b7 100644
> --- a/drivers/tty/serial/8250_early.c
> +++ b/drivers/tty/serial/8250_early.c
> @@ -140,7 +140,7 @@ static void __init init_port(struct early_serial8250_device *device)
>  	serial_out(port, UART_FCR, 0);		/* no fifo */
>  	serial_out(port, UART_MCR, 0x3);	/* DTR + RTS */
>  
> -	divisor = port->uartclk / (16 * device->baud);
> +	divisor = (port->uartclk + (8 * device->baud)) / (16 *	device->baud);

So this should be in fact DIV_ROUND_CLOSEST(), right?

But anyway I'm missing any explanation of *why* this is needed? This
should be part of the commit log. Is there any bug you are fixing here?

thanks,
-- 
js
suse labs
