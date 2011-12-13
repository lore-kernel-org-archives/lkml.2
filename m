Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1LME30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 23:29:26 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:45843
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551Ab1LME3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 23:29:20 -0500
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-serial@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/2 v3] serial: bfin-uart: Remove ASYNC_CTS_FLOW flag for hardware automatic CTS.
Date: Tue, 13 Dec 2011 12:22:02 +0800
Message-ID: <1323750122-17698-2-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323750122-17698-1-git-send-email-sonic.adi@gmail.com>
References: <1323750122-17698-1-git-send-email-sonic.adi@gmail.com>
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
index dedd9ab..26953bf 100644
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


