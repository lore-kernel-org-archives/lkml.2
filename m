Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab2DXWyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:54:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab2DXWfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:46 -0400
Message-Id: <20120424223245.067183915@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 36/62] pch_uart: Fix dma channel unallocated issue
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/serial/pch_uart.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1366,9 +1366,11 @@ static int pch_uart_verify_port(struct u
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


