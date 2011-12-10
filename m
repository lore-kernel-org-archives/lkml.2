Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab1LJN2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 08:28:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:49303 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab1LJN2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 08:28:00 -0500
Message-Id: <20111210132439.123088569@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 10 Dec 2011 13:27:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>
Subject: [patch 3/3] kvm tool: serial: Fix interrupt handling
References: <20111210132220.083204833@linutronix.de>
Content-Disposition: inline;
 filename=kvm-tools-serial-fix-interrupt-handling.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt injection of the serial emulation is completely
broken. It's just doing random toggling of the interrupt line, which
can lead to complete console hangs.

The real hardware asserts the interrupt line when a condition
(RX/TX/Status) is met and the corresponding interrupt is enabled in
the IER. It's deasserted when the condition is cleared or the
corresponding interrupt is disabled in the IER.

So the correct emulation just needs to check after each state change
in the LSR or the IER which bits in the IIR need to be set and update
the interrupt line accordingly. To avoid setting the same state over
and over keep an internal state of the last set interrupt line state
and only update via the kvm ioctl when the new state differs.

Rename serial8250__inject_interrupts() to serial8250__update_consoles()
which reflects what the function really is about.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/kvm/hw/serial.c               |   74 ++++++++++++++++++++++--------------
 tools/kvm/include/kvm/8250-serial.h |    2 
 tools/kvm/x86/kvm.c                 |    2 
 3 files changed, 49 insertions(+), 29 deletions(-)

Index: linux-kvm/tools/kvm/hw/serial.c
===================================================================
--- linux-kvm.orig/tools/kvm/hw/serial.c
+++ linux-kvm/tools/kvm/hw/serial.c
@@ -18,6 +18,7 @@ struct serial8250_device {
 
 	u16			iobase;
 	u8			irq;
+	u8			irq_state;
 
 	u8			rbr;		/* receive buffer */
 	u8			dll;
@@ -81,6 +82,31 @@ static struct serial8250_device devices[
 	},
 };
 
+static void serial8250_update_irq(struct kvm *kvm, struct serial8250_device *dev)
+{
+	u8 iir = 0;
+
+	/* Data ready and rcv interrupt enabled ? */
+	if ((dev->ier & UART_IER_RDI) && (dev->lsr & UART_LSR_DR))
+		iir |= UART_IIR_RDI;
+
+	/* Transmitter empty and interrupt enabled ? */
+	if ((dev->ier & UART_IER_THRI) && (dev->lsr & UART_LSR_TEMT))
+		iir |= UART_IIR_THRI;
+
+	/* Now update the irq line, if necessary */
+	if (!iir) {
+		dev->iir = UART_IIR_NO_INT;
+		if (dev->irq_state)
+			kvm__irq_line(kvm, dev->irq, 0);
+	} else {
+		dev->iir = iir;
+		if (!dev->irq_state)
+			kvm__irq_line(kvm, dev->irq, 1);
+	}
+	dev->irq_state = iir;
+}
+
 #define SYSRQ_PENDING_NONE		0
 #define SYSRQ_PENDING_BREAK		1
 #define SYSRQ_PENDING_CMD		2
@@ -128,7 +154,7 @@ static void serial8250__receive(struct k
 	dev->lsr |= UART_LSR_DR;
 }
 
