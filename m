Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab2KVWfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:35:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:49015 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab2KVSdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felipe Balbi <balbi@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas.devel@googlemail.com>
Subject: [ 82/83] Revert "serial: omap: fix software flow control"
Date: Wed, 21 Nov 2012 16:42:44 -0800
Message-Id: <20121122004221.396994103@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: Andreas Bießmann <andreas.devel@googlemail.com>
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
-#define OMAP_UART_SW_TX		0x8
+#define OMAP_UART_SW_TX		0x04
 
 /* Enable XON/XOFF flow control on input */
-#define OMAP_UART_SW_RX		0x2
+#define OMAP_UART_SW_RX		0x04
 
 #define OMAP_UART_SYSC_RESET	0X07
 #define OMAP_UART_TCR_TRIG	0X0F
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


