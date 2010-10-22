Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0JVSdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:33:45 -0400
Received: from kroah.org ([198.145.64.141]:37721 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651Ab0JVSYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 45/49] serial: mfd: add more baud rates support
Date: Fri, 22 Oct 2010 11:21:24 -0700
Message-Id: <1287771688-14805-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Add more baud rates support referring the baud_table[] defined
in drivers/char/tty_ioctl.c: 3000000/2000000/1000000/500000

Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Alan Cox <alan.cox@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mfd.c |   41 +++++++++++++++++++++++++++--------------
 1 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/serial/mfd.c b/drivers/serial/mfd.c
index ad35130..735799e 100644
--- a/drivers/serial/mfd.c
+++ b/drivers/serial/mfd.c
@@ -929,39 +929,52 @@ serial_hsu_set_termios(struct uart_port *port, struct ktermios *termios,
 		cval |= UART_LCR_EPAR;
 
 	/*
+	 * The base clk is 50Mhz, and the baud rate come from:
+	 *	baud = 50M * MUL / (DIV * PS * DLAB)
+	 *
 	 * For those basic low baud rate we can get the direct
-	 * scalar from 2746800, like 115200 = 2746800/24, for those
-	 * higher baud rate, we have to handle them case by case,
-	 * but DIV reg is never touched as its default value 0x3d09
+	 * scalar from 2746800, like 115200 = 2746800/24. For those
+	 * higher baud rate, we handle them case by case, mainly by
+	 * adjusting the MUL/PS registers, and DIV register is kept
+	 * as default value 0x3d09 to make things simple
 	 */
 	baud = uart_get_baud_rate(port, termios, old, 0, 4000000);
-	quot = uart_get_divisor(port, baud);
 
+	quot = 1;
 	switch (baud) {
 	case 3500000:
 		mul = 0x3345;
 		ps = 0xC;
-		quot = 1;
+		break;
+	case 3000000:
+		mul = 0x2EE0;
 		break;
 	case 2500000:
 		mul = 0x2710;
-		ps = 0x10;
-		quot = 1;
 		break;
-	case 18432000:
+	case 2000000:
+		mul = 0x1F40;
+		break;
+	case 1843200:
 		mul = 0x2400;
-		ps = 0x10;
-		quot = 1;
 		break;
 	case 1500000:
-		mul = 0x1D4C;
-		ps = 0xc;
-		quot = 1;
+		mul = 0x1770;
+		break;
+	case 1000000:
+		mul = 0xFA0;
+		break;
+	case 500000:
+		mul = 0x7D0;
 		break;
 	default:
-		;
+		/* Use uart_get_divisor to get quot for other baud rates */
+		quot = 0;
 	}
 
+	if (!quot)
+		quot = uart_get_divisor(port, baud);
+
 	if ((up->port.uartclk / quot) < (2400 * 16))
 		fcr = UART_FCR_ENABLE_FIFO | UART_FCR_HSU_64_1B;
 	else if ((up->port.uartclk / quot) < (230400 * 16))
-- 
1.7.2

