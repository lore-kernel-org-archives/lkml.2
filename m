Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2KUC1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:27:04 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab2KUC06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:58 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 17/42] sh-pfc: Move driver from drivers/sh/ to drivers/pinctrl/
Date: Wed, 21 Nov 2012 03:27:18 +0100
Message-Id: <1353464863-10281-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/pinctrl/Kconfig          |    1 +
 drivers/pinctrl/Makefile         |    1 +
 drivers/pinctrl/sh-pfc/Kconfig   |   24 ++
 drivers/pinctrl/sh-pfc/Makefile  |    5 +
 drivers/pinctrl/sh-pfc/core.c    |  611 ++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/core.h    |   54 ++++
 drivers/pinctrl/sh-pfc/gpio.c    |  181 +++++++++++
 drivers/pinctrl/sh-pfc/pinctrl.c |  481 ++++++++++++++++++++++++++++++
 drivers/sh/Kconfig               |    1 -
 drivers/sh/Makefile              |    1 -
 drivers/sh/pfc/Kconfig           |   18 --
 drivers/sh/pfc/Makefile          |    5 -
 drivers/sh/pfc/core.c            |  611 --------------------------------------
 drivers/sh/pfc/core.h            |   54 ----
 drivers/sh/pfc/gpio.c            |  181 -----------
 drivers/sh/pfc/pinctrl.c         |  481 ------------------------------
 16 files changed, 1358 insertions(+), 1352 deletions(-)
 create mode 100644 drivers/pinctrl/sh-pfc/Kconfig
 create mode 100644 drivers/pinctrl/sh-pfc/Makefile
 create mode 100644 drivers/pinctrl/sh-pfc/core.c
 create mode 100644 drivers/pinctrl/sh-pfc/core.h
 create mode 100644 drivers/pinctrl/sh-pfc/gpio.c
 create mode 100644 drivers/pinctrl/sh-pfc/pinctrl.c
 delete mode 100644 drivers/sh/pfc/Kconfig
 delete mode 100644 drivers/sh/pfc/Makefile
 delete mode 100644 drivers/sh/pfc/core.c
 delete mode 100644 drivers/sh/pfc/core.h
 delete mode 100644 drivers/sh/pfc/gpio.c
 delete mode 100644 drivers/sh/pfc/pinctrl.c

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index d96caef..448e62b 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -210,6 +210,7 @@ config PINCTRL_ARMADA_XP
 	bool
 	select PINCTRL_MVEBU
 
+source "drivers/pinctrl/sh-pfc/Kconfig"
 source "drivers/pinctrl/spear/Kconfig"
 
 config PINCTRL_XWAY
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index f395ba5..c44f17d 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -44,4 +44,5 @@ obj-$(CONFIG_PINCTRL_ARMADA_XP)  += pinctrl-armada-xp.o
 obj-$(CONFIG_PINCTRL_XWAY)	+= pinctrl-xway.o
 obj-$(CONFIG_PINCTRL_LANTIQ)	+= pinctrl-lantiq.o
 
