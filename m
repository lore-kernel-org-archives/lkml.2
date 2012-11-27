Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2K0AHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:07:15 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:46917 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501Ab2K0AHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:07:12 -0500
Message-ID: <50B4041C.9030002@ilyx.ru>
Date: Tue, 27 Nov 2012 04:06:52 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Andrew McGregor <andrew.mcgregor@alliedtelesis.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        ilya@ilyx.ru
Subject: [PATCH]tty: Incorrect use tty_ldisc_flush() in TTY drivers.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. Correct patch format.

Related bug 'tty: fix "IRQ45: nobody cared"'
Related commit 7b292b4bf9a9d6098440d85616d6ca4c608b8304

  Unfortunately, some drivers indirectly call ldisc's flush_buffer() function 
in own callback function close(). In particularly, by the use of tty_ldisc_flush(),
before TTY LAYER calls ldisc's flush_buffer() in the right moment.

1. It disturb the logic of work ldisc's layer.
2. It is simple overhead because we call ldisc's flush_buffer() at least two times.

Please, tell me what do you think about this? Can I make the adjustment for other drivers?

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 0fcfd98..d87f353 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1304,7 +1304,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	uart_shutdown(tty, state);
 	uart_flush_buffer(tty);
 
-	tty_ldisc_flush(tty);
+	tty_buffer_flush(tty);
 
 	tty_port_tty_set(port, NULL);
 	spin_lock_irqsave(&port->lock, flags);
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index d7bdd8d..8a02996 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -428,8 +428,8 @@ int tty_port_close_start(struct tty_port *port,
 			timeout = 2 * HZ;
 		schedule_timeout_interruptible(timeout);
 	}
-	/* Flush the ldisc buffering */
-	tty_ldisc_flush(tty);
+	/* Flush the driver buffering */
+	tty_buffer_flush(tty);
 
 	/* Drop DTR/RTS if HUPCL is set. This causes any attached modem to
 	   hang up the line */
