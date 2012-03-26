Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2CZFnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:43:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55430 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab2CZFmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:42:31 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 4/7] pch_uart: Support modem status interrupt
Date: Mon, 26 Mar 2012 14:43:03 +0900
Message-Id: <1332740586-28496-4-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332740586-28496-1-git-send-email-tomoya.rohm@gmail.com>
References: <1332740586-28496-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index c025c4b..7a9ef83 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1047,10 +1047,15 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 	int ret = 0;
 	unsigned char iid;
 	unsigned long flags;
+	int next = 1;
+	u8 msr;
 
 	spin_lock_irqsave(&priv->port.lock, flags);
 	handled = 0;
-	while ((iid = pch_uart_hal_get_iid(priv)) > 1) {
+	while (next) {
+		iid = pch_uart_hal_get_iid(priv);
+		if (iid & PCH_UART_IIR_IP) /* No Interrupt */
+			break;
 		switch (iid) {
 		case PCH_UART_IID_RLS:	/* Receiver Line Status */
 			lsr = pch_uart_hal_get_line_status(priv);
@@ -1084,12 +1089,18 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 				ret = handle_tx(priv);
 			break;
 		case PCH_UART_IID_MS:	/* Modem Status */
-			ret = PCH_UART_HANDLED_MS_INT;
+			msr = pch_uart_hal_get_modem(priv);
+			next = 0; /* MS ir prioirty is the lowest. So, MS ir
+				     means final interrupt */
+			if ((msr & UART_MSR_ANY_DELTA) == 0)
+				break;
+			ret |= PCH_UART_HANDLED_MS_INT;
 			break;
 		default:	/* Never junp to this label */
 			dev_err(priv->port.dev, "%s:iid=%02x (%lu)\n", __func__,
 				iid, jiffies);
 			ret = -1;
+			next = 0;
 			break;
 		}
 		handled |= (unsigned int)ret;
-- 
1.7.7.6