-void serial8250__inject_interrupt(struct kvm *kvm)
+void serial8250__update_consoles(struct kvm *kvm)
 {
 	unsigned int i;
 
@@ -139,17 +165,7 @@ void serial8250__inject_interrupt(struct
 
 		serial8250__receive(kvm, dev);
 
-		if (dev->ier & UART_IER_RDI && dev->lsr & UART_LSR_DR)
-			dev->iir = UART_IIR_RDI;
-		else if (dev->ier & UART_IER_THRI)
-			dev->iir = UART_IIR_THRI;
-		else
-			dev->iir = UART_IIR_NO_INT;
-
-		if (dev->iir != UART_IIR_NO_INT) {
-			kvm__irq_line(kvm, dev->irq, 0);
-			kvm__irq_line(kvm, dev->irq, 1);
-		}
+		serial8250_update_irq(kvm, dev);
 
 		mutex_unlock(&dev->mutex);
 	}
@@ -194,19 +210,26 @@ static bool serial8250_out(struct ioport
 
 			if (!(dev->mcr & UART_MCR_LOOP))
 				term_putc(CONSOLE_8250, addr, size, dev->id);
+			/* else FIXME: Inject data into rcv path for LOOP */
 
-			dev->iir = UART_IIR_NO_INT;
+			/*
+			 * Set transmitter and transmit hold register
+			 * empty.  We have no FIFO at the moment and
+			 * on the TX side it's only interesting, when
+			 * we could coalesce port io on the kernel
+			 * kernel.
+			 */
+			dev->lsr |= UART_LSR_TEMT | UART_LSR_THRE;
+			break;
 		} else {
 			dev->dll = ioport__read8(data);
 		}
 		break;
 	case UART_IER:
-		if (!(dev->lcr & UART_LCR_DLAB)) {
+		if (!(dev->lcr & UART_LCR_DLAB))
 			dev->ier = ioport__read8(data) & 0x3f;
-			kvm__irq_line(kvm, dev->irq, dev->ier ? 1 : 0);
-		} else {
+		else
 			dev->dlm = ioport__read8(data);
-		}
 		break;
 	case UART_FCR:
 		dev->fcr = ioport__read8(data);
@@ -231,6 +254,8 @@ static bool serial8250_out(struct ioport
 		break;
 	}
 
+	serial8250_update_irq(kvm, dev);
+
 	mutex_unlock(&dev->mutex);
 
 	return ret;
@@ -257,7 +282,6 @@ static bool serial8250_in(struct ioport 
 		} else {
 			ioport__write8(data, dev->rbr);
 			dev->lsr &= ~UART_LSR_DR;
-			dev->iir = UART_IIR_NO_INT;
 		}
 		break;
 	case UART_IER:
@@ -266,15 +290,9 @@ static bool serial8250_in(struct ioport 
 		else
 			ioport__write8(data, dev->ier);
 		break;
-	case UART_IIR: {
-		u8 iir = dev->iir;
-
-		if (dev->fcr & UART_FCR_ENABLE_FIFO)
-			iir |= 0xc0;
-
-		ioport__write8(data, iir);
+	case UART_IIR:
+		ioport__write8(data, dev->iir);
 		break;
-	}
 	case UART_LCR:
 		ioport__write8(data, dev->lcr);
 		break;
@@ -283,7 +301,6 @@ static bool serial8250_in(struct ioport 
 		break;
 	case UART_LSR:
 		ioport__write8(data, dev->lsr);
-		dev->lsr &= ~(UART_LSR_OE|UART_LSR_PE|UART_LSR_FE|UART_LSR_BI);
 		break;
 	case UART_MSR:
 		ioport__write8(data, dev->msr);
@@ -295,6 +312,9 @@ static bool serial8250_in(struct ioport 
 		ret = false;
 		break;
 	}
+
+	serial8250_update_irq(kvm, dev);
+
 	mutex_unlock(&dev->mutex);
 
 	return ret;
Index: linux-kvm/tools/kvm/include/kvm/8250-serial.h
===================================================================
--- linux-kvm.orig/tools/kvm/include/kvm/8250-serial.h
+++ linux-kvm/tools/kvm/include/kvm/8250-serial.h
@@ -4,7 +4,7 @@
 struct kvm;
 
 void serial8250__init(struct kvm *kvm);
-void serial8250__inject_interrupt(struct kvm *kvm);
+void serial8250__update_consoles(struct kvm *kvm);
 void serial8250__inject_sysrq(struct kvm *kvm);
 
 #endif /* KVM__8250_SERIAL_H */
Index: linux-kvm/tools/kvm/x86/kvm.c
===================================================================
--- linux-kvm.orig/tools/kvm/x86/kvm.c
+++ linux-kvm/tools/kvm/x86/kvm.c
@@ -351,6 +351,6 @@ void kvm__arch_setup_firmware(struct kvm
 
 void kvm__arch_periodic_poll(struct kvm *kvm)
 {
-	serial8250__inject_interrupt(kvm);
+	serial8250__update_consoles(kvm);
 	virtio_console__inject_interrupt(kvm);
 }


