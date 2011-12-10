Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab1LJUvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 15:51:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:49917 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1LJUvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 15:51:48 -0500
Date: Sat, 10 Dec 2011 21:51:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pekka Enberg <penberg@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        mingo@elte.hu
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
In-Reply-To: <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
Message-ID: <alpine.LFD.2.02.1112102144370.3020@ionos>
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Dec 2011, Pekka Enberg wrote:

> On Sat, 10 Dec 2011, Thomas Gleixner wrote:
> > We observed massive hangs of the serial console in kvm tool which
> > turned out to be caused by the bogus emulation of the interrupt line
> > behaviour.
> > 
> > This series cleans up and simplifies the serial code and in the last
> > step fixes the interrupt handling proper.
> 
> Applied, thanks Thomas!

There is a slight problem with them. I only tested them with the
rt-guest kernels, but non rt kernels are slightly unhappy. Sorry for
not thinking about that.

Fix below.

Thanks,

	tglx
------------------>
Subject: kvm tools: serial: Make it work with non rt guests as well
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 10 Dec 2011 21:27:26 +0100

Sasha reported, that a non RT guest reports "too much work for irq 4"
with the previous serial overhaul.

The reason is, that the new code allows unlimited tx transfers, which
triggers the sanity check in the 8250.c interrupt handler.

Limit the consecutive TX chars to 16 and let the guest kernel escape
from the 8250 interrupt handler. Set the TEMT/THRE bits in the
periodic serial console update.

Reported-by: Sasha Levin  <levinsasha928@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/kvm/hw/serial.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

Index: linux-kvm/tools/kvm/hw/serial.c
===================================================================
--- linux-kvm.orig/tools/kvm/hw/serial.c
+++ linux-kvm/tools/kvm/hw/serial.c
@@ -19,6 +19,7 @@ struct serial8250_device {
 	u16			iobase;
 	u8			irq;
 	u8			irq_state;
+	int			txcnt;
 
 	u8			rbr;		/* receive buffer */
 	u8			dll;
@@ -105,6 +106,16 @@ static void serial8250_update_irq(struct
 			kvm__irq_line(kvm, dev->irq, 1);
 	}
 	dev->irq_state = iir;
+
+	/*
+	 * If the kernel disabled the tx interrupt, we know that there
+	 * is nothing more to transmit, so we can reset our tx logic
+	 * here.
+	 */
+	if (!(dev->ier & UART_IER_THRI)) {
+		dev->lsr |= UART_LSR_TEMT | UART_LSR_THRE;
+		dev->txcnt = 0;
+	}
 }
 
 #define SYSRQ_PENDING_NONE		0
@@ -134,6 +145,15 @@ static void serial8250__receive(struct k
 {
 	int c;
 
+	/*
+	 * If the guest transmitted 16 chars in a row, we clear the
+	 * TEMT/THRE bits to let the kernel escape from the 8250
+	 * interrupt handler. We come here only once a ms, so that
+	 * should give the kernel the desired pause.
+	 */
+	dev->lsr |= UART_LSR_TEMT | UART_LSR_THRE;
+	dev->txcnt = 0;
+
 	if (dev->lsr & UART_LSR_DR)
 		return;
 
@@ -212,14 +232,8 @@ static bool serial8250_out(struct ioport
 				term_putc(CONSOLE_8250, addr, size, dev->id);
 			/* else FIXME: Inject data into rcv path for LOOP */
 
-			/*
-			 * Set transmitter and transmit hold register
-			 * empty.  We have no FIFO at the moment and
-			 * on the TX side it's only interesting, when
-			 * we could coalesce port io on the kernel
-			 * kernel.
-			 */
-			dev->lsr |= UART_LSR_TEMT | UART_LSR_THRE;
+			if (++dev->txcnt == 16)
+				dev->lsr &= ~(UART_LSR_TEMT | UART_LSR_THRE);
 			break;
 		} else {
 			dev->dll = ioport__read8(data);


