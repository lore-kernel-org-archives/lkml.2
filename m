Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0EQPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:25:59 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47089 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265Ab0EQPZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:25:58 -0400
Date: Mon, 17 May 2010 17:25:54 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Anirban Sinha <asinha@zeugmasystems.com>, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] Tidy REMOTE_DEBUG
Message-ID: <20100517152554.GB3686@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	CONFIG_REMOTE_DEBUG seems to be a leftover from 2.2 and 2.4
kernel series only present today at one single space (and no longer at
all if the patch is applied). As it's unreferenced from Kconfig side
we might as well drop it?

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From 7cc3dbcc665505816368268dee33f6f54d97fc84 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@cs.fau.de>
Date: Mon, 17 May 2010 17:21:02 +0200
Subject: [PATCH 2/2] Remove CONFIG_REMOTE_DEBUG

REMOTE_DEBUG does already appear in 2.2 kernel sources but didn't
appear as a config Option in the initial git import 2.6.12-rc. It's
currently just used in one single place of the linux kernel and should
probably be dropped totally

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/char/serial167.c |  223 +---------------------------------------------
 1 files changed, 1 insertions(+), 222 deletions(-)

diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 8dfd247..36e620a 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -176,23 +176,6 @@ static void config_setup(struct cyclades_port *);
 static void show_status(int);
 #endif
 
-#ifdef CONFIG_REMOTE_DEBUG
-static void debug_setup(void);
-void queueDebugChar(int c);
-int getDebugChar(void);
-
-#define DEBUG_PORT	1
-#define DEBUG_LEN	256
-
-typedef struct {
-	int in;
-	int out;
-	unsigned char buf[DEBUG_LEN];
-} debugq;
-
-debugq debugiq;
-#endif
-
 /*
  * I have my own version of udelay(), as it is needed when initialising
  * the chip, before the delay loop has been calibrated.  Should probably
@@ -515,11 +498,6 @@ static irqreturn_t cd2401_tx_interrupt(int irq, void *dev_id)
 	/* determine the channel and change to that context */
 	channel = (u_short) (base_addr[CyLICR] >> 2);
 
