Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab1HQRGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:06:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4300 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab1HQRGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:06:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110807251"
Message-Id: <20110817163522.946736379@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:35:30 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>
Subject: [patch 33/36] Hexagon: Platform-generic support.
References: <20110817163457.878854582@codeaurora.org>
Content-Disposition: inline; filename=platform-common.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We understand that devtree is preferred for platform support and
will be switching to that in the foreseeable future.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>

---
 arch/hexagon/include/asm/angel_console.h     |   24 +++
 arch/hexagon/include/asm/clock.h             |  172 ++++++++++++++++++++++
 arch/hexagon/include/asm/gpio.h              |   32 ++++
 arch/hexagon/include/asm/platform.h          |   49 ++++++
 arch/hexagon/include/asm/platform/sirc.h     |   71 +++++++++
 arch/hexagon/platform/common/Makefile        |   12 +
 arch/hexagon/platform/common/angel_console.c |   89 +++++++++++
 arch/hexagon/platform/common/angel_misc.c    |   56 +++++++
 arch/hexagon/platform/common/clock.c         |  100 ++++++++++++
 arch/hexagon/platform/common/irq.c           |   23 ++
 arch/hexagon/platform/common/platform.c      |   82 ++++++++++
 arch/hexagon/platform/common/sirc.c          |  208 +++++++++++++++++++++++++++
 12 files changed, 918 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/angel_console.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/angel_console.h	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ANGEL_CONSOLE_H
