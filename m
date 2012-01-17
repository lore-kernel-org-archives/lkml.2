Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2AQTER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:04:17 -0500
Received: from mail-ww0-f74.google.com ([74.125.82.74]:55714 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2AQTEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:04:16 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 2/3] serial: Make wakeup_capable a flag to reduce boot time
Date: Tue, 17 Jan 2012 10:56:02 -0800
Message-Id: <1326826563-32215-2-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326826563-32215-1-git-send-email-sjg@chromium.org>
References: <1326826563-32215-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The synchronize_rcu() call resulting from making every serial driver
wake-up capable (commit b3b708fa) slows boot down by 600ms on my Tegra2x
system (with CONFIG_PREEMPT disabled).

Waking up the machine from a serial port seems to be an unlikely
requirement, so make serial_core default to not using the behaviour.

Before:
[    0.338809] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.951861] serial8250.0: ttyS0 at MMIO 0x70006040 (irq = 69) is a Tegra
[    1.666042] console [ttyS0] enabled

After:
[    0.338452] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.339016] serial8250.0: ttyS0 at MMIO 0x70006040 (irq = 69) is a Tegra
[    1.041860] console [ttyS0] enabled

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 drivers/tty/serial/serial_core.c |    6 ++++--
 include/linux/serial_core.h      |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c7bf31a..0129551 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2348,8 +2348,10 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 */
 	tty_dev = tty_register_device(drv->tty_driver, uport->line, uport->dev);
 	if (likely(!IS_ERR(tty_dev))) {
-		device_init_wakeup(tty_dev, 1);
-		device_set_wakeup_enable(tty_dev, 0);
+		if (uport->wakeup_capable) {
+			device_init_wakeup(tty_dev, 1);
+			device_set_wakeup_enable(tty_dev, 0);
+		}
 	} else
 		printk(KERN_ERR "Cannot register tty device on line %d\n",
 		       uport->line);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index c91ace7..9a87975 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -377,7 +377,8 @@ struct uart_port {
 	unsigned char		hub6;			/* this should be in the 8250 driver */
 	unsigned char		suspended;
 	unsigned char		irq_wake;
-	unsigned char		unused[2];
+	unsigned char		wakeup_capable;	/* 1 if wake-up capable */
+	unsigned char		unused;
 	void			*private_data;		/* generic platform data pointer */
 };
 
-- 
1.7.7.3

