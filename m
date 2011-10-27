Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1J0WCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:02:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56876 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab1J0WCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:02:49 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=205/9=5D=20gma500=3A=20Add=20support=20for=20Intel=20GMBUS?=
Date: Fri, 28 Oct 2011 00:02:10 +0200
Message-Id: <1319752934-1919-6-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we integrate the new SDVO code we need GMBUS support

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/staging/gma500/Makefile        |    1 +
 drivers/staging/gma500/intel_gmbus.c   |  492 ++++++++++++++++++++++++++++++++
 drivers/staging/gma500/psb_device.c    |    7 +
 drivers/staging/gma500/psb_drv.h       |    9 +
 drivers/staging/gma500/psb_intel_drv.h |    7 +
 drivers/staging/gma500/psb_intel_reg.h |   72 +++++
 6 files changed, 588 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/gma500/intel_gmbus.c

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index c729868..fb740ed 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -11,6 +11,7 @@ psb_gfx-y += gem_glue.o \
 	  gtt.o \
 	  intel_bios.o \
 	  intel_i2c.o \
+	  intel_gmbus.o \
 	  intel_opregion.o \
 	  mmu.o \
 	  power.o \
diff --git a/drivers/staging/gma500/intel_gmbus.c b/drivers/staging/gma500/intel_gmbus.c
new file mode 100644
index 0000000..5c2b5a8
--- /dev/null
+++ b/drivers/staging/gma500/intel_gmbus.c
@@ -0,0 +1,492 @@
+/*
+ * Copyright (c) 2006 Dave Airlie <airlied@linux.ie>
+ * Copyright © 2006-2008,2010 Intel Corporation
+ *   Jesse Barnes <jesse.barnes@intel.com>
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
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ *	Chris Wilson <chris@chris-wilson.co.uk>
+ */
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+#include "drmP.h"
+#include "drm.h"
+#include "psb_intel_drv.h"
+#include "psb_drm.h"
+#include "psb_drv.h"
+#include "psb_intel_reg.h"
+
+#define _wait_for(COND, MS, W) ({ \
+	unsigned long timeout__ = jiffies + msecs_to_jiffies(MS);	\
+	int ret__ = 0;							\
+	while (! (COND)) {						\
+		if (time_after(jiffies, timeout__)) {			\
+			ret__ = -ETIMEDOUT;				\
+			break;						\
+		}							\
+		if (W && !(in_atomic() || in_dbg_master())) msleep(W);	\
+	}								\
+	ret__;								\
+})
+
+#define wait_for(COND, MS) _wait_for(COND, MS, 1)
+#define wait_for_atomic(COND, MS) _wait_for(COND, MS, 0)
+
+/* Intel GPIO access functions */
+
+#define I2C_RISEFALL_TIME 20
+
+static inline struct intel_gmbus *
+to_intel_gmbus(struct i2c_adapter *i2c)
+{
+	return container_of(i2c, struct intel_gmbus, adapter);
+}
+
+struct intel_gpio {
+	struct i2c_adapter adapter;
+	struct i2c_algo_bit_data algo;
+	struct drm_psb_private *dev_priv;
+	u32 reg;
+};
+
+void
+gma_intel_i2c_reset(struct drm_device *dev)
+{
+	REG_WRITE(GMBUS0, 0);
+}
+
+static void intel_i2c_quirk_set(struct drm_psb_private *dev_priv, bool enable)
+{
+	/* When using bit bashing for I2C, this bit needs to be set to 1 */
+	/* FIXME: We are never Pineview, right?
+
+	u32 val;
+
+	if (!IS_PINEVIEW(dev_priv->dev))
+		return;
+
+	val = REG_READ(DSPCLK_GATE_D);
+	if (enable)
+		val |= DPCUNIT_CLOCK_GATE_DISABLE;
+	else
+		val &= ~DPCUNIT_CLOCK_GATE_DISABLE;
+	REG_WRITE(DSPCLK_GATE_D, val);
+
+	return;
+	*/
+}
+
+static u32 get_reserved(struct intel_gpio *gpio)
+{
+	struct drm_psb_private *dev_priv = gpio->dev_priv;
+	struct drm_device *dev = dev_priv->dev;
+	u32 reserved = 0;
+
+	/* On most chips, these bits must be preserved in software. */
+	reserved = REG_READ(gpio->reg) &
+				     (GPIO_DATA_PULLUP_DISABLE |
+				      GPIO_CLOCK_PULLUP_DISABLE);
+
+	return reserved;
+}
+
+static int get_clock(void *data)
+{
+	struct intel_gpio *gpio = data;
+	struct drm_psb_private *dev_priv = gpio->dev_priv;
+	struct drm_device *dev = dev_priv->dev;
+	u32 reserved = get_reserved(gpio);
+	REG_WRITE(gpio->reg, reserved | GPIO_CLOCK_DIR_MASK);
+	REG_WRITE(gpio->reg, reserved);
+	return (REG_READ(gpio->reg) & GPIO_CLOCK_VAL_IN) != 0;
+}
+
+static int get_data(void *data)
+{
+	struct intel_gpio *gpio = data;
+	struct drm_psb_private *dev_priv = gpio->dev_priv;
+	struct drm_device *dev = dev_priv->dev;
+	u32 reserved = get_reserved(gpio);
+	REG_WRITE(gpio->reg, reserved | GPIO_DATA_DIR_MASK);
+	REG_WRITE(gpio->reg, reserved);
+	return (REG_READ(gpio->reg) & GPIO_DATA_VAL_IN) != 0;
+}
+
+static void set_clock(void *data, int state_high)
+{
+	struct intel_gpio *gpio = data;
+	struct drm_psb_private *dev_priv = gpio->dev_priv;
+	struct drm_device *dev = dev_priv->dev;
+	u32 reserved = get_reserved(gpio);
+	u32 clock_bits;
+
+	if (state_high)
+		clock_bits = GPIO_CLOCK_DIR_IN | GPIO_CLOCK_DIR_MASK;
+	else
+		clock_bits = GPIO_CLOCK_DIR_OUT | GPIO_CLOCK_DIR_MASK |
+			GPIO_CLOCK_VAL_MASK;
+
+	REG_WRITE(gpio->reg, reserved | clock_bits);
+	REG_READ(gpio->reg); /* Posting */
+}
+
+static void set_data(void *data, int state_high)
+{
+	struct intel_gpio *gpio = data;
+	struct drm_psb_private *dev_priv = gpio->dev_priv;
+	struct drm_device *dev = dev_priv->dev;
+	u32 reserved = get_reserved(gpio);
+	u32 data_bits;
+
+	if (state_high)
+		data_bits = GPIO_DATA_DIR_IN | GPIO_DATA_DIR_MASK;
+	else
+		data_bits = GPIO_DATA_DIR_OUT | GPIO_DATA_DIR_MASK |
+			GPIO_DATA_VAL_MASK;
+
+	REG_WRITE(gpio->reg, reserved | data_bits);
+	REG_READ(gpio->reg);
+}
+
+static struct i2c_adapter *
+intel_gpio_create(struct drm_psb_private *dev_priv, u32 pin)
+{
+	static const int map_pin_to_reg[] = {
+		0,
+		GPIOB,
+		GPIOA,
+		GPIOC,
+		GPIOD,
+		GPIOE,
+		0,
+		GPIOF,
+	};
+	struct intel_gpio *gpio;
+
+	if (pin >= ARRAY_SIZE(map_pin_to_reg) || !map_pin_to_reg[pin])
+		return NULL;
+
+	gpio = kzalloc(sizeof(struct intel_gpio), GFP_KERNEL);
+	if (gpio == NULL)
+		return NULL;
+
+	gpio->reg = map_pin_to_reg[pin];
+	gpio->dev_priv = dev_priv;
+
+	snprintf(gpio->adapter.name, sizeof(gpio->adapter.name),
+		 "i915 GPIO%c", "?BACDE?F"[pin]);
+	gpio->adapter.owner = THIS_MODULE;
+	gpio->adapter.algo_data	= &gpio->algo;
+	gpio->adapter.dev.parent = &dev_priv->dev->pdev->dev;
+	gpio->algo.setsda = set_data;
+	gpio->algo.setscl = set_clock;
+	gpio->algo.getsda = get_data;
+	gpio->algo.getscl = get_clock;
+	gpio->algo.udelay = I2C_RISEFALL_TIME;
+	gpio->algo.timeout = usecs_to_jiffies(2200);
+	gpio->algo.data = gpio;
+
+	if (i2c_bit_add_bus(&gpio->adapter))
+		goto out_free;
+
+	return &gpio->adapter;
+
+out_free:
+	kfree(gpio);
+	return NULL;
+}
+
+static int
+intel_i2c_quirk_xfer(struct drm_psb_private *dev_priv,
+		     struct i2c_adapter *adapter,
+		     struct i2c_msg *msgs,
+		     int num)
+{
+	struct intel_gpio *gpio = container_of(adapter,
+					       struct intel_gpio,
+					       adapter);
+	int ret;
+
+	gma_intel_i2c_reset(dev_priv->dev);
+
+	intel_i2c_quirk_set(dev_priv, true);
+	set_data(gpio, 1);
+	set_clock(gpio, 1);
+	udelay(I2C_RISEFALL_TIME);
+
+	ret = adapter->algo->master_xfer(adapter, msgs, num);
+
+	set_data(gpio, 1);
+	set_clock(gpio, 1);
+	intel_i2c_quirk_set(dev_priv, false);
+
+	return ret;
+}
+
+static int
+gmbus_xfer(struct i2c_adapter *adapter,
+	   struct i2c_msg *msgs,
+	   int num)
+{
+	struct intel_gmbus *bus = container_of(adapter,
+					       struct intel_gmbus,
+					       adapter);
+	struct drm_psb_private *dev_priv = adapter->algo_data;
+	struct drm_device *dev = dev_priv->dev;
+	int i, reg_offset;
+
+	if (bus->force_bit)
+		return intel_i2c_quirk_xfer(dev_priv,
+					    bus->force_bit, msgs, num);
+
+	reg_offset = 0;
+
+	REG_WRITE(GMBUS0 + reg_offset, bus->reg0);
+
+	for (i = 0; i < num; i++) {
+		u16 len = msgs[i].len;
+		u8 *buf = msgs[i].buf;
+
+		if (msgs[i].flags & I2C_M_RD) {
+			REG_WRITE(GMBUS1 + reg_offset,
+				   GMBUS_CYCLE_WAIT | (i + 1 == num ? GMBUS_CYCLE_STOP : 0) |
+				   (len << GMBUS_BYTE_COUNT_SHIFT) |
+				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
+				   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
+			REG_READ(GMBUS2+reg_offset);
+			do {
+				u32 val, loop = 0;
+
+				if (wait_for(REG_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_RDY), 50))
+					goto timeout;
+				if (REG_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+					goto clear_err;
+
+				val = REG_READ(GMBUS3 + reg_offset);
+				do {
+					*buf++ = val & 0xff;
+					val >>= 8;
+				} while (--len && ++loop < 4);
+			} while (len);
+		} else {
+			u32 val, loop;
+
+			val = loop = 0;
+			do {
+				val |= *buf++ << (8 * loop);
+			} while (--len && ++loop < 4);
+
+			REG_WRITE(GMBUS3 + reg_offset, val);
+			REG_WRITE(GMBUS1 + reg_offset,
+				   (i + 1 == num ? GMBUS_CYCLE_STOP : GMBUS_CYCLE_WAIT) |
+				   (msgs[i].len << GMBUS_BYTE_COUNT_SHIFT) |
+				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
+				   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
+			REG_READ(GMBUS2+reg_offset);
+
+			while (len) {
+				if (wait_for(REG_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_RDY), 50))
+					goto timeout;
+				if (REG_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+					goto clear_err;
+
+				val = loop = 0;
+				do {
+					val |= *buf++ << (8 * loop);
+				} while (--len && ++loop < 4);
+
+				REG_WRITE(GMBUS3 + reg_offset, val);
+				REG_READ(GMBUS2+reg_offset);
+			}
+		}
+
+		if (i + 1 < num && wait_for(REG_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE), 50))
+			goto timeout;
+		if (REG_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+			goto clear_err;
+	}
+
+	goto done;
+
+clear_err:
+	/* Toggle the Software Clear Interrupt bit. This has the effect
+	 * of resetting the GMBUS controller and so clearing the
+	 * BUS_ERROR raised by the slave's NAK.
+	 */
+	REG_WRITE(GMBUS1 + reg_offset, GMBUS_SW_CLR_INT);
+	REG_WRITE(GMBUS1 + reg_offset, 0);
+
+done:
+	/* Mark the GMBUS interface as disabled. We will re-enable it at the
+	 * start of the next xfer, till then let it sleep.
+	 */
+	REG_WRITE(GMBUS0 + reg_offset, 0);
+	return i;
+
+timeout:
+	DRM_INFO("GMBUS timed out, falling back to bit banging on pin %d [%s]\n",
+		 bus->reg0 & 0xff, bus->adapter.name);
+	REG_WRITE(GMBUS0 + reg_offset, 0);
+
+	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
+	bus->force_bit = intel_gpio_create(dev_priv, bus->reg0 & 0xff);
+	if (!bus->force_bit)
+		return -ENOMEM;
+
+	return intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs, num);
+}
+
+static u32 gmbus_func(struct i2c_adapter *adapter)
+{
+	struct intel_gmbus *bus = container_of(adapter,
+					       struct intel_gmbus,
+					       adapter);
+
+	if (bus->force_bit)
+		bus->force_bit->algo->functionality(bus->force_bit);
+
+	return (I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL |
+		/* I2C_FUNC_10BIT_ADDR | */
+		I2C_FUNC_SMBUS_READ_BLOCK_DATA |
+		I2C_FUNC_SMBUS_BLOCK_PROC_CALL);
+}
+
+static const struct i2c_algorithm gmbus_algorithm = {
+	.master_xfer	= gmbus_xfer,
+	.functionality	= gmbus_func
+};
+
+/**
+ * intel_gmbus_setup - instantiate all Intel i2c GMBuses
+ * @dev: DRM device
+ */
+int gma_intel_setup_gmbus(struct drm_device *dev)
+{
+	static const char *names[GMBUS_NUM_PORTS] = {
+		"disabled",
+		"ssc",
+		"vga",
+		"panel",
+		"dpc",
+		"dpb",
+		"reserved",
+		"dpd",
+	};
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int ret, i;
+
+	dev_priv->gmbus = kcalloc(sizeof(struct intel_gmbus), GMBUS_NUM_PORTS,
+				  GFP_KERNEL);
+	if (dev_priv->gmbus == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
+		struct intel_gmbus *bus = &dev_priv->gmbus[i];
+
+		bus->adapter.owner = THIS_MODULE;
+		bus->adapter.class = I2C_CLASS_DDC;
+		snprintf(bus->adapter.name,
+			 sizeof(bus->adapter.name),
+			 "i915 gmbus %s",
+			 names[i]);
+
+		bus->adapter.dev.parent = &dev->pdev->dev;
+		bus->adapter.algo_data	= dev_priv;
+
+		bus->adapter.algo = &gmbus_algorithm;
+		ret = i2c_add_adapter(&bus->adapter);
+		if (ret)
+			goto err;
+
+		/* By default use a conservative clock rate */
+		bus->reg0 = i | GMBUS_RATE_100KHZ;
+
+		/* XXX force bit banging until GMBUS is fully debugged */
+		bus->force_bit = intel_gpio_create(dev_priv, i);
+	}
+
+	gma_intel_i2c_reset(dev_priv->dev);
+
+	return 0;
+
+err:
+	while (--i) {
+		struct intel_gmbus *bus = &dev_priv->gmbus[i];
+		i2c_del_adapter(&bus->adapter);
+	}
+	kfree(dev_priv->gmbus);
+	dev_priv->gmbus = NULL;
+	return ret;
+}
+
+void gma_intel_gmbus_set_speed(struct i2c_adapter *adapter, int speed)
+{
+	struct intel_gmbus *bus = to_intel_gmbus(adapter);
+
+	/* speed:
+	 * 0x0 = 100 KHz
+	 * 0x1 = 50 KHz
+	 * 0x2 = 400 KHz
+	 * 0x3 = 1000 Khz
+	 */
+	bus->reg0 = (bus->reg0 & ~(0x3 << 8)) | (speed << 8);
+}
+
+void gma_intel_gmbus_force_bit(struct i2c_adapter *adapter, bool force_bit)
+{
+	struct intel_gmbus *bus = to_intel_gmbus(adapter);
+
+	if (force_bit) {
+		if (bus->force_bit == NULL) {
+			struct drm_psb_private *dev_priv = adapter->algo_data;
+			bus->force_bit = intel_gpio_create(dev_priv,
+							   bus->reg0 & 0xff);
+		}
+	} else {
+		if (bus->force_bit) {
+			i2c_del_adapter(bus->force_bit);
+			kfree(bus->force_bit);
+			bus->force_bit = NULL;
+		}
+	}
+}
+
+void gma_intel_teardown_gmbus(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int i;
+
+	if (dev_priv->gmbus == NULL)
+		return;
+
+	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
+		struct intel_gmbus *bus = &dev_priv->gmbus[i];
+		if (bus->force_bit) {
+			i2c_del_adapter(bus->force_bit);
+			kfree(bus->force_bit);
+		}
+		i2c_del_adapter(&bus->adapter);
+	}
+
+	kfree(dev_priv->gmbus);
+	dev_priv->gmbus = NULL;
+}
diff --git a/drivers/staging/gma500/psb_device.c b/drivers/staging/gma500/psb_device.c
index b97aa78..d1bc55b 100644
--- a/drivers/staging/gma500/psb_device.c
+++ b/drivers/staging/gma500/psb_device.c
@@ -290,11 +290,17 @@ static void psb_get_core_freq(struct drm_device *dev)
 static int psb_chip_setup(struct drm_device *dev)
 {
 	psb_get_core_freq(dev);
+	gma_intel_setup_gmbus(dev);
 	gma_intel_opregion_init(dev);
 	psb_intel_init_bios(dev);
 	return 0;
 }
 
