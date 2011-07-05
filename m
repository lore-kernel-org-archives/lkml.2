Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1GEOwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:52:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50591 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1GEOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:52:52 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 40/49] gma500: move the i2c code
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:43:07 +0100
Message-ID: <20110705144303.23872.63842.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This again is similar to upstream so give it a sensible name ready to look
at any merging or synchronization

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile        |    2 
 drivers/staging/gma500/intel_i2c.c     |  169 ++++++++++++++++++++++++++++++++
 drivers/staging/gma500/psb_intel_i2c.c |  169 --------------------------------
 3 files changed, 170 insertions(+), 170 deletions(-)
 create mode 100644 drivers/staging/gma500/intel_i2c.c
 delete mode 100644 drivers/staging/gma500/psb_intel_i2c.c

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index d4a87c0..961a60c 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -10,12 +10,12 @@ psb_gfx-y += gem_glue.o \
 	  gem.o \
 	  gtt.o \
 	  intel_bios.o \
+	  intel_i2c.o \
 	  intel_opregion.o \
 	  mmu.o \
 	  power.o \
 	  psb_drv.o \
 	  psb_intel_display.o \
-	  psb_intel_i2c.o \
 	  psb_intel_lvds.o \
 	  psb_intel_modes.o \
 	  psb_intel_sdvo.o \
