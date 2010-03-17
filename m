Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0CQMa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:30:57 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:40861 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754722Ab0CQMaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:30:55 -0400
Date: Wed, 17 Mar 2010 13:30:50 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: x86@kernel.org, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, alan@linux.intel.com,
       akpm@linux-foundation.org, hpa@zytor.com
Subject: [PATCH 1/2]: serial8250: Use native_io_delay on the x86
Message-ID: <20100317133050.54851ff8@marrow.netinsight.se>
In-Reply-To: <20100317132849.7d49939b@marrow.netinsight.se>
References: <20100317132849.7d49939b@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port 0x80 is not safe to use on all x86 boards (see
arch/x86/kernel/io_delay.c), so use native_io_delay instead.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 drivers/serial/8250.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c3db16b..b3007a4 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -38,6 +38,7 @@
 #include <linux/serial_8250.h>
 #include <linux/nmi.h>
 #include <linux/mutex.h>
+#include <linux/io.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -1109,11 +1110,8 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		 * Do a simple existence test first; if we fail this,
 		 * there's no point trying anything else.
 		 *
-		 * 0x80 is used as a nonsense port to prevent against
-		 * false positives due to ISA bus float.  The
-		 * assumption is that 0x80 is a non-existent port;
-		 * which should be safe since include/asm/io.h also
-		 * makes this assumption.
+		 * The IO delay is used to prevent against false positives
+		 * due to ISA bus float.
 		 *
 		 * Note: this is safe as long as MCR bit 4 is clear
 		 * and the device is in "PC" mode.
@@ -1121,7 +1119,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		scratch = serial_inp(up, UART_IER);
 		serial_outp(up, UART_IER, 0);
 #ifdef __i386__
-		outb(0xff, 0x080);
+		native_io_delay();
 #endif
 		/*
 		 * Mask out IER[7:4] bits for test as some UARTs (e.g. TL
@@ -1130,7 +1128,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		scratch2 = serial_inp(up, UART_IER) & 0x0f;
 		serial_outp(up, UART_IER, 0x0F);
 #ifdef __i386__
-		outb(0, 0x080);
+		native_io_delay();
 #endif
 		scratch3 = serial_inp(up, UART_IER) & 0x0f;
 		serial_outp(up, UART_IER, scratch);
-- 
1.6.0.4

