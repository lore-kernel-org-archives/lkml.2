Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab2C0JvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 05:51:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60955 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab2C0JvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 05:51:13 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] pch_uart: Fix dma channel unallocated issue
Date: Tue, 27 Mar 2012 18:56:02 +0900
Message-Id: <1332842162-26113-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/tty/serial/pch_uart.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 803847b..e297b7c 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1452,8 +1452,10 @@ static int pch_uart_verify_port(struct uart_port *port,
 			__func__);
 		return -EOPNOTSUPP;
 #endif
-		priv->use_dma = 1;
 		dev_info(priv->port.dev, "PCH UART : Use DMA Mode\n");
+		if (!priv->use_dma)
+			pch_request_dma(port);
+		priv->use_dma = 1;
 	}
 
 	return 0;
-- 
1.7.7.6