+static void psb_chip_teardown(struct drm_device *dev)
+{
+	gma_intel_teardown_gmbus(dev);
+}
+
 const struct psb_ops psb_chip_ops = {
 	.name = "Poulsbo",
 	.accel_2d = 1,
@@ -302,6 +308,7 @@ const struct psb_ops psb_chip_ops = {
 	.crtcs = 2,
 	.sgx_offset = PSB_SGX_OFFSET,
 	.chip_setup = psb_chip_setup,
+	.chip_teardown = psb_chip_teardown,
 
 	.crtc_helper = &psb_intel_helper_funcs,
 	.crtc_funcs = &psb_intel_crtc_funcs,
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 9cbb494..cf078db 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -261,6 +261,12 @@ struct psb_intel_opregion {
 	int enabled;
 };
 
+struct intel_gmbus {
+	struct i2c_adapter adapter;
+	struct i2c_adapter *force_bit;
+	u32 reg0;
+};
+
 struct psb_ops;
 
 struct drm_psb_private {
@@ -337,6 +343,9 @@ struct drm_psb_private {
 	/* PCI revision ID for B0:D2:F0 */
 	uint8_t platform_rev_id;
 
+	/* gmbus */
+	struct intel_gmbus *gmbus;
+
 	/*
 	 * LVDS info
 	 */
diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
index 0e45ba8..492add1 100644
--- a/drivers/staging/gma500/psb_intel_drv.h
+++ b/drivers/staging/gma500/psb_intel_drv.h
@@ -238,4 +238,11 @@ extern const struct drm_encoder_funcs psb_intel_lvds_enc_funcs;
 extern void mdfldWaitForPipeDisable(struct drm_device *dev, int pipe);
 extern void mdfldWaitForPipeEnable(struct drm_device *dev, int pipe);
 
+/* intel_gmbus.c */
+extern void gma_intel_i2c_reset(struct drm_device *dev);
+extern int gma_intel_setup_gmbus(struct drm_device *dev);
+extern void gma_intel_gmbus_set_speed(struct i2c_adapter *adapter, int speed);
+extern void gma_intel_gmbus_force_bit(struct i2c_adapter *adapter, bool force_bit);
+extern void gma_intel_teardown_gmbus(struct drm_device *dev);
+
 #endif				/* __INTEL_DRV_H__ */
diff --git a/drivers/staging/gma500/psb_intel_reg.h b/drivers/staging/gma500/psb_intel_reg.h
index 1ac16aa..f5c19f5 100644
--- a/drivers/staging/gma500/psb_intel_reg.h
+++ b/drivers/staging/gma500/psb_intel_reg.h
@@ -17,6 +17,78 @@
 #ifndef __PSB_INTEL_REG_H__
 #define __PSB_INTEL_REG_H__
 
+/*
+ * GPIO regs
+ */
+#define GPIOA			0x5010
+#define GPIOB			0x5014
+#define GPIOC			0x5018
+#define GPIOD			0x501c
+#define GPIOE			0x5020
+#define GPIOF			0x5024
+#define GPIOG			0x5028
+#define GPIOH			0x502c
+# define GPIO_CLOCK_DIR_MASK		(1 << 0)
+# define GPIO_CLOCK_DIR_IN		(0 << 1)
+# define GPIO_CLOCK_DIR_OUT		(1 << 1)
+# define GPIO_CLOCK_VAL_MASK		(1 << 2)
+# define GPIO_CLOCK_VAL_OUT		(1 << 3)
+# define GPIO_CLOCK_VAL_IN		(1 << 4)
+# define GPIO_CLOCK_PULLUP_DISABLE	(1 << 5)
+# define GPIO_DATA_DIR_MASK		(1 << 8)
+# define GPIO_DATA_DIR_IN		(0 << 9)
+# define GPIO_DATA_DIR_OUT		(1 << 9)
+# define GPIO_DATA_VAL_MASK		(1 << 10)
+# define GPIO_DATA_VAL_OUT		(1 << 11)
+# define GPIO_DATA_VAL_IN		(1 << 12)
+# define GPIO_DATA_PULLUP_DISABLE	(1 << 13)
+
+#define GMBUS0			0x5100 /* clock/port select */
+#define   GMBUS_RATE_100KHZ	(0<<8)
+#define   GMBUS_RATE_50KHZ	(1<<8)
+#define   GMBUS_RATE_400KHZ	(2<<8) /* reserved on Pineview */
+#define   GMBUS_RATE_1MHZ	(3<<8) /* reserved on Pineview */
+#define   GMBUS_HOLD_EXT	(1<<7) /* 300ns hold time, rsvd on Pineview */
+#define   GMBUS_PORT_DISABLED	0
+#define   GMBUS_PORT_SSC	1
+#define   GMBUS_PORT_VGADDC	2
+#define   GMBUS_PORT_PANEL	3
+#define   GMBUS_PORT_DPC	4 /* HDMIC */
+#define   GMBUS_PORT_DPB	5 /* SDVO, HDMIB */
+				  /* 6 reserved */
+#define   GMBUS_PORT_DPD	7 /* HDMID */
+#define   GMBUS_NUM_PORTS       8
+#define GMBUS1			0x5104 /* command/status */
+#define   GMBUS_SW_CLR_INT	(1<<31)
+#define   GMBUS_SW_RDY		(1<<30)
+#define   GMBUS_ENT		(1<<29) /* enable timeout */
+#define   GMBUS_CYCLE_NONE	(0<<25)
+#define   GMBUS_CYCLE_WAIT	(1<<25)
+#define   GMBUS_CYCLE_INDEX	(2<<25)
+#define   GMBUS_CYCLE_STOP	(4<<25)
+#define   GMBUS_BYTE_COUNT_SHIFT 16
+#define   GMBUS_SLAVE_INDEX_SHIFT 8
+#define   GMBUS_SLAVE_ADDR_SHIFT 1
+#define   GMBUS_SLAVE_READ	(1<<0)
+#define   GMBUS_SLAVE_WRITE	(0<<0)
+#define GMBUS2			0x5108 /* status */
+#define   GMBUS_INUSE		(1<<15)
+#define   GMBUS_HW_WAIT_PHASE	(1<<14)
+#define   GMBUS_STALL_TIMEOUT	(1<<13)
+#define   GMBUS_INT		(1<<12)
+#define   GMBUS_HW_RDY		(1<<11)
+#define   GMBUS_SATOER		(1<<10)
+#define   GMBUS_ACTIVE		(1<<9)
+#define GMBUS3			0x510c /* data buffer bytes 3-0 */
+#define GMBUS4			0x5110 /* interrupt mask (Pineview+) */
+#define   GMBUS_SLAVE_TIMEOUT_EN (1<<4)
+#define   GMBUS_NAK_EN		(1<<3)
+#define   GMBUS_IDLE_EN		(1<<2)
+#define   GMBUS_HW_WAIT_EN	(1<<1)
+#define   GMBUS_HW_RDY_EN	(1<<0)
+#define GMBUS5			0x5120 /* byte index */
+#define   GMBUS_2BYTE_INDEX_EN	(1<<31)
+
 #define BLC_PWM_CTL		0x61254
 #define BLC_PWM_CTL2		0x61250
 #define BLC_PWM_CTL_C		0x62254
-- 
1.7.4.1