diff --git a/drivers/staging/gma500/intel_i2c.c b/drivers/staging/gma500/intel_i2c.c
new file mode 100644
index 0000000..e33432d
--- /dev/null
+++ b/drivers/staging/gma500/intel_i2c.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright © 2006-2007 Intel Corporation
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
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+
+#include "psb_drv.h"
+#include "psb_intel_reg.h"
+
+/*
+ * Intel GPIO access functions
+ */
+
+#define I2C_RISEFALL_TIME 20
+
+static int get_clock(void *data)
+{
+	struct psb_intel_i2c_chan *chan = data;
+	struct drm_device *dev = chan->drm_dev;
+	u32 val;
+
+	val = REG_READ(chan->reg);
+	return (val & GPIO_CLOCK_VAL_IN) != 0;
+}
+
+static int get_data(void *data)
+{
+	struct psb_intel_i2c_chan *chan = data;
+	struct drm_device *dev = chan->drm_dev;
+	u32 val;
+
+	val = REG_READ(chan->reg);
+	return (val & GPIO_DATA_VAL_IN) != 0;
+}
+
+static void set_clock(void *data, int state_high)
+{
+	struct psb_intel_i2c_chan *chan = data;
+	struct drm_device *dev = chan->drm_dev;
+	u32 reserved = 0, clock_bits;
+
+	/* On most chips, these bits must be preserved in software. */
+	reserved =
+		    REG_READ(chan->reg) & (GPIO_DATA_PULLUP_DISABLE |
+					   GPIO_CLOCK_PULLUP_DISABLE);
+
+	if (state_high)
+		clock_bits = GPIO_CLOCK_DIR_IN | GPIO_CLOCK_DIR_MASK;
+	else
+		clock_bits = GPIO_CLOCK_DIR_OUT | GPIO_CLOCK_DIR_MASK |
+		    GPIO_CLOCK_VAL_MASK;
+	REG_WRITE(chan->reg, reserved | clock_bits);
+	udelay(I2C_RISEFALL_TIME);	/* wait for the line to change state */
+}
+
+static void set_data(void *data, int state_high)
+{
+	struct psb_intel_i2c_chan *chan = data;
+	struct drm_device *dev = chan->drm_dev;
+	u32 reserved = 0, data_bits;
+
+	/* On most chips, these bits must be preserved in software. */
+	reserved =
+		    REG_READ(chan->reg) & (GPIO_DATA_PULLUP_DISABLE |
+					   GPIO_CLOCK_PULLUP_DISABLE);
+
+	if (state_high)
+		data_bits = GPIO_DATA_DIR_IN | GPIO_DATA_DIR_MASK;
+	else
+		data_bits =
+		    GPIO_DATA_DIR_OUT | GPIO_DATA_DIR_MASK |
+		    GPIO_DATA_VAL_MASK;
+
+	REG_WRITE(chan->reg, reserved | data_bits);
+	udelay(I2C_RISEFALL_TIME);	/* wait for the line to change state */
+}
+
+/**
+ * psb_intel_i2c_create - instantiate an Intel i2c bus using the specified GPIO reg
+ * @dev: DRM device
+ * @output: driver specific output device
+ * @reg: GPIO reg to use
+ * @name: name for this bus
+ *
+ * Creates and registers a new i2c bus with the Linux i2c layer, for use
+ * in output probing and control (e.g. DDC or SDVO control functions).
+ *
+ * Possible values for @reg include:
+ *   %GPIOA
+ *   %GPIOB
+ *   %GPIOC
+ *   %GPIOD
+ *   %GPIOE
+ *   %GPIOF
+ *   %GPIOG
+ *   %GPIOH
+ * see PRM for details on how these different busses are used.
+ */
+struct psb_intel_i2c_chan *psb_intel_i2c_create(struct drm_device *dev,
+					const u32 reg, const char *name)
+{
+	struct psb_intel_i2c_chan *chan;
+
+	chan = kzalloc(sizeof(struct psb_intel_i2c_chan), GFP_KERNEL);
+	if (!chan)
+		goto out_free;
+
+	chan->drm_dev = dev;
+	chan->reg = reg;
+	snprintf(chan->adapter.name, I2C_NAME_SIZE, "intel drm %s", name);
+	chan->adapter.owner = THIS_MODULE;
+	chan->adapter.algo_data = &chan->algo;
+	chan->adapter.dev.parent = &dev->pdev->dev;
+	chan->algo.setsda = set_data;
+	chan->algo.setscl = set_clock;
+	chan->algo.getsda = get_data;
+	chan->algo.getscl = get_clock;
+	chan->algo.udelay = 20;
+	chan->algo.timeout = usecs_to_jiffies(2200);
+	chan->algo.data = chan;
+
+	i2c_set_adapdata(&chan->adapter, chan);
+
+	if (i2c_bit_add_bus(&chan->adapter))
+		goto out_free;
+
+	/* JJJ:  raise SCL and SDA? */
+	set_data(chan, 1);
+	set_clock(chan, 1);
+	udelay(20);
+
+	return chan;
+
+out_free:
+	kfree(chan);
+	return NULL;
+}
+
+/**
+ * psb_intel_i2c_destroy - unregister and free i2c bus resources
+ * @output: channel to free
+ *
+ * Unregister the adapter from the i2c layer, then free the structure.
+ */
+void psb_intel_i2c_destroy(struct psb_intel_i2c_chan *chan)
+{
+	if (!chan)
+		return;
+
+	i2c_del_adapter(&chan->adapter);
+	kfree(chan);
+}
diff --git a/drivers/staging/gma500/psb_intel_i2c.c b/drivers/staging/gma500/psb_intel_i2c.c
deleted file mode 100644
index e33432d..0000000
--- a/drivers/staging/gma500/psb_intel_i2c.c
+++ /dev/null
@@ -1,169 +0,0 @@
-/*
- * Copyright © 2006-2007 Intel Corporation
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
- * Authors:
- *	Eric Anholt <eric@anholt.net>
- */
-
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-
-#include "psb_drv.h"
-#include "psb_intel_reg.h"
-
-/*
- * Intel GPIO access functions
- */
-
-#define I2C_RISEFALL_TIME 20
-
-static int get_clock(void *data)
-{
-	struct psb_intel_i2c_chan *chan = data;
-	struct drm_device *dev = chan->drm_dev;
-	u32 val;
-
-	val = REG_READ(chan->reg);
-	return (val & GPIO_CLOCK_VAL_IN) != 0;
-}
-
-static int get_data(void *data)
-{
-	struct psb_intel_i2c_chan *chan = data;
-	struct drm_device *dev = chan->drm_dev;
-	u32 val;
-
-	val = REG_READ(chan->reg);
-	return (val & GPIO_DATA_VAL_IN) != 0;
-}
-
-static void set_clock(void *data, int state_high)
-{
-	struct psb_intel_i2c_chan *chan = data;
-	struct drm_device *dev = chan->drm_dev;
-	u32 reserved = 0, clock_bits;
-
-	/* On most chips, these bits must be preserved in software. */
-	reserved =
-		    REG_READ(chan->reg) & (GPIO_DATA_PULLUP_DISABLE |
-					   GPIO_CLOCK_PULLUP_DISABLE);
-
-	if (state_high)
-		clock_bits = GPIO_CLOCK_DIR_IN | GPIO_CLOCK_DIR_MASK;
-	else
-		clock_bits = GPIO_CLOCK_DIR_OUT | GPIO_CLOCK_DIR_MASK |
-		    GPIO_CLOCK_VAL_MASK;
-	REG_WRITE(chan->reg, reserved | clock_bits);
-	udelay(I2C_RISEFALL_TIME);	/* wait for the line to change state */
-}
-
-static void set_data(void *data, int state_high)
-{
-	struct psb_intel_i2c_chan *chan = data;
-	struct drm_device *dev = chan->drm_dev;
-	u32 reserved = 0, data_bits;
-
-	/* On most chips, these bits must be preserved in software. */
-	reserved =
-		    REG_READ(chan->reg) & (GPIO_DATA_PULLUP_DISABLE |
-					   GPIO_CLOCK_PULLUP_DISABLE);
-
-	if (state_high)
-		data_bits = GPIO_DATA_DIR_IN | GPIO_DATA_DIR_MASK;
-	else
-		data_bits =
-		    GPIO_DATA_DIR_OUT | GPIO_DATA_DIR_MASK |
-		    GPIO_DATA_VAL_MASK;
-
-	REG_WRITE(chan->reg, reserved | data_bits);
-	udelay(I2C_RISEFALL_TIME);	/* wait for the line to change state */
-}
-
-/**
- * psb_intel_i2c_create - instantiate an Intel i2c bus using the specified GPIO reg
- * @dev: DRM device
- * @output: driver specific output device
- * @reg: GPIO reg to use
- * @name: name for this bus
- *
- * Creates and registers a new i2c bus with the Linux i2c layer, for use
- * in output probing and control (e.g. DDC or SDVO control functions).
- *
- * Possible values for @reg include:
- *   %GPIOA
- *   %GPIOB
- *   %GPIOC
- *   %GPIOD
- *   %GPIOE
- *   %GPIOF
- *   %GPIOG
- *   %GPIOH
- * see PRM for details on how these different busses are used.
- */
-struct psb_intel_i2c_chan *psb_intel_i2c_create(struct drm_device *dev,
-					const u32 reg, const char *name)
-{
-	struct psb_intel_i2c_chan *chan;
-
-	chan = kzalloc(sizeof(struct psb_intel_i2c_chan), GFP_KERNEL);
-	if (!chan)
-		goto out_free;
-
-	chan->drm_dev = dev;
-	chan->reg = reg;
-	snprintf(chan->adapter.name, I2C_NAME_SIZE, "intel drm %s", name);
-	chan->adapter.owner = THIS_MODULE;
-	chan->adapter.algo_data = &chan->algo;
-	chan->adapter.dev.parent = &dev->pdev->dev;
-	chan->algo.setsda = set_data;
-	chan->algo.setscl = set_clock;
-	chan->algo.getsda = get_data;
-	chan->algo.getscl = get_clock;
-	chan->algo.udelay = 20;
-	chan->algo.timeout = usecs_to_jiffies(2200);
-	chan->algo.data = chan;
-
-	i2c_set_adapdata(&chan->adapter, chan);
-
-	if (i2c_bit_add_bus(&chan->adapter))
-		goto out_free;
-
-	/* JJJ:  raise SCL and SDA? */
-	set_data(chan, 1);
-	set_clock(chan, 1);
-	udelay(20);
-
-	return chan;
-
-out_free:
-	kfree(chan);
-	return NULL;
-}
-
-/**
- * psb_intel_i2c_destroy - unregister and free i2c bus resources
- * @output: channel to free
- *
- * Unregister the adapter from the i2c layer, then free the structure.
- */
-void psb_intel_i2c_destroy(struct psb_intel_i2c_chan *chan)
-{
-	if (!chan)
-		return;
-
-	i2c_del_adapter(&chan->adapter);
-	kfree(chan);
-}

