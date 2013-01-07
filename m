Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3AGKD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:03:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49047 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3AGKDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:03:53 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] [media] coda: Fix build due to iram.h rename
Date: Mon,  7 Jan 2013 11:03:45 +0100
Message-Id: <1357553025-21094-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c045e3f13 (ARM: imx: include iram.h rather than mach/iram.h) changed the
location of iram.h, which causes the following build error when building the coda
driver:

drivers/media/platform/coda.c:27:23: error: mach/iram.h: No such file or directory
drivers/media/platform/coda.c: In function 'coda_probe':
drivers/media/platform/coda.c:2000: error: implicit declaration of function 'iram_alloc'
drivers/media/platform/coda.c:2001: warning: assignment makes pointer from integer without a cast
drivers/media/platform/coda.c: In function 'coda_remove':
drivers/media/platform/coda.c:2024: error: implicit declaration of function 'iram_free'

Since the content of iram.h is not imx specific, move it to
include/linux/platform_data/imx-iram.h instead. This is an intermediate solution
until the i.MX iram allocator is converted to the generic SRAM allocator.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Based on an earlier version from Fabio Estevam, but this one moves iram.h
to include/linux/platform_data/imx-iram.h instead of include/linux/iram.h
which is a less generic name.

 arch/arm/mach-imx/iram.h               |   41 --------------------------------
 arch/arm/mach-imx/iram_alloc.c         |    3 +--
 drivers/media/platform/coda.c          |    2 +-
 include/linux/platform_data/imx-iram.h |   41 ++++++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 44 deletions(-)
 delete mode 100644 arch/arm/mach-imx/iram.h
 create mode 100644 include/linux/platform_data/imx-iram.h

diff --git a/arch/arm/mach-imx/iram.h b/arch/arm/mach-imx/iram.h
deleted file mode 100644
index 022690c..0000000
--- a/arch/arm/mach-imx/iram.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
- * MA 02110-1301, USA.
- */
-#include <linux/errno.h>
-
-#ifdef CONFIG_IRAM_ALLOC
-
-int __init iram_init(unsigned long base, unsigned long size);
-void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr);
-void iram_free(unsigned long dma_addr, unsigned int size);
-
-#else
-
-static inline int __init iram_init(unsigned long base, unsigned long size)
-{
-	return -ENOMEM;
-}
-
-static inline void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
-{
-	return NULL;
-}
-
-static inline void iram_free(unsigned long base, unsigned long size) {}
-
-#endif
diff --git a/arch/arm/mach-imx/iram_alloc.c b/arch/arm/mach-imx/iram_alloc.c
index 6c80424..e05cf40 100644
--- a/arch/arm/mach-imx/iram_alloc.c
+++ b/arch/arm/mach-imx/iram_alloc.c
@@ -22,8 +22,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/genalloc.h>
-
-#include "iram.h"
+#include "linux/platform_data/imx-iram.h"
 
 static unsigned long iram_phys_base;
 static void __iomem *iram_virt_base;
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 7b8b547..afadd3a 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -23,8 +23,8 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/of.h>
+#include <linux/platform_data/imx-iram.h>
 
-#include <mach/iram.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
diff --git a/include/linux/platform_data/imx-iram.h b/include/linux/platform_data/imx-iram.h
new file mode 100644
index 0000000..022690c
--- /dev/null
+++ b/include/linux/platform_data/imx-iram.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA 02110-1301, USA.
+ */
+#include <linux/errno.h>
+
+#ifdef CONFIG_IRAM_ALLOC
+
+int __init iram_init(unsigned long base, unsigned long size);
+void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr);
+void iram_free(unsigned long dma_addr, unsigned int size);
+
+#else
+
+static inline int __init iram_init(unsigned long base, unsigned long size)
+{
+	return -ENOMEM;
+}
+
+static inline void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
+{
+	return NULL;
+}
+
+static inline void iram_free(unsigned long base, unsigned long size) {}
+
+#endif
-- 
1.7.10.4

