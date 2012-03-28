Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab2C1LEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:04:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60776 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771Ab2C1LEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:04:21 -0400
Date: Wed, 28 Mar 2012 12:06:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
Message-ID: <20120328120638.76dd4b73@pyramind.ukuu.org.uk>
In-Reply-To: <20120325223315.GN6589@ZenIV.linux.org.uk>
References: <4F5BE1E6.9000201@nod.at>
	<4F5C861F.2000507@nod.at>
	<4F5DCF39.8080308@nod.at>
	<20120312105312.665d2362@pyramind.ukuu.org.uk>
	<4F5DDAD4.4060504@nod.at>
	<20120312114832.784bb6fe@pyramind.ukuu.org.uk>
	<20120324232001.GK6589@ZenIV.linux.org.uk>
	<20120325155143.7ca7cb13@ultron>
	<20120325183114.GM6589@ZenIV.linux.org.uk>
	<20120325220610.49063ad7@ultron>
	<20120325223315.GN6589@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	* TTY layer allocates tty on demand (open() time) and feeds them
> to ->install(), which is where we associate the suckers with tty_port,
> grabbing a reference to the latter and shoving it into ->driver_data (OK,
> it or that to struct it's embedded into - all the same)

Yep - actually we want to get a tty->port pointer so we can clean up some
of the indirection and allow the core code to get at the port directly

> 	* ->open()/->close()/->hungup() simply call tty_port_...()
> [BTW, is there any reason why you do not set ->driver_data to port and
> use container_of() in the places that want other parts of containing

See aboe comment.. that's also the way I've been thinking.

> 	* removal does tty_unregister_device() + prevents ->install() from
> finding it + (under port->mutex) does tty_hangup() on associated tty (if any).
> BTW, I really don't like the look of that place - tty_hangup() is async
> (otherwise it'd deadlock instantly), so what the devil is protecting tty
> from being freed before __tty_hangup() is done with it?  And when should

Nothing. However the locking is unfixable in this area until we've
removed the big tty mutex. It's a known problem. I've killed the big tty
mutex in the console layer this -next so we are inching in the right
direction. Once the BTM has gone we can actually fix the unplug race.

> 	* ->activate() plays strange games with TTY_IO_ERROR; why do we
> bother, seeing that it's under port->mutex and anybody trying to open the
> same tty will wait anyway?

The historic code used to do this and some of our drivers are not fully
converted over so still expect that pattern of behaviour in a few spots.

Alan
