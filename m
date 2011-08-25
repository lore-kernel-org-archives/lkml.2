Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1HYNMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:12:25 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49564 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab1HYNMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:12:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: Arnd Bergmann <arnd@arndb.de>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/5] TTY: serial, use ASYNCB_CLOSING in uart_close
Date: Thu, 25 Aug 2011 15:12:04 +0200
Message-Id: <1314277928-13388-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <4E556CB7.2010102@suse.cz>
References: <4E556CB7.2010102@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to move port->mutex locking after wait_until_sent in
uart_close (for rationale see next patches). But if we did it now, we
would introduce a race between close and open. This is exactly why
port->mutex is locked at the top of uart_close.

To avoid the race, we add ASYNCB_CLOSING to uart_close. Like every
other sane TTY driver. Thanks to tty_port_block_til_ready used in
uart_open we will have this for free. Then we can move the port->mutex
lock.

Also note that this will make the conversion to tty_port helpers
easier. They are currently handling ASYNC_CLOSING flag correctly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/serial_core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 781d566..cd7a0bb 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1293,6 +1293,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	 * the line discipline to only process XON/XOFF characters by
 	 * setting tty->closing.
 	 */
+	set_bit(ASYNCB_CLOSING, &port->flags);
 	tty->closing = 1;
 	spin_unlock_irqrestore(&port->lock, flags);
 
@@ -1340,8 +1341,10 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	 * Wake up anyone trying to open this port.
 	 */
 	clear_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
+	clear_bit(ASYNCB_CLOSING, &port->flags);
 	spin_unlock_irqrestore(&port->lock, flags);
 	wake_up_interruptible(&port->open_wait);
+	wake_up_interruptible(&port->close_wait);
 
 done:
 	mutex_unlock(&port->mutex);
-- 
1.7.6


