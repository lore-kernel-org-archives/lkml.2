Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1LUUQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:16:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:3561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1LUUQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:16:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="90118039"
Date: Wed, 21 Dec 2011 20:28:47 +0000
From: Alan Cox <alan@linux.intel.com>
To: Uwe =?ISO-8859-1?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] serial/efm32: add new driver
Message-ID: <20111221202847.4ffeba10@bob.linux.org.uk>
In-Reply-To: <1324479959-7343-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1324479959-7343-1-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 16:05:59 +0100
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> note that ARCH_EFM32 isn't in mainline yet, so to be actually usable
> some arch patches are needed.

Start by running it through the CodingStyle scripts as I see a //
comment in there 8)


> +static void efm32_usart_rx_chars(struct efm32_usart_port *efm_port)
> +{
> +	struct uart_port *port = &efm_port->port;
> +	struct tty_struct *tty = port->state->port.tty;

Needs to be using krefs and checking the tty is not NULL
(tty_port_tty_get)

> +static void efm32_usart_set_termios(struct uart_port *port,
> +		struct ktermios *new, struct ktermios *old)
> +{
> +	struct efm32_usart_port *efm_port = to_efm_port(port);
> +	unsigned long flags;
> +	unsigned baud;
> +	u32 clkdiv;
> +
> +	/* no modem control lines */
> +	new->c_cflag &= ~(HUPCL | CRTSCTS | CMSPAR);

Minor item - HUPCL shouldn't get cleared - its a request for hangup
behaviour not a port feature.

> +	/* currently only some features are implemented */
> +	new->c_cflag &= ~CSIZE;
> +	new->c_cflag |= CS8;
> +	new->c_cflag |= CSTOPB;
> +	new->c_cflag &= ~PARENB;

If you can do CS8 without parity you can do CS7 with parity.

> +	new->c_iflag = 0;

This seems broken. Lots of the iflgs are user requests and stack
properties not port features. For example you can do xon/xoff as its
pure software. As far as I can see you should leave c_iflag alone.

Alan
