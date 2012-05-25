Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab2EYByn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 21:54:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44998 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2EYByk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 21:54:40 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>, randy.dunlap@oracle.com,
        mjg59@srcf.ucam.org, gregkh@suse.de, trenn@suse.de,
        Valdis.Kletnieks@vt.edu, Dennis.Jansen@web.de, airlied@redhat.com,
        eric@anholt.net, alexdeucher@gmail.com, bskeggs@redhat.com,
        chris@chris-wilson.co.uk
Subject: [PATCH] gpu: remove gma500 stub driver
Date: Fri, 25 May 2012 09:50:44 +0800
Message-Id: <1337910644-21694-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.3, the gma500 drm driver moved from staging to drm group by
Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
brightness well and don't need gma500 stub driver anymore.

Cc: randy.dunlap@oracle.com
Cc: mjg59@srcf.ucam.org
Cc: gregkh@suse.de
Cc: trenn@suse.de
Cc: Valdis.Kletnieks@vt.edu
Cc: Dennis.Jansen@web.de
Cc: airlied@redhat.com
Cc: eric@anholt.net
Cc: alexdeucher@gmail.com
Cc: bskeggs@redhat.com
Cc: chris@chris-wilson.co.uk
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/gpu/Makefile       |    2 +-
 drivers/gpu/stub/Kconfig   |   18 ------------
 drivers/gpu/stub/Makefile  |    1 -
 drivers/gpu/stub/poulsbo.c |   64 --------------------------------------------
 drivers/video/Kconfig      |    2 -
 5 files changed, 1 insertions(+), 86 deletions(-)
 delete mode 100644 drivers/gpu/stub/Kconfig
 delete mode 100644 drivers/gpu/stub/Makefile
 delete mode 100644 drivers/gpu/stub/poulsbo.c

diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
index cc92778..30879df 100644
--- a/drivers/gpu/Makefile
+++ b/drivers/gpu/Makefile
@@ -1 +1 @@
-obj-y			+= drm/ vga/ stub/
+obj-y			+= drm/ vga/
diff --git a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig
deleted file mode 100644
index 4199179..0000000
--- a/drivers/gpu/stub/Kconfig
+++ /dev/null
@@ -1,18 +0,0 @@
-config STUB_POULSBO
-	tristate "Intel GMA500 Stub Driver"
-	depends on PCI
-	depends on NET # for THERMAL
-	# Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
-	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
-	select BACKLIGHT_CLASS_DEVICE if ACPI
-	select VIDEO_OUTPUT_CONTROL if ACPI
-	select INPUT if ACPI
-	select ACPI_VIDEO if ACPI
-	select THERMAL if ACPI
-	help
-	  Choose this option if you have a system that has Intel GMA500
-	  (Poulsbo) integrated graphics. If M is selected, the module will
-	  be called Poulsbo. This driver is a stub driver for Poulsbo that
-	  will call poulsbo.ko to enable the acpi backlight control sysfs
-	  entry file because there have no poulsbo native driver can support
-	  intel opregion.
diff --git a/drivers/gpu/stub/Makefile b/drivers/gpu/stub/Makefile
deleted file mode 100644
index cd940cc..0000000
--- a/drivers/gpu/stub/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_STUB_POULSBO) += poulsbo.o
diff --git a/drivers/gpu/stub/poulsbo.c b/drivers/gpu/stub/poulsbo.c
deleted file mode 100644
index 7edfd27..0000000
--- a/drivers/gpu/stub/poulsbo.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Intel Poulsbo Stub driver
- *
- * Copyright (C) 2010 Novell <jlee@novell.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published by
- * the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/acpi.h>
-#include <acpi/video.h>
-
-#define DRIVER_NAME "poulsbo"
-
-enum {
-	CHIP_PSB_8108 = 0,
-	CHIP_PSB_8109 = 1,
-};
-
-static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
-	{0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108}, \
-	{0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109}, \
-	{0, 0, 0}
-};
-
-static int poulsbo_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-{
-	return acpi_video_register();
-}
-
-static void poulsbo_remove(struct pci_dev *pdev)
-{
-	acpi_video_unregister();
-}
-
-static struct pci_driver poulsbo_driver = {
-	.name = DRIVER_NAME,
-	.id_table = pciidlist,
-	.probe = poulsbo_probe,
-	.remove = poulsbo_remove,
-};
-
-static int __init poulsbo_init(void)
-{
-	return pci_register_driver(&poulsbo_driver);
-}
-
-static void __exit poulsbo_exit(void)
-{
-	pci_unregister_driver(&poulsbo_driver);
-}
-
-module_init(poulsbo_init);
-module_exit(poulsbo_exit);
-
-MODULE_AUTHOR("Lee, Chun-Yi <jlee@novell.com>");
-MODULE_DESCRIPTION("Poulsbo Stub Driver");
-MODULE_LICENSE("GPL");
-
-MODULE_DEVICE_TABLE(pci, pciidlist);
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index a290be5..8a12c6e 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -21,8 +21,6 @@ source "drivers/gpu/vga/Kconfig"
 
 source "drivers/gpu/drm/Kconfig"
 
-source "drivers/gpu/stub/Kconfig"
-
 config VGASTATE
        tristate
        default n
-- 
1.6.0.2

