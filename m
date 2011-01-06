Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1AFW0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:26:05 -0500
Received: from kroah.org ([198.145.64.141]:55708 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab1AFWYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:24:01 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Govindraj.R" <govindraj.raja@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/36] Serial: Avoid unbalanced IRQ wake disable during resume
Date: Thu,  6 Jan 2011 14:23:21 -0800
Message-Id: <1294352605-31906-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Govindraj.R <govindraj.raja@ti.com>

To avoid unbalanced IRQ wake disable, ensure that wakeups are disabled
only when wakeups have been successfully enabled.
Tested on OMAP3630SDP/ZOOM3.

Signed-off-by: Govindraj.R <govindraj.raja@ti.com>
Reported-by: Paul Walmsley <paul@pwsan.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |    8 ++++++--
 include/linux/serial_core.h  |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 2835e29..76418c1 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1986,7 +1986,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 
 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
 	if (device_may_wakeup(tty_dev)) {
-		enable_irq_wake(uport->irq);
+		if (!enable_irq_wake(uport->irq))
+			uport->irq_wake = 1;
 		put_device(tty_dev);
 		mutex_unlock(&port->mutex);
 		return 0;
@@ -2052,7 +2053,10 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 
 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
 	if (!uport->suspended && device_may_wakeup(tty_dev)) {
-		disable_irq_wake(uport->irq);
+		if (uport->irq_wake) {
+			disable_irq_wake(uport->irq);
+			uport->irq_wake = 0;
+		}
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 7a6daf1..a23fa29 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -365,6 +365,7 @@ struct uart_port {
 	struct device		*dev;			/* parent device */
 	unsigned char		hub6;			/* this should be in the 8250 driver */
 	unsigned char		suspended;
+	unsigned char		irq_wake;
 	unsigned char		unused[2];
 	void			*private_data;		/* generic platform data pointer */
 };
-- 
1.7.3.2

