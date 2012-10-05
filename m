Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2JEQNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:13:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42859 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab2JEQNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:13:15 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/3] serial_core: Add helper for matching against linux,stdout-path
Date: Fri,  5 Oct 2012 18:12:59 +0200
Message-Id: <1349453581-1685-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349453581-1685-1-git-send-email-s.hauer@pengutronix.de>
References: <1349453581-1685-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devicetrees may have a linux,stdout-path property in the chosen
node describing the console device. This adds a helper function
to match a device against this property so a driver can call
add_preferred_console for a matching device.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/tty/serial/serial_core.c |   30 ++++++++++++++++++++++++++++++
 include/linux/serial_core.h      |    3 +++
 2 files changed, 33 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a21dc8e..f4a9f26 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -33,6 +33,7 @@
 #include <linux/serial_core.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/of.h>
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -2540,6 +2541,35 @@ void uart_insert_char(struct uart_port *port, unsigned int status,
 }
 EXPORT_SYMBOL_GPL(uart_insert_char);
 
+#ifdef CONFIG_OF
+/**
+ * of_uart_is_stdoutpath - check if this device matches the linux,stdout-path
+ *                         property
+ *
+ * Check if this device matches the linux,stdout-path property
+ * in the chosen node. return true if yes, false otherwise.
+ */
+int of_uart_is_stdoutpath(struct device *dev)
+{
+	struct device_node *dn;
+	const char *name;
+
+	name = of_get_property(of_chosen, "linux,stdout-path", NULL);
+	if (name == NULL)
+		return 0;
+
+	dn = of_find_node_by_path(name);
+	if (!dn)
+		return 0;
+
+	if (dn == dev->of_node)
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_uart_is_stdoutpath);
+#endif
+
 EXPORT_SYMBOL(uart_write_wakeup);
 EXPORT_SYMBOL(uart_register_driver);
 EXPORT_SYMBOL(uart_unregister_driver);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 0253c20..35a61f6 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -560,6 +560,9 @@ static inline int uart_handle_break(struct uart_port *port)
 					 (cflag) & CRTSCTS || \
 					 !((cflag) & CLOCAL))
 
+/* check if a device matches the linux,stdout-path property */
+int of_uart_is_stdoutpath(struct device *dev);
+
 #endif
 
 #endif /* LINUX_SERIAL_CORE_H */
-- 
1.7.10.4

