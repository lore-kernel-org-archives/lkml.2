Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2ARKKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:10:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44464 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab2ARKKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:10:30 -0500
Date: Wed, 18 Jan 2012 10:10:13 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amba-pl011: do not disable RTS during shutdown
Message-ID: <20120118101013.GF22472@flint.arm.linux.org.uk>
References: <1326796189-21722-1-git-send-email-shreshthakumar.sahu@stericsson.com> <20120117184047.GE22472@flint.arm.linux.org.uk> <20120118094505.GA889@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118094505.GA889@bnru02.bnr.st.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 03:15:06PM +0530, Shreshtha Kumar SAHU wrote:
> data type of old_cr was bool in patchv2, corrected in this patchv3

This is much better, just a small little niggle with it.

> @@ -1411,7 +1412,9 @@ static int pl011_startup(struct uart_port *port)
>  	while (readw(uap->port.membase + UART01x_FR) & UART01x_FR_BUSY)
>  		barrier();
>  
> -	cr = UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
> +	/* restore RTS and DTR */
> +	cr = (uap->old_cr & (UART011_CR_RTS | UART011_CR_DTR));

You don't need the outer set of parens around this (additional
unnecessary parens can cause confusion when trying to read code.)

> @@ -1488,9 +1492,16 @@ static void pl011_shutdown(struct uart_port *port)
>  
>  	/*
>  	 * disable the port
> +	 * disable the port. It should not disable RTS and DTR.
> +	 * Also RTS and DTR state should be preserved to restore
> +	 * it during startup().
>  	 */
>  	uap->autorts = false;
> -	writew(UART01x_CR_UARTEN | UART011_CR_TXE, uap->port.membase + UART011_CR);
> +	cr = readw(uap->port.membase + UART011_CR);
> +	uap->old_cr = cr;
> +	cr &= (UART011_CR_RTS | UART011_CR_DTR);

Ditto.

Once those are fixed:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