+obj-$(CONFIG_PINCTRL_SH_PFC)	+= sh-pfc/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
diff --git a/drivers/pinctrl/sh-pfc/Kconfig b/drivers/pinctrl/sh-pfc/Kconfig
new file mode 100644
index 0000000..ae69dbe
--- /dev/null
+++ b/drivers/pinctrl/sh-pfc/Kconfig
@@ -0,0 +1,24 @@
+#
+# Renesas SH and SH Mobile PINCTRL drivers
+#
+
+if ARCH_SHMOBILE || SUPERH
+
+config PINCTRL_SH_PFC
+	# XXX move off the gpio dependency
+	depends on GENERIC_GPIO
+	select GPIO_SH_PFC if ARCH_REQUIRE_GPIOLIB
+	select PINMUX
+	select PINCONF
+	def_bool y
+	help
+	  This enables pin control drivers for SH and SH Mobile platforms
+
+config GPIO_SH_PFC
+	bool "SuperH PFC GPIO support"
+	depends on PINCTRL_SH_PFC && GPIOLIB
+	help
+	  This enables support for GPIOs within the SoC's pin function
+	  controller.
+
+endif
diff --git a/drivers/pinctrl/sh-pfc/Makefile b/drivers/pinctrl/sh-pfc/Makefile
new file mode 100644
index 0000000..6ba6fb2
--- /dev/null
+++ b/drivers/pinctrl/sh-pfc/Makefile
@@ -0,0 +1,5 @@
+sh-pfc-objs			= core.o pinctrl.o
+ifeq ($(CONFIG_GPIO_SH_PFC),y)
+sh-pfc-objs			+= gpio.o
+endif
+obj-$(CONFIG_PINCTRL_SH_PFC)	+= sh-pfc.o
diff --git a/drivers/pinctrl/sh-pfc/core.c b/drivers/pinctrl/sh-pfc/core.c
new file mode 100644
index 0000000..68b40d8
--- /dev/null
+++ b/drivers/pinctrl/sh-pfc/core.c
@@ -0,0 +1,611 @@
+/*
+ * SuperH Pin Function Controller support.
+ *
+ * Copyright (C) 2008 Magnus Damm
+ * Copyright (C) 2009 - 2012 Paul Mundt
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#define DRV_NAME "sh-pfc"
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sh_pfc.h>
+#include <linux/slab.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/platform_device.h>
+
+#include "core.h"
+
+static void pfc_iounmap(struct sh_pfc *pfc)
+{
+	int k;
+
+	for (k = 0; k < pfc->num_windows; k++)
+		if (pfc->window[k].virt)
+			iounmap(pfc->window[k].virt);
+
+	kfree(pfc->window);
+	pfc->num_windows = 0;
+	pfc->window = NULL;
+}
+
+static int pfc_ioremap(struct sh_pfc *pfc, struct platform_device *pdev)
+{
+	struct resource *res;
+	int k;
+
+	if (pdev->num_resources == 0) {
+		pfc->num_windows = 0;
+		return 0;
+	}
+
+	pfc->window = kzalloc(pdev->num_resources * sizeof(*pfc->window),
+			      GFP_NOWAIT);
+	if (!pfc->window)
+		goto err1;
+
+	pfc->num_windows = pdev->num_resources;
+
+	for (k = 0, res = pdev->resource; k < pdev->num_resources; k++, res++) {
+		WARN_ON(resource_type(res) != IORESOURCE_MEM);
+		pfc->window[k].phys = res->start;
+		pfc->window[k].size = resource_size(res);
+		pfc->window[k].virt = ioremap_nocache(res->start,
+							 resource_size(res));
+		if (!pfc->window[k].virt)
+			goto err2;
+	}
+
+	return 0;
+
+err2:
+	pfc_iounmap(pfc);
+err1:
+	return -1;
+}
+
+static void __iomem *pfc_phys_to_virt(struct sh_pfc *pfc,
+				      unsigned long address)
+{
+	struct pfc_window *window;
+	int k;
+
+	/* scan through physical windows and convert address */
+	for (k = 0; k < pfc->num_windows; k++) {
+		window = pfc->window + k;
+
+		if (address < window->phys)
+			continue;
+
+		if (address >= (window->phys + window->size))
+			continue;
+
+		return window->virt + (address - window->phys);
+	}
+
+	/* no windows defined, register must be 1:1 mapped virt:phys */
+	return (void __iomem *)address;
+}
+
+static int enum_in_range(pinmux_enum_t enum_id, struct pinmux_range *r)
+{
+	if (enum_id < r->begin)
+		return 0;
+
+	if (enum_id > r->end)
+		return 0;
+
+	return 1;
+}
+
+static unsigned long gpio_read_raw_reg(void __iomem *mapped_reg,
+				       unsigned long reg_width)
+{
+	switch (reg_width) {
+	case 8:
+		return ioread8(mapped_reg);
+	case 16:
+		return ioread16(mapped_reg);
+	case 32:
+		return ioread32(mapped_reg);
+	}
+
+	BUG();
+	return 0;
+}
+
+static void gpio_write_raw_reg(void __iomem *mapped_reg,
+			       unsigned long reg_width,
+			       unsigned long data)
+{
+	switch (reg_width) {
+	case 8:
+		iowrite8(data, mapped_reg);
+		return;
+	case 16:
+		iowrite16(data, mapped_reg);
+		return;
+	case 32:
+		iowrite32(data, mapped_reg);
+		return;
+	}
+
+	BUG();
+}
+
+int sh_pfc_read_bit(struct pinmux_data_reg *dr, unsigned long in_pos)
+{
+	unsigned long pos;
+
+	pos = dr->reg_width - (in_pos + 1);
+
+	pr_debug("read_bit: addr = %lx, pos = %ld, "
+		 "r_width = %ld\n", dr->reg, pos, dr->reg_width);
+
+	return (gpio_read_raw_reg(dr->mapped_reg, dr->reg_width) >> pos) & 1;
+}
+
+void sh_pfc_write_bit(struct pinmux_data_reg *dr, unsigned long in_pos,
+		      unsigned long value)
+{
+	unsigned long pos;
+
+	pos = dr->reg_width - (in_pos + 1);
+
+	pr_debug("write_bit addr = %lx, value = %d, pos = %ld, "
+		 "r_width = %ld\n",
+		 dr->reg, !!value, pos, dr->reg_width);
+
+	if (value)
+		set_bit(pos, &dr->reg_shadow);
+	else
+		clear_bit(pos, &dr->reg_shadow);
+
+	gpio_write_raw_reg(dr->mapped_reg, dr->reg_width, dr->reg_shadow);
+}
+
+static void config_reg_helper(struct sh_pfc *pfc,
+			      struct pinmux_cfg_reg *crp,
+			      unsigned long in_pos,
+			      void __iomem **mapped_regp,
+			      unsigned long *maskp,
+			      unsigned long *posp)
+{
+	int k;
+
+	*mapped_regp = pfc_phys_to_virt(pfc, crp->reg);
+
+	if (crp->field_width) {
+		*maskp = (1 << crp->field_width) - 1;
+		*posp = crp->reg_width - ((in_pos + 1) * crp->field_width);
+	} else {
+		*maskp = (1 << crp->var_field_width[in_pos]) - 1;
+		*posp = crp->reg_width;
+		for (k = 0; k <= in_pos; k++)
+			*posp -= crp->var_field_width[k];
+	}
+}
+
+static int read_config_reg(struct sh_pfc *pfc,
+			   struct pinmux_cfg_reg *crp,
+			   unsigned long field)
+{
+	void __iomem *mapped_reg;
+	unsigned long mask, pos;
+
+	config_reg_helper(pfc, crp, field, &mapped_reg, &mask, &pos);
+
+	pr_debug("read_reg: addr = %lx, field = %ld, "
+		 "r_width = %ld, f_width = %ld\n",
+		 crp->reg, field, crp->reg_width, crp->field_width);
+
+	return (gpio_read_raw_reg(mapped_reg, crp->reg_width) >> pos) & mask;
+}
+
+static void write_config_reg(struct sh_pfc *pfc,
+			     struct pinmux_cfg_reg *crp,
+			     unsigned long field, unsigned long value)
+{
+	void __iomem *mapped_reg;
+	unsigned long mask, pos, data;
+
+	config_reg_helper(pfc, crp, field, &mapped_reg, &mask, &pos);
+
+	pr_debug("write_reg addr = %lx, value = %ld, field = %ld, "
+		 "r_width = %ld, f_width = %ld\n",
+		 crp->reg, value, field, crp->reg_width, crp->field_width);
+
+	mask = ~(mask << pos);
+	value = value << pos;
+
+	data = gpio_read_raw_reg(mapped_reg, crp->reg_width);
+	data &= mask;
+	data |= value;
+
+	if (pfc->pdata->unlock_reg)
+		gpio_write_raw_reg(pfc_phys_to_virt(pfc, pfc->pdata->unlock_reg),
+				   32, ~data);
+
+	gpio_write_raw_reg(mapped_reg, crp->reg_width, data);
+}
+
+static int setup_data_reg(struct sh_pfc *pfc, unsigned gpio)
+{
+	struct pinmux_gpio *gpiop = &pfc->pdata->gpios[gpio];
+	struct pinmux_data_reg *data_reg;
+	int k, n;
+
+	if (!enum_in_range(gpiop->enum_id, &pfc->pdata->data))
+		return -1;
+
+	k = 0;
+	while (1) {
+		data_reg = pfc->pdata->data_regs + k;
+
+		if (!data_reg->reg_width)
+			break;
+
+		data_reg->mapped_reg = pfc_phys_to_virt(pfc, data_reg->reg);
+
+		for (n = 0; n < data_reg->reg_width; n++) {
+			if (data_reg->enum_ids[n] == gpiop->enum_id) {
+				gpiop->flags &= ~PINMUX_FLAG_DREG;
+				gpiop->flags |= (k << PINMUX_FLAG_DREG_SHIFT);
+				gpiop->flags &= ~PINMUX_FLAG_DBIT;
+				gpiop->flags |= (n << PINMUX_FLAG_DBIT_SHIFT);
+				return 0;
+			}
+		}
+		k++;
+	}
+
+	BUG();
+
+	return -1;
+}
+
+static void setup_data_regs(struct sh_pfc *pfc)
+{
+	struct pinmux_data_reg *drp;
+	int k;
+
+	for (k = pfc->pdata->first_gpio; k <= pfc->pdata->last_gpio; k++)
+		setup_data_reg(pfc, k);
+
+	k = 0;
+	while (1) {
+		drp = pfc->pdata->data_regs + k;
+
+		if (!drp->reg_width)
+			break;
+
+		drp->reg_shadow = gpio_read_raw_reg(drp->mapped_reg,
+						    drp->reg_width);
+		k++;
+	}
+}
+
+int sh_pfc_get_data_reg(struct sh_pfc *pfc, unsigned gpio,
+			struct pinmux_data_reg **drp, int *bitp)
+{
+	struct pinmux_gpio *gpiop = &pfc->pdata->gpios[gpio];
+	int k, n;
+
+	if (!enum_in_range(gpiop->enum_id, &pfc->pdata->data))
+		return -1;
+
+	k = (gpiop->flags & PINMUX_FLAG_DREG) >> PINMUX_FLAG_DREG_SHIFT;
+	n = (gpiop->flags & PINMUX_FLAG_DBIT) >> PINMUX_FLAG_DBIT_SHIFT;
+	*drp = pfc->pdata->data_regs + k;
+	*bitp = n;
+	return 0;
+}
+
+static int get_config_reg(struct sh_pfc *pfc, pinmux_enum_t enum_id,
+			  struct pinmux_cfg_reg **crp,
+			  int *fieldp, int *valuep,
+			  unsigned long **cntp)
+{
+	struct pinmux_cfg_reg *config_reg;
+	unsigned long r_width, f_width, curr_width, ncomb;
+	int k, m, n, pos, bit_pos;
+
+	k = 0;
+	while (1) {
+		config_reg = pfc->pdata->cfg_regs + k;
+
+		r_width = config_reg->reg_width;
+		f_width = config_reg->field_width;
+
+		if (!r_width)
+			break;
+
+		pos = 0;
+		m = 0;
+		for (bit_pos = 0; bit_pos < r_width; bit_pos += curr_width) {
+			if (f_width)
+				curr_width = f_width;
+			else
+				curr_width = config_reg->var_field_width[m];
+
+			ncomb = 1 << curr_width;
+			for (n = 0; n < ncomb; n++) {
+				if (config_reg->enum_ids[pos + n] == enum_id) {
+					*crp = config_reg;
+					*fieldp = m;
+					*valuep = n;
+					*cntp = &config_reg->cnt[m];
+					return 0;
+				}
+			}
+			pos += ncomb;
+			m++;
+		}
+		k++;
+	}
+
+	return -1;
+}
+
+int sh_pfc_gpio_to_enum(struct sh_pfc *pfc, unsigned gpio, int pos,
+			pinmux_enum_t *enum_idp)
+{
+	pinmux_enum_t enum_id = pfc->pdata->gpios[gpio].enum_id;
+	pinmux_enum_t *data = pfc->pdata->gpio_data;
+	int k;
+
+	if (!enum_in_range(enum_id, &pfc->pdata->data)) {
+		if (!enum_in_range(enum_id, &pfc->pdata->mark)) {
+			pr_err("non data/mark enum_id for gpio %d\n", gpio);
+			return -1;
+		}
+	}
+
+	if (pos) {
+		*enum_idp = data[pos + 1];
+		return pos + 1;
+	}
+
+	for (k = 0; k < pfc->pdata->gpio_data_size; k++) {
+		if (data[k] == enum_id) {
+			*enum_idp = data[k + 1];
+			return k + 1;
+		}
+	}
+
+	pr_err("cannot locate data/mark enum_id for gpio %d\n", gpio);
+	return -1;
+}
+
+int sh_pfc_config_gpio(struct sh_pfc *pfc, unsigned gpio, int pinmux_type,
+		       int cfg_mode)
+{
+	struct pinmux_cfg_reg *cr = NULL;
+	pinmux_enum_t enum_id;
+	struct pinmux_range *range;
+	int in_range, pos, field, value;
+	unsigned long *cntp;
+
+	switch (pinmux_type) {
+
+	case PINMUX_TYPE_FUNCTION:
+		range = NULL;
+		break;
+
+	case PINMUX_TYPE_OUTPUT:
+		range = &pfc->pdata->output;
+		break;
+
+	case PINMUX_TYPE_INPUT:
+		range = &pfc->pdata->input;
+		break;
+
+	case PINMUX_TYPE_INPUT_PULLUP:
+		range = &pfc->pdata->input_pu;
+		break;
+
+	case PINMUX_TYPE_INPUT_PULLDOWN:
+		range = &pfc->pdata->input_pd;
+		break;
+
+	default:
+		goto out_err;
+	}
+
+	pos = 0;
+	enum_id = 0;
+	field = 0;
+	value = 0;
+	while (1) {
+		pos = sh_pfc_gpio_to_enum(pfc, gpio, pos, &enum_id);
+		if (pos <= 0)
+			goto out_err;
+
+		if (!enum_id)
+			break;
+
+		/* first check if this is a function enum */
+		in_range = enum_in_range(enum_id, &pfc->pdata->function);
+		if (!in_range) {
+			/* not a function enum */
+			if (range) {
+				/*
+				 * other range exists, so this pin is
+				 * a regular GPIO pin that now is being
+				 * bound to a specific direction.
+				 *
+				 * for this case we only allow function enums
+				 * and the enums that match the other range.
+				 */
+				in_range = enum_in_range(enum_id, range);
+
+				/*
+				 * special case pass through for fixed
+				 * input-only or output-only pins without
+				 * function enum register association.
+				 */
+				if (in_range && enum_id == range->force)
+					continue;
+			} else {
+				/*
+				 * no other range exists, so this pin
+				 * must then be of the function type.
+				 *
+				 * allow function type pins to select
+				 * any combination of function/in/out
+				 * in their MARK lists.
+				 */
+				in_range = 1;
+			}
+		}
+
+		if (!in_range)
+			continue;
+
+		if (get_config_reg(pfc, enum_id, &cr,
+				   &field, &value, &cntp) != 0)
+			goto out_err;
+
+		switch (cfg_mode) {
+		case GPIO_CFG_DRYRUN:
+			if (!*cntp ||
+			    (read_config_reg(pfc, cr, field) != value))
+				continue;
+			break;
+
+		case GPIO_CFG_REQ:
+			write_config_reg(pfc, cr, field, value);
+			*cntp = *cntp + 1;
+			break;
+
+		case GPIO_CFG_FREE:
+			*cntp = *cntp - 1;
+			break;
+		}
+	}
+
+	return 0;
+ out_err:
+	return -1;
+}
+
+static int sh_pfc_probe(struct platform_device *pdev)
+{
+	struct sh_pfc_platform_data *pdata = pdev->dev.platform_data;
+	struct sh_pfc *pfc;
+	int ret;
+
+	/*
+	 * Ensure that the type encoding fits
+	 */
+	BUILD_BUG_ON(PINMUX_FLAG_TYPE > ((1 << PINMUX_FLAG_DBIT_SHIFT) - 1));
+
+	if (pdata == NULL)
+		return -ENODEV;
+
+	pfc = devm_kzalloc(&pdev->dev, sizeof(pfc), GFP_KERNEL);
+	if (pfc == NULL)
+		return -ENOMEM;
+
+	pfc->pdata = pdata;
+	pfc->dev = &pdev->dev;
+
+	ret = pfc_ioremap(pfc, pdev);
+	if (unlikely(ret < 0))
+		return ret;
+
+	spin_lock_init(&pfc->lock);
+
+	pinctrl_provide_dummies();
+	setup_data_regs(pfc);
+
+	/*
+	 * Initialize pinctrl bindings first
+	 */
+	ret = sh_pfc_register_pinctrl(pfc);
+	if (unlikely(ret != 0))
+		goto err;
+
+#ifdef CONFIG_GPIO_SH_PFC
+	/*
+	 * Then the GPIO chip
+	 */
+	ret = sh_pfc_register_gpiochip(pfc);
+	if (unlikely(ret != 0)) {
+		/*
+		 * If the GPIO chip fails to come up we still leave the
+		 * PFC state as it is, given that there are already
+		 * extant users of it that have succeeded by this point.
+		 */
+		pr_notice("failed to init GPIO chip, ignoring...\n");
+	}
+#endif
+
+	platform_set_drvdata(pdev, pfc);
+
+	pr_info("%s support registered\n", pdata->name);
+
+	return 0;
+
+err:
+	pfc_iounmap(pfc);
+	return ret;
+}
+
+static int __devexit sh_pfc_remove(struct platform_device *pdev)
+{
+	struct sh_pfc *pfc = platform_get_drvdata(pdev);
+
+#ifdef CONFIG_GPIO_SH_PFC
+	sh_pfc_unregister_gpiochip(pfc);
+#endif
+	sh_pfc_unregister_pinctrl(pfc);
+
+	pfc_iounmap(pfc);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static const struct platform_device_id sh_pfc_id_table[] = {
+	{ "sh-pfc", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, sh_pfc_id_table);
+
+static struct platform_driver sh_pfc_driver = {
+	.probe		= sh_pfc_probe,
+	.remove		= __devexit_p(sh_pfc_remove),
+	.id_table	= sh_pfc_id_table,
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init sh_pfc_init(void)
+{
+	return platform_driver_register(&sh_pfc_driver);
+}
+postcore_initcall(sh_pfc_init);
+
+static void __exit sh_pfc_exit(void)
+{
+	platform_driver_unregister(&sh_pfc_driver);
+}
+module_exit(sh_pfc_exit);
+
+MODULE_AUTHOR("Magnus Damm, Paul Mundt");
+MODULE_DESCRIPTION("Pin Control and GPIO driver for SuperH pin function controller");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/sh-pfc/core.h b/drivers/pinctrl/sh-pfc/core.h
new file mode 100644
index 0000000..b71f559
--- /dev/null
+++ b/drivers/pinctrl/sh-pfc/core.h
@@ -0,0 +1,54 @@
+/*
+ * SuperH Pin Function Controller support.
+ *
+ * Copyright (C) 2012  Renesas Solutions Corp.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#ifndef __SH_PFC_CORE_H__
+#define __SH_PFC_CORE_H__
+
+#include <linux/compiler.h>
+#include <linux/sh_pfc.h>
+#include <linux/types.h>
+
+struct pfc_window {
+	phys_addr_t phys;
+	void __iomem *virt;
+	unsigned long size;
+};
+
+struct sh_pfc_chip;
+struct sh_pfc_pinctrl;
+
+struct sh_pfc {
+	struct device *dev;
+	struct sh_pfc_platform_data *pdata;
+	spinlock_t lock;
+
+	unsigned int num_windows;
+	struct pfc_window *window;
+
+	struct sh_pfc_chip *gpio;
+	struct sh_pfc_pinctrl *pinctrl;
+};
+
+int sh_pfc_register_gpiochip(struct sh_pfc *pfc);
+int sh_pfc_unregister_gpiochip(struct sh_pfc *pfc);
+
+int sh_pfc_register_pinctrl(struct sh_pfc *pfc);
+int sh_pfc_unregister_pinctrl(struct sh_pfc *pfc);
+
+int sh_pfc_read_bit(struct pinmux_data_reg *dr, unsigned long in_pos);
+void sh_pfc_write_bit(struct pinmux_data_reg *dr, unsigned long in_pos,
+		      unsigned long value);
+int sh_pfc_get_data_reg(struct sh_pfc *pfc, unsigned gpio,
+			struct pinmux_data_reg **drp, int *bitp);
+int sh_pfc_gpio_to_enum(struct sh_pfc *pfc, unsigned gpio, int pos,
+			pinmux_enum_t *enum_idp);
+int sh_pfc_config_gpio(struct sh_pfc *pfc, unsigned gpio, int pinmux_type,
+		       int cfg_mode);
+
+#endif /* __SH_PFC_CORE_H__ */
diff --git a/drivers/pinctrl/sh-pfc/gpio.c b/drivers/pinctrl/sh-pfc/gpio.c
new file mode 100644
index 0000000..9f4f0fd
--- /dev/null
+++ b/drivers/pinctrl/sh-pfc/gpio.c
@@ -0,0 +1,181 @@
+/*
+ * SuperH Pin Function Controller GPIO driver.
+ *
+ * Copyright (C) 2008 Magnus Damm
+ * Copyright (C) 2009 - 2012 Paul Mundt
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME " gpio: " fmt
+
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/sh_pfc.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "core.h"
+
+struct sh_pfc_chip {
+	struct sh_pfc		*pfc;
+	struct gpio_chip	gpio_chip;
+};
+
+static struct sh_pfc_chip *gpio_to_pfc_chip(struct gpio_chip *gc)
+{
+	return container_of(gc, struct sh_pfc_chip, gpio_chip);
+}
+
+static struct sh_pfc *gpio_to_pfc(struct gpio_chip *gc)
+{
+	return gpio_to_pfc_chip(gc)->pfc;
+}
+
+static int sh_gpio_request(struct gpio_chip *gc, unsigned offset)
+{
+	return pinctrl_request_gpio(offset);
+}
+
+static void sh_gpio_free(struct gpio_chip *gc, unsigned offset)
+{
+	pinctrl_free_gpio(offset);
+}
+
+static void sh_gpio_set_value(struct sh_pfc *pfc, unsigned gpio, int value)
+{
+	struct pinmux_data_reg *dr = NULL;
+	int bit = 0;
+
+	if (sh_pfc_get_data_reg(pfc, gpio, &dr, &bit) != 0)
+		BUG();
+	else
+		sh_pfc_write_bit(dr, bit, value);
+}
+
+static int sh_gpio_get_value(struct sh_pfc *pfc, unsigned gpio)
+{
+	struct pinmux_data_reg *dr = NULL;
+	int bit = 0;
+
+	if (sh_pfc_get_data_reg(pfc, gpio, &dr, &bit) != 0)
+		return -EINVAL;
+
+	return sh_pfc_read_bit(dr, bit);
+}
+
+static int sh_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	return pinctrl_gpio_direction_input(offset);
+}
+
+static int sh_gpio_direction_output(struct gpio_chip *gc, unsigned offset,
+				    int value)
+{
+	sh_gpio_set_value(gpio_to_pfc(gc), offset, value);
+
+	return pinctrl_gpio_direction_output(offset);
+}
+
+static int sh_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	return sh_gpio_get_value(gpio_to_pfc(gc), offset);
+}
+
+static void sh_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
+{
+	sh_gpio_set_value(gpio_to_pfc(gc), offset, value);
+}
+
+static int sh_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct sh_pfc *pfc = gpio_to_pfc(gc);
+	pinmux_enum_t enum_id;
+	pinmux_enum_t *enum_ids;
+	int i, k, pos;
+
+	pos = 0;
+	enum_id = 0;
+	while (1) {
+		pos = sh_pfc_gpio_to_enum(pfc, offset, pos, &enum_id);
+		if (pos <= 0 || !enum_id)
+			break;
+
+		for (i = 0; i < pfc->pdata->gpio_irq_size; i++) {
+			enum_ids = pfc->pdata->gpio_irq[i].enum_ids;
+			for (k = 0; enum_ids[k]; k++) {
+				if (enum_ids[k] == enum_id)
+					return pfc->pdata->gpio_irq[i].irq;
+			}
+		}
+	}
+
+	return -ENOSYS;
+}
+
+static void sh_pfc_gpio_setup(struct sh_pfc_chip *chip)
+{
+	struct sh_pfc *pfc = chip->pfc;
+	struct gpio_chip *gc = &chip->gpio_chip;
+
+	gc->request = sh_gpio_request;
+	gc->free = sh_gpio_free;
+	gc->direction_input = sh_gpio_direction_input;
+	gc->get = sh_gpio_get;
+	gc->direction_output = sh_gpio_direction_output;
+	gc->set = sh_gpio_set;
+	gc->to_irq = sh_gpio_to_irq;
+
+	WARN_ON(pfc->pdata->first_gpio != 0); /* needs testing */
+
+	gc->label = pfc->pdata->name;
+	gc->owner = THIS_MODULE;
+	gc->base = pfc->pdata->first_gpio;
+	gc->ngpio = (pfc->pdata->last_gpio - pfc->pdata->first_gpio) + 1;
+}
+
+int sh_pfc_register_gpiochip(struct sh_pfc *pfc)
+{
+	struct sh_pfc_chip *chip;
+	int ret;
+
+	chip = kzalloc(sizeof(struct sh_pfc_chip), GFP_KERNEL);
+	if (unlikely(!chip))
+		return -ENOMEM;
+
+	chip->pfc = pfc;
+
+	sh_pfc_gpio_setup(chip);
+
+	ret = gpiochip_add(&chip->gpio_chip);
+	if (unlikely(ret < 0)) {
+		kfree(chip);
+		return ret;
+	}
+
+	pfc->gpio = chip;
+
+	pr_info("%s handling gpio %d -> %d\n",
+		pfc->pdata->name, pfc->pdata->first_gpio,
+		pfc->pdata->last_gpio);
+
+	return 0;
+}
+
+int __exit sh_pfc_unregister_gpiochip(struct sh_pfc *pfc)
+{
+	struct sh_pfc_chip *chip = pfc->gpio;
+	int ret;
+
+	ret = gpiochip_remove(&chip->gpio_chip);
+	if (unlikely(ret < 0))
+		return ret;
+
+	kfree(chip);
+	pfc->gpio = NULL;
+	return 0;
+}
diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c b/drivers/pinctrl/sh-pfc/pinctrl.c
new file mode 100644
index 0000000..c0c8271
--- /dev/null
+++ b/drivers/pinctrl/sh-pfc/pinctrl.c
@@ -0,0 +1,481 @@
+/*
+ * SuperH Pin Function Controller pinmux support.
+ *
+ * Copyright (C) 2012  Paul Mundt
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#define DRV_NAME "sh-pfc"
+#define pr_fmt(fmt) KBUILD_MODNAME " pinctrl: " fmt
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sh_pfc.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+
+#include "core.h"
+
+struct sh_pfc_pinctrl {
+	struct pinctrl_dev *pctl;
+	struct sh_pfc *pfc;
+
+	struct pinmux_gpio **functions;
+	unsigned int nr_functions;
+
+	struct pinctrl_pin_desc *pads;
+	unsigned int nr_pads;
+
+	spinlock_t lock;
+};
+
+static int sh_pfc_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	return pmx->nr_pads;
+}
+
+static const char *sh_pfc_get_group_name(struct pinctrl_dev *pctldev,
+					 unsigned selector)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	return pmx->pads[selector].name;
+}
+
+static int sh_pfc_get_group_pins(struct pinctrl_dev *pctldev, unsigned group,
+				 const unsigned **pins, unsigned *num_pins)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	*pins = &pmx->pads[group].number;
+	*num_pins = 1;
+
+	return 0;
+}
+
+static void sh_pfc_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
+				unsigned offset)
+{
+	seq_printf(s, "%s", DRV_NAME);
+}
+
+static struct pinctrl_ops sh_pfc_pinctrl_ops = {
+	.get_groups_count	= sh_pfc_get_groups_count,
+	.get_group_name		= sh_pfc_get_group_name,
+	.get_group_pins		= sh_pfc_get_group_pins,
+	.pin_dbg_show		= sh_pfc_pin_dbg_show,
+};
+
+static int sh_pfc_get_functions_count(struct pinctrl_dev *pctldev)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	return pmx->nr_functions;
+}
+
+static const char *sh_pfc_get_function_name(struct pinctrl_dev *pctldev,
+					    unsigned selector)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	return pmx->functions[selector]->name;
+}
+
+static int sh_pfc_get_function_groups(struct pinctrl_dev *pctldev, unsigned func,
+				      const char * const **groups,
+				      unsigned * const num_groups)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	*groups = &pmx->functions[func]->name;
+	*num_groups = 1;
+
+	return 0;
+}
+
+static int sh_pfc_noop_enable(struct pinctrl_dev *pctldev, unsigned func,
+			      unsigned group)
+{
+	return 0;
+}
+
+static void sh_pfc_noop_disable(struct pinctrl_dev *pctldev, unsigned func,
+				unsigned group)
+{
+}
+
+static int sh_pfc_config_function(struct sh_pfc *pfc, unsigned offset)
+{
+	if (sh_pfc_config_gpio(pfc, offset,
+			       PINMUX_TYPE_FUNCTION,
+			       GPIO_CFG_DRYRUN) != 0)
+		return -EINVAL;
+
+	if (sh_pfc_config_gpio(pfc, offset,
+			       PINMUX_TYPE_FUNCTION,
+			       GPIO_CFG_REQ) != 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int sh_pfc_reconfig_pin(struct sh_pfc *pfc, unsigned offset,
+			       int new_type)
+{
+	unsigned long flags;
+	int pinmux_type;
+	int ret = -EINVAL;
+
+	spin_lock_irqsave(&pfc->lock, flags);
+
+	pinmux_type = pfc->pdata->gpios[offset].flags & PINMUX_FLAG_TYPE;
+
+	/*
+	 * See if the present config needs to first be de-configured.
+	 */
+	switch (pinmux_type) {
+	case PINMUX_TYPE_GPIO:
+		break;
+	case PINMUX_TYPE_OUTPUT:
+	case PINMUX_TYPE_INPUT:
+	case PINMUX_TYPE_INPUT_PULLUP:
+	case PINMUX_TYPE_INPUT_PULLDOWN:
+		sh_pfc_config_gpio(pfc, offset, pinmux_type, GPIO_CFG_FREE);
+		break;
+	default:
+		goto err;
+	}
+
+	/*
+	 * Dry run
+	 */
+	if (sh_pfc_config_gpio(pfc, offset, new_type,
+			       GPIO_CFG_DRYRUN) != 0)
+		goto err;
+
+	/*
+	 * Request
+	 */
+	if (sh_pfc_config_gpio(pfc, offset, new_type,
+			       GPIO_CFG_REQ) != 0)
+		goto err;
+
+	pfc->pdata->gpios[offset].flags &= ~PINMUX_FLAG_TYPE;
+	pfc->pdata->gpios[offset].flags |= new_type;
+
+	ret = 0;
+
+err:
+	spin_unlock_irqrestore(&pfc->lock, flags);
+
+	return ret;
+}
+
+
+static int sh_pfc_gpio_request_enable(struct pinctrl_dev *pctldev,
+				      struct pinctrl_gpio_range *range,
+				      unsigned offset)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+	struct sh_pfc *pfc = pmx->pfc;
+	unsigned long flags;
+	int ret, pinmux_type;
+
+	spin_lock_irqsave(&pfc->lock, flags);
+
+	pinmux_type = pfc->pdata->gpios[offset].flags & PINMUX_FLAG_TYPE;
+
+	switch (pinmux_type) {
+	case PINMUX_TYPE_FUNCTION:
+		pr_notice_once("Use of GPIO API for function requests is "
+			       "deprecated, convert to pinctrl\n");
+		/* handle for now */
+		ret = sh_pfc_config_function(pfc, offset);
+		if (unlikely(ret < 0))
+			goto err;
+
+		break;
+	case PINMUX_TYPE_GPIO:
+	case PINMUX_TYPE_INPUT:
+	case PINMUX_TYPE_OUTPUT:
+		break;
+	default:
+		pr_err("Unsupported mux type (%d), bailing...\n", pinmux_type);
+		ret = -ENOTSUPP;
+		goto err;
+	}
+
+	ret = 0;
+
+err:
+	spin_unlock_irqrestore(&pfc->lock, flags);
+
+	return ret;
+}
+
+static void sh_pfc_gpio_disable_free(struct pinctrl_dev *pctldev,
+				     struct pinctrl_gpio_range *range,
+				     unsigned offset)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+	struct sh_pfc *pfc = pmx->pfc;
+	unsigned long flags;
+	int pinmux_type;
+
+	spin_lock_irqsave(&pfc->lock, flags);
+
+	pinmux_type = pfc->pdata->gpios[offset].flags & PINMUX_FLAG_TYPE;
+
+	sh_pfc_config_gpio(pfc, offset, pinmux_type, GPIO_CFG_FREE);
+
+	spin_unlock_irqrestore(&pfc->lock, flags);
+}
+
+static int sh_pfc_gpio_set_direction(struct pinctrl_dev *pctldev,
+				     struct pinctrl_gpio_range *range,
+				     unsigned offset, bool input)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+	int type = input ? PINMUX_TYPE_INPUT : PINMUX_TYPE_OUTPUT;
+
+	return sh_pfc_reconfig_pin(pmx->pfc, offset, type);
+}
+
+static struct pinmux_ops sh_pfc_pinmux_ops = {
+	.get_functions_count	= sh_pfc_get_functions_count,
+	.get_function_name	= sh_pfc_get_function_name,
+	.get_function_groups	= sh_pfc_get_function_groups,
+	.enable			= sh_pfc_noop_enable,
+	.disable		= sh_pfc_noop_disable,
+	.gpio_request_enable	= sh_pfc_gpio_request_enable,
+	.gpio_disable_free	= sh_pfc_gpio_disable_free,
+	.gpio_set_direction	= sh_pfc_gpio_set_direction,
+};
+
+static int sh_pfc_pinconf_get(struct pinctrl_dev *pctldev, unsigned pin,
+			      unsigned long *config)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+	struct sh_pfc *pfc = pmx->pfc;
+
+	*config = pfc->pdata->gpios[pin].flags & PINMUX_FLAG_TYPE;
+
+	return 0;
+}
+
+static int sh_pfc_pinconf_set(struct pinctrl_dev *pctldev, unsigned pin,
+			      unsigned long config)
+{
+	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	/* Validate the new type */
+	if (config >= PINMUX_FLAG_TYPE)
+		return -EINVAL;
+
+	return sh_pfc_reconfig_pin(pmx->pfc, pin, config);
+}
+
+static void sh_pfc_pinconf_dbg_show(struct pinctrl_dev *pctldev,
+				    struct seq_file *s, unsigned pin)
+{
+	const char *pinmux_type_str[] = {
+		[PINMUX_TYPE_NONE]		= "none",
+		[PINMUX_TYPE_FUNCTION]		= "function",
+		[PINMUX_TYPE_GPIO]		= "gpio",
+		[PINMUX_TYPE_OUTPUT]		= "output",
+		[PINMUX_TYPE_INPUT]		= "input",
+		[PINMUX_TYPE_INPUT_PULLUP]	= "input bias pull up",
+		[PINMUX_TYPE_INPUT_PULLDOWN]	= "input bias pull down",
+	};
+	unsigned long config;
+	int rc;
+
+	rc = sh_pfc_pinconf_get(pctldev, pin, &config);
+	if (unlikely(rc != 0))
+		return;
+
+	seq_printf(s, " %s", pinmux_type_str[config]);
+}
+
+static struct pinconf_ops sh_pfc_pinconf_ops = {
+	.pin_config_get		= sh_pfc_pinconf_get,
+	.pin_config_set		= sh_pfc_pinconf_set,
+	.pin_config_dbg_show	= sh_pfc_pinconf_dbg_show,
+};
+
+static struct pinctrl_gpio_range sh_pfc_gpio_range = {
+	.name		= DRV_NAME,
+	.id		= 0,
+};
+
+static struct pinctrl_desc sh_pfc_pinctrl_desc = {
+	.name		= DRV_NAME,
+	.owner		= THIS_MODULE,
+	.pctlops	= &sh_pfc_pinctrl_ops,
+	.pmxops		= &sh_pfc_pinmux_ops,
+	.confops	= &sh_pfc_pinconf_ops,
+};
+
+static void __devinit sh_pfc_map_one_gpio(struct sh_pfc *pfc,
+					  struct sh_pfc_pinctrl *pmx,
+					  struct pinmux_gpio *gpio,
+					  unsigned offset)
+{
+	struct pinmux_data_reg *dummy;
+	unsigned long flags;
+	int bit;
+
+	gpio->flags &= ~PINMUX_FLAG_TYPE;
+
+	if (sh_pfc_get_data_reg(pfc, offset, &dummy, &bit) == 0)
+		gpio->flags |= PINMUX_TYPE_GPIO;
+	else {
+		gpio->flags |= PINMUX_TYPE_FUNCTION;
+
+		spin_lock_irqsave(&pmx->lock, flags);
+		pmx->nr_functions++;
+		spin_unlock_irqrestore(&pmx->lock, flags);
+	}
+}
+
+/* pinmux ranges -> pinctrl pin descs */
+static int __devinit sh_pfc_map_gpios(struct sh_pfc *pfc,
+				      struct sh_pfc_pinctrl *pmx)
+{
+	unsigned long flags;
+	int i;
+
+	pmx->nr_pads = pfc->pdata->last_gpio - pfc->pdata->first_gpio + 1;
+
+	pmx->pads = kmalloc(sizeof(struct pinctrl_pin_desc) * pmx->nr_pads,
+			    GFP_KERNEL);
+	if (unlikely(!pmx->pads)) {
+		pmx->nr_pads = 0;
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&pfc->lock, flags);
+
+	/*
+	 * We don't necessarily have a 1:1 mapping between pin and linux
+	 * GPIO number, as the latter maps to the associated enum_id.
+	 * Care needs to be taken to translate back to pin space when
+	 * dealing with any pin configurations.
+	 */
+	for (i = 0; i < pmx->nr_pads; i++) {
+		struct pinctrl_pin_desc *pin = pmx->pads + i;
+		struct pinmux_gpio *gpio = pfc->pdata->gpios + i;
+
+		pin->number = pfc->pdata->first_gpio + i;
+		pin->name = gpio->name;
+
+		/* XXX */
+		if (unlikely(!gpio->enum_id))
+			continue;
+
+		sh_pfc_map_one_gpio(pfc, pmx, gpio, i);
+	}
+
+	spin_unlock_irqrestore(&pfc->lock, flags);
+
+	sh_pfc_pinctrl_desc.pins = pmx->pads;
+	sh_pfc_pinctrl_desc.npins = pmx->nr_pads;
+
+	return 0;
+}
+
+static int __devinit sh_pfc_map_functions(struct sh_pfc *pfc,
+					  struct sh_pfc_pinctrl *pmx)
+{
+	unsigned long flags;
+	int i, fn;
+
+	pmx->functions = kzalloc(pmx->nr_functions * sizeof(void *),
+				 GFP_KERNEL);
+	if (unlikely(!pmx->functions))
+		return -ENOMEM;
+
+	spin_lock_irqsave(&pmx->lock, flags);
+
+	for (i = fn = 0; i < pmx->nr_pads; i++) {
+		struct pinmux_gpio *gpio = pfc->pdata->gpios + i;
+
+		if ((gpio->flags & PINMUX_FLAG_TYPE) == PINMUX_TYPE_FUNCTION)
+			pmx->functions[fn++] = gpio;
+	}
+
+	spin_unlock_irqrestore(&pmx->lock, flags);
+
+	return 0;
+}
+
+int sh_pfc_register_pinctrl(struct sh_pfc *pfc)
+{
+	struct sh_pfc_pinctrl *pmx;
+	int ret;
+
+	pmx = kzalloc(sizeof(struct sh_pfc_pinctrl), GFP_KERNEL);
+	if (unlikely(!pmx))
+		return -ENOMEM;
+
+	spin_lock_init(&pmx->lock);
+
+	pmx->pfc = pfc;
+	pfc->pinctrl = pmx;
+
+	ret = sh_pfc_map_gpios(pfc, pmx);
+	if (unlikely(ret != 0))
+		return ret;
+
+	ret = sh_pfc_map_functions(pfc, pmx);
+	if (unlikely(ret != 0))
+		goto free_pads;
+
+	pmx->pctl = pinctrl_register(&sh_pfc_pinctrl_desc, pfc->dev, pmx);
+	if (IS_ERR(pmx->pctl)) {
+		ret = PTR_ERR(pmx->pctl);
+		goto free_functions;
+	}
+
+	sh_pfc_gpio_range.npins = pfc->pdata->last_gpio
+				- pfc->pdata->first_gpio + 1;
+	sh_pfc_gpio_range.base = pfc->pdata->first_gpio;
+	sh_pfc_gpio_range.pin_base = pfc->pdata->first_gpio;
+
+	pinctrl_add_gpio_range(pmx->pctl, &sh_pfc_gpio_range);
+
+	return 0;
+
+free_functions:
+	kfree(pmx->functions);
+free_pads:
+	kfree(pmx->pads);
+	kfree(pmx);
+
+	return ret;
+}
+
+int __devexit sh_pfc_unregister_pinctrl(struct sh_pfc *pfc)
+{
+	struct sh_pfc_pinctrl *pmx = pfc->pinctrl;
+
+	pinctrl_unregister(pmx->pctl);
+
+	kfree(pmx->functions);
+	kfree(pmx->pads);
+	kfree(pmx);
+
+	pfc->pinctrl = NULL;
+	return 0;
+}
diff --git a/drivers/sh/Kconfig b/drivers/sh/Kconfig
index d860ef7..f168a61 100644
--- a/drivers/sh/Kconfig
+++ b/drivers/sh/Kconfig
@@ -1,6 +1,5 @@
 menu "SuperH / SH-Mobile Driver Options"
 
 source "drivers/sh/intc/Kconfig"
