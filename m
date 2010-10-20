Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab0JTFvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:51:43 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62890 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0JTFvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:51:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sfTj1qnnj53LXyKgZPYtda+q6Pr5vkZMmWDpNTlqJo8wh7sgFZPO+AjODBw9HBnR2M
         Kr8o/fY9qMvbjo5VL0oWnqE7i9m5HMQxS31McikHCWvv+x5RMIpHFxNb4SzfVxLsttwG
         ENB1ypaQNzH+O53v2RwPcMdcSadJaKs7xPQYU=
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: randy.dunlap@oracle.com, mjg59@srcf.ucam.org, gregkh@suse.de,
        trenn@suse.de, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Dennis.Jansen@web.de, airlied@linux.ie, airlied@redhat.com,
        eric@anholt.net, alexdeucher@gmail.com, bskeggs@redhat.com,
        chris@chris-wilson.co.uk, "Lee, Chun-Yi" <jlee@novell.com>
Subject: [PATCH] Add Intel GMA500(Poulsbo) Stub Driver
Date: Wed, 20 Oct 2010 13:51:19 +0800
Message-Id: <1287553879-25897-1-git-send-email-jlee@novell.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there have no GMA500(Poulsbo) native video driver to support
intel opregion. So, use this stub driver to enable the acpi backlight
control sysfs entry files by requrest acpi_video_register.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
---
 drivers/gpu/Makefile       |    2 +-
 drivers/gpu/stub/Kconfig   |   13 +++++++++
 drivers/gpu/stub/Makefile  |    1 +
 drivers/gpu/stub/poulsbo.c |   63 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/video/Kconfig      |    2 +
 5 files changed, 80 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpu/stub/Kconfig
 create mode 100644 drivers/gpu/stub/Makefile
 create mode 100644 drivers/gpu/stub/poulsbo.c

diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
index 30879df..cc92778 100644
--- a/drivers/gpu/Makefile
+++ b/drivers/gpu/Makefile
@@ -1 +1 @@
-obj-y			+= drm/ vga/
+obj-y			+= drm/ vga/ stub/
diff --git a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig
new file mode 100644
index 0000000..8f5a540
--- /dev/null
+++ b/drivers/gpu/stub/Kconfig
@@ -0,0 +1,13 @@
+config STUB_POULSBO
+	tristate "Intel GMA500 Stub Driver"
+	depends on PCI
+        # Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
+        # but for select to work, need to select ACPI_VIDEO's dependencies, ick
+        select ACPI_VIDEO if ACPI
+	help
+	  Choose this option if you have a system that has Intel GMA500
+	  (Poulsbo) integrated graphics. If M is selected, the module will
+	  be called Poulsbo. This driver is a stub driver for Poulsbo that
+	  will call poulsbo.ko to enable the acpi backlight control sysfs
+	  entry file because there have no poulsbo native driver can support
+	  intel opregion.
diff --git a/drivers/gpu/stub/Makefile b/drivers/gpu/stub/Makefile
new file mode 100644
index 0000000..cd940cc
--- /dev/null
+++ b/drivers/gpu/stub/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_STUB_POULSBO) += poulsbo.o
diff --git a/drivers/gpu/stub/poulsbo.c b/drivers/gpu/stub/poulsbo.c
new file mode 100644
index 0000000..d8aa636
--- /dev/null
+++ b/drivers/gpu/stub/poulsbo.c
@@ -0,0 +1,63 @@
+/*
+ * Intel Poulsbo Stub driver
+ *
+ * Copyright (C) 2010 Novell <jlee@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <acpi/video.h>
+
+#define DRIVER_NAME "poulsbo"
+
+enum {
+	CHIP_PSB_8108 = 0,
+	CHIP_PSB_8109 = 1,
+};
+
+static struct pci_device_id pciidlist[] = {
+	{0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108}, \
+	{0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109}, \
+	{0, 0, 0}
+};
+
+static int poulsbo_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	return acpi_video_register();
+}
+
+static void poulsbo_remove(struct pci_dev *pdev)
+{
+	acpi_video_unregister();
+}
+
+static struct pci_driver poulsbo_driver = {
+	.name = DRIVER_NAME,
+	.id_table = pciidlist,
+	.probe = poulsbo_probe,
+	.remove = poulsbo_remove,
+};
+
+static int __init poulsbo_init(void)
+{
+	return pci_register_driver(&poulsbo_driver);
+}
+
+static void __exit poulsbo_exit(void)
+{
+	pci_unregister_driver(&poulsbo_driver);
+}
+
+module_init(poulsbo_init);
+module_exit(poulsbo_exit);
+
+MODULE_AUTHOR("Lee, Chun-Yi <jlee@novell.com>");
+MODULE_DESCRIPTION("Poulsbo Stub Driver");
+MODULE_LICENSE("GPL");
+
+MODULE_DEVICE_TABLE(pci, pciidlist);
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 8b31fdf..8807ae5 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -17,6 +17,8 @@ source "drivers/gpu/vga/Kconfig"
 
 source "drivers/gpu/drm/Kconfig"
 
+source "drivers/gpu/stub/Kconfig"
+
 config VGASTATE
        tristate
        default n
-- 
1.6.0.2

