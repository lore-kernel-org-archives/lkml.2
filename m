Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2IXGlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 02:41:14 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:25698 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab2IXGlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 02:41:10 -0400
Date: Mon, 24 Sep 2012 08:39:44 +0200
Message-Id: <201209240639.q8O6di6f029596@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Alan Cox <alan@linux.intel.com>, Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] Powerpc 8xx CPM_UART setting MAXIDL register proportionaly to baud rate
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAXIDL is the timeout after which a receive buffer is closed when not full if
no more characters are received. We calculate it from the baudrate so that the
duration is always the same at standard rates: about 4ms. At 9600 bauds it gives
a timeout of 4 characters, which is the timeout on the 8250 UART.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

--- linux-3.5-vanilla/drivers/tty/serial/cpm_uart/cpm_uart_core.c	2012-07-21 22:58:29.000000000 +0200
+++ linux-3.5/drivers/tty/serial/cpm_uart/cpm_uart_core.c	2012-08-09 17:38:37.000000000 +0200
@@ -501,6 +501,7 @@
 	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
 	smc_t __iomem *smcp = pinfo->smcp;
 	scc_t __iomem *sccp = pinfo->sccp;
+	int maxidl;
 
 	pr_debug("CPM uart[%d]:set_termios\n", port->line);
 
@@ -511,6 +512,17 @@
 	else
 		pinfo->rx_fifosize = RX_BUF_SIZE;
 
+	/* MAXIDL is the timeout after which a receive buffer is closed
+	 * when not full if no more characters are received.
+	 * We calculate it from the baudrate so that the duration is
+	 * always the same at standard rates: about 4ms.
+	 */
+	maxidl = baud / 2400;
+	if (maxidl < 1)
+		maxidl = 1;
+	if (maxidl > 0x10)
+		maxidl = 0x10;
+
 	/* Character length programmed into the mode register is the
 	 * sum of: 1 start bit, number of data bits, 0 or 1 parity bit,
 	 * 1 or 2 stop bits, minus 1.
@@ -611,6 +623,7 @@
 		 * SMC/SCC receiver is disabled.
 		 */
 		out_be16(&pinfo->smcup->smc_mrblr, pinfo->rx_fifosize);
+		out_be16(&pinfo->smcup->smc_maxidl, maxidl);
 
 		/* Set the mode register.  We want to keep a copy of the
 		 * enables, because we want to put them back if they were
@@ -623,6 +636,7 @@
 		    SMCMR_SM_UART | prev_mode);
 	} else {
 		out_be16(&pinfo->sccup->scc_genscc.scc_mrblr, pinfo->rx_fifosize);
+		out_be16(&pinfo->sccup->scc_maxidl, maxidl);
 		out_be16(&sccp->scc_psmr, (sbits << 12) | scval);
 	}
 
