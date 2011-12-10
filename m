Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab1LJN2F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 08:28:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:49298 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab1LJN2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 08:28:00 -0500
Message-Id: <20111210132439.049356768@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 10 Dec 2011 13:27:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>
Subject: [patch 2/3] kvm tool: serial: Simplify switch cases
References: <20111210132220.083204833@linutronix.de>
Content-Disposition: inline;
 filename=kvm-tool-serial-simplify-switch-cases.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point to have the same switch case construct for all the
registers, just to take care of the oddball case of DLL/DLM.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/kvm/hw/serial.c |  129 +++++++++++++++++---------------------------------
 1 file changed, 44 insertions(+), 85 deletions(-)

Index: linux-kvm/tools/kvm/hw/serial.c
===================================================================
--- linux-kvm.orig/tools/kvm/hw/serial.c
+++ linux-kvm/tools/kvm/hw/serial.c
@@ -187,73 +187,48 @@ static bool serial8250_out(struct ioport
 
 	offset = port - dev->iobase;
 
-	if (dev->lcr & UART_LCR_DLAB) {
-		switch (offset) {
-		case UART_DLL:
-			dev->dll = ioport__read8(data);
-			break;
-		case UART_DLM:
-			dev->dlm = ioport__read8(data);
-			break;
-		case UART_FCR:
-			dev->fcr = ioport__read8(data);
-			break;
-		case UART_LCR:
-			dev->lcr = ioport__read8(data);
-			break;
-		case UART_MCR:
-			dev->mcr = ioport__read8(data);
-			break;
-		case UART_LSR:
-			/* Factory test */
-			break;
-		case UART_MSR:
-			/* Not used */
-			break;
-		case UART_SCR:
-			dev->scr = ioport__read8(data);
-			break;
-		default:
-			ret = false;
-			break;
-		}
-	} else {
-		switch (offset) {
-		case UART_TX: {
+	switch (offset) {
+	case UART_TX:
+		if (!(dev->lcr & UART_LCR_DLAB)) {
 			char *addr = data;
 
 			if (!(dev->mcr & UART_MCR_LOOP))
 				term_putc(CONSOLE_8250, addr, size, dev->id);
 
 			dev->iir = UART_IIR_NO_INT;
-			break;
+		} else {
+			dev->dll = ioport__read8(data);
 		}
-		case UART_FCR:
-			dev->fcr = ioport__read8(data);
-			break;
-		case UART_IER:
+		break;
+	case UART_IER:
+		if (!(dev->lcr & UART_LCR_DLAB)) {
 			dev->ier = ioport__read8(data) & 0x3f;
 			kvm__irq_line(kvm, dev->irq, dev->ier ? 1 : 0);
-			break;
-		case UART_LCR:
-			dev->lcr = ioport__read8(data);
-			break;
-		case UART_MCR:
-			dev->mcr = ioport__read8(data);
-			break;
-		case UART_LSR:
-			/* Factory test */
-			break;
-		case UART_MSR:
-			/* Not used */
-			break;
-		case UART_SCR:
-			dev->scr = ioport__read8(data);
-			break;
-		default:
-			ret = false;
-			break;
+		} else {
+			dev->dlm = ioport__read8(data);
 		}
+		break;
+	case UART_FCR:
+		dev->fcr = ioport__read8(data);
+		break;
+	case UART_LCR:
+		dev->lcr = ioport__read8(data);
+		break;
+	case UART_MCR:
+		dev->mcr = ioport__read8(data);
+		break;
+	case UART_LSR:
+		/* Factory test */
+		break;
+	case UART_MSR:
+		/* Not used */
+		break;
+	case UART_SCR:
+		dev->scr = ioport__read8(data);
+		break;
+	default:
+		ret = false;
+		break;
 	}
 
 	mutex_unlock(&dev->mutex);
@@ -275,37 +250,22 @@ static bool serial8250_in(struct ioport
 
 	offset = port - dev->iobase;
 
-	if (dev->lcr & UART_LCR_DLAB) {
-		switch (offset) {
-		case UART_DLL:
+	switch (offset) {
+	case UART_RX:
+		if (dev->lcr & UART_LCR_DLAB) {
 			ioport__write8(data, dev->dll);
-			goto out_unlock;
-
-		case UART_DLM:
-			ioport__write8(data, dev->dlm);
-			goto out_unlock;
-
-		default:
-			break;
-		}
-	} else {
-		switch (offset) {
-		case UART_RX:
+		} else {
 			ioport__write8(data, dev->rbr);
 			dev->lsr &= ~UART_LSR_DR;
 			dev->iir = UART_IIR_NO_INT;
-			goto out_unlock;
-
-		case UART_IER:
-			ioport__write8(data, dev->ier);
-			goto out_unlock;
-
-		default:
-			break;
 		}
-	}
-
-	switch (offset) {
+		break;
+	case UART_IER:
+		if (dev->lcr & UART_LCR_DLAB)
+			ioport__write8(data, dev->dlm);
+		else
+			ioport__write8(data, dev->ier);
+		break;
 	case UART_IIR: {
 		u8 iir = dev->iir;
 
@@ -333,9 +293,8 @@ static bool serial8250_in(struct ioport
 		break;
 	default:
 		ret = false;
-		goto out_unlock;
+		break;
 	}
-out_unlock:
 	mutex_unlock(&dev->mutex);
 
 	return ret;


