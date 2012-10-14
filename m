Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2JNO43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:56:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46560 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677Ab2JNOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:32 -0400
Message-Id: <20121014143542.770448123@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        Guillaume Jaunet <guillaume.jaunet@stericsson.com>,
        Christophe Arnal <christophe.arnal@stericsson.com>,
        Matthias Locher <matthias.locher@stericsson.com>,
        Rajanikanth HV <rajanikanth.hv@stericsson.com>,
        Bibek Basu <bibek.basu@stericsson.com>,
        Par-Gunnar Hjalmdahl <par-gunnar.hjalmdahl@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 066/147] serial: pl011: handle corruption at high clock speeds
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit c5dd553b9fd069892c9e2de734f4f604e280fa7a upstream.

This works around a few glitches in the ST version of the PL011
serial driver when using very high baud rates, as we do in the
Ux500: 3, 3.25, 4 and 4.05 Mbps.

Problem Observed/rootcause:

When using high baud-rates, and the baudrate*8 is getting close to
the provided clock frequency (so a division factor close to 1), when
using bursts of characters (so they are abutted), then it seems as if
there is not enough time to detect the beginning of the start-bit which
is a timing reference for the entire character, and thus the sampling
moment of character bits is moving towards the end of each bit, instead
of the middle.

Fix:
Increase slightly the RX baud rate of the UART above the theoretical
baudrate by 5%. This will definitely give more margin time to the
UART_RX to correctly sample the data at the middle of the bit period.

Also fix the ages old copy-paste error in the very stressed comment,
it's referencing the registers used in the PL010 driver rather than
the PL011 ones.

Signed-off-by: Guillaume Jaunet <guillaume.jaunet@stericsson.com>
Signed-off-by: Christophe Arnal <christophe.arnal@stericsson.com>
Signed-off-by: Matthias Locher <matthias.locher@stericsson.com>
Signed-off-by: Rajanikanth HV <rajanikanth.hv@stericsson.com>
Cc: Bibek Basu <bibek.basu@stericsson.com>
Cc: Par-Gunnar Hjalmdahl <par-gunnar.hjalmdahl@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/amba-pl011.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index cede938..925eb88 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1595,13 +1595,26 @@ pl011_set_termios(struct uart_port *port, struct ktermios *termios,
 			old_cr &= ~ST_UART011_CR_OVSFACT;
 	}
 
+	/*
+	 * Workaround for the ST Micro oversampling variants to
+	 * increase the bitrate slightly, by lowering the divisor,
+	 * to avoid delayed sampling of start bit at high speeds,
+	 * else we see data corruption.
+	 */
+	if (uap->vendor->oversampling) {
+		if ((baud >= 3000000) && (baud < 3250000) && (quot > 1))
+			quot -= 1;
+		else if ((baud > 3250000) && (quot > 2))
+			quot -= 2;
+	}
 	/* Set baud rate */
 	writew(quot & 0x3f, port->membase + UART011_FBRD);
 	writew(quot >> 6, port->membase + UART011_IBRD);
 
 	/*
 	 * ----------v----------v----------v----------v-----
-	 * NOTE: MUST BE WRITTEN AFTER UARTLCR_M & UARTLCR_L
+	 * NOTE: lcrh_tx and lcrh_rx MUST BE WRITTEN AFTER
+	 * UART011_FBRD & UART011_IBRD.
 	 * ----------^----------^----------^----------^-----
 	 */
 	writew(lcr_h, port->membase + uap->lcrh_rx);


