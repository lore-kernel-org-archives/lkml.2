Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab0G0ICY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:02:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40061 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753743Ab0G0ICW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:02:22 -0400
Date: Tue, 27 Jul 2010 09:14:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Philippe Langlais <philippe.langlais@stericsson.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Vincent Guittot <vincent.guittot@stericsson.com>
Subject: Re: patch "U6715 8250 serial like driver" added to gregkh-2.6 tree
Message-ID: <20100727091408.49d55447@lxorguk.ukuu.org.uk>
In-Reply-To: <4C4E9064.6070001@stericsson.com>
References: <1279531660-16317-1-git-send-email-philippe.langlais@stericsson.com>
	<12798430773066@site>
	<20100723090119.5d63cfb7@lxorguk.ukuu.org.uk>
	<4C4E9064.6070001@stericsson.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think what you need to keep this clean is to create a
> > port->set_termios() for the 8250 port (akin to
> > port->serial_in/serial_out) which does the specials you need each end and
> > calls the standard serial8250_set_termios)
> >    
> I don't think so, call a function which compute clock each time
> we access UART registers isn't optimal, another function to overload ?

set_termios() gets called once at init time and once each time a
caller requests a change in serial parameters. That's not usually
considered a hot path. I'm not suggesting you hide it in the register
methods but add ->set_termios as a method that can be overridden, plus
export the existing one so you can wrap it.

If you can't detect the chip then create yourself a u6715 driver file
which registers the ports you have and specifies the relevant
serial_in/out methods and other detail as well as containing the board
specific routines needed.

See arch/arm/mach-omap2/serial.c for a ARM example doing this, where all
the chip knowledge is nicely buried away in the platform support.
