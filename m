Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0CQOJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:09:18 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:42251 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754951Ab0CQOJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:09:14 -0400
Date: Wed, 17 Mar 2010 15:09:07 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Alan Cox <alan@linux.intel.com>
Cc: x86@kernel.org, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
       hpa@zytor.com
Subject: Re: [PATCH 1/2]: serial8250: Use native_io_delay on the x86
Message-ID: <20100317150907.59d40834@marrow.netinsight.se>
In-Reply-To: <20100317130159.23d1103f@linux.intel.com>
References: <20100317132849.7d49939b@marrow.netinsight.se>
	<20100317133050.54851ff8@marrow.netinsight.se>
	<20100317130159.23d1103f@linux.intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 13:01:59 +0000
Alan Cox <alan@linux.intel.com> wrote:

> On Wed, 17 Mar 2010 13:30:50 +0100
> Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:
> 
> > Port 0x80 is not safe to use on all x86 boards (see
> > arch/x86/kernel/io_delay.c), so use native_io_delay instead.
> > 
> > Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
> 
> native_io_delay() won't work if the system is being run with no delays.
> The I/O cycle isn't for the delay but to force the bus signals. So in
> various modes (paravirt, udelay, no delay) the native_io_delay won't
> actually do what is required.

You are right, I should have seen that.

Would something similar to the other patch be acceptable, i.e., like
the diff below?

> I'm actually surprised you hit this path and if anything the right fix
> is to avoid hitting this kind of probing in the first place.

But isn't this code path pretty much always being executed? If I read
the code correct, unless we have a buggy UART it will be executed if
UPF_BOOT_AUTOCONF is set.

// Simon

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 524f6ab..c5e3f9a 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -38,6 +38,7 @@
 #include <linux/serial_8250.h>
 #include <linux/nmi.h>
 #include <linux/mutex.h>
+#include <linux/io.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -1071,6 +1072,19 @@ static void autoconfig_16550a(struct uart_8250_port *up)
        serial_outp(up, UART_IER, iersave);
 }
 
+static void bus_delay(u8 val)
+{
+#ifdef __i386__
+# ifdef CONFIG_IO_DELAY_TYPE_0XED
+       const u16 io_port = 0xed;
+# else
+       const u16 io_port = 0x80;
+#endif
+
+       outb(0xff, io_port);
+#endif
+}
+
 /*
  * This routine is called by rs_init() to initialize a specific serial
  * port.  It determines what type of UART chip this serial port is
@@ -1104,29 +1118,24 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
                 * Do a simple existence test first; if we fail this,
                 * there's no point trying anything else.
                 *
-                * 0x80 is used as a nonsense port to prevent against
-                * false positives due to ISA bus float.  The
-                * assumption is that 0x80 is a non-existent port;
-                * which should be safe since include/asm/io.h also
-                * makes this assumption.
+                * The IO delay is used to prevent against false positives
+                * due to ISA bus float.
                 *
                 * Note: this is safe as long as MCR bit 4 is clear
                 * and the device is in "PC" mode.
                 */
                scratch = serial_inp(up, UART_IER);
                serial_outp(up, UART_IER, 0);
-#ifdef __i386__
-               outb(0xff, 0x080);
-#endif
+               bus_delay(0xff);
+
                /*
                 * Mask out IER[7:4] bits for test as some UARTs (e.g. TL
                 * 16C754B) allow only to modify them if an EFR bit is set.
                 */
                scratch2 = serial_inp(up, UART_IER) & 0x0f;
                serial_outp(up, UART_IER, 0x0F);
-#ifdef __i386__
-               outb(0, 0x080);
-#endif
+               bus_delay(0x0);
+
                scratch3 = serial_inp(up, UART_IER) & 0x0f;
                serial_outp(up, UART_IER, scratch);
                if (scratch2 != 0 || scratch3 != 0x0F) {
[simkag@marrow kernel]$ 
