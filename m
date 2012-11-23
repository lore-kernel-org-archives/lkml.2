Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2KWSnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 13:43:05 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:45565 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291Ab2KWSnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 13:43:04 -0500
Message-ID: <50AFC3A6.7010308@ilyx.ru>
Date: Fri, 23 Nov 2012 22:42:46 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew McGregor <andrew.mcgregor@alliedtelesis.co.nz>,
        linux-kernel@vger.kernel.org, ilya@ilyx.ru
Subject: [PATCH]tty: Incorrect use tty_ldisc_flush() in TTY drivers.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch correct tty serial drivers.

Unfortunately, many drivers indirectly call ldisc's flush_buffer() function 
in own callback function close(). Рarticularly, by the use of tty_ldisc_flush(),
before TTY LAYER calls ldisc's flush_buffer() in the right moment.

1. It disturb the logic of work ldisc's layer.
2. It is simple overhead because we call ldisc's flush_buffer() at least two times.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a21dc8e..c4a0a6d 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1288,7 +1288,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
        uart_shutdown(tty, state);
        uart_flush_buffer(tty);
 
-       tty_ldisc_flush(tty);
+       tty_buffer_flush(tty);
 
        tty_port_tty_set(port, NULL);
        spin_lock_irqsave(&port->lock, flags);
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index bf6e238..c23dd30 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -364,8 +364,8 @@ int tty_port_close_start(struct tty_port *port,
                        timeout = 2 * HZ;
                schedule_timeout_interruptible(timeout);
        }
-       /* Flush the ldisc buffering */
-       tty_ldisc_flush(tty);
+       /* Flush the driver buffering */
+       tty_buffer_flush(tty);
 
        /* Drop DTR/RTS if HUPCL is set. This causes any attached modem to
           hang up the line */

