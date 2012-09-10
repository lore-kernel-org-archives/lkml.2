Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2IJLMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:12:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51459 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab2IJLMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:12:40 -0400
Date: Mon, 10 Sep 2012 12:17:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH 09/14] tty/serial/amba-pl011: Implement clear_irqs
 callback
Message-ID: <20120910121702.550b8a90@pyramind.ukuu.org.uk>
In-Reply-To: <20120910041404.GI29537@lizard>
References: <20120910040802.GA1261@lizard>
	<20120910041404.GI29537@lizard>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2012 21:14:04 -0700
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> It's all pretty straightforward, except for TXIM interrupt. The interrupt
> has meaning "ready to transmit", so it's almost always raised, and the
> only way to silence it is to mask it. But that's OK, ops->start_tx will
> unmask it.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  drivers/tty/serial/amba-pl011.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
> index 88e2df2..7522d97 100644
> --- a/drivers/tty/serial/amba-pl011.c
> +++ b/drivers/tty/serial/amba-pl011.c
> @@ -1308,6 +1308,18 @@ static void pl011_put_poll_char(struct uart_port *port,
>  	writew(ch, uap->port.membase + UART01x_DR);
>  }
>  
> +static void pl011_clear_irqs(struct uart_port *port)
> +{
> +	struct uart_amba_port *uap = (struct uart_amba_port *)port;
> +	unsigned char __iomem *regs = uap->port.membase;
> +
> +	writew(readw(regs + UART011_MIS), regs + UART011_ICR);
> +	/*
> +	 * There is no way to clear TXIM, this is "ready to transmit IRQ", so
> +	 * we simply mask it. ops->start_tx will unmask it.
> +	 */

Not if you race here with the transmit start it won't.
