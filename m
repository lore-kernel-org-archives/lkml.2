Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2EIG0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:26:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38791 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755586Ab2EIFw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:58 -0400
Message-Id: <20120509055033.426055874@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 028/167] [PATCH] pch_uart: Fix dma channel unallocated issue
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit af6d17cdc8c89aeb3101f0d27cd32fc0592b40b2 upstream.

This driver anticipates pch_uart_verify_port() is not called
during installation.
However, actually pch_uart_verify_port() is called during
installation.
As a result, memory access violation occurs like below.

0. initial value: use_dma=0
1. starup()
    - dma channel is not allocated because use_dma=0
2. pch_uart_verify_port()
    - Set use_dma=1
3. UART processing acts DMA mode because use_dma=1
     - memory access violation occurs!

This patch fixes the issue.

Solution:
Whenever pch_uart_verify_port() is called and then
dma channel is not allocated, the channel should be allocated.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/pch_uart.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index bbbec4a..c2816f4 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1447,9 +1447,11 @@ static int pch_uart_verify_port(struct uart_port *port,
 			__func__);
 		return -EOPNOTSUPP;
 #endif
-		priv->use_dma = 1;
 		priv->use_dma_flag = 1;
 		dev_info(priv->port.dev, "PCH UART : Use DMA Mode\n");
+		if (!priv->use_dma)
+			pch_request_dma(port);
+		priv->use_dma = 1;
 	}
 
 	return 0;
-- 
1.7.10



