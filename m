Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2DCUB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:01:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52730 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2DCUB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:01:26 -0400
Date: Tue, 3 Apr 2012 21:03:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: sudhakar <sudhakar@fb.com>
Cc: <linux-serial@vger.kernel.org>, <alan@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <dan.j.williams@intel.com>,
        <nhan.h.mai@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] serial/8250_pci: Need to clear FIFOs for KT serial
 on BI
Message-ID: <20120403210345.624bd7ba@pyramind.ukuu.org.uk>
In-Reply-To: <4F7B53C9.4040509@fb.com>
References: <4F7B53C9.4040509@fb.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012 12:47:21 -0700
sudhakar <sudhakar@fb.com> wrote:

> 
> From: Sudhakar Mamillapalli <sudhakar@fb.com>
> 
> When using SOL thru a KT serial device and Intel ME gets reset
> the serial FIFOs need to be cleared for sane SOL output.  On

Acronym failure.

Please remember that people looking at a patch and even more so people in
future maintaining the code will not have any idea wtf you are talking
about !

Expand the acronyms in a patch and include a bit of context.


> @@ -1385,6 +1393,16 @@ serial8250_rx_chars(struct uart_8250_port *up, unsigned char lsr)
>  		lsr |= up->lsr_saved_flags;
>  		up->lsr_saved_flags = 0;
>  
> +		if ((up->port.type == PORT_KT_SERIAL) && (lsr & UART_LSR_BI)) {
> +			/*
> +			 * For KT serial device if break interrupt then got
> +			 * to clear the fifos for sane SOL output.
> +			 */
> +			serial8250_clear_fifos(up);
> +			fcr = uart_config[up->port.type].fcr;
> +			serial_port_out(port, UART_FCR, fcr);
> +		}
> +

This wants to be some kind of call back handled case not more stuff in
the core 8250.c which we are trying to drive all the special cases back
out of.

>  		if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
>  			/*
>  			 * For statistics only
> @@ -1729,7 +1747,12 @@ static void serial8250_backup_timeout(unsigned long data)
>  	 * based handler.
>  	 */
>  	if (up->port.irq) {
> -		ier = serial_in(up, UART_IER);
> +		/*
> +		 * Get the ier value from up->ier rather than reading the
> +		 * register, since some SOL uarts(for e.g. KT serial) it
> +		 * goes to 0 momentarily on BMC reset.
> +		 */
> +		ier = up->ier;
>  		serial_out(up, UART_IER, 0);

Surely you do this fixup in your own private serial_in method as various
other chips do for all sorts of brain damage.

>  	}
>  
> @@ -1896,8 +1919,12 @@ static void serial8250_put_poll_char(struct uart_port *port,
>  
>  	/*
>  	 *	First save the IER then disable the interrupts
> +	 *
> +	 *      Get the ier value from up->ier rather than reading the
> +	 *      register, since some SOL uarts(for e.g. KT serial) it
> +	 *      goes to 0 momentarily on BMC reset.
>  	 */
> -	ier = serial_port_in(port, UART_IER);
> +	ier = up->ier;
>  	if (up->capabilities & UART_CAP_UUE)

Ditto

>  		serial_port_out(port, UART_IER, UART_IER_UUE);
>  	else
> @@ -2818,8 +2845,12 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
>  
>  	/*
>  	 *	First save the IER then disable the interrupts
> +	 *
> +	 *      Get the ier value from up->ier rather than reading the
> +	 *      register, since some SOL uarts(for e.g. KT serial) it
> +	 *      goes to 0 momentarily on BMC reset.
>  	 */
> -	ier = serial_port_in(port, UART_IER);
> +	ier = up->ier;
>  

Ditto

In fact as far as I can see this boils down to

- a private serial_in method
- possibly adding a callback for special break handling. You may even be
  able to hide that in serial_in methods, but its probably better
  explicit.

Alan
