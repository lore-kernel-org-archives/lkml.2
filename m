Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0DAQd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:33:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42112 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932182Ab0DAQdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:33:14 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 01/14] tty: serial - fix tty referencing in set_ldisc
To: linux-kernel@vger.kernel.org
Date: Thu, 01 Apr 2010 17:04:18 +0100
Message-ID: <20100401160414.8882.51526.stgit@localhost.localdomain>
In-Reply-To: <20100401155513.8882.54006.stgit@localhost.localdomain>
References: <20100401155513.8882.54006.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass down the ldisc number so that the drivers don't have to peek into the
tty object themselves. This lets us get rid of another case of back referencing
port to tty which we don't want (because of races versus hangup/close).

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/bfin_5xx.c    |    7 ++-----
 drivers/serial/serial_core.c |    2 +-
 include/linux/serial_core.h  |    2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)


diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 96f7e74..e0d25ca 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -952,15 +952,12 @@ bfin_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
  * Enable the IrDA function if tty->ldisc.num is N_IRDA.
  * In other cases, disable IrDA function.
  */
-static void bfin_serial_set_ldisc(struct uart_port *port)
+static void bfin_serial_set_ldisc(struct uart_port *port, int ld)
 {
 	int line = port->line;
 	unsigned short val;
 
-	if (line >= port->state->port.tty->driver->num)
-		return;
-
-	switch (port->state->port.tty->termios->c_line) {
+	switch (ld) {
 	case N_IRDA:
 		val = UART_GET_GCTL(&bfin_serial_ports[line]);
 		val |= (IREN | RPOLC);
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 7f28307..686ff6c 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1194,7 +1194,7 @@ static void uart_set_ldisc(struct tty_struct *tty)
 	struct uart_port *uport = state->uart_port;
 
 	if (uport->ops->set_ldisc)
-		uport->ops->set_ldisc(uport);
+		uport->ops->set_ldisc(uport, tty->termios->c_line);
 }
 
 static void uart_set_termios(struct tty_struct *tty,
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index ad83996..5c4cbe6 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -216,7 +216,7 @@ struct uart_ops {
 	void		(*flush_buffer)(struct uart_port *);
 	void		(*set_termios)(struct uart_port *, struct ktermios *new,
 				       struct ktermios *old);
-	void		(*set_ldisc)(struct uart_port *);
+	void		(*set_ldisc)(struct uart_port *, int new);
 	void		(*pm)(struct uart_port *, unsigned int state,
 			      unsigned int oldstate);
 	int		(*set_wake)(struct uart_port *, unsigned int state);

