Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1LNOYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:24:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47251 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1LNOYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:24:51 -0500
Message-ID: <1323872631.28489.37.camel@twins>
Subject: Re: printk() vs tty_io
From: Peter Zijlstra <peterz@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 14 Dec 2011 15:23:51 +0100
In-Reply-To: <20111214140527.GA18080@thunk.org>
References: <1323804803.9082.40.camel@twins>
	 <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
	 <20111214104308.14d0500c@pyramind.ukuu.org.uk>
	 <1323860206.28489.35.camel@twins> <20111214140527.GA18080@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 09:05 -0500, Ted Ts'o wrote:
> On Wed, Dec 14, 2011 at 11:56:46AM +0100, Peter Zijlstra wrote:
> > 
> > Well, this was the 8250 serial port driver doing wakeups. Its a simple
> > on-board serial port,
> > 
> > [   29.797007]        [<ffffffff8108a650>] __wake_up_common+0x4e/0x84
> > [   29.797007]        [<ffffffff8108d6ea>] __wake_up+0x39/0x4d
> > [   29.797007]        [<ffffffff8135d0db>] tty_wakeup+0x5b/0x60
> > [   29.797007]        [<ffffffff81373fb9>] uart_write_wakeup+0x21/0x23
> > [   29.797007]        [<ffffffff81376899>] transmit_chars+0xd8/0x12f
> > [   29.797007]        [<ffffffff81377f3a>] serial8250_handle_port+0x2d9/0x2fd
> > [   29.797007]        [<ffffffff81377fcb>] serial8250_handle_irq+0x16/0x1d
> > [   29.797007]        [<ffffffff81377ff5>] serial8250_default_handle_irq+0x23/0x27
> > [   29.797007]        [<ffffffff81377ade>] serial8250_interrupt+0x4d/0xc6
> > [   29.797007]        [<ffffffff810c9ae8>] handle_irq_event_percpu+0xab/0x1fc
> > [   29.797007]        [<ffffffff810c9c7a>] handle_irq_event+0x41/0x61
> > [   29.797007]        [<ffffffff810cc4cd>] handle_edge_irq+0xd1/0xf6
> > [   29.797007]        [<ffffffff8103ab85>] handle_irq+0x24/0x2f
> > [   29.797007]        [<ffffffff8150acdd>] do_IRQ+0x4d/0xb3
> > 
> > which places the wakeup under uport->lock, serial8250_console_write()
> > takes uport->lock, under console_sem, connecting the locks.
> 
> printk() goes through serial8250_console_write() which writes to the
> UART device using a busy loop, with local IRQ's disabled.  So it's not
> serial8250_console_write() which is waking things up; this is coming
> form interrupt handler running on some different CPU.

Which can still deadlock you just fine..
