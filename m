Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0F3PZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:25:35 -0400
Received: from kroah.org ([198.145.64.141]:40053 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab0F3PZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:25:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dongdong Deng <dongdong.deng@windriver.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] serial: cpm_uart: implement the cpm_uart_early_write() function for console poll
Date: Wed, 30 Jun 2010 08:25:29 -0700
Message-Id: <1277911529-11401-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100630152318.GA11236@kroah.com>
References: <20100630152318.GA11236@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongdong Deng <dongdong.deng@windriver.com>

The cpm_uart_early_write() function which was used for console poll
isn't implemented in the cpm uart driver.

Implementing this function both fixes the build when CONFIG_CONSOLE_POLL
is set and allows kgdboc to work via the cpm uart.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/cpm_uart/cpm_uart_core.c |  143 +++++++++++++++++--------------
 1 files changed, 79 insertions(+), 64 deletions(-)

diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index 9eb62a2..cd6cf57 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -930,6 +930,83 @@ static void cpm_uart_config_port(struct uart_port *port, int flags)
 	}
 }
 
+#if defined(CONFIG_CONSOLE_POLL) || defined(CONFIG_SERIAL_CPM_CONSOLE)
+/*
+ * Write a string to the serial port
+ * Note that this is called with interrupts already disabled
+ */
+static void cpm_uart_early_write(struct uart_cpm_port *pinfo,
+		const char *string, u_int count)
+{
+	unsigned int i;
+	cbd_t __iomem *bdp, *bdbase;
+	unsigned char *cpm_outp_addr;
+
+	/* Get the address of the host memory buffer.
+	 */
+	bdp = pinfo->tx_cur;
+	bdbase = pinfo->tx_bd_base;
+
+	/*
+	 * Now, do each character.  This is not as bad as it looks
+	 * since this is a holding FIFO and not a transmitting FIFO.
+	 * We could add the complexity of filling the entire transmit
+	 * buffer, but we would just wait longer between accesses......
+	 */
+	for (i = 0; i < count; i++, string++) {
+		/* Wait for transmitter fifo to empty.
+		 * Ready indicates output is ready, and xmt is doing
+		 * that, not that it is ready for us to send.
+		 */
+		while ((in_be16(&bdp->cbd_sc) & BD_SC_READY) != 0)
+			;
+
+		/* Send the character out.
+		 * If the buffer address is in the CPM DPRAM, don't
+		 * convert it.
+		 */
+		cpm_outp_addr = cpm2cpu_addr(in_be32(&bdp->cbd_bufaddr),
+					pinfo);
+		*cpm_outp_addr = *string;
+
+		out_be16(&bdp->cbd_datlen, 1);
+		setbits16(&bdp->cbd_sc, BD_SC_READY);
+
+		if (in_be16(&bdp->cbd_sc) & BD_SC_WRAP)
+			bdp = bdbase;
+		else
+			bdp++;
+
+		/* if a LF, also do CR... */
+		if (*string == 10) {
+			while ((in_be16(&bdp->cbd_sc) & BD_SC_READY) != 0)
+				;
+
+			cpm_outp_addr = cpm2cpu_addr(in_be32(&bdp->cbd_bufaddr),
+						pinfo);
+			*cpm_outp_addr = 13;
+
+			out_be16(&bdp->cbd_datlen, 1);
+			setbits16(&bdp->cbd_sc, BD_SC_READY);
+
+			if (in_be16(&bdp->cbd_sc) & BD_SC_WRAP)
+				bdp = bdbase;
+			else
+				bdp++;
+		}
+	}
+
+	/*
+	 * Finally, Wait for transmitter & holding register to empty
+	 *  and restore the IER
+	 */
+	while ((in_be16(&bdp->cbd_sc) & BD_SC_READY) != 0)
+		;
+
+	pinfo->tx_cur = bdp;
+}
+#endif
+
 #ifdef CONFIG_CONSOLE_POLL
 /* Serial polling routines for writing and reading from the uart while
  * in an interrupt or debug context.
@@ -999,7 +1076,7 @@ static void cpm_put_poll_char(struct uart_port *port,
 	static char ch[2];
 
 	ch[0] = (char)c;
-	cpm_uart_early_write(pinfo->port.line, ch, 1);
+	cpm_uart_early_write(pinfo, ch, 1);
 }
 #endif /* CONFIG_CONSOLE_POLL */
 
@@ -1130,9 +1207,6 @@ static void cpm_uart_console_write(struct console *co, const char *s,
 				   u_int count)
 {
 	struct uart_cpm_port *pinfo = &cpm_uart_ports[co->index];
-	unsigned int i;
-	cbd_t __iomem *bdp, *bdbase;
-	unsigned char *cp;
 	unsigned long flags;
 	int nolock = oops_in_progress;
 
@@ -1142,66 +1216,7 @@ static void cpm_uart_console_write(struct console *co, const char *s,
 		spin_lock_irqsave(&pinfo->port.lock, flags);
 	}
 
-	/* Get the address of the host memory buffer.
-	 */
-	bdp = pinfo->tx_cur;
-	bdbase = pinfo->tx_bd_base;
-
-	/*
-	 * Now, do each character.  This is not as bad as it looks
-	 * since this is a holding FIFO and not a transmitting FIFO.
-	 * We could add the complexity of filling the entire transmit
-	 * buffer, but we would just wait longer between accesses......
-	 */
-	for (i = 0; i < count; i++, s++) {
-		/* Wait for transmitter fifo to empty.
-		 * Ready indicates output is ready, and xmt is doing
-		 * that, not that it is ready for us to send.
-		 */
-		while ((in_be16(&bdp->cbd_sc) & BD_SC_READY) != 0)
-			;
-
-		/* Send the character out.
-		 * If the buffer address is in the CPM DPRAM, don't
-		 * convert it.
-		 */
-		cp = cpm2cpu_addr(in_be32(&bdp->cbd_bufaddr), pinfo);
-		*cp = *s;
-
-		out_be16(&bdp->cbd_datlen, 1);
-		setbits16(&bdp->cbd_sc, BD_SC_READY);
-
-		if (in_be16(&bdp->cbd_sc) & BD_SC_WRAP)
-			bdp = bdbase;
-		else
-			bdp++;
-
-		/* if a LF, also do CR... */
-		if (*s == 10) {
-			while ((in_be16(&bdp->cbd_sc) & BD_SC_READY) != 0)
-				;
-
-			cp = cpm2cpu_addr(in_be32(&bdp->cbd_bufaddr), pinfo);
-			*cp = 13;
-
-			out_be16(&bdp->cbd_datlen, 1);
-			setbits16(&bdp->cbd_sc, BD_SC_READY);
-
-			if (in_be16(&bdp->cbd_sc) & BD_SC_WRAP)
-				bdp = bdbase;
-			else
-				bdp++;
-		}
-	}
-
-	/*
-	 * Finally, Wait for transmitter & holding register to empty
-	 *  and restore the IER
-	 */
-	while ((in_be16(&bdp->cbd_sc) & BD_SC_READY) != 0)
-		;
-
-	pinfo->tx_cur = bdp;
+	cpm_uart_early_write(pinfo, s, count);
 
 	if (unlikely(nolock)) {
 		local_irq_restore(flags);
-- 
1.7.1

