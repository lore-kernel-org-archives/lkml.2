Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab2JaRmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:42:10 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:34568 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933895Ab2JaRjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:39:36 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Paul Walmsley <paul@pwsan.com>, "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [RFC-v3 3/7] capebus: Beaglebone generic cape support
Date: Thu,  1 Nov 2012 17:32:28 +0200
Message-Id: <1351783952-11804-4-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1351783952-11804-1-git-send-email-panto@antoniou-consulting.com>
References: <1351783952-11804-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing beaglebone generic cape support.

With this you can create almost any kind of cape driver
that doesn't require complex interconnection of the parts.

Most beaglebone capes can be created with this, including
all the display capes (DVI/VGA/LCD) with touchscreen or not,
capes that only use i2c or spi devices, gpio-keys, leds etc.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/capebus/capes/Kconfig             |  6 +++
 drivers/capebus/capes/Makefile            |  1 +
 drivers/capebus/capes/bone-generic-cape.c | 75 +++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)
 create mode 100644 drivers/capebus/capes/Kconfig
 create mode 100644 drivers/capebus/capes/Makefile
 create mode 100644 drivers/capebus/capes/bone-generic-cape.c

diff --git a/drivers/capebus/capes/Kconfig b/drivers/capebus/capes/Kconfig
new file mode 100644
index 0000000..bfe54a6
--- /dev/null
+++ b/drivers/capebus/capes/Kconfig
@@ -0,0 +1,6 @@
+config CAPEBUS_BONE_GENERIC
+	tristate "Beaglebone Generic cape driver"
+	depends on CAPEBUS_BONE_CONTROLLER
+	default n
+	help
+	  "Select this to enable a generic cape driver; LCD/DVI capes etc"
diff --git a/drivers/capebus/capes/Makefile b/drivers/capebus/capes/Makefile
new file mode 100644
index 0000000..83da381
--- /dev/null
+++ b/drivers/capebus/capes/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_CAPEBUS_BONE_GENERIC)	+= bone-generic-cape.o
diff --git a/drivers/capebus/capes/bone-generic-cape.c b/drivers/capebus/capes/bone-generic-cape.c
new file mode 100644
index 0000000..b364614
--- /dev/null
+++ b/drivers/capebus/capes/bone-generic-cape.c
@@ -0,0 +1,75 @@
+/*
+ * Generic cape support
+ *
+ * Copyright (C) 2012 Pantelis Antoniou <panto@antoniou-consulting.com>
+ * Copyright (C) 2012 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+
+#include <linux/capebus/capebus-bone.h>
+
+/* fwd decl. */
+extern struct cape_driver bonegeneric_driver;
+
+static const struct of_device_id bonegeneric_of_match[] = {
+	{
+		.compatible = "bone-generic-cape",
+	},	{ },
+};
+MODULE_DEVICE_TABLE(of, bonegeneric_of_match);
+
+static int bonegeneric_probe(struct cape_dev *dev,
+		const struct cape_device_id *id)
+{
+	struct bone_capebus_generic_info *ginfo;
+	int err;
+
+	err = bone_capebus_probe_prolog(dev, id);
+	if (err != 0)
+		return err;
+
+	ginfo = bone_capebus_probe_generic(dev, id);
+	if (IS_ERR_OR_NULL(ginfo))
+		return IS_ERR(ginfo) ? PTR_ERR(ginfo) : -ENODEV;
+	dev->drv_priv = ginfo;
+	return 0;
+}
+
+static void bonegeneric_remove(struct cape_dev *dev)
+{
+	bone_capebus_remove_generic(dev->drv_priv);
+}
+
+struct cape_driver bonegeneric_driver = {
+	.driver = {
+		.name		= "bonegeneric",
+		.owner		= THIS_MODULE,
+		.of_match_table	= bonegeneric_of_match,
+	},
+	.probe		= bonegeneric_probe,
+	.remove		= bonegeneric_remove,
+};
+
+module_capebus_driver(bonegeneric_driver);
+
+MODULE_AUTHOR("Pantelis Antoniou");
+MODULE_DESCRIPTION("Beaglebone generic cape");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:bone-generic-cape");
-- 
1.7.12

