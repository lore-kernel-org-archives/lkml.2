Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab2B1JWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:22:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55120 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab2B1JWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:22:02 -0500
Date: Tue, 28 Feb 2012 09:21:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chanho Min <chanho0207@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
Message-ID: <20120228092140.GD18045@n2100.arm.linux.org.uk>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com> <20120227104858.GR22562@n2100.arm.linux.org.uk> <20120227110204.GA30199@n2100.arm.linux.org.uk> <CAOAMb1BjC2bF=rpJAhRUrB_U2mp8HGWxfcp+=TZ1etWzjUEwig@mail.gmail.com> <20120228083545.GA18045@n2100.arm.linux.org.uk> <CAOAMb1CJ=G45G3JsxwP23GSdEOnDmY5xVoQmWLXaKJJv2cLOLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOAMb1CJ=G45G3JsxwP23GSdEOnDmY5xVoQmWLXaKJJv2cLOLg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 06:16:10PM +0900, Chanho Min wrote:
> > RXFE _will_ be set.  Think about it - RXFE means Receive Fifo Empty.
> > If the receive fifo is empty, it _will_ be set.
> I know meaning of the RXFE. I also don't understand why RXFE is set by
> clearing FEN. We checked this by bellow debug codes.
> 
>  fr_before = readw(uap->port.membase + UART01x_FR);
>  writew(0, uap->port.membase + uap->lcrh_rx);
>  fr_after = readw(uap->port.membase + UART01x_FR);
> 
> If rx interrupt is ocurred before, fr_after becomes 0x90 but fr_before is 0x80.

Because the flags are manipulated to give the illusion of a one byte
FIFO, as stated in the TRM.

> > And RIS is the _Raw_ interrupt status.  That's the status _before_ the
> > mask is acted upon.
> >
> > But it won't be delivered because the mask register is zero.
> It can be delivered just after mask register is set to 1.

And we don't set the mask register to 1 until later.

> >> Root cause is that Rx interrupt set but Rx fifo is empty. If we just
> >> remove the sentence for clearing LCRH, nothing happens and interrupt
> >> handler don't this misbehave.
> >
> > No.
> When we just removed the sentence for clearing LCRH, this hangup doesn't
> happen.

But we want to do the transmit interrupt provocation with the FIFO disabled.
