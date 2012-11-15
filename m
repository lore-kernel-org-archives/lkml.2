Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993311Ab2KOI4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:56:54 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58344 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992991Ab2KOIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:50:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 5/9] MMC: sdio, use kref from tty_port
Date: Thu, 15 Nov 2012 09:49:52 +0100
Message-Id: <1352969396-23760-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit "TTY: move tty buffers to tty_port", the tty buffers are
not freed in some drivers. This is because tty_port_destructor is not
called whenever a tty_port is freed. This was an assumption I counted
with but was unfortunately untrue. So fix the drivers to fulfil this
assumption.

Here it is enough to switch to refcounting in tty_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mmc/card/sdio_uart.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 369f7ba..bd57a11 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -66,7 +66,6 @@ struct uart_icount {
 
 struct sdio_uart_port {
 	struct tty_port		port;
-	struct kref		kref;
 	unsigned int		index;
 	struct sdio_func	*func;
 	struct mutex		func_lock;
@@ -92,7 +91,6 @@ static int sdio_uart_add_port(struct sdio_uart_port *port)
 {
 	int index, ret = -EBUSY;
 
-	kref_init(&port->kref);
 	mutex_init(&port->func_lock);
 	spin_lock_init(&port->write_lock);
 	if (kfifo_alloc(&port->xmit_fifo, FIFO_SIZE, GFP_KERNEL))
@@ -122,23 +120,15 @@ static struct sdio_uart_port *sdio_uart_port_get(unsigned index)
 	spin_lock(&sdio_uart_table_lock);
 	port = sdio_uart_table[index];
 	if (port)
-		kref_get(&port->kref);
+		tty_port_get(&port->port);
 	spin_unlock(&sdio_uart_table_lock);
 
 	return port;
 }
 
-static void sdio_uart_port_destroy(struct kref *kref)
-{
-	struct sdio_uart_port *port =
-		container_of(kref, struct sdio_uart_port, kref);
-	kfifo_free(&port->xmit_fifo);
-	kfree(port);
-}
-
 static void sdio_uart_port_put(struct sdio_uart_port *port)
 {
-	kref_put(&port->kref, sdio_uart_port_destroy);
+	tty_port_put(&port->port);
 }
 
 static void sdio_uart_port_remove(struct sdio_uart_port *port)
@@ -736,6 +726,14 @@ static void sdio_uart_shutdown(struct tty_port *tport)
 	sdio_uart_release_func(port);
 }
 
+static void sdio_uart_port_destroy(struct tty_port *tport)
+{
+	struct sdio_uart_port *port =
+		container_of(tport, struct sdio_uart_port, port);
+	kfifo_free(&port->xmit_fifo);
+	kfree(port);
+}
+
 /**
  *	sdio_uart_install	-	install method
  *	@driver: the driver in use (sdio_uart in our case)
@@ -1044,6 +1042,7 @@ static const struct tty_port_operations sdio_uart_port_ops = {
 	.carrier_raised = uart_carrier_raised,
 	.shutdown = sdio_uart_shutdown,
 	.activate = sdio_uart_activate,
+	.destruct = sdio_uart_port_destroy,
 };
 
 static const struct tty_operations sdio_uart_ops = {
-- 
1.8.0


