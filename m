Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1BIDfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 22:35:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:35940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab1BIDfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 22:35:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,445,1291622400"; 
   d="scan'208";a="655857982"
From: Yin Kangkai <kangkai.yin@linux.intel.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        linux-serial <linux-serial@vger.kernel.org>
Cc: Yin Kangkai <kangkai.yin@linux.intel.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH resend 2/2] serial: change the divisor latch only when prescalar actually changed
Date: Wed,  9 Feb 2011 11:35:18 +0800
Message-Id: <1297222518-20801-1-git-send-email-kangkai.yin@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110125074447.GJ3315@kai-debian>
References: <20110125074447.GJ3315@kai-debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.7.2.3

