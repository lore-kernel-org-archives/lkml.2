Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938Ab2HWKj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:39:27 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:44271 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933831Ab2HWKiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:38:00 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Vikram Pandita <vikram.pandita@ti.com>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 20/23] serial: omap: fix software flow control
Date: Thu, 23 Aug 2012 13:33:00 +0300
Message-Id: <1345717983-18179-21-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vikram Pandita <vikram.pandita@ti.com>

Software flow control register bits were not defined correctly.

Also clarify the IXON and IXOFF logic to reflect what userspace wants.

Cc: stable@vger.kernel.org
Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/plat-omap/include/plat/omap-serial.h |  4 ++--
 drivers/tty/serial/omap-serial.c              | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index 743ac80..12e6805 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -42,10 +42,10 @@
 #define OMAP_UART_WER_MOD_WKUP	0X7F
 
 /* Enable XON/XOFF flow control on output */
-#define OMAP_UART_SW_TX		0x04
+#define OMAP_UART_SW_TX		0x8
 
 /* Enable XON/XOFF flow control on input */
-#define OMAP_UART_SW_RX		0x04
+#define OMAP_UART_SW_RX		0x2
 
 #define OMAP_UART_SYSC_RESET	0X07
 #define OMAP_UART_TCR_TRIG	0X0F
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index c3579c0..d49981d 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -606,19 +606,19 @@ serial_omap_configure_xonxoff
 
 	/*
 	 * IXON Flag:
-	 * Enable XON/XOFF flow control on output.
-	 * Transmit XON1, XOFF1
+	 * Flow control for OMAP.TX
+	 * OMAP.RX should listen for XON/XOFF
 	 */
 	if (termios->c_iflag & IXON)
-		up->efr |= OMAP_UART_SW_TX;
+		up->efr |= OMAP_UART_SW_RX;
 
 	/*
 	 * IXOFF Flag:
-	 * Enable XON/XOFF flow control on input.
-	 * Receiver compares XON1, XOFF1.
+	 * Flow control for OMAP.RX
+	 * OMAP.TX should send XON/XOFF
 	 */
 	if (termios->c_iflag & IXOFF)
-		up->efr |= OMAP_UART_SW_RX;
+		up->efr |= OMAP_UART_SW_TX;
 
 	serial_out(up, UART_EFR, up->efr | UART_EFR_ECB);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
-- 
1.7.12.rc3

