Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1AFW1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:27:00 -0500
Received: from kroah.org ([198.145.64.141]:55683 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab1AFWXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/36] 8250: use container_of() instead of casting
Date: Thu,  6 Jan 2011 14:23:13 -0800
Message-Id: <1294352605-31906-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jamie Iles <jamie@jamieiles.com>

The 8250 driver structure uart_8250_port took advantage of the fact
that the struct uart_port was the first member of its structure and
used an explicit cast to convert to the derived class. Replace the
explicit casts with container_of() for safety and clarity.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |   60 ++++++++++++++++++++++++++++++++----------------
 1 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 4d8e14b..0b4ce47 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -461,7 +461,8 @@ static void dwapb_serial_out(struct uart_port *p, int offset, int value)
 	/* Save the LCR value so it can be re-written when a
 	 * Busy Detect interrupt occurs. */
 	if (save_offset == UART_LCR) {
-		struct uart_8250_port *up = (struct uart_8250_port *)p;
+		struct uart_8250_port *up =
+			container_of(p, struct uart_8250_port, port);
 		up->lcr = value;
 	}
 	writeb(value, p->membase + offset);
@@ -485,7 +486,8 @@ static void io_serial_out(struct uart_port *p, int offset, int value)
 
 static void set_io_from_upio(struct uart_port *p)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)p;
+	struct uart_8250_port *up =
+		container_of(p, struct uart_8250_port, port);
 	switch (p->iotype) {
 	case UPIO_HUB6:
 		p->serial_in = hub6_serial_in;
@@ -1319,7 +1321,8 @@ static inline void __stop_tx(struct uart_8250_port *p)
 
 static void serial8250_stop_tx(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 
 	__stop_tx(up);
 
@@ -1336,7 +1339,8 @@ static void transmit_chars(struct uart_8250_port *up);
 
 static void serial8250_start_tx(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 
 	if (!(up->ier & UART_IER_THRI)) {
 		up->ier |= UART_IER_THRI;
@@ -1364,7 +1368,8 @@ static void serial8250_start_tx(struct uart_port *port)
 
 static void serial8250_stop_rx(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 
 	up->ier &= ~UART_IER_RLSI;
 	up->port.read_status_mask &= ~UART_LSR_DR;
@@ -1373,7 +1378,8 @@ static void serial8250_stop_rx(struct uart_port *port)
 
 static void serial8250_enable_ms(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 
 	/* no MSR capabilities */
 	if (up->bugs & UART_BUG_NOMSR)
@@ -1781,7 +1787,8 @@ static void serial8250_backup_timeout(unsigned long data)
 
 static unsigned int serial8250_tx_empty(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	unsigned long flags;
 	unsigned int lsr;
 
@@ -1795,7 +1802,8 @@ static unsigned int serial8250_tx_empty(struct uart_port *port)
 
 static unsigned int serial8250_get_mctrl(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	unsigned int status;
 	unsigned int ret;
 
@@ -1815,7 +1823,8 @@ static unsigned int serial8250_get_mctrl(struct uart_port *port)
 
 static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	unsigned char mcr = 0;
 
 	if (mctrl & TIOCM_RTS)
@@ -1836,7 +1845,8 @@ static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 static void serial8250_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&up->port.lock, flags);
@@ -1890,7 +1900,8 @@ static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 
 static int serial8250_get_poll_char(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	unsigned char lsr = serial_inp(up, UART_LSR);
 
 	if (!(lsr & UART_LSR_DR))
@@ -1904,7 +1915,8 @@ static void serial8250_put_poll_char(struct uart_port *port,
 			 unsigned char c)
 {
 	unsigned int ier;
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 
 	/*
 	 *	First save the IER then disable the interrupts
@@ -1938,7 +1950,8 @@ static void serial8250_put_poll_char(struct uart_port *port,
 
 static int serial8250_startup(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	unsigned long flags;
 	unsigned char lsr, iir;
 	int retval;
@@ -2166,7 +2179,8 @@ dont_test_tx_en:
 
 static void serial8250_shutdown(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	unsigned long flags;
 
 	/*
@@ -2235,7 +2249,8 @@ void
 serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 		          struct ktermios *old)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	unsigned char cval, fcr = 0;
 	unsigned long flags;
 	unsigned int baud, quot;
@@ -2435,7 +2450,8 @@ serial8250_set_ldisc(struct uart_port *port, int new)
 void serial8250_do_pm(struct uart_port *port, unsigned int state,
 		      unsigned int oldstate)
 {
-	struct uart_8250_port *p = (struct uart_8250_port *)port;
+	struct uart_8250_port *p =
+		container_of(port, struct uart_8250_port, port);
 
 	serial8250_set_sleep(p, state != 0);
 }
@@ -2566,7 +2582,8 @@ static void serial8250_release_rsa_resource(struct uart_8250_port *up)
 
 static void serial8250_release_port(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 
 	serial8250_release_std_resource(up);
 	if (up->port.type == PORT_RSA)
@@ -2575,7 +2592,8 @@ static void serial8250_release_port(struct uart_port *port)
 
 static int serial8250_request_port(struct uart_port *port)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	int ret = 0;
 
 	ret = serial8250_request_std_resource(up);
@@ -2590,7 +2608,8 @@ static int serial8250_request_port(struct uart_port *port)
 
 static void serial8250_config_port(struct uart_port *port, int flags)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 	int probeflags = PROBE_ANY;
 	int ret;
 
@@ -2771,7 +2790,8 @@ serial8250_register_ports(struct uart_driver *drv, struct device *dev)
 
 static void serial8250_console_putchar(struct uart_port *port, int ch)
 {
-	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
 
 	wait_for_xmitr(up, UART_LSR_THRE);
 	serial_out(up, UART_TX, ch);
-- 
1.7.3.2

