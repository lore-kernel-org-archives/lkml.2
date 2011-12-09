Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1LIGHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 01:07:47 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:50895 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1LIGHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 01:07:44 -0500
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-serial@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/2] serial: bfin-uart: Remove ASYNC_CTS_FLOW flag for hardware automatic CTS.
Date: Fri, 9 Dec 2011 14:00:21 +0800
Message-ID: <1323410421-10465-2-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323410421-10465-1-git-send-email-sonic.adi@gmail.com>
References: <1323410421-10465-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Blackfin uart supports automatic CTS trigger when hardware flow control is enabled.
No need to start and top tx in CTS interrupt. So, remote ASYNC_CTS_FLOW flag.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/tty/serial/bfin_uart.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 57747c4..929dd11 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -116,11 +116,20 @@ static void bfin_serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
 static irqreturn_t bfin_serial_mctrl_cts_int(int irq, void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;
-	unsigned int status;
-
-	status = bfin_serial_get_mctrl(&uart->port);
+	unsigned int status = bfin_serial_get_mctrl(&uart->port);
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
+	struct tty_struct *tty = uart->port.state->port.tty;
+
 	UART_CLEAR_SCTS(uart);
+	if (tty->hw_stopped) {
+		if (status) {
+			tty->hw_stopped = 0;
+			uart_write_wakeup(&uart->port);
+		}
+	} else {
+		if (!status)
+			tty->hw_stopped = 1;
+	}
 #endif
 	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
 
@@ -1358,7 +1367,9 @@ static int bfin_serial_probe(struct platform_device *pdev)
 			uart->cts_pin = -1;
 		else {
 			uart->cts_pin = res->start;
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 			uart->port.flags |= ASYNC_CTS_FLOW;
+#endif
 		}
 
 		res = platform_get_resource(pdev, IORESOURCE_IO, 1);
-- 
1.7.0.4


