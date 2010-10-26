Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248Ab0JZUVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:21:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57998 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760132Ab0JZUTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:19:21 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v4 01/12] misc: add driver for sequencer serial port
Date: Tue, 26 Oct 2010 16:18:17 -0400
Message-Id: <1288124308-14999-2-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288124308-14999-1-git-send-email-cyril@ti.com>
References: <1288124308-14999-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI's sequencer serial port (TI-SSP) is a jack-of-all-trades type of serial port
device.  It has a built-in programmable execution engine that can be programmed
to operate as almost any serial bus (I2C, SPI, EasyScale, and others).

This patch adds a driver for this controller device.  The driver does not
expose a user-land interface.  Protocol drivers built on top of this layer are
expected to remain in-kernel.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/include/mach/ti_ssp.h |   89 +++++
 drivers/misc/Kconfig                        |   10 +
 drivers/misc/Makefile                       |    1 +
 drivers/misc/ti_ssp.c                       |  492 +++++++++++++++++++++++++++
 4 files changed, 592 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-davinci/include/mach/ti_ssp.h
 create mode 100644 drivers/misc/ti_ssp.c

diff --git a/arch/arm/mach-davinci/include/mach/ti_ssp.h b/arch/arm/mach-davinci/include/mach/ti_ssp.h
new file mode 100644
index 0000000..c98d0f2
--- /dev/null
+++ b/arch/arm/mach-davinci/include/mach/ti_ssp.h
@@ -0,0 +1,89 @@
+/*
+ * Sequencer Serial Port (SSP) driver for Texas Instruments' SoCs
+ *
+ * Copyright (C) 2010 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __TI_SSP_H__
+#define __TI_SSP_H__
+
+struct ti_ssp_dev_data {
+	const char	*dev_name;
+	unsigned long	iosel; /* see note below */
+	unsigned long	config;
+	const void	*pdata;
+	size_t		pdata_size;
+};
+
+struct ti_ssp_data {
+	unsigned long		out_clock;
+	struct ti_ssp_dev_data	dev_data[2];
+};
+
+/*
+ * Sequencer port IO pin configuration bits.  These do not correlate 1-1 with
+ * the hardware.  The iosel field in the port data combines iosel1 and iosel2,
+ * and is therefore not a direct map to register space.  It is best to use the
+ * macros below to construct iosel values.
+ *
+ * least significant 16 bits --> iosel1
+ * most significant 16 bits  --> iosel2
+ */
+
+#define SSP_IN			0x0000
+#define SSP_DATA		0x0001
+#define SSP_CLOCK		0x0002
+#define SSP_CHIPSEL		0x0003
+#define SSP_OUT			0x0004
+#define SSP_PIN_SEL(pin, v)	((v) << ((pin) * 3))
+#define SSP_PIN_MASK(pin)	SSP_PIN_SEL(pin, 0x7)
+#define SSP_INPUT_SEL(pin)	((pin) << 16)
+
+/* Sequencer port config bits */
+#define SSP_EARLY_DIN		BIT(8)
+#define SSP_DELAY_DOUT		BIT(9)
+
+/* Sequence map definitions */
+#define SSP_CLK_HIGH		BIT(0)
+#define SSP_CLK_LOW		0
+#define SSP_DATA_HIGH		BIT(1)
+#define SSP_DATA_LOW		0
+#define SSP_CS_HIGH		BIT(2)
+#define SSP_CS_LOW		0
+#define SSP_OUT_MODE		BIT(3)
+#define SSP_IN_MODE		0
+#define SSP_DATA_REG		BIT(4)
+#define SSP_ADDR_REG		0
+
+#define SSP_OPCODE_DIRECT	((0x0) << 5)
+#define SSP_OPCODE_TOGGLE	((0x1) << 5)
+#define SSP_OPCODE_SHIFT	((0x2) << 5)
+#define SSP_OPCODE_BRANCH0	((0x4) << 5)
+#define SSP_OPCODE_BRANCH1	((0x5) << 5)
+#define SSP_OPCODE_BRANCH	((0x6) << 5)
+#define SSP_OPCODE_STOP		((0x7) << 5)
+#define SSP_BRANCH(addr)	((addr) << 8)
+#define SSP_COUNT(cycles)	((cycles) << 8)
+
+int ti_ssp_raw_read(struct device *dev);
+int ti_ssp_raw_write(struct device *dev, u32 val);
+int ti_ssp_load(struct device *dev, int offs, u32* prog, int len);
+int ti_ssp_run(struct device *dev, u32 pc, u32 input, u32 *output);
+int ti_ssp_set_mode(struct device *dev, int mode);
+int ti_ssp_set_iosel(struct device *dev, u32 iosel);
+
+#endif /* __TI_SSP_H__ */
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b743312..a8b7ce3 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -390,6 +390,16 @@ config BMP085
 	  To compile this driver as a module, choose M here: the
 	  module will be called bmp085.
 
