Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2JPOO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:14:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59389 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2JPOO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:14:57 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] Revert "serial: omap: fix software flow control"
Date: Tue, 16 Oct 2012 17:09:22 +0300
Message-ID: <1350396562-32579-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.0.rc0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6
(serial: omap: fix software flow control).

As Russell has pointed out, that commit isn't fixing
Software Flow Control at all, and it actually makes
it even more broken.

It was agreed to revert this commit and use Russell's
latest UART patches instead.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---

Hi Greg,

you might prefer to do the revert yourself, in that case just
revert commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6.

thanks

 arch/arm/plat-omap/include/plat/omap-serial.h |  4 ++--
 drivers/tty/serial/omap-serial.c              | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index f4a4cd0..1957a85 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -40,10 +40,10 @@
 #define OMAP_UART_WER_MOD_WKUP	0X7F
 
 /* Enable XON/XOFF flow control on output */
-#define OMAP_UART_SW_TX		0x8
+#define OMAP_UART_SW_TX		0x04
 
 /* Enable XON/XOFF flow control on input */
-#define OMAP_UART_SW_RX		0x2
+#define OMAP_UART_SW_RX		0x04
 
 #define OMAP_UART_SYSC_RESET	0X07
 #define OMAP_UART_TCR_TRIG	0X0F
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 6ede6fd..6d3d26a 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -671,19 +671,19 @@ serial_omap_configure_xonxoff
 
 	/*
 	 * IXON Flag:
-	 * Flow control for OMAP.TX
-	 * OMAP.RX should listen for XON/XOFF
+	 * Enable XON/XOFF flow control on output.
+	 * Transmit XON1, XOFF1
 	 */
 	if (termios->c_iflag & IXON)
-		up->efr |= OMAP_UART_SW_RX;
+		up->efr |= OMAP_UART_SW_TX;
 
 	/*
 	 * IXOFF Flag:
-	 * Flow control for OMAP.RX
-	 * OMAP.TX should send XON/XOFF
+	 * Enable XON/XOFF flow control on input.
+	 * Receiver compares XON1, XOFF1.
 	 */
 	if (termios->c_iflag & IXOFF)
-		up->efr |= OMAP_UART_SW_TX;
+		up->efr |= OMAP_UART_SW_RX;
 
 	serial_out(up, UART_EFR, up->efr | UART_EFR_ECB);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
-- 
1.8.0.rc0

