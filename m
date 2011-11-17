Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1KQF6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:58:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55095 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1KQF6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:58:10 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 3/6] pch_uart: Support modem status interrupt
Date: Thu, 17 Nov 2011 14:57:30 +0900
Message-Id: <1321509453-12008-3-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
References: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 013e16a..217cf37 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -953,10 +953,15 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
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
@@ -990,12 +995,18 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
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
1.7.4.4