+config TI_SSP
+	tristate "Sequencer Serial Port support"
+	depends on ARCH_DAVINCI_TNETV107X
+	---help---
+	  Say Y here if you want support for the Sequencer Serial Port
+	  in a Texas Instruments TNETV107X SoC.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ti_ssp.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 42eab95..7568100 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
 obj-$(CONFIG_EP93XX_PWM)	+= ep93xx_pwm.o
 obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
+obj-$(CONFIG_TI_SSP)		+= ti_ssp.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
 obj-$(CONFIG_HMC6352)		+= hmc6352.o
diff --git a/drivers/misc/ti_ssp.c b/drivers/misc/ti_ssp.c
new file mode 100644
index 0000000..5d9dc23
--- /dev/null
+++ b/drivers/misc/ti_ssp.c
@@ -0,0 +1,492 @@
+/*
+ * Sequencer Serial Port (SSP) driver for Texas Instruments' SoCs
+ *
+ * Copyright (C) 2010 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/wait.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+
+#include <mach/ti_ssp.h>
+
+/* Register Offsets */
+#define REG_REV		0x00
+#define REG_IOSEL_1	0x04
+#define REG_IOSEL_2	0x08
+#define REG_PREDIV	0x0c
+#define REG_INTR_ST	0x10
+#define REG_INTR_EN	0x14
+#define REG_TEST_CTRL	0x18
+
+/* Per port registers */
+#define PORT_CFG_2	0x00
+#define PORT_ADDR	0x04
+#define PORT_DATA	0x08
+#define PORT_CFG_1	0x0c
+#define PORT_STATE	0x10
+
+#define SSP_PORT_CONFIG_MASK	(SSP_EARLY_DIN | SSP_DELAY_DOUT)
+#define SSP_PORT_CLKRATE_MASK	0x0f
+
+#define SSP_SEQRAM_WR_EN	BIT(4)
+#define SSP_SEQRAM_RD_EN	BIT(5)
+#define SSP_START		BIT(15)
+#define SSP_BUSY		BIT(10)
+#define SSP_PORT_ASL		BIT(7)
+#define SSP_PORT_CFO1		BIT(6)
+
+#define SSP_PORT_SEQRAM_SIZE	32
+
+static const int ssp_port_base[]   = {0x040, 0x080};
+static const int ssp_port_seqram[] = {0x100, 0x180};
+
+struct ti_ssp {
+	struct resource			*res;
+	struct device			*dev;
+	void __iomem			*regs;
+	spinlock_t			lock;
+	struct clk			*clk;
+	int				irq;
+	const struct ti_ssp_data	*data;
+	wait_queue_head_t		wqh;
+};
+
+static inline struct ti_ssp *dev_to_ssp(struct device *dev)
+{
+	return dev_get_drvdata(dev->parent);
+}
+
+static inline int dev_to_port(struct device *dev)
+{
+	return to_platform_device(dev)->id;
+}
+
+/* Register Access Helpers, rmw() functions need to run locked */
+static inline u32 ssp_read(struct ti_ssp *ssp, int reg)
+{
+	return __raw_readl(ssp->regs + reg);
+}
+
+static inline void ssp_write(struct ti_ssp *ssp, int reg, u32 val)
+{
+	__raw_writel(val, ssp->regs + reg);
+}
+
+static inline void ssp_rmw(struct ti_ssp *ssp, int reg, u32 mask, u32 bits)
+{
+	u32 val = ssp_read(ssp, reg);
+	val &= ~mask;
+	val |= bits;
+	ssp_write(ssp, reg, val);
+}
+
+static inline u32 ssp_port_read(struct ti_ssp *ssp, int port, int reg)
+{
+	return ssp_read(ssp, ssp_port_base[port] + reg);
+}
+
+static inline void ssp_port_write(struct ti_ssp *ssp, int port, int reg,
+				  u32 val)
+{
+	ssp_write(ssp, ssp_port_base[port] + reg, val);
+}
+
+static inline void ssp_port_rmw(struct ti_ssp *ssp, int port, int reg,
+				u32 mask, u32 bits)
+{
+	ssp_rmw(ssp, ssp_port_base[port] + reg, mask, bits);
+}
+
+static inline void ssp_port_clr_bits(struct ti_ssp *ssp, int port, int reg,
+				     u32 bits)
+{
+	ssp_port_rmw(ssp, port, reg, bits, 0);
+}
+
+static inline void ssp_port_set_bits(struct ti_ssp *ssp, int port, int reg,
+				     u32 bits)
+{
+	ssp_port_rmw(ssp, port, reg, 0, bits);
+}
+
+/* Called to setup port clock mode, caller must hold ssp->lock */
+static int __set_mode(struct ti_ssp *ssp, int port, int mode)
+{
+	mode &= SSP_PORT_CONFIG_MASK;
+	ssp_port_rmw(ssp, port, PORT_CFG_1, SSP_PORT_CONFIG_MASK, mode);
+
+	return 0;
+}
+
+int ti_ssp_set_mode(struct device *dev, int mode)
+{
+	struct ti_ssp *ssp = dev_to_ssp(dev);
+	int port = dev_to_port(dev);
+	int ret;
+
+	spin_lock(&ssp->lock);
+	ret = __set_mode(ssp, port, mode);
+	spin_unlock(&ssp->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(ti_ssp_set_mode);
+
+/* Called to setup port iosel, caller must hold ssp->lock */
+static int __set_iosel(struct ti_ssp *ssp, int port, u32 iosel)
+{
+	unsigned val;
+
+	/* IOSEL1 gets the least significant 16 bits */
+	val = ssp_read(ssp, REG_IOSEL_1);
+	val &= 0xffff << (port ? 0 : 16);
+	val |= (iosel & 0xffff) << (port ? 16 : 0);
+	ssp_write(ssp, REG_IOSEL_1, val);
+
+	/* IOSEL2 gets the most significant 16 bits */
+	val = ssp_read(ssp, REG_IOSEL_2);
+	val &= 0x0007 << (port ? 0 : 16);
+	val |= (iosel & 0x00070000) >> (port ? 0 : 16);
+	ssp_write(ssp, REG_IOSEL_2, val);
+
+	return 0;
+}
+
+int ti_ssp_set_iosel(struct device *dev, u32 iosel)
+{
+	struct ti_ssp *ssp = dev_to_ssp(dev);
+	int port = dev_to_port(dev);
+	int ret;
+
+	spin_lock(&ssp->lock);
+	ret = __set_iosel(ssp, port, iosel);
+	spin_unlock(&ssp->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(ti_ssp_set_iosel);
+
+int ti_ssp_load(struct device *dev, int offs, u32* prog, int len)
+{
+	struct ti_ssp *ssp = dev_to_ssp(dev);
+	int port = dev_to_port(dev);
+	int i;
+
+	if (len > SSP_PORT_SEQRAM_SIZE)
+		return -ENOSPC;
+
+	spin_lock(&ssp->lock);
+
+	/* Enable SeqRAM access */
+	ssp_port_set_bits(ssp, port, PORT_CFG_2, SSP_SEQRAM_WR_EN);
+
+	/* Copy code */
+	for (i = 0; i < len; i++) {
+		__raw_writel(prog[i], ssp->regs + offs + 4*i +
+			     ssp_port_seqram[port]);
+	}
+
+	/* Disable SeqRAM access */
+	ssp_port_clr_bits(ssp, port, PORT_CFG_2, SSP_SEQRAM_WR_EN);
+
+	spin_unlock(&ssp->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ti_ssp_load);
+
+int ti_ssp_raw_read(struct device *dev)
+{
+	struct ti_ssp *ssp = dev_to_ssp(dev);
+	int port = dev_to_port(dev);
+	u32 val;
+
+	val = ssp_read(ssp, REG_IOSEL_2);
+	val >>= (port ? 27 : 11);
+
+	return val & 0x0f;
+}
+EXPORT_SYMBOL(ti_ssp_raw_read);
+
+int ti_ssp_raw_write(struct device *dev, u32 val)
+{
+	struct ti_ssp *ssp = dev_to_ssp(dev);
+	int port = dev_to_port(dev);
+	u32 mask;
+
+	spin_lock(&ssp->lock);
+
+	val &= 0x0f;
+	val <<= (port ? 22 : 6);
+	mask = 0x0f << (port ? 22 : 6);
+	ssp_rmw(ssp, REG_IOSEL_2, mask, val);
+
+	spin_unlock(&ssp->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(ti_ssp_raw_write);
+
+static inline int __xfer_done(struct ti_ssp *ssp, int port)
+{
+	return !(ssp_port_read(ssp, port, PORT_CFG_1) & SSP_BUSY);
+}
+
+int ti_ssp_run(struct device *dev, u32 pc, u32 input, u32 *output)
+{
+	struct ti_ssp *ssp = dev_to_ssp(dev);
+	int port = dev_to_port(dev);
+	int ret;
+
+	if (pc & ~(0x3f))
+		return -EINVAL;
+
+	/* Grab ssp->lock to serialize rmw on ssp registers */
+	spin_lock(&ssp->lock);
+
+	ssp_port_write(ssp, port, PORT_ADDR, input >> 16);
+	ssp_port_write(ssp, port, PORT_DATA, input & 0xffff);
+	ssp_port_rmw(ssp, port, PORT_CFG_1, 0x3f, pc);
+
+	/* grab wait queue head lock to avoid race with the isr */
+	spin_lock_irq(&ssp->wqh.lock);
+
+	/* kick off sequence execution in hardware */
+	ssp_port_set_bits(ssp, port, PORT_CFG_1, SSP_START);
+
+	/* drop ssp lock; no register writes beyond this */
+	spin_unlock(&ssp->lock);
+
+	ret = wait_event_interruptible_locked_irq(ssp->wqh,
+						  __xfer_done(ssp, port));
+	spin_unlock_irq(&ssp->wqh.lock);
+
+	if (ret < 0)
+		return ret;
+
+	if (output) {
+		*output = (ssp_port_read(ssp, port, PORT_ADDR) << 16) |
+			  (ssp_port_read(ssp, port, PORT_DATA) &  0xffff);
+	}
+
+	ret = ssp_port_read(ssp, port, PORT_STATE) & 0x3f; /* stop address */
+
+	return ret;
+}
+EXPORT_SYMBOL(ti_ssp_run);
+
+static irqreturn_t ti_ssp_interrupt(int irq, void *data)
+{
+	struct ti_ssp *ssp = data;
+
+	spin_lock(&ssp->wqh.lock);
+
+	ssp_write(ssp, REG_INTR_ST, 0x3);
+	wake_up_locked(&ssp->wqh);
+
+	spin_unlock(&ssp->wqh.lock);
+
+	return IRQ_HANDLED;
+}
+
+static int __unregister_subdev(struct device *dev, void *unused)
+{
+	platform_device_unregister(to_platform_device(dev));
+	return 0;
+}
+
+static int unregister_subdevs(struct ti_ssp *ssp)
+{
+	return device_for_each_child(ssp->dev, NULL, __unregister_subdev);
+}
+
+static void register_subdevs(struct ti_ssp *ssp)
+{
+	int id;
+
+	for (id = 0; id < 2; id++) {
+		const struct ti_ssp_dev_data *data = &ssp->data->dev_data[id];
+
+		if (!data->dev_name)
+			continue;
+
+		spin_lock(&ssp->lock);
+		__set_iosel(ssp, id, data->iosel);
+		ssp_port_rmw(ssp, id, PORT_CFG_1, SSP_PORT_CONFIG_MASK,
+			     data->config);
+		ssp_port_rmw(ssp, id, PORT_CFG_2, SSP_PORT_CLKRATE_MASK, 0);
+		spin_unlock(&ssp->lock);
+
+		platform_device_register_data(ssp->dev, data->dev_name, id,
+					      data->pdata, data->pdata_size);
+	}
+}
+
+static int __devinit ti_ssp_probe(struct platform_device *pdev)
+{
+	static struct ti_ssp *ssp;
+	const struct ti_ssp_data *pdata = pdev->dev.platform_data;
+	int ret = 0, prediv = 0xff;
+	unsigned long sysclk;
+	struct device *dev = &pdev->dev;
+
+	ssp = kzalloc(sizeof(*ssp), GFP_KERNEL);
+	if (!ssp) {
+		dev_err(dev, "cannot allocate device info\n");
+		return -ENOMEM;
+	}
+
+	ssp->data = pdata;
+	ssp->dev = dev;
+	dev_set_drvdata(dev, ssp);
+
+	ret = -ENODEV;
+	ssp->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!ssp->res) {
+		dev_err(dev, "cannot determine register area\n");
+		goto error_res;
+	}
+
+	ret = -EINVAL;
+	if (!request_mem_region(ssp->res->start, resource_size(ssp->res),
+				pdev->name)) {
+		dev_err(dev, "cannot claim register memory\n");
+		goto error_res;
+	}
+
+	ret = -ENOMEM;
+	ssp->regs = ioremap(ssp->res->start, resource_size(ssp->res));
+	if (!ssp->regs) {
+		dev_err(dev, "cannot map register memory\n");
+		goto error_map;
+	}
+
+	ret = -EINVAL;
+	ssp->clk = clk_get(dev, NULL);
+	if (IS_ERR(ssp->clk)) {
+		dev_err(dev, "cannot claim device clock\n");
+		goto error_clk;
+	}
+
+	ssp->irq = platform_get_irq(pdev, 0);
+	if (ssp->irq < 0) {
+		dev_err(dev, "unknown irq\n");
+		goto error_irq;
+	}
+
+	ret = request_threaded_irq(ssp->irq, NULL, ti_ssp_interrupt, 0,
+				   dev_name(dev), ssp);
+	if (ret < 0) {
+		dev_err(dev, "cannot acquire irq\n");
+		goto error_irq;
+	}
+
+	spin_lock_init(&ssp->lock);
+	init_waitqueue_head(&ssp->wqh);
+
+	/* Power on and initialize SSP */
+	ret = clk_enable(ssp->clk);
+	if (ret)
+		goto error_enable;
+
+	/* Reset registers to a sensible known state */
+	ssp_write(ssp, REG_IOSEL_1, 0);
+	ssp_write(ssp, REG_IOSEL_2, 0);
+	ssp_write(ssp, REG_INTR_EN, 0x3);
+	ssp_write(ssp, REG_INTR_ST, 0x3);
+	ssp_write(ssp, REG_TEST_CTRL, 0);
+	ssp_port_write(ssp, 0, PORT_CFG_1, SSP_PORT_ASL);
+	ssp_port_write(ssp, 1, PORT_CFG_1, SSP_PORT_ASL);
+	ssp_port_write(ssp, 0, PORT_CFG_2, SSP_PORT_CFO1);
+	ssp_port_write(ssp, 1, PORT_CFG_2, SSP_PORT_CFO1);
+
+	sysclk = clk_get_rate(ssp->clk);
+	if (pdata && pdata->out_clock)
+		prediv = (sysclk / pdata->out_clock) - 1;
+	prediv = clamp(prediv, 0, 0xff);
+	ssp_rmw(ssp, REG_PREDIV, 0xff, prediv);
+
+	register_subdevs(ssp);
+
+	return 0;
+
+error_enable:
+	free_irq(ssp->irq, ssp);
+error_irq:
+	clk_put(ssp->clk);
+error_clk:
+	iounmap(ssp->regs);
+error_map:
+	release_mem_region(ssp->res->start, resource_size(ssp->res));
+error_res:
+	kfree(ssp);
+	return ret;
+}
+
+static int __devexit ti_ssp_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ti_ssp *ssp = dev_get_drvdata(dev);
+
+	unregister_subdevs(ssp);
+	clk_disable(ssp->clk);
+	free_irq(ssp->irq, ssp);
+	clk_put(ssp->clk);
+	iounmap(ssp->regs);
+	release_mem_region(ssp->res->start, resource_size(ssp->res));
+	kfree(ssp);
+	dev_set_drvdata(dev, NULL);
+	return 0;
+}
+
+static struct platform_driver ti_ssp_driver = {
+	.probe		= ti_ssp_probe,
+	.remove		= __devexit_p(ti_ssp_remove),
+	.driver		= {
+		.name	= "ti-ssp",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init ti_ssp_init(void)
+{
+	return platform_driver_register(&ti_ssp_driver);
+}
+arch_initcall_sync(ti_ssp_init);
+
+static void __exit ti_ssp_exit(void)
+{
+	platform_driver_unregister(&ti_ssp_driver);
+}
+module_exit(ti_ssp_exit);
+
+MODULE_DESCRIPTION("Sequencer Serial Port (SSP) Driver");
+MODULE_AUTHOR("Cyril Chemparathy");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ti_ssp");
-- 
1.7.0.4

