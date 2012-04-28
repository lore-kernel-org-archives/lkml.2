Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2D1SCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 14:02:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45959 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab2D1SCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 14:02:23 -0400
Date: Sat, 28 Apr 2012 19:05:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Preston Fick <pffick@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, preston.fick@silabs.com,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Message-ID: <20120428190502.32eaf294@pyramind.ukuu.org.uk>
In-Reply-To: <1335632134-2488-1-git-send-email-preston.fick@silabs.com>
References: <1335632134-2488-1-git-send-email-preston.fick@silabs.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   */
> @@ -424,8 +430,8 @@ static int cp210x_open(struct tty_struct *tty, struct usb_serial_port *port)
>  
>  	dbg("%s - port %d", __func__, port->number);
>  
> -	result = cp210x_set_config_single(port, CP210X_IFC_ENABLE,
> -								UART_ENABLE);
> +	result = cp210x_set_config(port, REQTYPE_HOST_TO_INTERFACE,
> +				CP210X_IFC_ENABLE, UART_ENABLE, NULL, 0);

These kind of unrelated changes make review hard. Why are they there ?

> +	case IOCTL_GPIOGET:
> +		if ((port_priv->bPartNumber == CP2103_PARTNUM) ||


All the part specific stuff in ifs rapidly gets unmaintainable. Better to
set up a port_priv->get_gpio/set_gpio.

>  /*
>   * cp210x_get_termios
>   * Reads the baud rate, data bits, parity, stop bits and flow control mode
> @@ -490,14 +565,16 @@ static void cp210x_get_termios_port(struct usb_serial_port *port,
>  
>  	dbg("%s - port %d", __func__, port->number);
>  
> -	cp210x_get_config(port, CP210X_GET_BAUDRATE, &baud, 4);
> +	cp210x_get_config(port, REQTYPE_INTERFACE_TO_HOST,
> +			CP210X_GET_BAUDRATE, 0, &baud, 4);


And again it disturbs all the rest of the code for no apparent good
reason.

  
The large number of changes all over the code for a single localised
feature change ought to be flagging up that it's not being done in a
clean way.

The other question is whether having some custom gpio poking interface is
actually a good idea. I suspect probably not. The kernel gpio layer can
help a bit but doesn't really solve the problem as there is no way to tie
a gpio to a port. Given how many devices seem to have gpios these days I
wonder if we need a gpio setting interface via termiox.

We could also the agree how that maps onto the extra gpio lines used with
SIM card readers and the like so we can standardise that.

Alan
