Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab0HJWAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:00:22 -0400
Received: from kroah.org ([198.145.64.141]:44872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933368Ab0HJWAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/68] tty: serial - fix tty referencing in set_ldisc
Date: Tue, 10 Aug 2010 14:58:48 -0700
Message-Id: <1281477570-18944-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Pass down the ldisc number so that the drivers don't have to peek into the
tty object themselves. This lets us get rid of another case of back referencing
port to tty which we don't want (because of races versus hangup/close).

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_5xx.c    |    7 ++-----
 drivers/serial/serial_core.c |    2 +-
 include/linux/serial_core.h  |    2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 511cbf6..a9eff2b 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -957,15 +957,12 @@ bfin_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
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
index 12ee7e0..570dca2 100644
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
index f10db6e..3292816 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -220,7 +220,7 @@ struct uart_ops {
 	void		(*flush_buffer)(struct uart_port *);
 	void		(*set_termios)(struct uart_port *, struct ktermios *new,
 				       struct ktermios *old);
-	void		(*set_ldisc)(struct uart_port *);
+	void		(*set_ldisc)(struct uart_port *, int new);
 	void		(*pm)(struct uart_port *, unsigned int state,
 			      unsigned int oldstate);
 	int		(*set_wake)(struct uart_port *, unsigned int state);
-- 
1.7.2

