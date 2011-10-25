Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab1JYJtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:49:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49702 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab1JYJtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:49:07 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>, Greg KH <greg@kroah.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 7/7] samples/amp: add an rpmsg driver sample
Date: Tue, 25 Oct 2011 11:48:26 +0200
Message-Id: <1319536106-25802-8-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319536106-25802-1-git-send-email-ohad@wizery.com>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an rpmsg driver sample, which demonstrates how to communicate with
an AMP-configured remote processor over the rpmsg bus.

The driver repeatedly sends a "Hello World!" message to the remote
processor.

Note that once probed, the driver can immediately start sending messages
using the rpmsg_send() API, without having to worry about creating endpoints
or allocating rpmsg addresses: all that work is done by the rpmsg bus,
and the required information is already embedded in the rpmsg channel
that the driver is probed with.

Designed with Brian Swetland <swetland@google.com>.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 samples/Kconfig                   |    8 +++
 samples/Makefile                  |    2 +-
 samples/amp/Makefile              |    1 +
 samples/amp/rpmsg_client_sample.c |  100 +++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+), 1 deletions(-)
 create mode 100644 samples/amp/Makefile
 create mode 100644 samples/amp/rpmsg_client_sample.c

diff --git a/samples/Kconfig b/samples/Kconfig
index 96a7572..997ddd3 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -67,4 +67,12 @@ config SAMPLE_HIDRAW
 	help
 	  Build an example of how to use hidraw from userspace.
 
+config SAMPLE_RPMSG_CLIENT
+	tristate "Build rpmsg client sample -- loadable modules only"
+	depends on RPMSG && m
+	help
+	  Build an rpmsg client sample driver, which demonstrates how
+	  to communicate with an AMP-configured remote processor over
+	  the rpmsg bus.
+
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 6280817..040f424 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,4 +1,4 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/ \
-			   hw_breakpoint/ kfifo/ kdb/ hidraw/
+			   hw_breakpoint/ kfifo/ kdb/ hidraw/ amp/
diff --git a/samples/amp/Makefile b/samples/amp/Makefile
new file mode 100644
index 0000000..2d4973c
--- /dev/null
+++ b/samples/amp/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_RPMSG_CLIENT) += rpmsg_client_sample.o
diff --git a/samples/amp/rpmsg_client_sample.c b/samples/amp/rpmsg_client_sample.c
new file mode 100644
index 0000000..7b23380
--- /dev/null
+++ b/samples/amp/rpmsg_client_sample.c
@@ -0,0 +1,100 @@
+/*
+ * Remote processor messaging - sample client driver
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * Ohad Ben-Cohen <ohad@wizery.com>
+ * Brian Swetland <swetland@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/amp/rpmsg.h>
+
+#define MSG		"hello world!"
+#define MSG_LIMIT	100
+
+static void rpmsg_sample_cb(struct rpmsg_channel *rpdev, void *data, int len,
+						void *priv, u32 src)
+{
+	int ret;
+	static int rx_count;
+
+	dev_info(&rpdev->dev, "incoming msg %d (src: 0x%x)\n", ++rx_count, src);
+
+	print_hex_dump(KERN_DEBUG, __func__, DUMP_PREFIX_NONE, 16, 1,
+		       data, len,  true);
+
+	/* samples should not live forever */
+	if (rx_count >= MSG_LIMIT) {
+		dev_info(&rpdev->dev, "goodbye!\n");
+		return;
+	}
+
+	/* send a new message now */
+	ret = rpmsg_send(rpdev, MSG, strlen(MSG));
+	if (ret)
+		dev_err(&rpdev->dev, "rpmsg_send failed: %d\n", ret);
+}
+
+static int rpmsg_sample_probe(struct rpmsg_channel *rpdev)
+{
+	int ret;
+
+	dev_info(&rpdev->dev, "new channel: 0x%x -> 0x%x!\n",
+					rpdev->src, rpdev->dst);
+
+	/* send a message to our remote processor */
+	ret = rpmsg_send(rpdev, MSG, strlen(MSG));
+	if (ret) {
+		dev_err(&rpdev->dev, "rpmsg_send failed: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __devexit rpmsg_sample_remove(struct rpmsg_channel *rpdev)
+{
+	dev_info(&rpdev->dev, "rpmsg sample client driver is removed\n");
+}
+
+static struct rpmsg_device_id rpmsg_driver_sample_id_table[] = {
+	{ .name	= "rpmsg-client-sample" },
+	{ },
+};
+MODULE_DEVICE_TABLE(rpmsg, rpmsg_driver_sample_id_table);
+
+static struct rpmsg_driver rpmsg_sample_client = {
+	.drv.name	= KBUILD_MODNAME,
+	.drv.owner	= THIS_MODULE,
+	.id_table	= rpmsg_driver_sample_id_table,
+	.probe		= rpmsg_sample_probe,
+	.callback	= rpmsg_sample_cb,
+	.remove		= __devexit_p(rpmsg_sample_remove),
+};
+
+static int __init rpmsg_client_sample_init(void)
+{
+	return register_rpmsg_driver(&rpmsg_sample_client);
+}
+module_init(rpmsg_client_sample_init);
+
+static void __exit rpmsg_client_sample_fini(void)
+{
+	unregister_rpmsg_driver(&rpmsg_sample_client);
+}
+module_exit(rpmsg_client_sample_fini);
+
+MODULE_DESCRIPTION("Remote processor messaging sample client driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.5.4

