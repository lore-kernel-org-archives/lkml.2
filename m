Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2JCM2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:28:14 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:60164 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab2JCM2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:28:13 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <alan@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: [PATCH v3] serial/8250/8250_early: Prevent rounding error in uartclk
Date: Wed, 3 Oct 2012 16:27:43 +0400
Message-ID: <1349267263-21683-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.121.8.154]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify divisor to select the nearest baud rate divider rather than the
lowest. It minimizes baud rate errors especially on low UART clock
frequencies.

For example, if uartclk is 33000000 and baud is 115200 the ratio is
about 17.9 The current code selects 17 (5% error) but should select 18
(0.5% error).

This 5% error in baud rate leads to garbage on receiving end, while 0.5%
doesn't.

The issue showed up when using the stock 8250 driver for
Synopsys DW UART. This was on a FPGA with ~12MHz UART clock.
When we enabled early serial, we saw garbage which was narrowed down
to the rounding error.

So the bug had been latent and it only showed up with such low cock rates.

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
---
 drivers/tty/serial/8250/8250_early.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
index eaafb98..843a150 100644
--- a/drivers/tty/serial/8250/8250_early.c
+++ b/drivers/tty/serial/8250/8250_early.c
@@ -140,7 +140,7 @@ static void __init init_port(struct early_serial8250_device *device)
 	serial_out(port, UART_FCR, 0);		/* no fifo */
 	serial_out(port, UART_MCR, 0x3);	/* DTR + RTS */
 
-	divisor = port->uartclk / (16 * device->baud);
+	divisor = DIV_ROUND_CLOSEST(port->uartclk, 16 * device->baud);
 	c = serial_in(port, UART_LCR);
 	serial_out(port, UART_LCR, c | UART_LCR_DLAB);
 	serial_out(port, UART_DLL, divisor & 0xff);
-- 
1.7.9.5

