Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0FNTM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:12:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882Ab0FNTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:12:27 -0400
Date: Mon, 14 Jun 2010 12:12:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ygeorgie@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] serial: mcf: Don't take spinlocks in already
 protected functions
Message-Id: <20100614121225.a03c9203.akpm@linux-foundation.org>
In-Reply-To: <1276070186-11393-1-git-send-email-ygeorgie@gmail.com>
References: <1276070186-11393-1-git-send-email-ygeorgie@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jun 2010 09:56:26 +0200
ygeorgie@gmail.com wrote:

> From: Yury Georgievskiy <ygeorgie@gmail.com>
> 
> Don't take the port spinlock in uart functions where the serial core
> already takes care of locking/unlocking them.
> 
> The code would actually lock up on architectures where spinlocks are
> implemented.
> 
> Also protect calling mcf_rx_chars/mcf_tx_chars in the
> interrupt handler by the port spinlock and use IRQ_RETVAL
> to return from isr.
> 

Thanks.  Did you runtime test this?

> @@ -368,11 +354,15 @@ static irqreturn_t mcf_interrupt(int irq, void *data)
>  	unsigned int isr;
>  
>  	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
> +
> +	spin_lock(&port->lock);
>  	if (isr & MCFUART_UIR_RXREADY)
>  		mcf_rx_chars(pp);
>  	if (isr & MCFUART_UIR_TXREADY)
>  		mcf_tx_chars(pp);
> -	return IRQ_HANDLED;
> +	spin_unlock(&port->lock);
> +
> +	return IRQ_RETVAL(isr);
>  }

I think this is a little abusive of IRQ_RETVAL.  If there are some bits
set in `isr' other than MCFUART_UIR_RXREADY and MCFUART_UIR_TXREADY, we
claim we handled it, only we didn't.

Probably the code works OK, but it all seems a bit uncomfortable. 
Perhaps make it more explicit?


--- a/drivers/serial/mcf.c~serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix
+++ a/drivers/serial/mcf.c
@@ -352,17 +352,22 @@ static irqreturn_t mcf_interrupt(int irq
 	struct uart_port *port = data;
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned int isr;
+	irqreturn_t ret = IRQ_NONE;
 
 	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
 
 	spin_lock(&port->lock);
-	if (isr & MCFUART_UIR_RXREADY)
+	if (isr & MCFUART_UIR_RXREADY) {
 		mcf_rx_chars(pp);
-	if (isr & MCFUART_UIR_TXREADY)
+		ret = IRQ_HANDLED;
+	}
+	if (isr & MCFUART_UIR_TXREADY) {
 		mcf_tx_chars(pp);
+		ret = IRQ_HANDLED;
+	}
 	spin_unlock(&port->lock);
 
-	return IRQ_RETVAL(isr);
+	return ret;
 }
 
 /****************************************************************************/
_

