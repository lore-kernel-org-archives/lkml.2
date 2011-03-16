Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab1CPVOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:14:19 -0400
Received: from kroah.org ([198.145.64.141]:32839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab1CPVNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:13:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-serial@vger.kernel.org
Cc: Yin Kangkai <kangkai.yin@linux.intel.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/76] serial: change the divisor latch only when prescalar actually changed
Date: Wed, 16 Mar 2011 14:11:57 -0700
Message-Id: <1300309966-5745-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309966-5745-1-git-send-email-gregkh@suse.de>
References: <20110316205746.GA2938@kroah.com>
 <1300309966-5745-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yin Kangkai <kangkai.yin@linux.intel.com>

In 8250.c original ns16550 autoconfig code, we change the divisor latch when
we goto to high speed mode, we're assuming the previous speed is legacy. This
some times is not true.

For example in a system with both CONFIG_SERIAL_8250 and
CONFIG_SERIAL_8250_PNP set, in this case, the code (autoconfig) will be called
twice, one in serial8250_init/probe() and the other is from
serial_pnp_probe. When serial_pnp_probe calls the autoconfig for NS16550A,
it's already in high speed mode, change the divisor latch (quot << 3) in this
case will make the UART console garbled.

CC: Greg Kroah-Hartman <greg@kroah.com>
CC: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
CC: stable@kernel.org
Signed-off-by: Yin Kangkai <kangkai.yin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/serial/8250.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index c10a6a9..b3b881b 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -954,6 +954,23 @@ static int broken_efr(struct uart_8250_port *up)
 	return 0;
 }
 
+static inline int ns16550a_goto_highspeed(struct uart_8250_port *up)
+{
+	unsigned char status;
+
+	status = serial_in(up, 0x04); /* EXCR2 */
+#define PRESL(x) ((x) & 0x30)
+	if (PRESL(status) == 0x10) {
+		/* already in high speed mode */
+		return 0;
+	} else {
+		status &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
+		status |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
+		serial_outp(up, 0x04, status);
+	}
+	return 1;
+}
+
 /*
  * We know that the chip has FIFOs.  Does it have an EFR?  The
  * EFR is located in the same register position as the IIR and
@@ -1025,12 +1042,8 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 			quot = serial_dl_read(up);
 			quot <<= 3;
 
-			status1 = serial_in(up, 0x04); /* EXCR2 */
-			status1 &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
-			status1 |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
-			serial_outp(up, 0x04, status1);
-
-			serial_dl_write(up, quot);
+			if (ns16550a_goto_highspeed(up))
+				serial_dl_write(up, quot);
 
 			serial_outp(up, UART_LCR, 0);
 
@@ -3025,15 +3038,10 @@ void serial8250_resume_port(int line)
 	struct uart_8250_port *up = &serial8250_ports[line];
 
 	if (up->capabilities & UART_NATSEMI) {
-		unsigned char tmp;
-
 		/* Ensure it's still in high speed mode */
 		serial_outp(up, UART_LCR, 0xE0);
 
-		tmp = serial_in(up, 0x04); /* EXCR2 */
-		tmp &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
-		tmp |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
-		serial_outp(up, 0x04, tmp);
+		ns16550a_goto_highspeed(up);
 
 		serial_outp(up, UART_LCR, 0);
 		up->port.uartclk = 921600*16;
-- 
1.7.4.1

