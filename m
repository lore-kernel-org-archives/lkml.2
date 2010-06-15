Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab0FOT0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:26:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46368 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758247Ab0FOT0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:26:14 -0400
Date: Tue, 15 Jun 2010 20:29:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: hyc@symas.com
Cc: linux-kernel@vger.kernel.org, <greg@kroah.com>, Alan@symas.com,
       Cox@symas.com, Greg@symas.com, KH@symas.com
Subject: Re: [PATCH] tty: Add EXTPROC support for LINEMODE
Message-ID: <20100615202924.24446d28@lxorguk.ukuu.org.uk>
In-Reply-To: <E1OObIu-0004K2-3K@lirone.symas.net>
References: <E1OObIu-0004K2-3K@lirone.symas.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>      bit set, and the data will be the contents of a struct termios.
>      This allows the process on the server side of the pty to know
>      when the state of the terminal has changed, and what the new
>      state is.

First problem - the kernel and user idea of struct termios don't match.


> diff --git a/arch/alpha/include/asm/termbits.h b/arch/alpha/include/asm/termbits.h
> index ad854a4..879dd35 100644
> --- a/arch/alpha/include/asm/termbits.h
> +++ b/arch/alpha/include/asm/termbits.h
> @@ -180,6 +180,7 @@ struct ktermios {
>  #define FLUSHO	0x00800000
>  #define PENDIN	0x20000000
>  #define IEXTEN	0x00000400
> +#define EXTPROC	0x10000000

For Alpha this value should match OSF if possible.


> +			if (cs & TIOCPKT_IOCTL) {
> +				c = sizeof(struct termios);
> +				if (c > nr)
> +					c = nr;
> +				copy_to_user(b, tty->link->termios, c);
> +				nr -= c;
> +				b += c;
> +			}

This is where the wheels come off the bus.

The kernel use struct ktermios which is what tty->link->termios is

The C library presents this via struct termios which is a glibc invention
dependant on the C library and which is converted by libc from struct
termios or struct termios2 depending on your C library

How you fix that given a broken by design historic Unix interface which
pastes arbitary struct termios objects into the data stream is an
interesting question - doubly so when like most Unixen we have also have
extended terminal attributes as well (termiox)

Alan
