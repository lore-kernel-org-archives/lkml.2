Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0FAUxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:53:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab0FAUxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 12/31] tty: serial - fix tty back references in termios
Date: Tue,  1 Jun 2010 22:52:52 +0200
Message-Id: <1275425591-8803-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19GSIgvVc7AzbOHiHYPozAQCUczKq6/ETycFlL
 ezdLAeeVJ3ITwqVcpPOby4DMWnykiOJEbJodC6vCuYibrIMHZs
 nCygGpUQ5Ac93st0k7CwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

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
 drivers/serial/max3100.c     |    7 ++-----
 5 files changed, 19 insertions(+), 26 deletions(-)

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
index eacb588..66ecc7a 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -909,13 +909,11 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
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
index 3351c3b..beb1afa 100644
--- a/drivers/serial/max3100.c
+++ b/drivers/serial/max3100.c
@@ -430,17 +430,14 @@ max3100_set_termios(struct uart_port *port, struct ktermios *termios,
 	int baud = 0;
 	unsigned cflag;
 	u32 param_new, param_mask, parity = 0;
-	struct tty_struct *tty = s->port.state->port.tty;
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
-	if (!tty)
-		return;
 
 	cflag = termios->c_cflag;
 	param_new = 0;
 	param_mask = 0;
 
-	baud = tty_get_baud_rate(tty);
+	baud = tty_termios_baud_rate(termios);
 	param_new = s->conf & MAX3100_BAUD;
 	switch (baud) {
 	case 300:
@@ -485,7 +482,7 @@ max3100_set_termios(struct uart_port *port, struct ktermios *termios,
 	default:
 		baud = s->baud;
 	}
-	tty_encode_baud_rate(tty, baud, baud);
+	tty_termios_encode_baud_rate(termios, baud, baud);
 	s->baud = baud;
 	param_mask |= MAX3100_BAUD;
 
-- 
1.7.0.4

