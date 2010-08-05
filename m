Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934562Ab0HEWcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:32:53 -0400
Received: from kroah.org ([198.145.64.141]:37782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934550Ab0HEWYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Claudio Scordino <claudio@evidence.eu.com>, Bernhard Roth <br@pwrnet.de>,
        Philippe De Muyter <phdm@macqel.be>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 54/67] serial: general fixes in the serial_rs485 structure
Date: Thu,  5 Aug 2010 15:23:21 -0700
Message-Id: <1281047014-23429-54-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudio Scordino <claudio@evidence.eu.com>

Fix several issues related to the RS485 interface:

 - It adds the flag SER_RS485_RTS_BEFORE_SEND that was missing from the
   serial_rs485 structure (even if "delay_rts_before_send" was existing)

 - It adds a further "delay_rts_after_send" field for those drivers that
   can have a delay after send (e.g., atmel_serial)

 - It fixes the usage of the structure in the atmel_serial driver (where
   "delay_rts_before_send" should be used instead of "delay_rts_after_send").

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Bernhard Roth <br@pwrnet.de>
Cc: Philippe De Muyter <phdm@macqel.be>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/atmel_serial.c |   11 ++++++++---
 include/linux/serial.h        |    4 +++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index a182def..3892666 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -217,7 +217,8 @@ void atmel_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
 	if (rs485conf->flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
 		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
-		UART_PUT_TTGR(port, rs485conf->delay_rts_before_send);
+		if (rs485conf->flags & SER_RS485_RTS_AFTER_SEND)
+			UART_PUT_TTGR(port, rs485conf->delay_rts_after_send);
 		mode |= ATMEL_US_USMODE_RS485;
 	} else {
 		dev_dbg(port->dev, "Setting UART to RS232\n");
@@ -292,7 +293,9 @@ static void atmel_set_mctrl(struct uart_port *port, u_int mctrl)
 
 	if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
-		UART_PUT_TTGR(port, atmel_port->rs485.delay_rts_before_send);
+		if (atmel_port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
+			UART_PUT_TTGR(port,
+					atmel_port->rs485.delay_rts_after_send);
 		mode |= ATMEL_US_USMODE_RS485;
 	} else {
 		dev_dbg(port->dev, "Setting UART to RS232\n");
@@ -1211,7 +1214,9 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
-		UART_PUT_TTGR(port, atmel_port->rs485.delay_rts_before_send);
+		if (atmel_port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
+			UART_PUT_TTGR(port,
+					atmel_port->rs485.delay_rts_after_send);
 		mode |= ATMEL_US_USMODE_RS485;
 	} else {
 		dev_dbg(port->dev, "Setting UART to RS232\n");
diff --git a/include/linux/serial.h b/include/linux/serial.h
index c3b45ad..ef91406 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -210,8 +210,10 @@ struct serial_rs485 {
 #define SER_RS485_ENABLED		(1 << 0)
 #define SER_RS485_RTS_ON_SEND		(1 << 1)
 #define SER_RS485_RTS_AFTER_SEND	(1 << 2)
+#define SER_RS485_RTS_BEFORE_SEND	(1 << 3)
 	__u32	delay_rts_before_send;	/* Milliseconds */
-	__u32	padding[6];		/* Memory is cheap, new structs
+	__u32	delay_rts_after_send;	/* Milliseconds */
+	__u32	padding[5];		/* Memory is cheap, new structs
 					   are a royal PITA .. */
 };
 
-- 
1.7.2

