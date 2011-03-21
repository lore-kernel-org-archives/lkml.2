Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab1CUXa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:30:58 -0400
Received: from kroah.org ([198.145.64.141]:52584 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab1CUXRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:24 2011
Message-Id: <20110321230324.162318304@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <greg@kroah.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Yin Kangkai <kangkai.yin@linux.intel.com>
Subject: [24/78] serial: change the divisor latch only when prescalar actually changed
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yin Kangkai <kangkai.yin@linux.intel.com>

commit 0d0389e5414c8950b1613e8bdc74289cde3d6d98 upstream.

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
Signed-off-by: Yin Kangkai <kangkai.yin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/serial/8250.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -954,6 +954,23 @@ static int broken_efr(struct uart_8250_p
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
@@ -1025,12 +1042,8 @@ static void autoconfig_16550a(struct uar
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


