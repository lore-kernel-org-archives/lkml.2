Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965129Ab2B1Bfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:35:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60944 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab2B1Bfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:35:30 -0500
MIME-Version: 1.0
In-Reply-To: <20120227110204.GA30199@n2100.arm.linux.org.uk>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
	<20120227104858.GR22562@n2100.arm.linux.org.uk>
	<20120227110204.GA30199@n2100.arm.linux.org.uk>
Date: Tue, 28 Feb 2012 10:35:30 +0900
Message-ID: <CAOAMb1BjC2bF=rpJAhRUrB_U2mp8HGWxfcp+=TZ1etWzjUEwig@mail.gmail.com>
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
From: Chanho Min <chanho0207@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 8:02 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Feb 27, 2012 at 10:48:58AM +0000, Russell King - ARM Linux wrote:
>> I'd much prefer to only clear those interrupts which actually need to be
>> cleared at this point.  So, I'd suggest this approach instead:
>
> Thinking about this a little more, we definitely want to mask and clear
> interrupts at probe time as well:
>
I'm not satisfied with this completely. RIS has some pending
interrupts even if interrupts are masked/disabled in IMSC. If your
patch is applied, interrupt can be pended as bellows and RXFE of the
flag register is set as well.

writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS |
       UART011_RTIS | UART011_RXIS, uap->port.membase + UART011_ICR);
...
Interrupt is occured and pended in RIS
..
writew(uap->im, uap->port.membase + UART011_IMSC);

Root cause is that Rx interrupt set but Rx fifo is empty. If we just
remove the sentence for clearing LCRH, nothing happens and interrupt
handler don't this misbehave. Also I don't fully understand why we
need to clear interrupts at probe time. If we prefer to only clear
those interrupts which actually need to be cleared, this is the
improved patch.

Thanks,

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 drivers/tty/serial/amba-pl011.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 6800f5f..96d1828 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1397,7 +1397,12 @@ static int pl011_startup(struct uart_port *port)
 	writew(cr, uap->port.membase + UART011_CR);
 	writew(0, uap->port.membase + UART011_FBRD);
 	writew(1, uap->port.membase + UART011_IBRD);
+	spin_lock_irq(&uap->port.lock);
 	writew(0, uap->port.membase + uap->lcrh_rx);
+	/* Clear pending error and receive interrupts */
+	writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS |
+		UART011_RTIS | UART011_RXIS, uap->port.membase + UART011_ICR);
+	spin_unlock_irq(&uap->port.lock);
 	if (uap->lcrh_tx != uap->lcrh_rx) {
 		int i;
 		/*
@@ -1417,10 +1422,6 @@ static int pl011_startup(struct uart_port *port)
 	cr |= UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
 	writew(cr, uap->port.membase + UART011_CR);

-	/* Clear pending error interrupts */
-	writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS,
-	       uap->port.membase + UART011_ICR);
-
 	/*
 	 * initialise the old status of the modem signals
 	 */
-- 
1.7.0.4
