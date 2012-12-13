Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab2LMOMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:12:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44934 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab2LMOMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 191/241] Revert "serial: omap: fix software flow control"
Date: Thu, 13 Dec 2012 11:59:16 -0200
Message-Id: <1355407206-17100-192-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit a4f743851f74fc3e0cc40c13082e65c24139f481 upstream.

This reverts commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6
(serial: omap: fix software flow control).

As Russell has pointed out, that commit isn't fixing
Software Flow Control at all, and it actually makes
it even more broken.

It was agreed to revert this commit and use Russell's
latest UART patches instead.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/plat-omap/include/plat/omap-serial.h |    4 ++--
 drivers/tty/serial/omap-serial.c              |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index 3a57644..1a52725 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -42,10 +42,10 @@
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
index 22992cd..d3cda0c 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -667,19 +667,19 @@ serial_omap_configure_xonxoff
 
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
1.7.9.5

