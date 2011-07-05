Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1GEOwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:52:24 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50582 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1GEOwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:52:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 38/49] gma500: move opregion files
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:42:36 +0100
Message-ID: <20110705144234.23872.35328.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We've now sorted them out so they can go into the generic code. In actual
fact only the non MID devices use the functions but they are small and
having the name match i915 is going to help any future merging type work.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile             |    2 -
 drivers/staging/gma500/intel_opregion.c     |   80 +++++++++++++++++++++++++++
 drivers/staging/gma500/psb_intel_opregion.c |   81 ---------------------------
 3 files changed, 81 insertions(+), 82 deletions(-)
 create mode 100644 drivers/staging/gma500/intel_opregion.c
 delete mode 100644 drivers/staging/gma500/psb_intel_opregion.c

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 7f76a19..c014373 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -10,9 +10,9 @@ psb_gfx-y += gem_glue.o \
 	  gem.o \
 	  gtt.o \
 	  intel_bios.o \
+	  intel_opregion.o \
 	  power.o \
 	  psb_drv.o \
-	  psb_intel_opregion.o \
 	  psb_intel_display.o \
 	  psb_intel_i2c.o \
 	  psb_intel_lvds.o \
diff --git a/drivers/staging/gma500/intel_opregion.c b/drivers/staging/gma500/intel_opregion.c
new file mode 100644
index 0000000..8240965
--- /dev/null
+++ b/drivers/staging/gma500/intel_opregion.c
@@ -0,0 +1,80 @@
+/*
+ * Copyright 2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ */
+
+#include "psb_drv.h"
+
+struct opregion_header {
+	u8 signature[16];
+	u32 size;
+	u32 opregion_ver;
+	u8 bios_ver[32];
+	u8 vbios_ver[16];
+	u8 driver_ver[16];
+	u32 mboxes;
+	u8 reserved[164];
+} __packed;
+
+struct opregion_apci {
+	/*FIXME: add it later*/
+} __packed;
+
+struct opregion_swsci {
+	/*FIXME: add it later*/
+} __packed;
+
+struct opregion_acpi {
+	/*FIXME: add it later*/
+} __packed;
+
+int intel_opregion_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 opregion_phy;
+	void *base;
+	u32 *lid_state;
+
+	dev_priv->lid_state = NULL;
+
+	pci_read_config_dword(dev->pdev, 0xfc, &opregion_phy);
+	if (opregion_phy == 0)
+		return -ENOTSUPP;
+
+	base = ioremap(opregion_phy, 8*1024);
+	if (!base)
+		return -ENOMEM;
+
+	lid_state = base + 0x01ac;
+
+	dev_priv->lid_state = lid_state;
+	dev_priv->lid_last_state = readl(lid_state);
+	return 0;
+}
+
+int intel_opregion_exit(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	if (dev_priv->lid_state)
+		iounmap(dev_priv->lid_state);
+	return 0;
+}
diff --git a/drivers/staging/gma500/psb_intel_opregion.c b/drivers/staging/gma500/psb_intel_opregion.c
deleted file mode 100644
index a586f3d..0000000
--- a/drivers/staging/gma500/psb_intel_opregion.c
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * Copyright 2010 Intel Corporation
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice (including the next
- * paragraph) shall be included in all copies or substantial portions of the
- * Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
- * DEALINGS IN THE SOFTWARE.
- *
- */
-
-#include "psb_drv.h"
-
-struct opregion_header {
-	u8 signature[16];
-	u32 size;
-	u32 opregion_ver;
-	u8 bios_ver[32];
-	u8 vbios_ver[16];
-	u8 driver_ver[16];
-	u32 mboxes;
-	u8 reserved[164];
-} __packed;
-
-struct opregion_apci {
-	/*FIXME: add it later*/
-} __packed;
-
-struct opregion_swsci {
-	/*FIXME: add it later*/
-} __packed;
-
-struct opregion_acpi {
-	/*FIXME: add it later*/
-} __packed;
-
-int intel_opregion_init(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	u32 opregion_phy;
-	void *base;
-	u32 *lid_state;
-
-	dev_priv->lid_state = NULL;
-
-	pci_read_config_dword(dev->pdev, 0xfc, &opregion_phy);
-	if (opregion_phy == 0)
-		return -ENOTSUPP;
-
-	base = ioremap(opregion_phy, 8*1024);
-	if (!base)
-		return -ENOMEM;
-
-	lid_state = base + 0x01ac;
-
-	dev_priv->lid_state = lid_state;
-	dev_priv->lid_last_state = readl(lid_state);
-	return 0;
-}
-
-int intel_opregion_exit(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	if (dev_priv->lid_state)
-		iounmap(dev_priv->lid_state);
-	return 0;
-}
-	
\ No newline at end of file

