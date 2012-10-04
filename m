Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab2JDWQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:16:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab2JDVRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:17:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Shubhrajyoti D <shubhrajyoti@ti.com>,
        Vikram Pandita <vikram.pandita@ti.com>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 19/56] serial: omap: fix software flow control
Date: Thu,  4 Oct 2012 14:15:40 -0700
Message-Id: <20121004211154.291602463@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikram Pandita <vikram.pandita@ti.com>

commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6 upstream.

Software flow control register bits were not defined correctly.

Also clarify the IXON and IXOFF logic to reflect what userspace wants.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-omap/include/plat/omap-serial.h |    4 ++--
 drivers/tty/serial/omap-serial.c              |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

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
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -667,19 +667,19 @@ serial_omap_configure_xonxoff
 
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


