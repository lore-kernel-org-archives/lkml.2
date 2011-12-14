Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1LNK5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:57:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:48889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1LNK5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:57:50 -0500
Message-ID: <1323860206.28489.35.camel@twins>
Subject: Re: printk() vs tty_io
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 14 Dec 2011 11:56:46 +0100
In-Reply-To: <20111214104308.14d0500c@pyramind.ukuu.org.uk>
References: <1323804803.9082.40.camel@twins>
	 <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
	 <20111214104308.14d0500c@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 10:43 +0000, Alan Cox wrote:
> On Tue, 13 Dec 2011 15:52:35 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Tue, Dec 13, 2011 at 11:33 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > I've been poking at reducing the constraints on printk(), like make it
> > > work under rq->lock etc..
> > 
> > You aren't supposed register a console that wakes things up. But the
> > only console that honors that afaik is the traditional vt console.
> > *Maybe* the network console, I didn't check.
> 
> Serial console tries to be good as does netconsole. 

Well, this was the 8250 serial port driver doing wakeups. Its a simple
on-board serial port,

[   29.797007]        [<ffffffff8108a650>] __wake_up_common+0x4e/0x84
[   29.797007]        [<ffffffff8108d6ea>] __wake_up+0x39/0x4d
[   29.797007]        [<ffffffff8135d0db>] tty_wakeup+0x5b/0x60
[   29.797007]        [<ffffffff81373fb9>] uart_write_wakeup+0x21/0x23
[   29.797007]        [<ffffffff81376899>] transmit_chars+0xd8/0x12f
[   29.797007]        [<ffffffff81377f3a>] serial8250_handle_port+0x2d9/0x2fd
[   29.797007]        [<ffffffff81377fcb>] serial8250_handle_irq+0x16/0x1d
[   29.797007]        [<ffffffff81377ff5>] serial8250_default_handle_irq+0x23/0x27
[   29.797007]        [<ffffffff81377ade>] serial8250_interrupt+0x4d/0xc6
[   29.797007]        [<ffffffff810c9ae8>] handle_irq_event_percpu+0xab/0x1fc
[   29.797007]        [<ffffffff810c9c7a>] handle_irq_event+0x41/0x61
[   29.797007]        [<ffffffff810cc4cd>] handle_edge_irq+0xd1/0xf6
[   29.797007]        [<ffffffff8103ab85>] handle_irq+0x24/0x2f
[   29.797007]        [<ffffffff8150acdd>] do_IRQ+0x4d/0xb3

which places the wakeup under uport->lock, serial8250_console_write()
takes uport->lock, under console_sem, connecting the locks.


