Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0FNUUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:20:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49716 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab0FNUUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BEdFwd+DY5OlUftlOwTMbVvH3BGxqogCm6NJzj8DKN+DphqzHlgm1TwA/dUsj9ILFx
         +S94fDJNydKVTDh8rYyF2tNN2Lt/ifxKMPFyOi9acLVEBMw1ZAWPS3qYKBevHIB6CRdq
         judkjC+E74FDb2HACRjFLnzhCXynHEEE88ZlM=
Date: Mon, 14 Jun 2010 22:20:30 +0200
From: Yury Georgievskiy <ygeorgie@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] serial: mcf: Don't take spinlocks in already
 protected functions
Message-ID: <20100614202030.GA10318@gce.cern.ch>
References: <1276070186-11393-1-git-send-email-ygeorgie@gmail.com>
 <20100614121225.a03c9203.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614121225.a03c9203.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed,  9 Jun 2010 09:56:26 +0200
> ygeorgie@gmail.com wrote:
> 
> > From: Yury Georgievskiy <ygeorgie@gmail.com>
> > 
> > Don't take the port spinlock in uart functions where the serial core
> > already takes care of locking/unlocking them.
> > 
> > The code would actually lock up on architectures where spinlocks are
> > implemented.
> > 
> > Also protect calling mcf_rx_chars/mcf_tx_chars in the
> > interrupt handler by the port spinlock and use IRQ_RETVAL
> > to return from isr.
> > 
> 
> Thanks.  Did you runtime test this?

Unfortunately not.

I spotted it as I am now writing the UART driver for Philips SCC2698B integrated circuit
and was looking for serial drivers examples.

And also came across d8d721f4c005f9a69bd1b5d5c6ba99b7e1d464de commit that has patched a
similar problem.

> 
> > @@ -368,11 +354,15 @@ static irqreturn_t mcf_interrupt(int irq, void *data)
> >  	unsigned int isr;
> >  
> >  	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
> > +
> > +	spin_lock(&port->lock);
> >  	if (isr & MCFUART_UIR_RXREADY)
> >  		mcf_rx_chars(pp);
> >  	if (isr & MCFUART_UIR_TXREADY)
> >  		mcf_tx_chars(pp);
> > -	return IRQ_HANDLED;
> > +	spin_unlock(&port->lock);
> > +
> > +	return IRQ_RETVAL(isr);
> >  }
> 
> I think this is a little abusive of IRQ_RETVAL.  If there are some bits
> set in `isr' other than MCFUART_UIR_RXREADY and MCFUART_UIR_TXREADY, we
> claim we handled it, only we didn't.
> 
> Probably the code works OK, but it all seems a bit uncomfortable. 
> Perhaps make it more explicit?
> 

Fair enough.
The code looks more relevant.

> 
> --- a/drivers/serial/mcf.c~serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix
> +++ a/drivers/serial/mcf.c
> @@ -352,17 +352,22 @@ static irqreturn_t mcf_interrupt(int irq
>  	struct uart_port *port = data;
>  	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
>  	unsigned int isr;
> +	irqreturn_t ret = IRQ_NONE;
>  
>  	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
>  
>  	spin_lock(&port->lock);
> -	if (isr & MCFUART_UIR_RXREADY)
> +	if (isr & MCFUART_UIR_RXREADY) {
>  		mcf_rx_chars(pp);
> -	if (isr & MCFUART_UIR_TXREADY)
> +		ret = IRQ_HANDLED;
> +	}
> +	if (isr & MCFUART_UIR_TXREADY) {
>  		mcf_tx_chars(pp);
> +		ret = IRQ_HANDLED;
> +	}
>  	spin_unlock(&port->lock);
>  
> -	return IRQ_RETVAL(isr);
> +	return ret;
>  }
>  
>  /****************************************************************************/
> _
> 
