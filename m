Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab1DASHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:07:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44182 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755194Ab1DASHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:07:01 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 9/9] gma500: psb_reset actually holds lid functions
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 18:44:16 +0100
Message-ID: <20110401174252.18112.40323.stgit@localhost.localdomain>
In-Reply-To: <20110401173554.18112.67483.stgit@localhost.localdomain>
References: <20110401173554.18112.67483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So rename the file something sensible

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile    |    2 -
 drivers/staging/gma500/psb_lid.c   |   90 ++++++++++++++++++++++++++++++++++++
 drivers/staging/gma500/psb_reset.c |   90 ------------------------------------
 3 files changed, 91 insertions(+), 91 deletions(-)
 create mode 100644 drivers/staging/gma500/psb_lid.c
 delete mode 100644 drivers/staging/gma500/psb_reset.c

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 4d7aabe..e00557e 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -15,7 +15,7 @@ psb_gfx-y += psb_bl.o \
 	  psb_intel_lvds.o \
 	  psb_intel_modes.o \
 	  psb_intel_sdvo.o \
-	  psb_reset.o \
+	  psb_lid.o \
 	  psb_pvr_glue.o \
 	  psb_mmu.o \
 	  psb_powermgmt.o \
diff --git a/drivers/staging/gma500/psb_lid.c b/drivers/staging/gma500/psb_lid.c
new file mode 100644
index 0000000..21fd202
--- /dev/null
+++ b/drivers/staging/gma500/psb_lid.c
@@ -0,0 +1,90 @@
+/**************************************************************************
+ * Copyright (c) 2007, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ **************************************************************************/
+
+#include <drm/drmP.h>
+#include "psb_drv.h"
+#include "psb_reg.h"
+#include "psb_intel_reg.h"
+#include <linux/spinlock.h>
+
+static void psb_lid_timer_func(unsigned long data)
+{
+	struct drm_psb_private * dev_priv = (struct drm_psb_private *)data;
+	struct drm_device *dev = (struct drm_device *)dev_priv->dev;
+	struct timer_list *lid_timer = &dev_priv->lid_timer;
+	unsigned long irq_flags;
+	u32 *lid_state = dev_priv->lid_state;
+	u32 pp_status;
+
+	if (*lid_state == dev_priv->lid_last_state)
+		goto lid_timer_schedule;
+
+	if ((*lid_state) & 0x01) {
+		/*lid state is open*/
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) | POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while ((pp_status & PP_ON) == 0);
+
+		/*FIXME: should be backlight level before*/
+		psb_intel_lvds_set_brightness(dev, 100);
+	} else {
+		psb_intel_lvds_set_brightness(dev, 0);
+
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) & ~POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while ((pp_status & PP_ON) == 0);
+	}
+		/* printk(KERN_INFO"%s: lid: closed\n", __FUNCTION__); */
+
+	dev_priv->lid_last_state =  *lid_state;
+
+lid_timer_schedule:
+	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);
+	if (!timer_pending(lid_timer)) {
+		lid_timer->expires = jiffies + PSB_LID_DELAY;
+		add_timer(lid_timer);
+	}
+	spin_unlock_irqrestore(&dev_priv->lid_lock, irq_flags);
+}
+
+void psb_lid_timer_init(struct drm_psb_private *dev_priv)
+{
+	struct timer_list *lid_timer = &dev_priv->lid_timer;
+	unsigned long irq_flags;
+
+	spin_lock_init(&dev_priv->lid_lock);
+	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);
+
+	init_timer(lid_timer);
+
+	lid_timer->data = (unsigned long)dev_priv;
+	lid_timer->function = psb_lid_timer_func;
+	lid_timer->expires = jiffies + PSB_LID_DELAY;
+
+	add_timer(lid_timer);
+	spin_unlock_irqrestore(&dev_priv->lid_lock, irq_flags);
+}
+
+void psb_lid_timer_takedown(struct drm_psb_private *dev_priv)
+{
+	del_timer_sync(&dev_priv->lid_timer);
+}
+
diff --git a/drivers/staging/gma500/psb_reset.c b/drivers/staging/gma500/psb_reset.c
deleted file mode 100644
index 21fd202..0000000
--- a/drivers/staging/gma500/psb_reset.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/**************************************************************************
- * Copyright (c) 2007, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
- **************************************************************************/
-
-#include <drm/drmP.h>
-#include "psb_drv.h"
-#include "psb_reg.h"
-#include "psb_intel_reg.h"
-#include <linux/spinlock.h>
-
-static void psb_lid_timer_func(unsigned long data)
-{
-	struct drm_psb_private * dev_priv = (struct drm_psb_private *)data;
-	struct drm_device *dev = (struct drm_device *)dev_priv->dev;
-	struct timer_list *lid_timer = &dev_priv->lid_timer;
-	unsigned long irq_flags;
-	u32 *lid_state = dev_priv->lid_state;
-	u32 pp_status;
-
-	if (*lid_state == dev_priv->lid_last_state)
-		goto lid_timer_schedule;
-
-	if ((*lid_state) & 0x01) {
-		/*lid state is open*/
-		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) | POWER_TARGET_ON);
-		do {
-			pp_status = REG_READ(PP_STATUS);
-		} while ((pp_status & PP_ON) == 0);
-
-		/*FIXME: should be backlight level before*/
-		psb_intel_lvds_set_brightness(dev, 100);
-	} else {
-		psb_intel_lvds_set_brightness(dev, 0);
-
-		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) & ~POWER_TARGET_ON);
-		do {
-			pp_status = REG_READ(PP_STATUS);
-		} while ((pp_status & PP_ON) == 0);
-	}
-		/* printk(KERN_INFO"%s: lid: closed\n", __FUNCTION__); */
-
-	dev_priv->lid_last_state =  *lid_state;
-
-lid_timer_schedule:
-	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);
-	if (!timer_pending(lid_timer)) {
-		lid_timer->expires = jiffies + PSB_LID_DELAY;
-		add_timer(lid_timer);
-	}
-	spin_unlock_irqrestore(&dev_priv->lid_lock, irq_flags);
-}
-
-void psb_lid_timer_init(struct drm_psb_private *dev_priv)
-{
-	struct timer_list *lid_timer = &dev_priv->lid_timer;
-	unsigned long irq_flags;
-
-	spin_lock_init(&dev_priv->lid_lock);
-	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);
-
-	init_timer(lid_timer);
-
-	lid_timer->data = (unsigned long)dev_priv;
-	lid_timer->function = psb_lid_timer_func;
-	lid_timer->expires = jiffies + PSB_LID_DELAY;
-
-	add_timer(lid_timer);
-	spin_unlock_irqrestore(&dev_priv->lid_lock, irq_flags);
-}
-
-void psb_lid_timer_takedown(struct drm_psb_private *dev_priv)
-{
-	del_timer_sync(&dev_priv->lid_timer);
-}
-

