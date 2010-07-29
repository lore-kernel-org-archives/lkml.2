Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0G2NlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:41:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59645 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754229Ab0G2NlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:41:22 -0400
Date: Thu, 29 Jul 2010 14:53:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Philippe Langlais <philippe.langlais@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <gregkh@suse.de>,
        <ludovic.barre@stericsson.com>, <vincent.guittot@stericsson.com>
Subject: Re: [PATCH] U6715 16550A serial driver support
Message-ID: <20100729145335.16cea2dc@lxorguk.ukuu.org.uk>
In-Reply-To: <1280410348-28940-2-git-send-email-philippe.langlais@stericsson.com>
References: <1280410348-28940-1-git-send-email-philippe.langlais@stericsson.com>
	<1280410348-28940-2-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In 16550A auto-configuration, if the fifo size is 64 then it's an U6 16550A port

That may not be reliable given the other 8250 clones around but looks
generally sane.


> @@ -2238,6 +2254,10 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
>  	unsigned long flags;
>  	unsigned int baud, quot;
>  
> +	/* Possibly call pre_set_termios function.  */
> +	if (port->pre_set_termios)
> +		port->pre_set_termios(port, termios, old);
> +

Ok I think it might be better to have

serial8250_do_set_termios(...)
{
	/* Existing set_termios code here */
}
EXPORT_SYMBOL(serial8250_do_set_termios);

serial8250_set_termios(...)
{
	if (port->set_termios)
		return port->set_termios(...)
	else
		serial8250_do_set_termions(...)
}

That allows people to wrap it with before/after/both handling, or replace
it entirely.

So in your case it would

my_set_termios()
{
	/* pre set termios code here */
	return serial8250_do_set_termios();
}


Looks ok to me though - it splits the special bits out from the core
nicely
