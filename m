Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab2EPGeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:34:16 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:28847
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759116Ab2EPGd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:33:26 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839hd24he5bhe96h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 4/4] serial: bfin_uart: Make MMR access compatible with 32 bits bf609 style controller.
Date: Wed, 16 May 2012 14:22:26 +0800
Message-ID: <1337149346-5277-4-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337149346-5277-1-git-send-email-sonic.adi@gmail.com>
References: <1337149346-5277-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Simplify serial data width calculation and adapt to bf609 LCR bit mask.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/tty/serial/bfin_uart.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 7924ba6..bd97db2 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -594,7 +594,7 @@ static unsigned int bfin_serial_tx_empty(struct uart_port *port)
 static void bfin_serial_break_ctl(struct uart_port *port, int break_state)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-	u16 lcr = UART_GET_LCR(uart);
+	u32 lcr = UART_GET_LCR(uart);
 	if (break_state)
 		lcr |= SB;
 	else
@@ -1068,7 +1068,7 @@ bfin_serial_console_get_options(struct bfin_serial_port *uart, int *baud,
 	status = UART_GET_IER(uart) & (ERBFI | ETBEI);
 	if (status == (ERBFI | ETBEI)) {
 		/* ok, the port was enabled */
-		u16 lcr, clk;
+		u32 lcr, clk;
 
 		lcr = UART_GET_LCR(uart);
 
@@ -1079,20 +1079,8 @@ bfin_serial_console_get_options(struct bfin_serial_port *uart, int *baud,
 			else
 				*parity = 'o';
 		}
-		switch (lcr & 0x03) {
-		case 0:
-			*bits = 5;
-			break;
-		case 1:
-			*bits = 6;
-			break;
-		case 2:
-			*bits = 7;
-			break;
-		case 3:
-			*bits = 8;
-			break;
-		}
+		*bits = ((lcr & WLS_MASK) >> WLS_OFFSET) + 5;
+
 		/* Set DLAB in LCR to Access CLK */
 		UART_SET_DLAB(uart);
 
-- 
1.7.0.4


