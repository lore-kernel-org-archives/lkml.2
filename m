Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2ADUxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:53:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab2ADUxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:53:40 -0500
Date: Wed, 4 Jan 2012 12:53:10 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: UV serial regression since 2.6.36
Message-ID: <20120104205310.GA21496@suse.de>
References: <4EDE988B.6010501@suse.cz>
 <4F049D6B.6040503@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F049D6B.6040503@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 07:41:47PM +0100, Jiri Slaby wrote:
> On 12/06/2011 11:34 PM, Jiri Slaby wrote:
> > Hi,
> > 
> > In short, the issue causes serial port traffic to stop after some time
> > on UV machines. Only when serial is used as a console. It worked
> > perfectly with 2.6.32. It's a standard 16550 on 0x3f8 (well, it's
> > emulated to be at that port). Also in the PNP subsys.
> > 
> > To reproduce that 'debug' kernel parameter must not be used.
> > 
> > The root cause seems to be that the serial "chip" there has problems
> > with interrupts. It generates some but doesn't indicate it's the source
> > or somebody clears it (NOINT is set). And when it is supposed to
> > generate one (on THRE), it does not. So there are bytes in the TX buffer
> > which are never sent. Until the port is kicked e.g. by "echo h >
> > /proc/sysrq-trigger".
> > 
> > The unhandled interrupts were always an issue, but somehow hidden. It
> > became a real problem with patches post 2.6.32.
> > 
> > I bisected it to these two commits _together_:
> > 
> > commit 3f582b8c11014e4ce310d9839fb335164195333f
> > Author: Arnd Bergmann <arnd@arndb.de>
> > Date:   Tue Jun 29 22:31:40 2010 +0200
> > 
> >     serial: fix termios settings in open
> > 
> > AND
> > 
> > commit 74c2107759dc6efaa1b9127014be58a742a1e7ac
> > Author: Alan Cox <alan@linux.intel.com>
> > Date:   Tue Jun 1 22:53:00 2010 +0200
> > 
> >     serial: Use block_til_ready helper
> > 
> > Those reverted on the top of 2.6.37 makes it work again. Those reverted
> > on the top of 3.0 plus mine 3 reverted which removed update_set_termios
> > completely makes it work again.
> > 
> > I didn't look closely to why those patches are causing that. Like
> > c_cflag copy in uart_update_termios and "tty->termios->c_cflag & CBAUD"
> > test in tty_port_block_til_ready don't look good to me...
> 
> My vacation is over. I suppose you haven't had a chance to take a look
> into the regression? (Just in case any of you is looking into that right
> now to not duplicate the effort.)

I haven't, sorry, as I was on vacation as well.

greg k-h
