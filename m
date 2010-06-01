Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab0FAUxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:53:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab0FAUxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 13/31] tty: serial - fix tty referencing in set_ldisc
Date: Tue,  1 Jun 2010 22:52:53 +0200
Message-Id: <1275425591-8803-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19dArGbihmlFw6hyD0VBPStRsS4ZXgnHphfwtB
 U4OItDS+DwvuPYgTy8eTJb4uJMUHQ49pc9S3CpGJoiyCC2KORK
 rAKLUP6yjsLJ+KuT/TcSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

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
1.7.0.4

