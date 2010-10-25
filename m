Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0JYWyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:54:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab0JYWyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:54:43 -0400
Date: Mon, 25 Oct 2010 15:54:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Arkadiusz =?UTF-8?Q?Buba?= =?UTF-8?Q?=C5=82a?= 
	<arkadiusz.bubala@gmail.com>,
        linux@maxim.org.za,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: atmel_serial: fix RTS high after initialization in RS485 mode
Message-Id: <20101025155410.f960fcd5.akpm@linux-foundation.org>
In-Reply-To: <4CC40EFD.8070000@evidence.eu.com>
References: <4CC40EFD.8070000@evidence.eu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Oct 2010 12:48:29 +0200
Claudio Scordino <claudio@evidence.eu.com> wrote:

> Hi Nicolas,
> 
> 	when working in RS485 mode, the atmel_serial driver keeps RTS
> high after the initialization of the serial port. It goes low only after
> the first character has been sent. 
> 
> This patch fixes this behavior. It has been already tested by Arkadiusz (CC:-ed).
> 
> Best regards,
> 
> 	Claudio
> 
> 
> atmel_serial: RTS line low after initialization of the serial port
> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
> Signed-off-by: Arkadiusz Bubala <arkadiusz.bubala@gmail.com>
> ---
>  drivers/serial/atmel_serial.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index 3892666..85aa66f 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -1732,6 +1732,15 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
>  	device_init_wakeup(&pdev->dev, 1);
>  	platform_set_drvdata(pdev, port);
>  
> +	if (port->rs485.flags & SER_RS485_ENABLED) {
> +		unsigned int control = 0;
> +		unsigned int mode = 0;
> +		control |= ATMEL_US_RTSEN;
> +		mode |= ATMEL_US_USMODE_NORMAL;
> +		UART_PUT_MR(&port->uart, mode);
> +		UART_PUT_CR(&port->uart, control);
> +	}
> +
>  	return 0;
>  

That was a lot of code!  How about just this?

	if (port->rs485.flags & SER_RS485_ENABLED) {
		UART_PUT_MR(&port->uart, ATMEL_US_USMODE_NORMAL);
		UART_PUT_CR(&port->uart, ATMEL_US_RTSEN);
	}

