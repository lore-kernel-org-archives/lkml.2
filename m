Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab2IJR6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:58:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58654 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab2IJR6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:58:35 -0400
Date: Mon, 10 Sep 2012 10:56:01 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH 09/14] tty/serial/amba-pl011: Implement clear_irqs
 callback
Message-ID: <20120910175601.GA13164@lizard>
References: <20120910040802.GA1261@lizard>
 <20120910041404.GI29537@lizard>
 <20120910121702.550b8a90@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120910121702.550b8a90@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 12:17:02PM +0100, Alan Cox wrote:
[...]
> > +static void pl011_clear_irqs(struct uart_port *port)
> > +{
> > +	struct uart_amba_port *uap = (struct uart_amba_port *)port;
> > +	unsigned char __iomem *regs = uap->port.membase;
> > +
> > +	writew(readw(regs + UART011_MIS), regs + UART011_ICR);
> > +	/*
> > +	 * There is no way to clear TXIM, this is "ready to transmit IRQ", so
> > +	 * we simply mask it. ops->start_tx will unmask it.
> > +	 */
> 
> Not if you race here with the transmit start it won't.

True, the race is possible. But I guess there will be no harm: only non-polling
code uses ->start_tx(), but then we don't care, the port is used for NMI
debugger, so the worst that can happen, is that we'll get another NMI just
after the race, and so we'll mask it again.

And once we release the port from KDB, we never call this function anymore
(since normal IRQ routine will be called instead).

I guess I need to add some commens about this.

Thanks!
