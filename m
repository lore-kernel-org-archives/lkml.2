Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2B1IgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:36:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39541 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2B1IgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:36:14 -0500
Date: Tue, 28 Feb 2012 08:35:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chanho Min <chanho0207@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
Message-ID: <20120228083545.GA18045@n2100.arm.linux.org.uk>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com> <20120227104858.GR22562@n2100.arm.linux.org.uk> <20120227110204.GA30199@n2100.arm.linux.org.uk> <CAOAMb1BjC2bF=rpJAhRUrB_U2mp8HGWxfcp+=TZ1etWzjUEwig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOAMb1BjC2bF=rpJAhRUrB_U2mp8HGWxfcp+=TZ1etWzjUEwig@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:35:30AM +0900, Chanho Min wrote:
> On Mon, Feb 27, 2012 at 8:02 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Feb 27, 2012 at 10:48:58AM +0000, Russell King - ARM Linux wrote:
> >> I'd much prefer to only clear those interrupts which actually need to be
> >> cleared at this point.  So, I'd suggest this approach instead:
> >
> > Thinking about this a little more, we definitely want to mask and clear
> > interrupts at probe time as well:
> >
> I'm not satisfied with this completely. RIS has some pending
> interrupts even if interrupts are masked/disabled in IMSC. If your
> patch is applied, interrupt can be pended as bellows and RXFE of the
> flag register is set as well.

RXFE _will_ be set.  Think about it - RXFE means Receive Fifo Empty.
If the receive fifo is empty, it _will_ be set.

And RIS is the _Raw_ interrupt status.  That's the status _before_ the
mask is acted upon.

> writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS |
>        UART011_RTIS | UART011_RXIS, uap->port.membase + UART011_ICR);
> ...
> Interrupt is occured and pended in RIS

But it won't be delivered because the mask register is zero.

> ..
> writew(uap->im, uap->port.membase + UART011_IMSC);
> 
> Root cause is that Rx interrupt set but Rx fifo is empty. If we just
> remove the sentence for clearing LCRH, nothing happens and interrupt
> handler don't this misbehave.

No.
