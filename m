Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1AFWbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:31:35 -0500
Received: from kroah.org ([198.145.64.141]:55620 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab1AFWXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:36 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Baurzhan Ismagulov <ibr@radix50.net>,
        Michael Trimarchi <michael@gandalf.sssup.it>,
        Bruno Morelli <bruno@evidence.eu.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/36] serial: cpm_uat: reducing CPM serial latency
Date: Thu,  6 Jan 2011 14:22:55 -0800
Message-Id: <1294352605-31906-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Baurzhan Ismagulov <ibr@radix50.net>

Setting Rx FIFO size to 1 reduces reader process wakeup latency up to
20x for baud rates <= 9600. This patch sets the Rx FIFO size to 1 for
baud rates <= 9600 or if low latency has been requested for the tty.

Signed-off-by: Michael Trimarchi <michael@gandalf.sssup.it>
Signed-off-by: Bruno Morelli <bruno@evidence.eu.com>
Signed-off-by: Baurzhan Ismagulov <ibr@radix50.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/cpm_uart/cpm_uart_core.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/cpm_uart/cpm_uart_core.c b/drivers/serial/cpm_uart/cpm_uart_core.c
index f2b8adc..8692ff9 100644
--- a/drivers/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -72,6 +72,8 @@ static void cpm_uart_initbd(struct uart_cpm_port *pinfo);
 
 /**************************************************************/
 
+#define HW_BUF_SPD_THRESHOLD    9600
+
 /*
  * Check, if transmit buffers are processed
 */
@@ -503,6 +505,11 @@ static void cpm_uart_set_termios(struct uart_port *port,
 	pr_debug("CPM uart[%d]:set_termios\n", port->line);
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
+	if (baud <= HW_BUF_SPD_THRESHOLD ||
+	    (pinfo->port.state && pinfo->port.state->port.tty->low_latency))
+		pinfo->rx_fifosize = 1;
+	else
+		pinfo->rx_fifosize = RX_BUF_SIZE;
 
 	/* Character length programmed into the mode register is the
 	 * sum of: 1 start bit, number of data bits, 0 or 1 parity bit,
@@ -594,6 +601,17 @@ static void cpm_uart_set_termios(struct uart_port *port,
 	 */
 	bits++;
 	if (IS_SMC(pinfo)) {
+		/*
+		 * MRBLR can be changed while an SMC/SCC is operating only
+		 * if it is done in a single bus cycle with one 16-bit move
+		 * (not two 8-bit bus cycles back-to-back). This occurs when
+		 * the cp shifts control to the next RxBD, so the change does
+		 * not take effect immediately. To guarantee the exact RxBD
+		 * on which the change occurs, change MRBLR only while the
+		 * SMC/SCC receiver is disabled.
+		 */
+		out_be16(&pinfo->smcup->smc_mrblr, pinfo->rx_fifosize);
+
 		/* Set the mode register.  We want to keep a copy of the
 		 * enables, because we want to put them back if they were
 		 * present.
@@ -604,6 +622,7 @@ static void cpm_uart_set_termios(struct uart_port *port,
 		out_be16(&smcp->smc_smcmr, smcr_mk_clen(bits) | cval |
 		    SMCMR_SM_UART | prev_mode);
 	} else {
+		out_be16(&pinfo->sccup->scc_genscc.scc_mrblr, pinfo->rx_fifosize);
 		out_be16(&sccp->scc_psmr, (sbits << 12) | scval);
 	}
 
-- 
1.7.3.2

