Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0DAQdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:33:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42115 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932189Ab0DAQdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:33:18 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 02/14] tty: serial - fix tty back references in termios
To: linux-kernel@vger.kernel.org
Date: Thu, 01 Apr 2010 17:04:29 +0100
Message-ID: <20100401160424.8882.1814.stgit@localhost.localdomain>
In-Reply-To: <20100401155513.8882.54006.stgit@localhost.localdomain>
References: <20100401155513.8882.54006.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One or two drivers go poking back into the tty from the termios setting
routine in unsafe ways. We don't need to pass the tty down because the
[ab]users are just using it to get at things they can get at anyway.

This leaves low_latency setting to sort out along with set_ldisc use.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/21285.c       |   10 +++-------
 drivers/serial/imx.c         |   10 ++++------
 drivers/serial/ioc3_serial.c |    9 +++++----
 drivers/serial/ioc4_serial.c |    9 +++++----
 drivers/serial/max3100.c     |    3 +--
 5 files changed, 18 insertions(+), 23 deletions(-)


diff --git a/drivers/serial/21285.c b/drivers/serial/21285.c
index 8681f13..d89aa38 100644
--- a/drivers/serial/21285.c
+++ b/drivers/serial/21285.c
@@ -216,7 +216,7 @@ serial21285_set_termios(struct uart_port *port, struct ktermios *termios,
 			struct ktermios *old)
 {
 	unsigned long flags;
-	unsigned int baud, quot, h_lcr;
+	unsigned int baud, quot, h_lcr, b;
 
 	/*
 	 * We don't support modem control lines.
@@ -234,12 +234,8 @@ serial21285_set_termios(struct uart_port *port, struct ktermios *termios,
 	 */
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16); 
 	quot = uart_get_divisor(port, baud);
-
-	if (port->state && port->state->port.tty) {
-		struct tty_struct *tty = port->state->port.tty;
-		unsigned int b = port->uartclk / (16 * quot);
-		tty_encode_baud_rate(tty, b, b);
-	}
+	b = port->uartclk / (16 * quot);
+	tty_termios_encode_baud_rate(termios, b, b);
 
 	switch (termios->c_cflag & CSIZE) {
 	case CS5:
diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 4315b23..9504b44 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -901,13 +901,11 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 	rational_best_approximation(16 * div * baud, sport->port.uartclk,
 		1 << 16, 1 << 16, &num, &denom);
 
-	if (port->state && port->state->port.tty) {
-		tdiv64 = sport->port.uartclk;
-		tdiv64 *= num;
-		do_div(tdiv64, denom * 16 * div);
-		tty_encode_baud_rate(sport->port.state->port.tty,
+	tdiv64 = sport->port.uartclk;
+	tdiv64 *= num;
+	do_div(tdiv64, denom * 16 * div);
+	tty_termios_encode_baud_rate(termios,
 				(speed_t)tdiv64, (speed_t)tdiv64);
-	}
 
 	num -= 1;
 	denom -= 1;
diff --git a/drivers/serial/ioc3_serial.c b/drivers/serial/ioc3_serial.c
index f164ba4..bd2e9e6 100644
--- a/drivers/serial/ioc3_serial.c
+++ b/drivers/serial/ioc3_serial.c
@@ -954,12 +954,13 @@ ioc3_change_speed(struct uart_port *the_port,
 		  struct ktermios *new_termios, struct ktermios *old_termios)
 {
 	struct ioc3_port *port = get_ioc3_port(the_port);
-	unsigned int cflag;
+	unsigned int cflag, iflag;
 	int baud;
 	int new_parity = 0, new_parity_enable = 0, new_stop = 0, new_data = 8;
 	struct uart_state *state = the_port->state;
 
 	cflag = new_termios->c_cflag;
+	iflag = new_termios->c_iflag;
 
 	switch (cflag & CSIZE) {
 	case CS5:
@@ -1000,12 +1001,12 @@ ioc3_change_speed(struct uart_port *the_port,
 
 	state->port.tty->low_latency = 1;
 
-	if (I_IGNPAR(state->port.tty))
+	if (iflag & IGNPAR))
 		the_port->ignore_status_mask &= ~(N_PARITY_ERROR
 						  | N_FRAMING_ERROR);
-	if (I_IGNBRK(state->port.tty)) {
+	if (iflag & IGNBRK) {
 		the_port->ignore_status_mask &= ~N_BREAK;
-		if (I_IGNPAR(state->port.tty))
+		if (iflag & IGNPAR)
 			the_port->ignore_status_mask &= ~N_OVERRUN_ERROR;
 	}
 	if (!(cflag & CREAD)) {
diff --git a/drivers/serial/ioc4_serial.c b/drivers/serial/ioc4_serial.c
index 8ad28fc..2c30023 100644
--- a/drivers/serial/ioc4_serial.c
+++ b/drivers/serial/ioc4_serial.c
@@ -1685,11 +1685,12 @@ ioc4_change_speed(struct uart_port *the_port,
 {
 	struct ioc4_port *port = get_ioc4_port(the_port, 0);
 	int baud, bits;
-	unsigned cflag;
+	unsigned cflag, iflag;
 	int new_parity = 0, new_parity_enable = 0, new_stop = 0, new_data = 8;
 	struct uart_state *state = the_port->state;
 
 	cflag = new_termios->c_cflag;
+	iflag = new_termios->c_iflag;
 
 	switch (cflag & CSIZE) {
 	case CS5:
@@ -1741,12 +1742,12 @@ ioc4_change_speed(struct uart_port *the_port,
 
 	state->port.tty->low_latency = 1;
 
-	if (I_IGNPAR(state->port.tty))
+	if (iflag & IGNPAR)
 		the_port->ignore_status_mask &= ~(N_PARITY_ERROR
 						| N_FRAMING_ERROR);
-	if (I_IGNBRK(state->port.tty)) {
+	if (iflag & IGNBRK) {
 		the_port->ignore_status_mask &= ~N_BREAK;
-		if (I_IGNPAR(state->port.tty))
+		if (iflag & IGNPAR))
 			the_port->ignore_status_mask &= ~N_OVERRUN_ERROR;
 	}
 	if (!(cflag & CREAD)) {
diff --git a/drivers/serial/max3100.c b/drivers/serial/max3100.c
index 3351c3b..dfcabfe 100644
--- a/drivers/serial/max3100.c
+++ b/drivers/serial/max3100.c
@@ -430,7 +430,6 @@ max3100_set_termios(struct uart_port *port, struct ktermios *termios,
 	int baud = 0;
 	unsigned cflag;
 	u32 param_new, param_mask, parity = 0;
-	struct tty_struct *tty = s->port.state->port.tty;
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 	if (!tty)
@@ -485,7 +484,7 @@ max3100_set_termios(struct uart_port *port, struct ktermios *termios,
 	default:
 		baud = s->baud;
 	}
-	tty_encode_baud_rate(tty, baud, baud);
+	tty_termios_encode_baud_rate(termios, baud, baud);
 	s->baud = baud;
 	param_mask |= MAX3100_BAUD;
 

