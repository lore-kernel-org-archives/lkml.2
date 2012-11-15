Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993277Ab2KOI4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:56:54 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58340 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992988Ab2KOIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:50:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 7/9] TTY: introduce tty_port_destroy
Date: Thu, 15 Nov 2012 09:49:54 +0100
Message-Id: <1352969396-23760-8-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit "TTY: move tty buffers to tty_port", the tty buffers are
not freed in some drivers. This is because tty_port_destructor is not
called whenever a tty_port is freed. This was an assumption I counted
with but was unfortunately untrue.

Those using refcounting are safe now, but for those which do not we
introduce a function to be called right before the tty_port is freed
by the drivers.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_port.c | 16 +++++++++++++++-
 include/linux/tty.h    |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index fdc42c2..b7ff59d 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -122,12 +122,26 @@ void tty_port_free_xmit_buf(struct tty_port *port)
 }
 EXPORT_SYMBOL(tty_port_free_xmit_buf);
 
+/**
+ * tty_port_destroy -- destroy inited port
+ * @port: tty port to be doestroyed
+ *
+ * When a port was initialized using tty_port_init, one has to destroy the
+ * port by this function. Either indirectly by using tty_port refcounting
+ * (tty_port_put) or directly if refcounting is not used.
+ */
+void tty_port_destroy(struct tty_port *port)
+{
+	tty_buffer_free_all(port);
+}
+EXPORT_SYMBOL(tty_port_destroy);
+
 static void tty_port_destructor(struct kref *kref)
 {
 	struct tty_port *port = container_of(kref, struct tty_port, kref);
 	if (port->xmit_buf)
 		free_page((unsigned long)port->xmit_buf);
-	tty_buffer_free_all(port);
+	tty_port_destroy(port);
 	if (port->ops && port->ops->destruct)
 		port->ops->destruct(port);
 	else
diff --git a/include/linux/tty.h b/include/linux/tty.h
index d7ff88f..8db1b56 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -455,6 +455,7 @@ extern struct device *tty_port_register_device_attr(struct tty_port *port,
 		const struct attribute_group **attr_grp);
 extern int tty_port_alloc_xmit_buf(struct tty_port *port);
 extern void tty_port_free_xmit_buf(struct tty_port *port);
+extern void tty_port_destroy(struct tty_port *port);
 extern void tty_port_put(struct tty_port *port);
 
 static inline struct tty_port *tty_port_get(struct tty_port *port)
-- 
1.8.0


