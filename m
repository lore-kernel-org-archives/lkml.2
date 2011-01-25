Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab1AYHB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:01:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:8647 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab1AYHB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:01:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,373,1291622400"; 
   d="scan'208,223";a="880661979"
Date: Tue, 25 Jan 2011 15:01:54 +0800
From: Yin Kangkai <kangkai.yin@linux.intel.com>
To: linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] serial: change the divisor latch only when prescalar
 actually changed
Message-ID: <20110125070154.GI3315@kai-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ae9984c3c24ad17d04a2fed547d1628f29b5be99 Mon Sep 17 00:00:00 2001
From: Yin Kangkai <kangkai.yin@intel.com>
Date: Mon, 24 Jan 2011 20:01:40 +0800
Subject: [PATCH] serial: change the divisor latch only when prescalar actually changed.

In 8250.c original ns16550 autoconfig code, we change the divisor latch when
we goto to high speed mode, we're assuming the previous speed is legacy. This
some times is not true.

For example in a system with both CONFIG_SERIAL_8250 and
CONFIG_SERIAL_8250_PNP set, in this case, the code (autoconfig) will
be called twice, one in serial8250_init/probe() and the other is from
serial_pnp_probe. When serial_pnp_probe calls the autoconfig for NS16550A,
it's already in high speed mode, change the divisor latch (quot << 3) in this
case will make the UART console garbled.

Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
---
 drivers/serial/8250.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b57f40f..e928e06 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -927,6 +927,24 @@ static int broken_efr(struct uart_8250_port *up)
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
+
 /*
  * We know that the chip has FIFOs.  Does it have an EFR?  The
  * EFR is located in the same register position as the IIR and
@@ -998,12 +1016,8 @@ static void autoconfig_16550a(struct uart_8250_port *up)
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
 
@@ -2975,15 +2989,10 @@ void serial8250_resume_port(int line)
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
1.6.5


-- 
Don't worry, be happy.