-#ifdef CONFIG_REMOTE_DEBUG
-	if (channel == DEBUG_PORT) {
-		panic("TxInt on debug port!!!");
-	}
-#endif
 	/* validate the port number (as configured and open) */
 	if ((channel < 0) || (NR_PORTS <= channel)) {
 		base_addr[CyIER] &= ~(CyTxMpty | CyTxRdy);
@@ -635,14 +613,6 @@ static irqreturn_t cd2401_rx_interrupt(int irq, void *dev_id)
 	info->last_active = jiffies;
 	save_cnt = char_count = base_addr[CyRFOC];
 
-#ifdef CONFIG_REMOTE_DEBUG
-	if (channel == DEBUG_PORT) {
-		while (char_count--) {
-			data = base_addr[CyRDR];
-			queueDebugChar(data);
-		}
-	} else
-#endif
 		/* if there is nowhere to put the data, discard it */
 	if (info->tty == 0) {
 		while (char_count--) {
@@ -2197,9 +2167,7 @@ static int __init serial167_init(void)
 		port_num++;
 		info++;
 	}
-#ifdef CONFIG_REMOTE_DEBUG
-	debug_setup();
-#endif
+
 	ret = request_irq(MVME167_IRQ_SER_ERR, cd2401_rxerr_interrupt, 0,
 			  "cd2401_errors", cd2401_rxerr_interrupt);
 	if (ret) {
@@ -2520,193 +2488,4 @@ static int __init serial167_console_init(void)
 
 console_initcall(serial167_console_init);
 
-#ifdef CONFIG_REMOTE_DEBUG
-void putDebugChar(int c)
-{
-	volatile unsigned char *base_addr = (u_char *) BASE_ADDR;
-	unsigned long flags;
-	volatile u_char sink;
-	u_char ier;
-	int port;
-
-	local_irq_save(flags);
-
-	/* Ensure transmitter is enabled! */
-
-	port = DEBUG_PORT;
-	base_addr[CyCAR] = (u_char) port;
-	while (base_addr[CyCCR])
-		;
-	base_addr[CyCCR] = CyENB_XMTR;
-
-	ier = base_addr[CyIER];
-	base_addr[CyIER] = CyTxMpty;
-
-	while (1) {
-		if (pcc2chip[PccSCCTICR] & 0x20) {
-			/* We have a Tx int. Acknowledge it */
-			sink = pcc2chip[PccTPIACKR];
-			if ((base_addr[CyLICR] >> 2) == port) {
-				base_addr[CyTDR] = c;
-				base_addr[CyTEOIR] = 0;
-				break;
-			} else
-				base_addr[CyTEOIR] = CyNOTRANS;
-		}
-	}
-
-	base_addr[CyIER] = ier;
-
-	local_irq_restore(flags);
-}
-
-int getDebugChar()
-{
-	volatile unsigned char *base_addr = (u_char *) BASE_ADDR;
-	unsigned long flags;
-	volatile u_char sink;
-	u_char ier;
-	int port;
-	int i, c;
-
-	i = debugiq.out;
-	if (i != debugiq.in) {
-		c = debugiq.buf[i];
-		if (++i == DEBUG_LEN)
-			i = 0;
-		debugiq.out = i;
-		return c;
-	}
-	/* OK, nothing in queue, wait in poll loop */
-
-	local_irq_save(flags);
-
-	/* Ensure receiver is enabled! */
-
-	port = DEBUG_PORT;
-	base_addr[CyCAR] = (u_char) port;
-#if 0
-	while (base_addr[CyCCR])
-		;
-	base_addr[CyCCR] = CyENB_RCVR;
-#endif
-	ier = base_addr[CyIER];
-	base_addr[CyIER] = CyRxData;
-
-	while (1) {
-		if (pcc2chip[PccSCCRICR] & 0x20) {
-			/* We have a Rx int. Acknowledge it */
-			sink = pcc2chip[PccRPIACKR];
-			if ((base_addr[CyLICR] >> 2) == port) {
-				int cnt = base_addr[CyRFOC];
-				while (cnt-- > 0) {
-					c = base_addr[CyRDR];
-					if (c == 0)
-						printk
-						    ("!! debug char is null (cnt=%d) !!",
-						     cnt);
-					else
-						queueDebugChar(c);
-				}
-				base_addr[CyREOIR] = 0;
-				i = debugiq.out;
-				if (i == debugiq.in)
-					panic("Debug input queue empty!");
-				c = debugiq.buf[i];
-				if (++i == DEBUG_LEN)
-					i = 0;
-				debugiq.out = i;
-				break;
-			} else
-				base_addr[CyREOIR] = CyNOTRANS;
-		}
-	}
-
-	base_addr[CyIER] = ier;
-
-	local_irq_restore(flags);
-
-	return (c);
-}
-
-void queueDebugChar(int c)
-{
-	int i;
-
-	i = debugiq.in;
-	debugiq.buf[i] = c;
-	if (++i == DEBUG_LEN)
-		i = 0;
-	if (i != debugiq.out)
-		debugiq.in = i;
-}
-
-static void debug_setup()
-{
-	unsigned long flags;
-	volatile unsigned char *base_addr = (u_char *) BASE_ADDR;
-	int i, cflag;
-
-	cflag = B19200;
-
-	local_irq_save(flags);
-
-	for (i = 0; i < 4; i++) {
-		base_addr[CyCAR] = i;
-		base_addr[CyLICR] = i << 2;
-	}
-
-	debugiq.in = debugiq.out = 0;
-
-	base_addr[CyCAR] = DEBUG_PORT;
-
-	/* baud rate */
-	i = cflag & CBAUD;
-
-	base_addr[CyIER] = 0;
-
-	base_addr[CyCMR] = CyASYNC;
-	base_addr[CyLICR] = DEBUG_PORT << 2;
-	base_addr[CyLIVR] = 0x5c;
-
-	/* tx and rx baud rate */
-
-	base_addr[CyTCOR] = baud_co[i];
-	base_addr[CyTBPR] = baud_bpr[i];
-	base_addr[CyRCOR] = baud_co[i] >> 5;
-	base_addr[CyRBPR] = baud_bpr[i];
-
-	/* set line characteristics  according configuration */
-
-	base_addr[CySCHR1] = 0;
-	base_addr[CySCHR2] = 0;
-	base_addr[CySCRL] = 0;
-	base_addr[CySCRH] = 0;
-	base_addr[CyCOR1] = Cy_8_BITS | CyPARITY_NONE;
-	base_addr[CyCOR2] = 0;
-	base_addr[CyCOR3] = Cy_1_STOP;
-	base_addr[CyCOR4] = baud_cor4[i];
-	base_addr[CyCOR5] = 0;
-	base_addr[CyCOR6] = 0;
-	base_addr[CyCOR7] = 0;
-
-	write_cy_cmd(base_addr, CyINIT_CHAN);
-	write_cy_cmd(base_addr, CyENB_RCVR);
-
-	base_addr[CyCAR] = DEBUG_PORT;	/* !!! Is this needed? */
-
-	base_addr[CyRTPRL] = 2;
-	base_addr[CyRTPRH] = 0;
-
-	base_addr[CyMSVR1] = CyRTS;
-	base_addr[CyMSVR2] = CyDTR;
-
-	base_addr[CyIER] = CyRxData;
-
-	local_irq_restore(flags);
-
-}				/* debug_setup */
-
-#endif
-
 MODULE_LICENSE("GPL");
-- 
1.6.3.3