-source "drivers/sh/pfc/Kconfig"
 
 endmenu
diff --git a/drivers/sh/Makefile b/drivers/sh/Makefile
index e57895b..fc67f56 100644
--- a/drivers/sh/Makefile
+++ b/drivers/sh/Makefile
@@ -5,7 +5,6 @@ obj-y	:= intc/
 
 obj-$(CONFIG_HAVE_CLK)		+= clk/
 obj-$(CONFIG_MAPLE)		+= maple/
-obj-$(CONFIG_SH_PFC)		+= pfc/
 obj-$(CONFIG_SUPERHYWAY)	+= superhyway/
 
 obj-y				+= pm_runtime.o
diff --git a/drivers/sh/pfc/Kconfig b/drivers/sh/pfc/Kconfig
deleted file mode 100644
index eaeabc5..0000000
--- a/drivers/sh/pfc/Kconfig
+++ /dev/null
@@ -1,18 +0,0 @@
-comment "Pin function controller options"
-
-config SH_PFC
-	# XXX move off the gpio dependency
-	depends on GENERIC_GPIO
-	select GPIO_SH_PFC if ARCH_REQUIRE_GPIOLIB
-	select PINCTRL_SH_PFC
-	select PINCTRL
-	select PINMUX
-	select PINCONF
-	def_bool y
-
-config GPIO_SH_PFC
-	bool "SuperH PFC GPIO support"
-	depends on SH_PFC && GPIOLIB
-	help
-	  This enables support for GPIOs within the SoC's pin function
-	  controller.
diff --git a/drivers/sh/pfc/Makefile b/drivers/sh/pfc/Makefile
deleted file mode 100644
index 6315cf3..0000000
--- a/drivers/sh/pfc/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-sh-pfc-objs			= core.o pinctrl.o
-ifeq ($(CONFIG_GPIO_SH_PFC),y)
-sh-pfc-objs			+= gpio.o
-endif
-obj-y				+= sh-pfc.o
diff --git a/drivers/sh/pfc/core.c b/drivers/sh/pfc/core.c
deleted file mode 100644
index 68b40d8..0000000
--- a/drivers/sh/pfc/core.c
+++ /dev/null
@@ -1,611 +0,0 @@
-/*
- * SuperH Pin Function Controller support.
- *
- * Copyright (C) 2008 Magnus Damm
- * Copyright (C) 2009 - 2012 Paul Mundt
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#define DRV_NAME "sh-pfc"
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/bitops.h>
-#include <linux/err.h>
-#include <linux/errno.h>
-#include <linux/io.h>
-#include <linux/ioport.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/sh_pfc.h>
-#include <linux/slab.h>
-#include <linux/pinctrl/machine.h>
-#include <linux/platform_device.h>
-
-#include "core.h"
-
-static void pfc_iounmap(struct sh_pfc *pfc)
-{
-	int k;
-
-	for (k = 0; k < pfc->num_windows; k++)
-		if (pfc->window[k].virt)
-			iounmap(pfc->window[k].virt);
-
-	kfree(pfc->window);
-	pfc->num_windows = 0;
-	pfc->window = NULL;
-}
-
-static int pfc_ioremap(struct sh_pfc *pfc, struct platform_device *pdev)
-{
-	struct resource *res;
-	int k;
-
-	if (pdev->num_resources == 0) {
-		pfc->num_windows = 0;
-		return 0;
-	}
-
-	pfc->window = kzalloc(pdev->num_resources * sizeof(*pfc->window),
-			      GFP_NOWAIT);
-	if (!pfc->window)
-		goto err1;
-
-	pfc->num_windows = pdev->num_resources;
-
-	for (k = 0, res = pdev->resource; k < pdev->num_resources; k++, res++) {
-		WARN_ON(resource_type(res) != IORESOURCE_MEM);
-		pfc->window[k].phys = res->start;
-		pfc->window[k].size = resource_size(res);
-		pfc->window[k].virt = ioremap_nocache(res->start,
-							 resource_size(res));
-		if (!pfc->window[k].virt)
-			goto err2;
-	}
-
-	return 0;
-
-err2:
-	pfc_iounmap(pfc);
-err1:
-	return -1;
-}
-
-static void __iomem *pfc_phys_to_virt(struct sh_pfc *pfc,
-				      unsigned long address)
-{
-	struct pfc_window *window;
-	int k;
-
-	/* scan through physical windows and convert address */
-	for (k = 0; k < pfc->num_windows; k++) {
-		window = pfc->window + k;
-
-		if (address < window->phys)
-			continue;
-
-		if (address >= (window->phys + window->size))
-			continue;
-
-		return window->virt + (address - window->phys);
-	}
-
-	/* no windows defined, register must be 1:1 mapped virt:phys */
-	return (void __iomem *)address;
-}
-
-static int enum_in_range(pinmux_enum_t enum_id, struct pinmux_range *r)
-{
-	if (enum_id < r->begin)
-		return 0;
-
-	if (enum_id > r->end)
-		return 0;
-
-	return 1;
-}
-
-static unsigned long gpio_read_raw_reg(void __iomem *mapped_reg,
-				       unsigned long reg_width)
-{
-	switch (reg_width) {
-	case 8:
-		return ioread8(mapped_reg);
-	case 16:
-		return ioread16(mapped_reg);
-	case 32:
-		return ioread32(mapped_reg);
-	}
-
-	BUG();
-	return 0;
-}
-
-static void gpio_write_raw_reg(void __iomem *mapped_reg,
-			       unsigned long reg_width,
-			       unsigned long data)
-{
-	switch (reg_width) {
-	case 8:
-		iowrite8(data, mapped_reg);
-		return;
-	case 16:
-		iowrite16(data, mapped_reg);
-		return;
-	case 32:
-		iowrite32(data, mapped_reg);
-		return;
-	}
-
-	BUG();
-}
-
-int sh_pfc_read_bit(struct pinmux_data_reg *dr, unsigned long in_pos)
-{
-	unsigned long pos;
-
-	pos = dr->reg_width - (in_pos + 1);
-
-	pr_debug("read_bit: addr = %lx, pos = %ld, "
-		 "r_width = %ld\n", dr->reg, pos, dr->reg_width);
-
-	return (gpio_read_raw_reg(dr->mapped_reg, dr->reg_width) >> pos) & 1;
-}
-
-void sh_pfc_write_bit(struct pinmux_data_reg *dr, unsigned long in_pos,
-		      unsigned long value)
-{
-	unsigned long pos;
-
-	pos = dr->reg_width - (in_pos + 1);
-
-	pr_debug("write_bit addr = %lx, value = %d, pos = %ld, "
-		 "r_width = %ld\n",
-		 dr->reg, !!value, pos, dr->reg_width);
-
-	if (value)
-		set_bit(pos, &dr->reg_shadow);
-	else
-		clear_bit(pos, &dr->reg_shadow);
-
-	gpio_write_raw_reg(dr->mapped_reg, dr->reg_width, dr->reg_shadow);
-}
-
-static void config_reg_helper(struct sh_pfc *pfc,
-			      struct pinmux_cfg_reg *crp,
-			      unsigned long in_pos,
-			      void __iomem **mapped_regp,
-			      unsigned long *maskp,
-			      unsigned long *posp)
-{
-	int k;
-
-	*mapped_regp = pfc_phys_to_virt(pfc, crp->reg);
-
-	if (crp->field_width) {
-		*maskp = (1 << crp->field_width) - 1;
-		*posp = crp->reg_width - ((in_pos + 1) * crp->field_width);
-	} else {
-		*maskp = (1 << crp->var_field_width[in_pos]) - 1;
-		*posp = crp->reg_width;
-		for (k = 0; k <= in_pos; k++)
-			*posp -= crp->var_field_width[k];
-	}
-}
-
-static int read_config_reg(struct sh_pfc *pfc,
-			   struct pinmux_cfg_reg *crp,
-			   unsigned long field)
-{
-	void __iomem *mapped_reg;
-	unsigned long mask, pos;
-
-	config_reg_helper(pfc, crp, field, &mapped_reg, &mask, &pos);
-
-	pr_debug("read_reg: addr = %lx, field = %ld, "
-		 "r_width = %ld, f_width = %ld\n",
-		 crp->reg, field, crp->reg_width, crp->field_width);
-
-	return (gpio_read_raw_reg(mapped_reg, crp->reg_width) >> pos) & mask;
-}
-
-static void write_config_reg(struct sh_pfc *pfc,
-			     struct pinmux_cfg_reg *crp,
-			     unsigned long field, unsigned long value)
-{
-	void __iomem *mapped_reg;
-	unsigned long mask, pos, data;
-
-	config_reg_helper(pfc, crp, field, &mapped_reg, &mask, &pos);
-
-	pr_debug("write_reg addr = %lx, value = %ld, field = %ld, "
-		 "r_width = %ld, f_width = %ld\n",
-		 crp->reg, value, field, crp->reg_width, crp->field_width);
-
-	mask = ~(mask << pos);
-	value = value << pos;
-
-	data = gpio_read_raw_reg(mapped_reg, crp->reg_width);
-	data &= mask;
-	data |= value;
-
-	if (pfc->pdata->unlock_reg)
-		gpio_write_raw_reg(pfc_phys_to_virt(pfc, pfc->pdata->unlock_reg),
-				   32, ~data);
-
-	gpio_write_raw_reg(mapped_reg, crp->reg_width, data);
-}
-
-static int setup_data_reg(struct sh_pfc *pfc, unsigned gpio)
-{
-	struct pinmux_gpio *gpiop = &pfc->pdata->gpios[gpio];
-	struct pinmux_data_reg *data_reg;
-	int k, n;
-
-	if (!enum_in_range(gpiop->enum_id, &pfc->pdata->data))
-		return -1;
-
-	k = 0;
-	while (1) {
-		data_reg = pfc->pdata->data_regs + k;
-
-		if (!data_reg->reg_width)
-			break;
-
-		data_reg->mapped_reg = pfc_phys_to_virt(pfc, data_reg->reg);
-
-		for (n = 0; n < data_reg->reg_width; n++) {
-			if (data_reg->enum_ids[n] == gpiop->enum_id) {
-				gpiop->flags &= ~PINMUX_FLAG_DREG;
-				gpiop->flags |= (k << PINMUX_FLAG_DREG_SHIFT);
-				gpiop->flags &= ~PINMUX_FLAG_DBIT;
-				gpiop->flags |= (n << PINMUX_FLAG_DBIT_SHIFT);
-				return 0;
-			}
-		}
-		k++;
-	}
-
-	BUG();
-
-	return -1;
-}
-
-static void setup_data_regs(struct sh_pfc *pfc)
-{
-	struct pinmux_data_reg *drp;
-	int k;
-
-	for (k = pfc->pdata->first_gpio; k <= pfc->pdata->last_gpio; k++)
-		setup_data_reg(pfc, k);
-
-	k = 0;
-	while (1) {
-		drp = pfc->pdata->data_regs + k;
-
-		if (!drp->reg_width)
-			break;
-
-		drp->reg_shadow = gpio_read_raw_reg(drp->mapped_reg,
-						    drp->reg_width);
-		k++;
-	}
-}
-
-int sh_pfc_get_data_reg(struct sh_pfc *pfc, unsigned gpio,
-			struct pinmux_data_reg **drp, int *bitp)
-{
-	struct pinmux_gpio *gpiop = &pfc->pdata->gpios[gpio];
-	int k, n;
-
-	if (!enum_in_range(gpiop->enum_id, &pfc->pdata->data))
-		return -1;
-
-	k = (gpiop->flags & PINMUX_FLAG_DREG) >> PINMUX_FLAG_DREG_SHIFT;
-	n = (gpiop->flags & PINMUX_FLAG_DBIT) >> PINMUX_FLAG_DBIT_SHIFT;
-	*drp = pfc->pdata->data_regs + k;
-	*bitp = n;
-	return 0;
-}
-
-static int get_config_reg(struct sh_pfc *pfc, pinmux_enum_t enum_id,
-			  struct pinmux_cfg_reg **crp,
-			  int *fieldp, int *valuep,
-			  unsigned long **cntp)
-{
-	struct pinmux_cfg_reg *config_reg;
-	unsigned long r_width, f_width, curr_width, ncomb;
-	int k, m, n, pos, bit_pos;
-
-	k = 0;
-	while (1) {
-		config_reg = pfc->pdata->cfg_regs + k;
-
-		r_width = config_reg->reg_width;
-		f_width = config_reg->field_width;
-
-		if (!r_width)
-			break;
-
-		pos = 0;
-		m = 0;
-		for (bit_pos = 0; bit_pos < r_width; bit_pos += curr_width) {
-			if (f_width)
-				curr_width = f_width;
-			else
-				curr_width = config_reg->var_field_width[m];
-
-			ncomb = 1 << curr_width;
-			for (n = 0; n < ncomb; n++) {
-				if (config_reg->enum_ids[pos + n] == enum_id) {
-					*crp = config_reg;
-					*fieldp = m;
-					*valuep = n;
-					*cntp = &config_reg->cnt[m];
-					return 0;
-				}
-			}
-			pos += ncomb;
-			m++;
-		}
-		k++;
-	}
-
-	return -1;
-}
-
-int sh_pfc_gpio_to_enum(struct sh_pfc *pfc, unsigned gpio, int pos,
-			pinmux_enum_t *enum_idp)
-{
-	pinmux_enum_t enum_id = pfc->pdata->gpios[gpio].enum_id;
-	pinmux_enum_t *data = pfc->pdata->gpio_data;
-	int k;
-
-	if (!enum_in_range(enum_id, &pfc->pdata->data)) {
-		if (!enum_in_range(enum_id, &pfc->pdata->mark)) {
-			pr_err("non data/mark enum_id for gpio %d\n", gpio);
-			return -1;
-		}
-	}
-
-	if (pos) {
-		*enum_idp = data[pos + 1];
-		return pos + 1;
-	}
-
-	for (k = 0; k < pfc->pdata->gpio_data_size; k++) {
-		if (data[k] == enum_id) {
-			*enum_idp = data[k + 1];
-			return k + 1;
-		}
-	}
-
-	pr_err("cannot locate data/mark enum_id for gpio %d\n", gpio);
-	return -1;
-}
-
-int sh_pfc_config_gpio(struct sh_pfc *pfc, unsigned gpio, int pinmux_type,
-		       int cfg_mode)
-{
-	struct pinmux_cfg_reg *cr = NULL;
-	pinmux_enum_t enum_id;
-	struct pinmux_range *range;
-	int in_range, pos, field, value;
-	unsigned long *cntp;
-
-	switch (pinmux_type) {
-
-	case PINMUX_TYPE_FUNCTION:
-		range = NULL;
-		break;
-
-	case PINMUX_TYPE_OUTPUT:
-		range = &pfc->pdata->output;
-		break;
-
-	case PINMUX_TYPE_INPUT:
-		range = &pfc->pdata->input;
-		break;
-
-	case PINMUX_TYPE_INPUT_PULLUP:
-		range = &pfc->pdata->input_pu;
-		break;
-
-	case PINMUX_TYPE_INPUT_PULLDOWN:
-		range = &pfc->pdata->input_pd;
-		break;
-
-	default:
-		goto out_err;
-	}
-
-	pos = 0;
-	enum_id = 0;
-	field = 0;
-	value = 0;
-	while (1) {
-		pos = sh_pfc_gpio_to_enum(pfc, gpio, pos, &enum_id);
-		if (pos <= 0)
-			goto out_err;
-
-		if (!enum_id)
-			break;
-
-		/* first check if this is a function enum */
-		in_range = enum_in_range(enum_id, &pfc->pdata->function);
-		if (!in_range) {
-			/* not a function enum */
-			if (range) {
-				/*
-				 * other range exists, so this pin is
-				 * a regular GPIO pin that now is being
-				 * bound to a specific direction.
-				 *
-				 * for this case we only allow function enums
-				 * and the enums that match the other range.
-				 */
-				in_range = enum_in_range(enum_id, range);
-
-				/*
-				 * special case pass through for fixed
-				 * input-only or output-only pins without
-				 * function enum register association.
-				 */
-				if (in_range && enum_id == range->force)
-					continue;
-			} else {
-				/*
-				 * no other range exists, so this pin
-				 * must then be of the function type.
-				 *
-				 * allow function type pins to select
-				 * any combination of function/in/out
-				 * in their MARK lists.
-				 */
-				in_range = 1;
-			}
-		}
-
-		if (!in_range)
-			continue;
-
-		if (get_config_reg(pfc, enum_id, &cr,
-				   &field, &value, &cntp) != 0)
-			goto out_err;
-
-		switch (cfg_mode) {
-		case GPIO_CFG_DRYRUN:
-			if (!*cntp ||
-			    (read_config_reg(pfc, cr, field) != value))
-				continue;
-			break;
-
-		case GPIO_CFG_REQ:
-			write_config_reg(pfc, cr, field, value);
-			*cntp = *cntp + 1;
-			break;
-
-		case GPIO_CFG_FREE:
-			*cntp = *cntp - 1;
-			break;
-		}
-	}
-
-	return 0;
- out_err:
-	return -1;
-}
-
-static int sh_pfc_probe(struct platform_device *pdev)
-{
-	struct sh_pfc_platform_data *pdata = pdev->dev.platform_data;
-	struct sh_pfc *pfc;
-	int ret;
-
-	/*
-	 * Ensure that the type encoding fits
-	 */
-	BUILD_BUG_ON(PINMUX_FLAG_TYPE > ((1 << PINMUX_FLAG_DBIT_SHIFT) - 1));
-
-	if (pdata == NULL)
-		return -ENODEV;
-
-	pfc = devm_kzalloc(&pdev->dev, sizeof(pfc), GFP_KERNEL);
-	if (pfc == NULL)
-		return -ENOMEM;
-
-	pfc->pdata = pdata;
-	pfc->dev = &pdev->dev;
-
-	ret = pfc_ioremap(pfc, pdev);
-	if (unlikely(ret < 0))
-		return ret;
-
-	spin_lock_init(&pfc->lock);
-
-	pinctrl_provide_dummies();
-	setup_data_regs(pfc);
-
-	/*
-	 * Initialize pinctrl bindings first
-	 */
-	ret = sh_pfc_register_pinctrl(pfc);
-	if (unlikely(ret != 0))
-		goto err;
-
-#ifdef CONFIG_GPIO_SH_PFC
-	/*
-	 * Then the GPIO chip
-	 */
-	ret = sh_pfc_register_gpiochip(pfc);
-	if (unlikely(ret != 0)) {
-		/*
-		 * If the GPIO chip fails to come up we still leave the
-		 * PFC state as it is, given that there are already
-		 * extant users of it that have succeeded by this point.
-		 */
-		pr_notice("failed to init GPIO chip, ignoring...\n");
-	}
-#endif
-
-	platform_set_drvdata(pdev, pfc);
-
-	pr_info("%s support registered\n", pdata->name);
-
-	return 0;
-
-err:
-	pfc_iounmap(pfc);
-	return ret;
-}
-
-static int __devexit sh_pfc_remove(struct platform_device *pdev)
-{
-	struct sh_pfc *pfc = platform_get_drvdata(pdev);
-
-#ifdef CONFIG_GPIO_SH_PFC
-	sh_pfc_unregister_gpiochip(pfc);
-#endif
-	sh_pfc_unregister_pinctrl(pfc);
-
-	pfc_iounmap(pfc);
-
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
-}
-
-static const struct platform_device_id sh_pfc_id_table[] = {
-	{ "sh-pfc", 0 },
-	{ },
-};
-MODULE_DEVICE_TABLE(platform, sh_pfc_id_table);
-
-static struct platform_driver sh_pfc_driver = {
-	.probe		= sh_pfc_probe,
-	.remove		= __devexit_p(sh_pfc_remove),
-	.id_table	= sh_pfc_id_table,
-	.driver		= {
-		.name	= DRV_NAME,
-		.owner	= THIS_MODULE,
-	},
-};
-
-static int __init sh_pfc_init(void)
-{
-	return platform_driver_register(&sh_pfc_driver);
-}
-postcore_initcall(sh_pfc_init);
-
-static void __exit sh_pfc_exit(void)
-{
-	platform_driver_unregister(&sh_pfc_driver);
-}
-module_exit(sh_pfc_exit);
-
-MODULE_AUTHOR("Magnus Damm, Paul Mundt");
-MODULE_DESCRIPTION("Pin Control and GPIO driver for SuperH pin function controller");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/sh/pfc/core.h b/drivers/sh/pfc/core.h
deleted file mode 100644
index b71f559..0000000
--- a/drivers/sh/pfc/core.h
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- * SuperH Pin Function Controller support.
- *
- * Copyright (C) 2012  Renesas Solutions Corp.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-#ifndef __SH_PFC_CORE_H__
-#define __SH_PFC_CORE_H__
-
-#include <linux/compiler.h>
-#include <linux/sh_pfc.h>
-#include <linux/types.h>
-
-struct pfc_window {
-	phys_addr_t phys;
-	void __iomem *virt;
-	unsigned long size;
-};
-
-struct sh_pfc_chip;
-struct sh_pfc_pinctrl;
-
-struct sh_pfc {
-	struct device *dev;
-	struct sh_pfc_platform_data *pdata;
-	spinlock_t lock;
-
-	unsigned int num_windows;
-	struct pfc_window *window;
-
-	struct sh_pfc_chip *gpio;
-	struct sh_pfc_pinctrl *pinctrl;
-};
-
-int sh_pfc_register_gpiochip(struct sh_pfc *pfc);
-int sh_pfc_unregister_gpiochip(struct sh_pfc *pfc);
-
-int sh_pfc_register_pinctrl(struct sh_pfc *pfc);
-int sh_pfc_unregister_pinctrl(struct sh_pfc *pfc);
-
-int sh_pfc_read_bit(struct pinmux_data_reg *dr, unsigned long in_pos);
-void sh_pfc_write_bit(struct pinmux_data_reg *dr, unsigned long in_pos,
-		      unsigned long value);
-int sh_pfc_get_data_reg(struct sh_pfc *pfc, unsigned gpio,
-			struct pinmux_data_reg **drp, int *bitp);
-int sh_pfc_gpio_to_enum(struct sh_pfc *pfc, unsigned gpio, int pos,
-			pinmux_enum_t *enum_idp);
-int sh_pfc_config_gpio(struct sh_pfc *pfc, unsigned gpio, int pinmux_type,
-		       int cfg_mode);
-
-#endif /* __SH_PFC_CORE_H__ */
diff --git a/drivers/sh/pfc/gpio.c b/drivers/sh/pfc/gpio.c
deleted file mode 100644
index 9f4f0fd..0000000
--- a/drivers/sh/pfc/gpio.c
+++ /dev/null
@@ -1,181 +0,0 @@
-/*
- * SuperH Pin Function Controller GPIO driver.
- *
- * Copyright (C) 2008 Magnus Damm
- * Copyright (C) 2009 - 2012 Paul Mundt
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME " gpio: " fmt
-
-#include <linux/gpio.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/pinctrl/consumer.h>
-#include <linux/sh_pfc.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-
-#include "core.h"
-
-struct sh_pfc_chip {
-	struct sh_pfc		*pfc;
-	struct gpio_chip	gpio_chip;
-};
-
-static struct sh_pfc_chip *gpio_to_pfc_chip(struct gpio_chip *gc)
-{
-	return container_of(gc, struct sh_pfc_chip, gpio_chip);
-}
-
-static struct sh_pfc *gpio_to_pfc(struct gpio_chip *gc)
-{
-	return gpio_to_pfc_chip(gc)->pfc;
-}
-
-static int sh_gpio_request(struct gpio_chip *gc, unsigned offset)
-{
-	return pinctrl_request_gpio(offset);
-}
-
-static void sh_gpio_free(struct gpio_chip *gc, unsigned offset)
-{
-	pinctrl_free_gpio(offset);
-}
-
-static void sh_gpio_set_value(struct sh_pfc *pfc, unsigned gpio, int value)
-{
-	struct pinmux_data_reg *dr = NULL;
-	int bit = 0;
-
-	if (sh_pfc_get_data_reg(pfc, gpio, &dr, &bit) != 0)
-		BUG();
-	else
-		sh_pfc_write_bit(dr, bit, value);
-}
-
-static int sh_gpio_get_value(struct sh_pfc *pfc, unsigned gpio)
-{
-	struct pinmux_data_reg *dr = NULL;
-	int bit = 0;
-
-	if (sh_pfc_get_data_reg(pfc, gpio, &dr, &bit) != 0)
-		return -EINVAL;
-
-	return sh_pfc_read_bit(dr, bit);
-}
-
-static int sh_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
-{
-	return pinctrl_gpio_direction_input(offset);
-}
-
-static int sh_gpio_direction_output(struct gpio_chip *gc, unsigned offset,
-				    int value)
-{
-	sh_gpio_set_value(gpio_to_pfc(gc), offset, value);
-
-	return pinctrl_gpio_direction_output(offset);
-}
-
-static int sh_gpio_get(struct gpio_chip *gc, unsigned offset)
-{
-	return sh_gpio_get_value(gpio_to_pfc(gc), offset);
-}
-
-static void sh_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
-{
-	sh_gpio_set_value(gpio_to_pfc(gc), offset, value);
-}
-
-static int sh_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
-{
-	struct sh_pfc *pfc = gpio_to_pfc(gc);
-	pinmux_enum_t enum_id;
-	pinmux_enum_t *enum_ids;
-	int i, k, pos;
-
-	pos = 0;
-	enum_id = 0;
-	while (1) {
-		pos = sh_pfc_gpio_to_enum(pfc, offset, pos, &enum_id);
-		if (pos <= 0 || !enum_id)
-			break;
-
-		for (i = 0; i < pfc->pdata->gpio_irq_size; i++) {
-			enum_ids = pfc->pdata->gpio_irq[i].enum_ids;
-			for (k = 0; enum_ids[k]; k++) {
-				if (enum_ids[k] == enum_id)
-					return pfc->pdata->gpio_irq[i].irq;
-			}
-		}
-	}
-
-	return -ENOSYS;
-}
-
-static void sh_pfc_gpio_setup(struct sh_pfc_chip *chip)
-{
-	struct sh_pfc *pfc = chip->pfc;
-	struct gpio_chip *gc = &chip->gpio_chip;
-
-	gc->request = sh_gpio_request;
-	gc->free = sh_gpio_free;
-	gc->direction_input = sh_gpio_direction_input;
-	gc->get = sh_gpio_get;
-	gc->direction_output = sh_gpio_direction_output;
-	gc->set = sh_gpio_set;
-	gc->to_irq = sh_gpio_to_irq;
-
-	WARN_ON(pfc->pdata->first_gpio != 0); /* needs testing */
-
-	gc->label = pfc->pdata->name;
-	gc->owner = THIS_MODULE;
-	gc->base = pfc->pdata->first_gpio;
-	gc->ngpio = (pfc->pdata->last_gpio - pfc->pdata->first_gpio) + 1;
-}
-
-int sh_pfc_register_gpiochip(struct sh_pfc *pfc)
-{
-	struct sh_pfc_chip *chip;
-	int ret;
-
-	chip = kzalloc(sizeof(struct sh_pfc_chip), GFP_KERNEL);
-	if (unlikely(!chip))
-		return -ENOMEM;
-
-	chip->pfc = pfc;
-
-	sh_pfc_gpio_setup(chip);
-
-	ret = gpiochip_add(&chip->gpio_chip);
-	if (unlikely(ret < 0)) {
-		kfree(chip);
-		return ret;
-	}
-
-	pfc->gpio = chip;
-
-	pr_info("%s handling gpio %d -> %d\n",
-		pfc->pdata->name, pfc->pdata->first_gpio,
-		pfc->pdata->last_gpio);
-
-	return 0;
-}
-
-int __exit sh_pfc_unregister_gpiochip(struct sh_pfc *pfc)
-{
-	struct sh_pfc_chip *chip = pfc->gpio;
-	int ret;
-
-	ret = gpiochip_remove(&chip->gpio_chip);
-	if (unlikely(ret < 0))
-		return ret;
-
-	kfree(chip);
-	pfc->gpio = NULL;
-	return 0;
-}
diff --git a/drivers/sh/pfc/pinctrl.c b/drivers/sh/pfc/pinctrl.c
deleted file mode 100644
index c0c8271..0000000
--- a/drivers/sh/pfc/pinctrl.c
+++ /dev/null
@@ -1,481 +0,0 @@
-/*
- * SuperH Pin Function Controller pinmux support.
- *
- * Copyright (C) 2012  Paul Mundt
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#define DRV_NAME "sh-pfc"
-#define pr_fmt(fmt) KBUILD_MODNAME " pinctrl: " fmt
-
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/sh_pfc.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/pinctrl/consumer.h>
-#include <linux/pinctrl/pinconf.h>
-#include <linux/pinctrl/pinconf-generic.h>
-#include <linux/pinctrl/pinctrl.h>
-#include <linux/pinctrl/pinmux.h>
-
-#include "core.h"
-
-struct sh_pfc_pinctrl {
-	struct pinctrl_dev *pctl;
-	struct sh_pfc *pfc;
-
-	struct pinmux_gpio **functions;
-	unsigned int nr_functions;
-
-	struct pinctrl_pin_desc *pads;
-	unsigned int nr_pads;
-
-	spinlock_t lock;
-};
-
-static int sh_pfc_get_groups_count(struct pinctrl_dev *pctldev)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-
-	return pmx->nr_pads;
-}
-
-static const char *sh_pfc_get_group_name(struct pinctrl_dev *pctldev,
-					 unsigned selector)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-
-	return pmx->pads[selector].name;
-}
-
-static int sh_pfc_get_group_pins(struct pinctrl_dev *pctldev, unsigned group,
-				 const unsigned **pins, unsigned *num_pins)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-
-	*pins = &pmx->pads[group].number;
-	*num_pins = 1;
-
-	return 0;
-}
-
-static void sh_pfc_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
-				unsigned offset)
-{
-	seq_printf(s, "%s", DRV_NAME);
-}
-
-static struct pinctrl_ops sh_pfc_pinctrl_ops = {
-	.get_groups_count	= sh_pfc_get_groups_count,
-	.get_group_name		= sh_pfc_get_group_name,
-	.get_group_pins		= sh_pfc_get_group_pins,
-	.pin_dbg_show		= sh_pfc_pin_dbg_show,
-};
-
-static int sh_pfc_get_functions_count(struct pinctrl_dev *pctldev)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-
-	return pmx->nr_functions;
-}
-
-static const char *sh_pfc_get_function_name(struct pinctrl_dev *pctldev,
-					    unsigned selector)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-
-	return pmx->functions[selector]->name;
-}
-
-static int sh_pfc_get_function_groups(struct pinctrl_dev *pctldev, unsigned func,
-				      const char * const **groups,
-				      unsigned * const num_groups)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-
-	*groups = &pmx->functions[func]->name;
-	*num_groups = 1;
-
-	return 0;
-}
-
-static int sh_pfc_noop_enable(struct pinctrl_dev *pctldev, unsigned func,
-			      unsigned group)
-{
-	return 0;
-}
-
-static void sh_pfc_noop_disable(struct pinctrl_dev *pctldev, unsigned func,
-				unsigned group)
-{
-}
-
-static int sh_pfc_config_function(struct sh_pfc *pfc, unsigned offset)
-{
-	if (sh_pfc_config_gpio(pfc, offset,
-			       PINMUX_TYPE_FUNCTION,
-			       GPIO_CFG_DRYRUN) != 0)
-		return -EINVAL;
-
-	if (sh_pfc_config_gpio(pfc, offset,
-			       PINMUX_TYPE_FUNCTION,
-			       GPIO_CFG_REQ) != 0)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int sh_pfc_reconfig_pin(struct sh_pfc *pfc, unsigned offset,
-			       int new_type)
-{
-	unsigned long flags;
-	int pinmux_type;
-	int ret = -EINVAL;
-
-	spin_lock_irqsave(&pfc->lock, flags);
-
-	pinmux_type = pfc->pdata->gpios[offset].flags & PINMUX_FLAG_TYPE;
-
-	/*
-	 * See if the present config needs to first be de-configured.
-	 */
-	switch (pinmux_type) {
-	case PINMUX_TYPE_GPIO:
-		break;
-	case PINMUX_TYPE_OUTPUT:
-	case PINMUX_TYPE_INPUT:
-	case PINMUX_TYPE_INPUT_PULLUP:
-	case PINMUX_TYPE_INPUT_PULLDOWN:
-		sh_pfc_config_gpio(pfc, offset, pinmux_type, GPIO_CFG_FREE);
-		break;
-	default:
-		goto err;
-	}
-
-	/*
-	 * Dry run
-	 */
-	if (sh_pfc_config_gpio(pfc, offset, new_type,
-			       GPIO_CFG_DRYRUN) != 0)
-		goto err;
-
-	/*
-	 * Request
-	 */
-	if (sh_pfc_config_gpio(pfc, offset, new_type,
-			       GPIO_CFG_REQ) != 0)
-		goto err;
-
-	pfc->pdata->gpios[offset].flags &= ~PINMUX_FLAG_TYPE;
-	pfc->pdata->gpios[offset].flags |= new_type;
-
-	ret = 0;
-
-err:
-	spin_unlock_irqrestore(&pfc->lock, flags);
-
-	return ret;
-}
-
-
-static int sh_pfc_gpio_request_enable(struct pinctrl_dev *pctldev,
-				      struct pinctrl_gpio_range *range,
-				      unsigned offset)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-	struct sh_pfc *pfc = pmx->pfc;
-	unsigned long flags;
-	int ret, pinmux_type;
-
-	spin_lock_irqsave(&pfc->lock, flags);
-
-	pinmux_type = pfc->pdata->gpios[offset].flags & PINMUX_FLAG_TYPE;
-
-	switch (pinmux_type) {
-	case PINMUX_TYPE_FUNCTION:
-		pr_notice_once("Use of GPIO API for function requests is "
-			       "deprecated, convert to pinctrl\n");
-		/* handle for now */
-		ret = sh_pfc_config_function(pfc, offset);
-		if (unlikely(ret < 0))
-			goto err;
-
-		break;
-	case PINMUX_TYPE_GPIO:
-	case PINMUX_TYPE_INPUT:
-	case PINMUX_TYPE_OUTPUT:
-		break;
-	default:
-		pr_err("Unsupported mux type (%d), bailing...\n", pinmux_type);
-		ret = -ENOTSUPP;
-		goto err;
-	}
-
-	ret = 0;
-
-err:
-	spin_unlock_irqrestore(&pfc->lock, flags);
-
-	return ret;
-}
-
-static void sh_pfc_gpio_disable_free(struct pinctrl_dev *pctldev,
-				     struct pinctrl_gpio_range *range,
-				     unsigned offset)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-	struct sh_pfc *pfc = pmx->pfc;
-	unsigned long flags;
-	int pinmux_type;
-
-	spin_lock_irqsave(&pfc->lock, flags);
-
-	pinmux_type = pfc->pdata->gpios[offset].flags & PINMUX_FLAG_TYPE;
-
-	sh_pfc_config_gpio(pfc, offset, pinmux_type, GPIO_CFG_FREE);
-
-	spin_unlock_irqrestore(&pfc->lock, flags);
-}
-
-static int sh_pfc_gpio_set_direction(struct pinctrl_dev *pctldev,
-				     struct pinctrl_gpio_range *range,
-				     unsigned offset, bool input)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-	int type = input ? PINMUX_TYPE_INPUT : PINMUX_TYPE_OUTPUT;
-
-	return sh_pfc_reconfig_pin(pmx->pfc, offset, type);
-}
-
-static struct pinmux_ops sh_pfc_pinmux_ops = {
-	.get_functions_count	= sh_pfc_get_functions_count,
-	.get_function_name	= sh_pfc_get_function_name,
-	.get_function_groups	= sh_pfc_get_function_groups,
-	.enable			= sh_pfc_noop_enable,
-	.disable		= sh_pfc_noop_disable,
-	.gpio_request_enable	= sh_pfc_gpio_request_enable,
-	.gpio_disable_free	= sh_pfc_gpio_disable_free,
-	.gpio_set_direction	= sh_pfc_gpio_set_direction,
-};
-
-static int sh_pfc_pinconf_get(struct pinctrl_dev *pctldev, unsigned pin,
-			      unsigned long *config)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-	struct sh_pfc *pfc = pmx->pfc;
-
-	*config = pfc->pdata->gpios[pin].flags & PINMUX_FLAG_TYPE;
-
-	return 0;
-}
-
-static int sh_pfc_pinconf_set(struct pinctrl_dev *pctldev, unsigned pin,
-			      unsigned long config)
-{
-	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-
-	/* Validate the new type */
-	if (config >= PINMUX_FLAG_TYPE)
-		return -EINVAL;
-
-	return sh_pfc_reconfig_pin(pmx->pfc, pin, config);
-}
-
-static void sh_pfc_pinconf_dbg_show(struct pinctrl_dev *pctldev,
-				    struct seq_file *s, unsigned pin)
-{
-	const char *pinmux_type_str[] = {
-		[PINMUX_TYPE_NONE]		= "none",
-		[PINMUX_TYPE_FUNCTION]		= "function",
-		[PINMUX_TYPE_GPIO]		= "gpio",
-		[PINMUX_TYPE_OUTPUT]		= "output",
-		[PINMUX_TYPE_INPUT]		= "input",
-		[PINMUX_TYPE_INPUT_PULLUP]	= "input bias pull up",
-		[PINMUX_TYPE_INPUT_PULLDOWN]	= "input bias pull down",
-	};
-	unsigned long config;
-	int rc;
-
-	rc = sh_pfc_pinconf_get(pctldev, pin, &config);
-	if (unlikely(rc != 0))
-		return;
-
-	seq_printf(s, " %s", pinmux_type_str[config]);
-}
-
-static struct pinconf_ops sh_pfc_pinconf_ops = {
-	.pin_config_get		= sh_pfc_pinconf_get,
-	.pin_config_set		= sh_pfc_pinconf_set,
-	.pin_config_dbg_show	= sh_pfc_pinconf_dbg_show,
-};
-
-static struct pinctrl_gpio_range sh_pfc_gpio_range = {
-	.name		= DRV_NAME,
-	.id		= 0,
-};
-
-static struct pinctrl_desc sh_pfc_pinctrl_desc = {
-	.name		= DRV_NAME,
-	.owner		= THIS_MODULE,
-	.pctlops	= &sh_pfc_pinctrl_ops,
-	.pmxops		= &sh_pfc_pinmux_ops,
-	.confops	= &sh_pfc_pinconf_ops,
-};
-
-static void __devinit sh_pfc_map_one_gpio(struct sh_pfc *pfc,
-					  struct sh_pfc_pinctrl *pmx,
-					  struct pinmux_gpio *gpio,
-					  unsigned offset)
-{
-	struct pinmux_data_reg *dummy;
-	unsigned long flags;
-	int bit;
-
-	gpio->flags &= ~PINMUX_FLAG_TYPE;
-
-	if (sh_pfc_get_data_reg(pfc, offset, &dummy, &bit) == 0)
-		gpio->flags |= PINMUX_TYPE_GPIO;
-	else {
-		gpio->flags |= PINMUX_TYPE_FUNCTION;
-
-		spin_lock_irqsave(&pmx->lock, flags);
-		pmx->nr_functions++;
-		spin_unlock_irqrestore(&pmx->lock, flags);
-	}
-}
-
-/* pinmux ranges -> pinctrl pin descs */
-static int __devinit sh_pfc_map_gpios(struct sh_pfc *pfc,
-				      struct sh_pfc_pinctrl *pmx)
-{
-	unsigned long flags;
-	int i;
-
-	pmx->nr_pads = pfc->pdata->last_gpio - pfc->pdata->first_gpio + 1;
-
-	pmx->pads = kmalloc(sizeof(struct pinctrl_pin_desc) * pmx->nr_pads,
-			    GFP_KERNEL);
-	if (unlikely(!pmx->pads)) {
-		pmx->nr_pads = 0;
-		return -ENOMEM;
-	}
-
-	spin_lock_irqsave(&pfc->lock, flags);
-
-	/*
-	 * We don't necessarily have a 1:1 mapping between pin and linux
-	 * GPIO number, as the latter maps to the associated enum_id.
-	 * Care needs to be taken to translate back to pin space when
-	 * dealing with any pin configurations.
-	 */
-	for (i = 0; i < pmx->nr_pads; i++) {
-		struct pinctrl_pin_desc *pin = pmx->pads + i;
-		struct pinmux_gpio *gpio = pfc->pdata->gpios + i;
-
-		pin->number = pfc->pdata->first_gpio + i;
-		pin->name = gpio->name;
-
-		/* XXX */
-		if (unlikely(!gpio->enum_id))
-			continue;
-
-		sh_pfc_map_one_gpio(pfc, pmx, gpio, i);
-	}
-
-	spin_unlock_irqrestore(&pfc->lock, flags);
-
-	sh_pfc_pinctrl_desc.pins = pmx->pads;
-	sh_pfc_pinctrl_desc.npins = pmx->nr_pads;
-
-	return 0;
-}
-
-static int __devinit sh_pfc_map_functions(struct sh_pfc *pfc,
-					  struct sh_pfc_pinctrl *pmx)
-{
-	unsigned long flags;
-	int i, fn;
-
-	pmx->functions = kzalloc(pmx->nr_functions * sizeof(void *),
-				 GFP_KERNEL);
-	if (unlikely(!pmx->functions))
-		return -ENOMEM;
-
-	spin_lock_irqsave(&pmx->lock, flags);
-
-	for (i = fn = 0; i < pmx->nr_pads; i++) {
-		struct pinmux_gpio *gpio = pfc->pdata->gpios + i;
-
-		if ((gpio->flags & PINMUX_FLAG_TYPE) == PINMUX_TYPE_FUNCTION)
-			pmx->functions[fn++] = gpio;
-	}
-
-	spin_unlock_irqrestore(&pmx->lock, flags);
-
-	return 0;
-}
-
-int sh_pfc_register_pinctrl(struct sh_pfc *pfc)
-{
-	struct sh_pfc_pinctrl *pmx;
-	int ret;
-
-	pmx = kzalloc(sizeof(struct sh_pfc_pinctrl), GFP_KERNEL);
-	if (unlikely(!pmx))
-		return -ENOMEM;
-
-	spin_lock_init(&pmx->lock);
-
-	pmx->pfc = pfc;
-	pfc->pinctrl = pmx;
-
-	ret = sh_pfc_map_gpios(pfc, pmx);
-	if (unlikely(ret != 0))
-		return ret;
-
-	ret = sh_pfc_map_functions(pfc, pmx);
-	if (unlikely(ret != 0))
-		goto free_pads;
-
-	pmx->pctl = pinctrl_register(&sh_pfc_pinctrl_desc, pfc->dev, pmx);
-	if (IS_ERR(pmx->pctl)) {
-		ret = PTR_ERR(pmx->pctl);
-		goto free_functions;
-	}
-
-	sh_pfc_gpio_range.npins = pfc->pdata->last_gpio
-				- pfc->pdata->first_gpio + 1;
-	sh_pfc_gpio_range.base = pfc->pdata->first_gpio;
-	sh_pfc_gpio_range.pin_base = pfc->pdata->first_gpio;
-
-	pinctrl_add_gpio_range(pmx->pctl, &sh_pfc_gpio_range);
-
-	return 0;
-
-free_functions:
-	kfree(pmx->functions);
-free_pads:
-	kfree(pmx->pads);
-	kfree(pmx);
-
-	return ret;
-}
-
-int __devexit sh_pfc_unregister_pinctrl(struct sh_pfc *pfc)
-{
-	struct sh_pfc_pinctrl *pmx = pfc->pinctrl;
-
-	pinctrl_unregister(pmx->pctl);
-
-	kfree(pmx->functions);
-	kfree(pmx->pads);
-	kfree(pmx);
-
-	pfc->pinctrl = NULL;
-	return 0;
-}
-- 
1.7.8.6

