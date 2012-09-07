Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab2IFOgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:36:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2IFOgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:36:50 -0400
From: Huang Shijie <shijie8@gmail.com>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 1/2] serial: mxs-auart: fix the wrong setting order
Date: Thu,  6 Sep 2012 22:38:40 -0400
Message-Id: <1346985521-2248-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After set the AUART_CTRL0_CLKGATE, the UART will gate all the clocks off.
So the following line will not take effect.
       ................................................................
 	writel(AUART_INTR_RXIEN | AUART_INTR_RTIEN | AUART_INTR_CTSMIEN,
 			u->membase + AUART_INTR_CLR);
       ................................................................

To fix this issue, the patch moves this gate-off line to
the end of setting registers.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/tty/serial/mxs-auart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index dafeef2..ea5f888 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -457,11 +457,11 @@ static void mxs_auart_shutdown(struct uart_port *u)
 
 	writel(AUART_CTRL2_UARTEN, u->membase + AUART_CTRL2_CLR);
 
-	writel(AUART_CTRL0_CLKGATE, u->membase + AUART_CTRL0_SET);
-
 	writel(AUART_INTR_RXIEN | AUART_INTR_RTIEN | AUART_INTR_CTSMIEN,
 			u->membase + AUART_INTR_CLR);
 
+	writel(AUART_CTRL0_CLKGATE, u->membase + AUART_CTRL0_SET);
+
 	clk_disable_unprepare(s->clk);
 }
 
-- 
1.7.4.4

