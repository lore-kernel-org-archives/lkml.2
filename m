Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154Ab0G3SX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:23:58 -0400
Received: from kroah.org ([198.145.64.141]:58588 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759999Ab0G3Rz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:42 2010
Message-Id: <20100730175142.115694132@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dongdong Deng <dongdong.deng@windriver.com>
Subject: [093/205] serial: cpm_uart: implement the cpm_uart_early_write() function for console poll
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dongdong Deng <dongdong.deng@windriver.com>

commit 8cd774ad30c22b9d89823f1f05d845f4cdaba9e8 upstream.

The cpm_uart_early_write() function which was used for console poll
isn't implemented in the cpm uart driver.

Implementing this function both fixes the build when CONFIG_CONSOLE_POLL
is set and allows kgdboc to work via the cpm uart.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/cpm_uart/cpm_uart_core.c |  143 +++++++++++++++++---------------
 1 file changed, 79 insertions(+), 64 deletions(-)

--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -930,6 +930,83 @@ static void cpm_uart_config_port(struct
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
@@ -999,7 +1076,7 @@ static void cpm_put_poll_char(struct uar
 	static char ch[2];
 
 	ch[0] = (char)c;
-	cpm_uart_early_write(pinfo->port.line, ch, 1);
+	cpm_uart_early_write(pinfo, ch, 1);
 }
 #endif /* CONFIG_CONSOLE_POLL */
 
@@ -1130,9 +1207,6 @@ static void cpm_uart_console_write(struc
 				   u_int count)
 {
 	struct uart_cpm_port *pinfo = &cpm_uart_ports[co->index];
-	unsigned int i;
-	cbd_t __iomem *bdp, *bdbase;
-	unsigned char *cp;
 	unsigned long flags;
 	int nolock = oops_in_progress;
 
@@ -1142,66 +1216,7 @@ static void cpm_uart_console_write(struc
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