+#define _ANGEL_CONSOLE_H
+
+void __init register_angel_console(void);
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/clock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/clock.h	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,172 @@
+/*
+ * MSM architecture clock driver header
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2007-2011, Code Aurora Forum
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_MSM_CLOCK_H
+#define __ARCH_ARM_MACH_MSM_CLOCK_H
+
+#include <linux/list.h>
+/*
+ * High level clock API support
+ */
+struct module;
+#define CLKFLAG_INVERT   0x00000001 /* invert the clock */
+#define CLKFLAG_NOINVERT 0x00000002 /* do not invert */
+#define CLKFLAG_NONEST   0x00000004 /* disable nesting of enable/disable */
+#define CLKFLAG_NORESET  0x00000008 /* Prohibit resetting clock */
+
+#define CLK_FIRST_AVAILABLE_FLAG 0x00000100
+#define CLKFLAG_USE_MIN_TO_SET   0x00000200
+#define CLKFLAG_USE_MAX_TO_SET   0x00000400
+#define CLKFLAG_USE_NO_SET       0x00000800
+#define CLKFLAG_AUTO_OFF         0x00001000
+
+struct clk {
+	spinlock_t              lock;
+	uint32_t                id;
+	uint32_t                count;
+	const char              *name;
+	uint32_t                flags;
+	struct list_head        list;
+	struct clk		*parent;
+	struct module           *owner;
+};
+
+#define A11S_CLK_CNTL_ADDR (MSM_CSR_BASE + 0x100)
+#define A11S_CLK_SEL_ADDR (MSM_CSR_BASE + 0x104)
+#define A11S_VDD_SVS_PLEVEL_ADDR (MSM_CSR_BASE + 0x124)
+
+#define SPSS_CLK_CNTL_ADDR (MSM_CSR_BASE + 0x100)
+#define SPSS_CLK_SEL_ADDR (MSM_CSR_BASE + 0x104)
+
+#define PLLn_L_VAL(n)	(MSM_CLK_CTL_BASE + 0x304 + 28 * (n))
+
+/* Scorpion PLL registers */
+#define PLL_CTL_ADDR         (MSM_SCPLL_BASE + 0x4)
+#define PLL_STATUS_ADDR      (MSM_SCPLL_BASE + 0x18)
+#define PLL_FSM_CTL_EXT_ADDR (MSM_SCPLL_BASE + 0x10)
+
+/*
+ * Supported clocks
+ */
+#define ACPU_CLK           0  /* Applications processor clock */
+#define ADM_CLK            1  /* Applications data mover clock */
+#define ADSP_CLK           2  /* ADSP clock */
+#define EBI1_CLK           3  /* External bus interface 1 clock */
+#define EBI2_CLK           4  /* External bus interface 2 clock */
+#define ECODEC_CLK         5  /* External CODEC clock */
+#define EMDH_CLK           6  /* External MDDI host clock */
+#define GP_CLK             7  /* General purpose clock */
+#define GRP_CLK            8  /* Graphics clock */
+#define I2C_CLK            9  /* I2C clock */
+#define ICODEC_RX_CLK     10  /* Internal CODEX RX clock */
+#define ICODEC_TX_CLK     11  /* Internal CODEX TX clock */
+#define IMEM_CLK          12  /* Internal graphics memory clock */
+#define MDC_CLK           13  /* MDDI client clock */
+#define MDP_CLK           14  /* Mobile display processor clock */
+#define PBUS_CLK          15  /* Peripheral bus clock */
+#define PCM_CLK           16  /* PCM clock */
+#define PMDH_CLK          17  /* Primary MDDI host clock */
+#define SDAC_CLK          18  /* Stereo DAC clock */
+#define SDC1_CLK          19  /* Secure Digital Card clocks */
+#define SDC1_PCLK         20
+#define SDC2_CLK          21
+#define SDC2_PCLK         22
+#define SDC3_CLK          23
+#define SDC3_PCLK         24
+#define SDC4_CLK          25
+#define SDC4_PCLK         26
+#define TSIF_CLK          27  /* Transport Stream Interface clocks */
+#define TSIF_REF_CLK      28
+#define TV_DAC_CLK        29  /* TV clocks */
+#define TV_ENC_CLK        30
+#define UART1_CLK         31  /* UART clocks */
+#define UART2_CLK         32
+#define UART3_CLK         33
+#define UART1DM_CLK       34
+#define UART2DM_CLK       35
+#define USB_HS_CLK        36  /* High speed USB core clock */
+#define USB_HS_PCLK       37  /* High speed USB pbus clock */
+#define USB_OTG_CLK       38  /* Full speed USB clock */
+#define VDC_CLK           39  /* Video controller clock */
+#define VFE_CLK           40  /* Camera / Video Front End clock */
+#define VFE_MDC_CLK       41  /* VFE MDDI client clock */
+
+#define MDP_LCDC_PCLK_CLK 42
+#define MDP_LCDC_PAD_PCLK_CLK 43
+#define MDP_VSYNC_CLK     44
+
+#define SPI_CLK           45
+#define VFE_AXI_CLK       46
+
+#ifdef CONFIG_HEXAGON_COMET
+#define NR_CLOCKS	3
+#endif
+
+#define CLOCK(clk_name, clk_id, clk_flags) {	\
+	.name = clk_name, \
+	.owner = THIS_MODULE, \
+	.id = clk_id, \
+	.flags = clk_flags, \
+	}
+
+#define OFF CLKFLAG_AUTO_OFF
+#define MIN_SET CLKFLAG_USE_MIN_TO_SET
+#define MAX_SET CLKFLAG_USE_MAX_TO_SET
+#define NO_SET  CLKFLAG_USE_NO_SET
+#define MIN_MAX (MIN_SET | MAX_SET)
+
+/*
+ * ARM11 clock configuration for specific ACPU speeds
+ */
+
+#define ACPU_PLL_TCXO	-1
+#define ACPU_PLL_0	0
+#define ACPU_PLL_1	1
+#define ACPU_PLL_2	2
+#define ACPU_PLL_3	3
+
+struct clkctl_acpu_speed {
+	unsigned int     use_for_scaling;
+	unsigned int     a11clk_khz;
+	int              pll;
+	unsigned int     a11clk_src_sel;
+	unsigned int     a11clk_src_div;
+	unsigned int     ahbclk_khz;
+	unsigned int     ahbclk_div;
+#if defined(CONFIG_ARCH_QSD)
+	unsigned int     sc_core_src_sel_mask;
+	unsigned int     sc_l_value;
+#else
+	unsigned int     ebi1clk_khz;
+#endif
+	int              vdd;
+};
+
+struct msm_clock_platform_data {
+	uint32_t acpu_switch_time_us;
+	uint32_t max_speed_delta_khz;
+	uint32_t vdd_switch_time_us;
+	struct clk *active_clocks;
+	int active_clock_count;
+};
+
+extern struct clkctl_acpu_speed acpu_freq_tbl[];
+
+void __init msm_clock_init(struct msm_clock_platform_data *);
+int clk_register(struct clk *);
+
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/gpio.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/gpio.h	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef __ASM_ARCH_HEXAGON_GPIO_H
+#define __ASM_ARCH_HEXAGON_GPIO_H
+
+#ifdef CONFIG_GENERIC_GPIO
+#include <asm-generic/gpio.h>
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	 return __gpio_to_irq(gpio);
+}
+#endif
+
+#endif
+
Index: linux-hexagon-kernel/arch/hexagon/include/asm/platform.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/platform.h	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,49 @@
+/*
+ * Platform support for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef __PLATFORM_H
+#define __PLATFORM_H
+
+extern int on_simulator;
+extern unsigned long bootmem_lastpg;
+
+/* Platforms */
+enum {
+	PLATFORM_COMET	= 1,	/*  Comet/Simulator  */
+};
+
+/*
+ * Function pointers to all our platform specific callouts
+ */
+struct platform_ops_t {
+	void (*register_early_console)(void);
+	void (*clock_init)(void);
+	void (*irq_init)(void);
+};
+
+void platform_setup_ops(struct platform_ops_t *);
+void __init comet_setup_ops(struct platform_ops_t * ops);
+void __init amazon_setup_ops(struct platform_ops_t * ops);
+
+extern void __init plat_clock_init(void);
+
+extern void __init angel_get_command_line(char *s, unsigned n);
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/platform/common/angel_console.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/common/angel_console.c	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,89 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/kernel.h>  /*  printk  */
+#include <asm/platform.h>
+/*
+ * In the intermediate transition from simulator to hardware,
+ * we can't use the extended Angel API, and need to use the
+ * basic, pointer-based console output. Unfortunately, the
+ * simulator implementation of this bypasses the TLB while
+ * the hardware platform version plays through the map.
+ * So we use a different method, depending on where we're
+ * running...
+ */
+
+static char	cr = '\r';
+
+static void angel_write(struct console *c, const char *s, unsigned n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++) {
+		if (!on_simulator) {
+			/*
+			 * On hardware developement platform, cr isn't automatic
+			 * with nl
+			 */
+
+			if (*s == '\n') {
+				asm volatile("R0=#0x43;"
+					"R1=%0;"
+					"trap0(#0);"
+					:
+					: "r" (cr)
+					: "r0", "r1"
+				);
+			}
+			asm volatile("R0=#0x03;"
+				"R1=%0;"
+				"trap0(#0);"
+				:
+				: "r" ((long)(s))
+				: "r0", "r1"
+			);
+		} else {
+			/* On the sim, do call-by-value with no cr */
+			asm volatile("R0=#0x43;"
+				"R1=%0;"
+				"trap0(#0);"
+				:
+				: "r" (*s)
+				: "r0", "r1"
+			);
+		}
+		s++;
+	}
+
+}
+
+static struct console angel_cons_info = {
+	.name	= "angel",
+	.write	= angel_write,
+	.flags	= CON_PRINTBUFFER | CON_BOOT,
+	.index	= -1,
+};
+
+void __init register_angel_console(void)
+{
+	register_console(&angel_cons_info);
+}
+
+
Index: linux-hexagon-kernel/arch/hexagon/platform/common/clock.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/common/clock.c	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,100 @@
+/*
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2007-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/spinlock_types.h>
+#include <linux/mutex.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <asm/clock.h>
+
+static DEFINE_MUTEX(clocks_mutex);
+static LIST_HEAD(clocks);
+
+int clk_enable(struct clk *clk)
+{
+	#warning "unimplemented function clk_enable"
+	return 0;
+}
+
+void clk_disable(struct clk *clk)
+{
+	#warning "unimplemented function clk_disable"
+}
+
+/*
+ * clk_put
+ * @clk - pointer to clock to "free"
+ *
+ * module_put decrements the reference count of the "module" passed.
+ */
+void clk_put(struct clk *clk)
+{
+	module_put(clk->owner);
+}
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	struct clk *c_clk;
+
+	mutex_lock(&clocks_mutex);
+	list_for_each_entry(c_clk, &clocks, list) {
+		if (!strcmp(id, c_clk->name) && try_module_get(c_clk->owner)) {
+			mutex_unlock(&clocks_mutex);
+			return c_clk;
+		}
+	}
+	mutex_unlock(&clocks_mutex);
+	return ERR_PTR(-ENOENT);
+}
+
+/*
+ *  msm_serial_probe calls this and uses it to set the pdev->uartclk, but
+ *  it doesn't ever seem to be used by the driver...  so maybe returning
+ *  garbage is OK for now.
+ */
+unsigned long clk_get_rate(struct clk *clk)
+{
+	#warning "unimplemented function clk_disable"
+	return (unsigned long)clk;
+}
+
+struct clk iss_v2_clocks[] = {
+	CLOCK("uart1_clk",      UART1_CLK,      OFF),
+	CLOCK("uart2_clk",      UART2_CLK,      0),
+	CLOCK("uart3_clk",      UART3_CLK,      OFF),
+};
+
+int clk_register(struct clk *clk)
+{
+	if (!clk || IS_ERR(clk))
+		return -EINVAL;
+	mutex_lock(&clocks_mutex);
+	spin_lock_init(&clk->lock);
+	list_add_tail(&clk->list, &clocks);
+	mutex_unlock(&clocks_mutex);
+	return 0;
+}
+
+void __init msm_clock_init(struct msm_clock_platform_data * clkdata)
+{
+	int n;
+
+	/* Register all the clocks */
+	for (n = 0; n < NR_CLOCKS; n++)
+		clk_register(clkdata->active_clocks+n);
+}
Index: linux-hexagon-kernel/arch/hexagon/platform/common/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/common/Makefile	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,12 @@
+
+obj-y += platform.o irq.o
+
+obj-y += clock.o
+
+ifdef CONFIG_HEXAGON_ANGEL_TRAPS
+obj-y += angel_misc.o angel_console.o
+endif
+
+ifdef CONFIG_HEXAGON_COMET
+obj-y += sirc.o
+endif
Index: linux-hexagon-kernel/arch/hexagon/platform/common/platform.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/common/platform.c	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,82 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include <asm/platform.h>
+#include <asm/angel_console.h>
+#include <asm/irq.h>
+
+__initdata unsigned long bootmem_lastpg;
+
+/*
+ * Detect what plaform we are on
+ *
+ * This should be changed to an autodetect once we get a device-tree
+ */
+static int platform_detect(void)
+{
+#ifdef CONFIG_HEXAGON_COMET
+	return PLATFORM_COMET;
+#endif
+	BUG();
+}
+
+static void __init common_setup_ops(struct platform_ops_t * ops)
+{
+#ifdef CONFIG_HEXAGON_ANGEL_TRAPS
+	ops->register_early_console = register_angel_console;
+#endif
+	ops->clock_init = NULL; /* Platform must override this */
+	ops->irq_init = platform_irq_init;
+}
+
+void __init platform_setup_ops(struct platform_ops_t * ops)
+{
+	int platform;
+
+	/* Set the common ops and then let platforms override them */
+	common_setup_ops(ops);
+
+	/* Detect which platform we're on */
+	platform = platform_detect();
+
+	/*
+	 * Call the platform setup routine to set the function
+	 * pointers
+	 */
+	switch (platform) {
+	case PLATFORM_COMET:
+		comet_setup_ops(ops);
+		break;
+	default:
+		BUG();
+	};
+
+	BUG_ON(ops->clock_init == NULL);
+}
+
+/*
+ * Need these prototypes until we can build all platforms at once
+ */
+#ifndef CONFIG_HEXAGON_COMET
+void __init comet_setup_ops(struct platform_ops_t *ops) {}
+#endif
+
+
Index: linux-hexagon-kernel/arch/hexagon/platform/common/irq.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/common/irq.c	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,23 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <asm/irq.h>
+
+/* For now, a no-op ... When would we ever need this ?? */
+void __init platform_irq_init(void) {}
Index: linux-hexagon-kernel/arch/hexagon/platform/common/angel_misc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/common/angel_misc.c	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <asm/mem-layout.h>
+#include <asm/page.h>
+
+void __init angel_get_command_line(char *s, unsigned n)
+{
+	unsigned long message[2];
+	/*
+	 * According to the Angel spec, this operation returns
+	 * a success/failure (0/-1) code and a pointer to the
+	 * string in the string buffer.  We don't seem to get
+	 * either value in the Hexagon simulator environment,
+	 * so while we'll try to obtain the values, we won't
+	 * inspect them, and instead blindly assume success.
+	 */
+	unsigned long rv0;
+	unsigned long rv1;
+
+	/*
+	 * Protocol says pass a pointer to a two-word block
+	 * containing buffer address and max length.  Simulator
+	 * sees through the TLB memory map, but pass the physical
+	 * address just the same.
+	 */
+
+	message[0] = __pa(s);
+	message[1] = n;
+
+	asm volatile("R0=#0x15;"
+		"R1=%2;"
+		"trap0(#0);"
+		"%0 = R0;"
+		"%1 = R1;"
+		: "=r" (rv0), "=r" (rv1)
+		: "r" (message)
+		: "r0");
+}
+
Index: linux-hexagon-kernel/arch/hexagon/include/asm/platform/sirc.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/platform/sirc.h	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,71 @@
+/*
+ * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Code Aurora nor
+ *       the names of its contributors may be used to endorse or promote
+ *       products derived from this software without specific prior written
+ *       permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
+ * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
+ * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
+ * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+/*  Derived from arch/arm/mach-msm/include/mach/sirc.h  */
+
+#ifndef __SIRC_H
+#define __SIRC_H
+
+/*
+ * Some, but not all, hexagon-based systems use a macro wrapped
+ * around the hexagon core that cascades multiple interrupt
+ * registers to several CPU irq's.  The structures here are
+ * used to define that routing.
+ */
+struct sirc_regs {
+	void __iomem   *int_status;
+	void __iomem   *int_polarity;
+	void __iomem   *int_type;
+	void __iomem   *int_enable;
+	void __iomem   *int_enable_set;
+	void __iomem   *int_enable_clear;
+	void __iomem   *int_clear;
+};
+
+struct sirc_save {
+	unsigned int int_enable;
+	unsigned int wake_enable;
+	unsigned int type;
+	unsigned int polarity;
+};
+
+struct sirc_cascade_regs {
+	unsigned int    cascade_irq;
+	unsigned int    sirq_base;
+	unsigned int    group_size;
+	unsigned int    base_addr;
+	struct sirc_regs regs;
+	struct sirc_save save;
+};
+
+void hexss_init_sirc(struct sirc_cascade_regs *, int);
+void hexss_sirc_enter_sleep(void);
+void hexss_sirc_exit_sleep(void);
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/platform/common/sirc.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/platform/common/sirc.c	2011-07-20 15:19:45.035151233 -0500
@@ -0,0 +1,208 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <asm/irq.h>
+#include <asm/platform/sirc.h>
+
+/* Mask off the given interrupt. Keep the int_enable mask in sync with
+   the enable reg, so it can be restored after power collapse. */
+static void sirc_irq_mask(struct irq_data *data)
+{
+	struct sirc_cascade_regs *regs_table = irq_data_get_irq_chip_data(data);
+
+	unsigned int mask = 1UL << (data->irq - regs_table->sirq_base);
+
+	writel(mask, regs_table->regs.int_enable_clear);
+
+	regs_table->save.int_enable &= ~mask;
+}
+
+/* Unmask the given interrupt. Keep the int_enable mask in sync with
+   the enable reg, so it can be restored after power collapse. */
+static void sirc_irq_unmask(struct irq_data *data)
+{
+	struct sirc_cascade_regs *regs_table = irq_data_get_irq_chip_data(data);
+
+	unsigned int mask = 1UL << (data->irq - regs_table->sirq_base);
+
+	writel(mask, regs_table->regs.int_enable_set);
+
+	regs_table->save.int_enable |= mask;
+}
+
+static void sirc_irq_ack(struct irq_data *data)
+{
+	struct sirc_cascade_regs *regs_table = irq_data_get_irq_chip_data(data);
+
+	unsigned int mask = 1UL << (data->irq - regs_table->sirq_base);
+
+	/* XXX TODO: Only the edge interrupts need to be acked;
+	 * we can save some overhead by not ack'ing the level irqs */
+	writel(mask, regs_table->regs.int_clear);
+}
+
+static int sirc_irq_set_wake(struct irq_data *data, unsigned int on)
+{
+	struct sirc_cascade_regs *regs_table = irq_data_get_irq_chip_data(data);
+
+	unsigned int mask = 1UL << (data->irq - regs_table->sirq_base);
+
+	/* Used to set the interrupt enable mask during power collapse. */
+	if (on)
+		regs_table->save.wake_enable |= mask;
+	else
+		regs_table->save.wake_enable &= ~mask;
+
+	return 0;
+}
+
+static int sirc_irq_set_type(struct irq_data *data, unsigned int flow_type)
+{
+	struct sirc_cascade_regs *regs_table = irq_data_get_irq_chip_data(data);
+	unsigned int mask = 1UL << (data->irq - regs_table->sirq_base);
+	unsigned int val = readl(regs_table->regs.int_polarity);
+	unsigned int irq = data->irq;
+
+	if (flow_type & (IRQF_TRIGGER_LOW | IRQF_TRIGGER_FALLING))
+		val |= mask;
+	else
+		val &= ~mask;
+
+	writel(val, regs_table->regs.int_polarity);
+
+	val = readl(regs_table->regs.int_type);
+	if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) {
+		val |= mask;
+		irq_desc[irq].handle_irq = handle_edge_irq;
+	} else {
+		val &= ~mask;
+		irq_desc[irq].handle_irq = handle_level_irq;
+	}
+
+	writel(val, regs_table->regs.int_type);
+
+	return 0;
+}
+
+/* Finds the pending interrupt on the passed cascade irq and redrives it */
+static void sirc_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct sirc_cascade_regs *regs_table = irq_desc_get_handler_data(desc);
+	unsigned int status;
+	unsigned int bitpos;
+
+	/* Search group for bits that are set */
+	status = readl(regs_table->regs.int_status);
+	if (status == 0)
+		goto ack;
+
+	/* Which bit was set in the status register? */
+	bitpos = 0;
+	while ((bitpos < regs_table->group_size) &&
+	      ((status & (1U << bitpos)) == 0))
+		bitpos++;
+
+	/* Redrive to software irq */
+	generic_handle_irq(bitpos + regs_table->sirq_base);
+
+	/* Ack the first-level interrupt */
+ack:
+	irq_desc_get_chip(desc)->irq_eoi(&desc->irq_data);
+}
+
+void hexss_sirc_enter_sleep(void)
+{
+#ifdef NOT_TODAY
+	int i;
+	for (i = 0; i < NR_SIRC_GROUPS; i++) {
+		regs_table[i].save.type	=
+			readl(regs_table[i].regs.int_type);
+		regs_table[i].save.polarity =
+			readl(regs_table[i].regs.int_polarity);
+		writel(regs_table[i].save.wake_enable,
+			regs_table[i].regs.int_enable);
+	}
+#endif
+}
+
+void hexss_sirc_exit_sleep(void)
+{
+#ifdef NOT_TODAY
+	int i;
+	for (i = 0; i < NR_SIRC_GROUPS; i++) {
+		writel(regs_table[i].save.type, regs_table[i].regs.int_type);
+		writel(regs_table[i].save.polarity,
+			regs_table[i].regs.int_polarity);
+		writel(regs_table[i].save.int_enable,
+			regs_table[i].regs.int_enable);
+	}
+#endif
+}
+
+static struct irq_chip sirc_irq_chip = {
+	.name          = "sirc",
+	.irq_ack       = sirc_irq_ack,
+	.irq_mask      = sirc_irq_mask,
+	.irq_unmask    = sirc_irq_unmask,
+	.irq_set_wake  = sirc_irq_set_wake,
+	.irq_set_type  = sirc_irq_set_type,
+};
+
+void __init hexss_init_sirc(struct sirc_cascade_regs *regs_table, int regs_sz)
+{
+	int i;
+
+	/* Set up status register base addresses */
+	for (i = 0; i < regs_sz; i++) {
+		unsigned int sirc_base_addr =
+			(unsigned int) ioremap(regs_table[i].base_addr,
+						PAGE_SIZE);
+		regs_table[i].regs.int_status       += sirc_base_addr;
+		regs_table[i].regs.int_polarity     += sirc_base_addr;
+		regs_table[i].regs.int_type         += sirc_base_addr;
+		regs_table[i].regs.int_enable       += sirc_base_addr;
+		regs_table[i].regs.int_enable_set   += sirc_base_addr;
+		regs_table[i].regs.int_enable_clear += sirc_base_addr;
+		regs_table[i].regs.int_clear        += sirc_base_addr;
+	}
+
+	/* Install a handler for each secondary */
+	for (i = 0; i < regs_sz; i++) {
+		unsigned int sirq = regs_table[i].sirq_base;
+		unsigned int last = sirq + regs_table[i].group_size;
+		while (sirq < last) {
+			irq_set_chip(sirq, &sirc_irq_chip);
+			irq_set_chip_data(sirq, &regs_table[i]);
+			irq_set_handler(sirq, handle_level_irq);
+			sirq++;
+		}
+	}
+
+	/* Turn on the cascade handlers */
+	for (i = 0; i < regs_sz; i++) {
+		unsigned int irq = regs_table[i].cascade_irq;
+
+		irq_set_handler_data(irq, &regs_table[i]);
+		irq_set_chained_handler(irq, sirc_irq_handler);
+		irq_set_irq_wake(irq, 1);
+	}
+}
+

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

