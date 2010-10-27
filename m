Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0J0WUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 18:20:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39431 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751031Ab0J0WUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 18:20:42 -0400
Date: Wed, 27 Oct 2010 23:19:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
Message-ID: <20101027231948.5e62dd09@lxorguk.ukuu.org.uk>
In-Reply-To: <4CC893CD.7020701@freescale.com>
References: <4CC893CD.7020701@freescale.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 16:04:13 -0500
Timur Tabi <timur@freescale.com> wrote:

> Greg,
> 
> Do you have an updated version of Tiny TTY that uses tty_port structures?  I'm
> trying to write a new TTY driver for a device that is not a UART, and I'm having
> a hard time finding a good example.  I suspect I need to understand the tty_port
> structure, but I can't find any documentation for it.
> 
> One specific problem I'm having is that I can't figure out how to get a
> tty_struct pointer in my interrupt handler.  The ISR gets called whenever there
> is new input, and it needs to call tty_insert_flip_string().  But it appears
> that it's possible to have my driver opened multiple times, each time creating a
> new TTY.  But since I can only have one interrupt handler, I don't know how to
> determine which of the tty_structs to use.  I figure tty_port is a way to
> resolve this problem, but I don't know how to use it exactly.

You only have one tty struct for the multiple opens.

Basically

		tty_port	-	lifetime of hardware being loaded
		tty_struct	-	lifetime open/close (and a bit
					beyond for refs)


So you can use tty_port_tty_get() which also knows about all the ghastly
internal locking rules.

Eventually the rx buffer should be moved to the tty_port which will make
the world vastly saner.

drivers/mmc/card/sdio_uart.c

is in some ways the best example, it handles all the horrible cases
including unloading of hardware v open races, its way more than you'd
need but does illustrate it all.

I've also got a draft tty_kfifo layer which is designed to be tty_port
with kfifo queues as a helper. Remind me next week if it would be useful
and I'll dig it back out.

Alan
