Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab2LQST2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:19:28 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39867 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2LQSTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:19:25 -0500
Date: Mon, 17 Dec 2012 18:23:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: <alan@linux.intel.com>, <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <swarren@wwwdotorg.org>
Subject: Re: [PATCH] serial: tegra: add serial driver
Message-ID: <20121217182343.37324522@pyramind.ukuu.org.uk>
In-Reply-To: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com>
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> +
> +static void tegra_uart_copy_rx_to_tty(struct tegra_uart_port *tup, int count)
> +{
> +	int copied;
> +
> +	tup->uport.icount.rx += count;
> +	dma_sync_single_for_cpu(tup->uport.dev, tup->rx_dma_buf_phys,
> +				TEGRA_UART_RX_DMA_BUFFER_SIZE, DMA_FROM_DEVICE);
> +	copied = tty_insert_flip_string(tup->uport.state->port.tty,

Reference needed and port.tty can go to NULL
(good rule of thumb - any use of port.tty directly is probably wrong)

‎
> +	tty_flip_buffer_push(u->state->port.tty);

Ditto (and elsewhere)

> +	if ((c_cflag & PARENB) == PARENB) {
> +		symb_bit++;
> +		if ((c_cflag & CMSPAR) == CMSPAR) {
> +			dev_err(tup->uport.dev, "Space parity not supported\n");
> +			return;

No - this is out of spec and lets user tasks spam the log. Just clear the
flag if not supported.


> +	/* Baud rate. */
> +	baud = uart_get_baud_rate(u, termios, oldtermios, 200, 4000000);
> +	spin_unlock_irqrestore(&u->lock, flags);
> +	tegra_set_baudrate(tup, baud);
> +	spin_lock_irqsave(&u->lock, flags);

I think you need to use the helpers to put the actual baud it got into the
termios if not B0 - see 8250.c ?

Alan
