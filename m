Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2FUB3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 21:29:53 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:42794 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab2FUB3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 21:29:52 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: mturquette@linaro.org, shawn.guo@linaro.org, viresh.linux@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org, rubini@gnudd.com,
        giancarlo.asnaghi@st.com, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH RFC] sta2x11 common clock framework implementation
Date: Thu, 21 Jun 2012 03:29:25 +0200
Message-Id: <1340242165-4279-1-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>


Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---

Hi,

this is a first implementation of the common clock framework for the STA2X11
(aka connext) chip.
The STA2X11 contains a bunch of AMBA peripherals (and some more non-amba cells)
with a pci express interface. The goal is using standard existing amba drivers
to deal with peripherals seen through a pcie to amba bridge. To this purpose,
a generic pci-amba wrapper driver has been developed: basically, each time
a new device belonging to the connext is probed an amba device is dynamically
instantiated. For the amba drivers to be used, a clock api must also be
implemented, so here we are. The unusual things about this implementation are:

* We can't register the clocks until their control registers are available.
Since such registers belong to some sta2x11 multifunction pci device, we
listen on the platform bus notifier. When all the interesting devices are up
and running, we start registering clocks. Luckily, this should happen at the
proper time (not too late).

* A pci fixup callback is registered (on device enable). When the pcie-amba
wrapper enables the pci device, the callback is invoked to register a clock
lookup for the device.

* We don't deal with platform data yet, because we have no platform on
STA2X11 machine at present. This will be probably solved via device tree
or equivalent runtime methods.

WARNING: this patch is RFC only. Since it depends on patches not yet in the
next tree, it will probably not even compile.


 arch/x86/Kconfig                    |    3 +
 arch/x86/include/asm/clkdev.h       |   25 ++
 drivers/clk/Makefile                |    1 +
 drivers/clk/sta2x11/Makefile        |    1 +
 drivers/clk/sta2x11/clk-audio-pll.c |  146 ++++++++
 drivers/clk/sta2x11/clk-soc-pll.c   |   94 +++++
 drivers/clk/sta2x11/clk.h           |   68 ++++
 drivers/clk/sta2x11/sta2x11-clk.c   |  661 +++++++++++++++++++++++++++++++++++
 8 files changed, 999 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7b989ca..72013efe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -497,6 +497,9 @@ config STA2X11
 	depends on X86_32_NON_STANDARD && PCI
 	select X86_DEV_DMA_OPS
 	select X86_DMA_REMAP
+	select HAVE_CLK
+	select CLKDEV_LOOKUP
+	select COMMON_CLK
 	select SWIOTLB
 	select MFD_STA2X11
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/arch/x86/include/asm/clkdev.h b/arch/x86/include/asm/clkdev.h
new file mode 100644
index 0000000..1433611
--- /dev/null
+++ b/arch/x86/include/asm/clkdev.h
@@ -0,0 +1,25 @@
+/*
+ *  based on arch/mips/include/asm/clkdev.h
+ *
+ *  which in turn is based on the arm version of clkdev.h by Russel King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Helper for the clk API to assist looking up a struct clk.
+ */
+#ifndef __ASM_CLKDEV_H
+#define __ASM_CLKDEV_H
+
+#include <linux/slab.h>
+
+#define __clk_get(clk)	({ 1; })
+#define __clk_put(clk)	do { } while (0)
+
+static inline struct clk_lookup_alloc *__clkdev_alloc(size_t size)
+{
+	return kzalloc(size, GFP_KERNEL);
+}
+
+#endif
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 26b6b92..280916d 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
 obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
+obj-$(CONFIG_STA2X11)		+= sta2x11/
diff --git a/drivers/clk/sta2x11/Makefile b/drivers/clk/sta2x11/Makefile
new file mode 100644
index 0000000..4975370
--- /dev/null
+++ b/drivers/clk/sta2x11/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_STA2X11) += sta2x11-clk.o clk-soc-pll.o clk-audio-pll.o
diff --git a/drivers/clk/sta2x11/clk-audio-pll.c b/drivers/clk/sta2x11/clk-audio-pll.c
new file mode 100644
index 0000000..6b28126
--- /dev/null
+++ b/drivers/clk/sta2x11/clk-audio-pll.c
@@ -0,0 +1,146 @@
+/*
+ * Common clock api implementation for sta2x11
+ * audio-pll clock type implementation
+ *
+ * Copyright ST Microelectronics 2012 (Davide Ciminaghi)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#define DEBUG
+
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/sta2x11-mfd.h>
+#include <linux/clk-provider.h>
+#include <asm/div64.h>
+#include <asm/sta2x11.h>
+
+#include "clk.h"
+
+/**
+ * struct clk_audio_pll - sta2x11 audio pll clock
+ * @hw: clk_hw for the pll
+ *
+ * Soc pll
+ */
+struct clk_audio_pll {
+	struct clk_hw hw;
+	void __iomem *base;
+	spinlock_t *lock;
+};
+
+#define to_clk_audio_pll(_hw) container_of(_hw, struct clk_audio_pll, hw)
+
+static unsigned long clk_audio_pll_recalc_rate(struct clk_hw *hw,
+					       unsigned long parent_rate)
+{
+	struct clk_audio_pll *audio_pll = to_clk_audio_pll(hw);
+	u32 scpllctl = readl(audio_pll->base + SCTL_SCPLLCTL);
+	u32 scpllfctrl = readl(audio_pll->base + SCTL_SCPLLFCTRL);
+	u16 scresfract = readl(audio_pll->base + SCTL_SCRESFRACT);
+	u64 fvco, inff, ndiv, fract, idf, phi, odf;
+	int frac_control, dither_disable;
+
+	inff = parent_rate;
+	frac_control = scpllctl & SCTL_SCPLLCTL_FRAC_CONTROL;
+	ndiv = (scpllfctrl >> SCTL_SCPLLFCTRL_AUDIO_PLL_NDIV_SHIFT) &
+		SCTL_SCPLLFCTRL_AUDIO_PLL_NDIV_MASK;
+	fract = scresfract & SCTL_SCRESFRACT_MASK ;
+	idf = (scpllfctrl >> SCTL_SCPLLFCTRL_AUDIO_PLL_IDF_SHIFT) &
+		SCTL_SCPLLFCTRL_AUDIO_PLL_IDF_MASK;
+	idf = idf ? idf : 1;
+	odf = (scpllfctrl >> SCTL_SCPLLFCTRL_AUDIO_PLL_ODF_SHIFT) &
+		SCTL_SCPLLFCTRL_AUDIO_PLL_ODF_MASK;
+	odf = odf > 5 ? 32 : (1<<odf);
+	dither_disable = ((scpllfctrl >> SCTL_SCPLLFCTRL_DITHER_DISABLE_SHIFT) &
+			  SCTL_SCPLLFCTRL_DITHER_DISABLE_MASK) ? 0 : 1;
+
+	pr_debug("%s : refclk = %llu, scpllctl = 0x%08x\n", __func__,
+		 inff, scpllctl);
+	pr_debug("%s : scpllfctrl = 0x%08x, scresfract = 0x%08x\n",
+		 __func__, scpllfctrl, scresfract);
+	pr_debug("%s : ndiv = %llu, frac_control = %d, dither_disable = %d\n",
+		 __func__, ndiv, frac_control, dither_disable);
+	pr_debug("%s: fract = %llu, idf = %llu, odf = %llu\n",
+		 __func__, fract, idf, odf);
+
+	fvco = frac_control ?
+		div_u64((inff*2*((ndiv<<17)+(fract<<1)+dither_disable ? 0 : 1)),
+			(idf<<17)) :
+		div_u64((inff * 2 * ndiv), idf);
+	phi = div_u64(fvco, (odf * 2));
+
+	pr_debug("%s: fvco = %llu Hz, phi = %llu Hz\n", __func__, fvco, phi);
+
+	return phi;
+}
+
+static int clk_audio_pll_enable(struct clk_hw *hw)
+{
+	struct clk_audio_pll *audio_pll = to_clk_audio_pll(hw);
+	u32 scpllctl;
+	spin_lock(audio_pll->lock);
+	scpllctl = readl(audio_pll->base + SCTL_SCPLLCTL);
+	scpllctl &= ~SCTL_SCPLLCTL_AUDIO_PLL_PD;
+	writel(scpllctl, audio_pll->base + SCTL_SCPLLCTL);
+	spin_unlock(audio_pll->lock);
+	return 0;
+}
+
+static void clk_audio_pll_disable(struct clk_hw *hw)
+{
+	struct clk_audio_pll *audio_pll = to_clk_audio_pll(hw);
+	u32 scpllctl;
+	spin_lock(audio_pll->lock);
+	scpllctl = readl(audio_pll->base + SCTL_SCPLLCTL);
+	scpllctl |= SCTL_SCPLLCTL_AUDIO_PLL_PD;
+	writel(scpllctl, audio_pll->base + SCTL_SCPLLCTL);
+	spin_unlock(audio_pll->lock);
+}
+
+static const struct clk_ops clk_soc_pll_ops = {
+	.enable = clk_audio_pll_enable,
+	.disable = clk_audio_pll_disable,
+	.recalc_rate = clk_audio_pll_recalc_rate,
+};
+
+
+struct clk *sta2x11_clk_audio_pll(const char *name, const char *parent_name,
+				  void __iomem *base, spinlock_t *lock)
+{
+	struct clk_audio_pll *audio_pll;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	audio_pll = kzalloc(sizeof(*audio_pll), GFP_KERNEL);
+	if (!audio_pll)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_soc_pll_ops;
+	init.flags = 0;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	audio_pll->base = base;
+	audio_pll->lock = lock;
+	audio_pll->hw.init = &init;
+
+	clk = clk_register(NULL, &audio_pll->hw);
+	if (IS_ERR(clk))
+		kfree(audio_pll);
+
+	return clk;
+}
diff --git a/drivers/clk/sta2x11/clk-soc-pll.c b/drivers/clk/sta2x11/clk-soc-pll.c
new file mode 100644
index 0000000..80dc8bc
--- /dev/null
+++ b/drivers/clk/sta2x11/clk-soc-pll.c
@@ -0,0 +1,94 @@
+/*
+ * Common clock api implementation for sta2x11
+ * soc-pll clock type implementation
+ *
+ * Copyright ST Microelectronics 2012 (Davide Ciminaghi)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#define DEBUG
+
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/sta2x11-mfd.h>
+#include <asm/sta2x11.h>
+
+#include "clk.h"
+
+/**
+ * struct clk_soc_pll - sta2x11 soc pll clock
+ * @hw: clk_hw for the pll
+ *
+ * Soc pll
+ */
+struct clk_soc_pll {
+	struct clk_hw hw;
+	void __iomem *base;
+	spinlock_t *lock;
+};
+
+#define to_clk_soc_pll(_hw) container_of(_hw, struct clk_soc_pll, hw)
+
+#define PLL1NMUL_MASK	0x7f
+#define PLL1NMUL_SHIFT	3
+
+static unsigned long clk_soc_pll_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	struct clk_soc_pll *soc_pll = to_clk_soc_pll(hw);
+	unsigned long out;
+	u32 scpllfctrl = readl(soc_pll->base + SCTL_SCPLLFCTRL);
+	u32 nmul = (scpllfctrl >> PLL1NMUL_SHIFT) & PLL1NMUL_MASK;
+	out = parent_rate * nmul;
+	pr_debug("%s : soc_pll->base = %p\n", __func__, soc_pll->base);
+	pr_debug("%s : scpllfctrl = 0x%08x\n", __func__, scpllfctrl);
+	pr_debug("%s : nmul = %d\n", __func__, nmul);
+	pr_debug("%s : calculated rate = %lu\n", __func__, out);
+	pr_debug("%s : parent_rate = %lu\n", __func__, parent_rate);
+	return out;
+}
+
+static const struct clk_ops clk_soc_pll_ops = {
+	.recalc_rate = clk_soc_pll_recalc_rate,
+};
+
+
+struct clk *sta2x11_clk_soc_pll(const char *name, const char *parent_name,
+				void __iomem *base, spinlock_t *lock)
+{
+	struct clk_soc_pll *soc_pll;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	soc_pll = kzalloc(sizeof(*soc_pll), GFP_KERNEL);
+	if (!soc_pll)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_soc_pll_ops;
+	init.flags = 0;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+
+	soc_pll->base = base;
+	soc_pll->lock = lock;
+	soc_pll->hw.init = &init;
+
+	clk = clk_register(NULL, &soc_pll->hw);
+	if (IS_ERR(clk))
+		kfree(soc_pll);
+
+	return clk;
+}
diff --git a/drivers/clk/sta2x11/clk.h b/drivers/clk/sta2x11/clk.h
new file mode 100644
index 0000000..f505a64
--- /dev/null
+++ b/drivers/clk/sta2x11/clk.h
@@ -0,0 +1,68 @@
+/*
+ * Common clock api implementation for sta2x11
+ *
+ * Davide Ciminaghi 2012 <ciminaghi@gnudd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __STA2X11_CLK_H__
+#define __STA2X11_CLK_H__
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/spinlock.h>
+
+/*
+ * Indices for connext clocks
+ */
+enum sta2x11_clk {
+	xtal, sata, pcie, sdvo, eth, usb,
+	soc_vco, soc_phia, soc_phib, audio_pll_phi,
+	soc_phi, soc_phi_byp,
+	soc_phi_byp_div3, soc_phi_byp_div4, soc_phi_byp_div6,
+	audio_pll_phi_div2, audio_pll_phi_div4, audio_pll_phi_div10,
+	audio_pll_msp, audio_pll_sarac, audio_pll_sdmmc,
+	hclk_pre, hclk, clk_48M, clk_52M, sdmmc,
+	/* Uarts' peripheral clocks */
+	hclk_uart0, hclk_uart1, hclk_uart2, hclk_uart3,
+	/* Uarts' baud rate clocks */
+	bclk_uart0, bclk_uart1, bclk_uart2, bclk_uart3,
+	stmmac_csr, stmmac_rmii,
+	sta2x11_n_clks,
+};
+
+/*
+ * Clock types used on the connext
+ *
+ * By convention, a clock listed in clk_data[] with type == none, is not
+ * registered (usually because the clock itself is not active on the
+ * board the kernel is being run on).
+ */
+enum sta2x11_clk_type {
+	/* Not present on this board */
+	none = 0,
+	fixed_rate_root = 1,
+	fixed_factor = 2,
+	mux = 3,
+	tab_divider = 4,
+	soc_pll = 5,
+	audio_pll = 6,
+	sta2x11_clk_ntypes,
+};
+
+struct clk *sta2x11_clk_soc_pll(const char *name, const char *parent_name,
+				void __iomem *reg, spinlock_t *lock);
+struct clk *sta2x11_clk_audio_pll(const char *name, const char *parent_name,
+				  void __iomem *base, spinlock_t *lock);
+#endif /* __STA2X11_CLK_H__ */
diff --git a/drivers/clk/sta2x11/sta2x11-clk.c b/drivers/clk/sta2x11/sta2x11-clk.c
new file mode 100644
index 0000000..02173cb
--- /dev/null
+++ b/drivers/clk/sta2x11/sta2x11-clk.c
@@ -0,0 +1,661 @@
+/*
+ * Common clock api implementation for sta2x11
+ *
+ * Copyright ST Microelectronics 2012 (Davide Ciminaghi)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#define DEBUG
+
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/sta2x11-mfd.h>
+#include <linux/clkdev.h>
+#include <asm/sta2x11.h>
+
+#include "clk.h"
+
+#define STA2X11_MAX_CLK_NAME_LEN 60
+#define STA2X11_MAX_CLK_NPARENTS 8
+
+/*
+ * struct sta2x11_clk_reg_data
+ * This structure contains data about the registers needed to control
+ * a connext instance's clocks. Since such registers are actually owned
+ * by sta2x11-mfd, we get this data via sta2x11_mfd_get_regs_data()
+ *
+ * @sctl_base : virtual address of sctl registers
+ * @sctl_lock : spinlock needed to access the sctl registers
+ * @apb_soc_base : virtual address of apb-soc registers
+ * @apb_soc_lock : spinlock needed to access the apb-soc registers
+ */
+struct sta2x11_clk_reg_data {
+	void __iomem *sctl_base;
+	spinlock_t *sctl_lock;
+	void __iomem *apb_soc_base;
+	spinlock_t *apb_soc_lock;
+};
+
+/*
+ * struct sta2x11_clk_data
+ * This structure is used to build the table listing all the
+ * clocks for a connext chip.
+ *
+ * @basename : basename of the clock (a .%d suffix will be added to
+ * deal with multiple connext instances).
+ * @type : sta2x11 clock type (see clk.h, enum sta2x11_clk_type)
+ * @reg_offset : the controlling register's offset for this clock
+ * @init : pointer to init function. When this pointer is not NULL, the
+ * pointed function is invoked before clock registration. This is used to
+ * fill the clock struct fields which are unknown at compile time (typically
+ * virtual addresses of controlling registers).
+ * @args : arguments needed for registration
+ */
+struct sta2x11_clk_data {
+	const char *basename;
+	int type;
+	unsigned int reg_offset;
+	void (*init)(struct sta2x11_clk_data *, struct sta2x11_clk_reg_data *);
+	unsigned long flags;
+	union {
+		struct	{
+			const char *parent_name;
+			unsigned long rate;
+		} fixed_rate_root;
+		struct {
+			const char *parent_name;
+			unsigned int mult;
+			unsigned int div;
+		} fixed_factor;
+		struct {
+			const char **parent_names;
+			u8 num_parents;
+			void __iomem *reg;
+			u8 shift;
+			u8 width;
+			u8 clk_mux_flags;
+			spinlock_t *lock;
+		} mux;
+		struct {
+			const char *parent_name;
+			void __iomem *base;
+			spinlock_t *lock;
+		} soc_pll;
+		struct {
+			const char *parent_name;
+			void __iomem *base;
+			spinlock_t *lock;
+		} audio_pll;
+		struct {
+			const char *parent_name;
+			void __iomem *reg;
+			u8 shift;
+			u8 width;
+			spinlock_t *lock;
+			unsigned int *div_tab;
+		} tab_divider;
+	} args;
+};
+
+/* Various helper macros used to setup the clock table */
+
+/*
+ * Use this macro to declare a fixed clock with no parents
+ *
+ * @name : clock name
+ * @f : clock frequency
+ */
+#define DECLARE_FIXED_RATE_ROOT_CLK(n, f)				\
+	[n] = {								\
+		.basename = #n,						\
+		.type = fixed_rate_root,				\
+		.flags = CLK_IS_ROOT,					\
+		.args = {						\
+			.fixed_rate_root = {				\
+				.parent_name = NULL,			\
+				.rate = f,				\
+			}						\
+		}							\
+	}
+
+/*
+ * Use this macro to declare a fixed factor clock
+ *
+ * @n : clock name
+ * @parent_name = name of parent clock
+ * @flags = clock flags
+ * @mult = const mult factor
+ * @div = const div factor
+ */
+#define DECLARE_FIXED_FACTOR_CLK(n, pn, f, m, d)			\
+	[n] = {								\
+		.basename = #n,						\
+		.type = fixed_factor,					\
+		.reg_offset = 0,					\
+		.flags = f,						\
+		.args = {						\
+			.fixed_factor = {				\
+				.parent_name = #pn,			\
+				.mult = m,				\
+				.div = d,				\
+			}						\
+		}							\
+	}
+
+/*
+ * Use this macro to declare a mux clock
+ *
+ * @name : clock name
+ * @reg_offset : offset of controlling register
+ * @parent_names : names of parents
+ * @init : pointer to init function
+ * @flags : clock flags
+ * @shift : bitmask shift
+ * @width : bitmask width
+ * @clk_mux_flags : flags of clock mux
+ */
+#define DECLARE_MUX_CLK(n, ro, pn, in, f, s, w, cmf)			\
+	[n] = {								\
+		.basename = #n,						\
+		.type = mux,						\
+		.flags = f,						\
+		.reg_offset = ro,					\
+		.init = in,						\
+		.args = {						\
+			.mux = {					\
+				.parent_names = pn,			\
+				.num_parents = ARRAY_SIZE(pn),		\
+				.shift = s,				\
+				.width = w,				\
+				.clk_mux_flags = cmf,			\
+			},						\
+		}							\
+	}
+
+/*
+ * Use this macro to declare a pll clock
+ *
+ * @n : clock name
+ * @parent_name : name of parent
+ * @type : clock type
+ */
+#ifndef xcat
+#define xcat(a, b) a##b
+#endif
+
+#define DECLARE_PLL_CLK(n, pn, t)			\
+	[n] = {						\
+		.basename = #n,				\
+		.type = t,				\
+		.init = xcat(t, _init),			\
+		.args = {				\
+			.t = {				\
+				.parent_name = #pn,	\
+			},				\
+		}					\
+	}
+
+/*
+ * Use this macro to declare a soc-pll clock
+ *
+ * @n : clock name
+ * @parent_name : name of parent
+ */
+#define DECLARE_SOC_PLL_CLK(n, pn)   DECLARE_PLL_CLK(n, pn, soc_pll)
+
+/*
+ * Use this macro to declare an audio-pll clock
+ *
+ * @n : clock name
+ * @parent_name : name of parent
+ */
+#define DECLARE_AUDIO_PLL_CLK(n, pn)  DECLARE_PLL_CLK(n, pn, audio_pll)
+
+/* Arrays with parents */
+
+static __initdata const char *soc_phi_parents[] = {
+	"soc_phia.%d",
+	"soc_phib.%d",
+};
+
+static __initdata const char *audio_pll_sdmmc_parents[] = {
+	"audio_pll_phi.%d",
+	"eaudio_pll_phi_div2.%d",
+};
+
+static __initdata const char *audio_pll_msp_parents[] = {
+	"audio_pll_phi_div4.%d",
+	"audio_pll_phi_div10.%d",
+};
+
+static __initdata const char *audio_pll_sarac_parents[] = {
+	"audio_pll_phi_div4.%d",
+	"audio_pll_phi.%d",
+};
+
+static __initdata const char *hclk_pre_parents[] = {
+	"soc_phi_byp_div3.%d",
+	"soc_phi_byp_div4.%d",
+	"soc_phi_byp_div6.%d",
+	"soc_phi_byp_div3.%d",
+};
+
+static __initdata const char *hclk_parents[] = {
+	"soc_phi_byp.%d",
+	"hclk_pre.%d",
+};
+
+/*
+ * Init functions
+ */
+/*
+ * Init function for soc-pll clock
+ */
+static void __init soc_pll_init(struct sta2x11_clk_data *cptr,
+				struct sta2x11_clk_reg_data *clk_reg_data)
+{
+	cptr->args.soc_pll.base = clk_reg_data->sctl_base;
+	cptr->args.soc_pll.lock = clk_reg_data->sctl_lock;
+}
+
+/*
+ * Init function for audio-pll clock
+ */
+static void __init audio_pll_init(struct sta2x11_clk_data *cptr,
+				  struct sta2x11_clk_reg_data *clk_reg_data)
+{
+	cptr->args.audio_pll.base = clk_reg_data->sctl_base;
+	cptr->args.audio_pll.lock = clk_reg_data->sctl_lock;
+}
+
+/*
+ * Init functions for mux clocks
+ */
+static void __init
+sctl_mux_clock_init(struct sta2x11_clk_data *cptr,
+		    struct sta2x11_clk_reg_data *clk_reg_data)
+{
+	cptr->args.mux.reg = clk_reg_data->sctl_base + cptr->reg_offset;
+	cptr->args.mux.lock = clk_reg_data->sctl_lock;
+}
+
+/*
+ * This table contains everything is needed to register all the clocks
+ * on a single connext instance
+ *
+ * FIXME: this table shall be patched at startup to deal with the (very few
+ * at present) differences between STA2X11 based boards. This will be done
+ * as soon as I know how to deal with platform data.
+ *
+ * FIXME: complete this table with all the remaining clocks (mmc, msp, spi, ...)
+ */
+static __initdata struct sta2x11_clk_data clk_data[] = {
+	/* 24MHz refclk */
+	DECLARE_FIXED_RATE_ROOT_CLK(xtal, 24000000),
+	/* Sata clk */
+	DECLARE_FIXED_RATE_ROOT_CLK(sata, 100000000),
+	/* Eth clk */
+	DECLARE_FIXED_RATE_ROOT_CLK(eth, 50000000),
+	/* Soc pll vco */
+	DECLARE_SOC_PLL_CLK(soc_vco, xtal),
+	/* FIXME : IMPLEMENT soc_phia AND soc_phib AS clk-divider WITH TAB */
+	/* Soc pll vco dividers */
+	DECLARE_FIXED_FACTOR_CLK(soc_phia, soc_vco, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(soc_phib, soc_vco, 0, 1, 5),
+	DECLARE_MUX_CLK(soc_phi, SCTL_SCCTL, soc_phi_parents,
+			sctl_mux_clock_init, 0, 2, 1, 0),
+	/*
+	 * FIXME : CORRECTLY IMPLEMENT THIS ONE AS A DIFFERENT TYPE OF CLOCK
+	 *
+	 * We need a mux clock controlled by a custom function:
+	 *
+	 * soc_phi_byp = soc_phi if pll is locked && !powered down && !bypassed
+	 * soc_phi_byp = xtal otherwise
+	 *
+	 * For now we assume that the soc pll is never bypassed, so we just
+	 * use a fixed factor clock to keep the correct names
+	 */
+	DECLARE_FIXED_FACTOR_CLK(soc_phi_byp, soc_phi, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(clk_48M, soc_phi_byp, 0, 1, 13),
+	DECLARE_FIXED_FACTOR_CLK(soc_phi_byp_div3, soc_phi_byp, 0, 1, 3),
+	DECLARE_FIXED_FACTOR_CLK(soc_phi_byp_div4, soc_phi_byp, 0, 1, 4),
+	DECLARE_FIXED_FACTOR_CLK(soc_phi_byp_div6, soc_phi_byp, 0, 1, 6),
+	DECLARE_FIXED_FACTOR_CLK(clk_52M, soc_phi_byp_div6, 0, 1, 2),
+	DECLARE_MUX_CLK(hclk_pre, SCTL_SCCTL, hclk_pre_parents,
+			sctl_mux_clock_init, 0, 0, 2, 0),
+	DECLARE_MUX_CLK(hclk, SCTL_SCCTL, hclk_parents,
+			sctl_mux_clock_init, 0, 9, 1, 0),
+	/* Audio pll derived clocks */
+	DECLARE_AUDIO_PLL_CLK(audio_pll_phi, xtal),
+	DECLARE_FIXED_FACTOR_CLK(audio_pll_phi_div2, audio_pll_phi, 0, 1, 2),
+	DECLARE_FIXED_FACTOR_CLK(audio_pll_phi_div10, audio_pll_phi, 0, 1, 10),
+	DECLARE_FIXED_FACTOR_CLK(audio_pll_phi_div4, audio_pll_phi_div2,
+				 0, 1, 2),
+	DECLARE_MUX_CLK(audio_pll_sdmmc, SCTL_SCCTL, audio_pll_sdmmc_parents,
+			sctl_mux_clock_init, 0, 8, 1, 0),
+	DECLARE_MUX_CLK(audio_pll_msp, SCTL_SCCTL, audio_pll_msp_parents,
+			sctl_mux_clock_init, 0, 8, 1, 0),
+	DECLARE_MUX_CLK(audio_pll_sarac, SCTL_SCCTL, audio_pll_sarac_parents,
+			sctl_mux_clock_init, 0, 8, 1, 0),
+	/* Peripheral clocks for uarts. FIXME: these are actually gated */
+	DECLARE_FIXED_FACTOR_CLK(hclk_uart0, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_uart1, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_uart2, hclk, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(hclk_uart3, hclk, 0, 1, 1),
+	/* Baud rate clocks for uarts. FIXME: these are actually gated */
+	DECLARE_FIXED_FACTOR_CLK(bclk_uart0, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_uart1, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_uart2, clk_48M, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(bclk_uart3, clk_48M, 0, 1, 1),
+	/* Stmmac clock: FIXME: this is actually a mux with sata */
+	DECLARE_FIXED_FACTOR_CLK(stmmac_rmii, eth, 0, 1, 1),
+	DECLARE_FIXED_FACTOR_CLK(stmmac_csr, stmmac_rmii, 0, 1, 2),
+};
+
+
+/*
+ * The following code registers various clock types for the connext
+ */
+
+typedef struct clk *(regfunc)(struct sta2x11_clk_data *, const char *, int);
+
+static __init struct clk *
+do_register_fixed_rate_root(struct sta2x11_clk_data *cptr,
+			    const char *name,
+			    int instance_id)
+{
+	pr_debug("Registering fixed rate root clock %s, rate = %lu\n",
+		 name, cptr->args.fixed_rate_root.rate);
+	return clk_register_fixed_rate(NULL,
+				       name,
+				       NULL,
+				       cptr->flags,
+				       cptr->args.fixed_rate_root.rate);
+}
+
+static __init struct clk *
+do_register_fixed_factor(struct sta2x11_clk_data *cptr,
+			 const char *name, int instance_id)
+{
+	char parent_name[STA2X11_MAX_CLK_NAME_LEN];
+	snprintf(parent_name, sizeof(parent_name), "%s.%d",
+		 cptr->args.fixed_factor.parent_name, instance_id);
+	return clk_register_fixed_factor(NULL, name,
+					 parent_name,
+					 cptr->flags,
+					 cptr->args.fixed_factor.mult,
+					 cptr->args.fixed_factor.div);
+}
+
+static __init struct clk *
+do_register_mux(struct sta2x11_clk_data *cptr,
+		const char *name, int instance_id)
+{
+	int i, nparents = cptr->args.mux.num_parents;
+	char *parents[STA2X11_MAX_CLK_NPARENTS], *ptr;
+	char parent_names[STA2X11_MAX_CLK_NPARENTS*STA2X11_MAX_CLK_NAME_LEN];
+	if (nparents > STA2X11_MAX_CLK_NPARENTS)
+		return ERR_PTR(-ENOMEM);
+	for (i = 0, ptr = parent_names; i < nparents; i++,
+		     ptr += STA2X11_MAX_CLK_NAME_LEN) {
+		snprintf(ptr, STA2X11_MAX_CLK_NAME_LEN,
+			 cptr->args.mux.parent_names[i], instance_id);
+		parents[i] = ptr;
+	}
+	return clk_register_mux(NULL, name, (const char **)parents,
+				cptr->args.mux.num_parents, cptr->flags,
+				cptr->args.mux.reg, cptr->args.mux.shift,
+				cptr->args.mux.width,
+				cptr->args.mux.clk_mux_flags,
+				cptr->args.mux.lock);
+}
+
+static __init struct clk *
+do_register_tab_divider(struct sta2x11_clk_data *cptr,
+			const char *name, int instance_id)
+{
+	/* FIXME : implement this */
+	return ERR_PTR(-ENODEV);
+}
+
+static __init struct clk *
+do_register_soc_pll(struct sta2x11_clk_data *cptr,
+		    const char *name, int instance_id)
+{
+	char parent_name[STA2X11_MAX_CLK_NAME_LEN];
+	snprintf(parent_name, sizeof(parent_name), "%s.%d",
+		 cptr->args.soc_pll.parent_name, instance_id);
+	pr_debug("%s: registering soc_pll clock %s\n", __func__, name);
+	pr_debug("%s: parent = %s\n", __func__, parent_name);
+	return sta2x11_clk_soc_pll(name, parent_name, cptr->args.soc_pll.base,
+				   cptr->args.soc_pll.lock);
+}
+
+static __init struct clk *
+do_register_audio_pll(struct sta2x11_clk_data *cptr,
+		      const char *name, int instance_id)
+{
+	char parent_name[STA2X11_MAX_CLK_NAME_LEN];
+	snprintf(parent_name, sizeof(parent_name), "%s.%d",
+		 cptr->args.audio_pll.parent_name, instance_id);
+	pr_debug("%s: registering audio_pll clock %s\n", __func__, name);
+	pr_debug("%s: parent = %s\n", __func__, parent_name);
+	return sta2x11_clk_audio_pll(name, parent_name,
+				     cptr->args.audio_pll.base,
+				     cptr->args.audio_pll.lock);
+}
+
+/*
+ * This function registers all the clocks listed in the clk_data table
+ * Such table is static and can be modified on a per-board basis at startup.
+ */
+static __initdata regfunc * regfuncs[] = {
+	[fixed_rate_root] = do_register_fixed_rate_root,
+	[fixed_factor] = do_register_fixed_factor,
+	[mux] = do_register_mux,
+	[tab_divider] = do_register_tab_divider,
+	[soc_pll] = do_register_soc_pll,
+	[audio_pll] = do_register_audio_pll,
+};
+
+static int __init register_clocks(struct sta2x11_instance *instance,
+				  struct sta2x11_clk_reg_data *clk_reg_data)
+{
+	int i, instance_id;
+	struct sta2x11_clk_data *cptr;
+	struct clk *clk, **clks;
+
+	/*
+	 * struct sta2x11_instance is opaque at present.
+	 */
+	instance_id = sta2x11_get_instance_id(instance);
+
+	/*
+	 * When this function is called, kmalloc already works, so we should
+	 * have no problem using it
+	 */
+	clks = kzalloc(sta2x11_n_clks * sizeof(struct clk *), GFP_KERNEL);
+	if (!clks)
+		return -ENOMEM;
+
+	for (i = 0, cptr = clk_data; i < ARRAY_SIZE(clk_data); i++, cptr++) {
+		/*
+		 * name can be on stack, since the clock framework does
+		 * kstrdup on register
+		 */
+		char name[STA2X11_MAX_CLK_NAME_LEN];
+		if (cptr->type < 0 || cptr->type > sta2x11_clk_ntypes) {
+			pr_err("%s: invalid type %d for clk %s, skipping\n",
+			       __func__, cptr->type,
+			       cptr->basename ? cptr->basename : "UNKNOWN");
+			continue;
+		}
+		if (cptr->type == none)
+			/* Clock not implemented on this board */
+			continue;
+		if (!regfuncs[cptr->type]) {
+			pr_err("%s : no regfunc for clk %s, skipping\n",
+			       __func__, cptr->basename ? cptr->basename :
+			       "UNKNOWN");
+			continue;
+		}
+		/*
+		 * Set up a clock name by adding an instance id to its
+		 * basename
+		 */
+		snprintf(name, sizeof(name), "%s.%d", cptr->basename,
+			 instance_id);
+		/*
+		 * This should add runtime data to the clock. In particular,
+		 * it should add the controlling register's virtual address
+		 * (which is unknown at compile time)
+		 */
+		if (cptr->init)
+			cptr->init(cptr, clk_reg_data);
+		/* Ok, now just register the clock */
+		clk = regfuncs[cptr->type](cptr, name, instance_id);
+		if (IS_ERR(clk)) {
+			pr_err("%s error registering clock %s\n",
+			       __func__, name);
+		} else {
+			pr_info("%s: registered clock %s\n", __func__, name);
+			clks[i] = clk;
+			/*
+			  A lookup is also added for each of the registered
+			  clocks
+			*/
+			clk_register_clkdev(clks[i], name, NULL);
+		}
+	}
+	/* Finally assign registered clocks to the instance they belong to */
+	sta2x11_instance_add_clks(instance, clks);
+	return 0;
+}
+
+/*
+ * Notifier routine for platform bus
+ * We basically look for sta2x11-sctl and sta2x11-apb-soc-regs to be
+ * bound to their platform drivers and then ask sta2x11-mfd for a base address
+ * and a spin lock address for each of the two devices. If everyhing is
+ * ok, we register the sta2x11 clocks.
+ */
+static int __devinit sta2x11_clk_notifier_fun(struct notifier_block *nb,
+					  unsigned long action, void *data)
+{
+	struct device *dev = (struct device *)data;
+	struct platform_device *platdev = to_platform_device(dev);
+	const struct mfd_cell *cell = mfd_get_cell(platdev);
+	struct pci_dev *pdev;
+	struct sta2x11_instance *instance;
+	struct sta2x11_clk_reg_data clk_reg_data;
+
+	dev_dbg(dev, "%s entered", __func__);
+
+	/* We are only interested in mfd devices' addition */
+	if (action != BUS_NOTIFY_BOUND_DRIVER) {
+		pr_debug("%s: ignoring action %lu\n", __func__, action);
+		return 0;
+	}
+	if (!cell) {
+		dev_dbg(dev, "%s: ignoring device", __func__);
+		return 0;
+	}
+	if (strcmp(cell->name, STA2X11_MFD_SCTL_NAME) &&
+	    strcmp(cell->name, STA2X11_MFD_APB_SOC_REGS_NAME)) {
+		dev_dbg(dev, "%s: ignoring cell %s\n", __func__, cell->name);
+		return 0;
+	}
+	pdev = *(struct pci_dev **)(dev->platform_data);
+	instance = sta2x11_get_instance(pdev);
+	if (sta2x11_mfd_get_regs_data(platdev, sta2x11_sctl,
+				      &clk_reg_data.sctl_base,
+				      &clk_reg_data.sctl_lock)) {
+		pr_debug("%s : cannot get data on sctl regs\n", __func__);
+		return 0;
+	}
+	if (sta2x11_mfd_get_regs_data(platdev, sta2x11_apb_soc_regs,
+				      &clk_reg_data.apb_soc_base,
+				      &clk_reg_data.apb_soc_lock)) {
+		pr_debug("%s : cannot get data on apb_soc_regs\n", __func__);
+		return 0;
+	}
+	/* Ok, all mfd devices are up and running, we can now register clocks */
+	register_clocks(instance, &clk_reg_data);
+	return 0;
+}
+
+static struct notifier_block sta2x11_clk_notifier __devinitdata = {
+	.notifier_call = sta2x11_clk_notifier_fun
+};
+
+
+/*
+ * This function just registers a notifier for the platform bus to know
+ * when the sta2x11-sctl and sta2x11-apb-soc-regs devices have been bound
+ * to the relevant drivers
+ */
+static int __init sta2x11_init_clocks(void)
+{
+	pr_debug("%s : registering notifier\n", __func__);
+	if (bus_register_notifier(&platform_bus_type, &sta2x11_clk_notifier))
+		pr_err("%s: error registering platform bus notifier\n",
+		       __func__);
+	return 0;
+}
+subsys_initcall(sta2x11_init_clocks);
+
+/*
+ * This is invoked on pci_enable() for every connext pci device
+ *
+ * It registers a lookup for the device's clock (if needed), so that
+ * the driver can find it.
+ */
+static void clk_new_pdev(struct pci_dev *pdev)
+{
+	struct sta2x11_instance *instance = sta2x11_get_instance(pdev);
+	int instance_id;
+	/* Initialize with an invalid index */
+	enum sta2x11_clk clk_index = sta2x11_n_clks;
+	struct clk **clks;
+	char *name = devm_kzalloc(&pdev->dev, strlen(dev_name(&pdev->dev)) + 6,
+				  GFP_KERNEL);
+	if (!instance)
+		/* Just ignore devices not belonging to the connext */
+		return;
+	instance_id = sta2x11_get_instance_id(instance);
+
+	clks = sta2x11_instance_get_clks(instance);
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_STMICRO_UART_HWFC:
+		clk_index = pdev->devfn == 5 ? bclk_uart2 : bclk_uart3;
+		/* FALL THROUGH */
+	case PCI_DEVICE_ID_STMICRO_UART_NO_HWFC:
+		if (clk_index == sta2x11_n_clks)
+			clk_index = pdev->devfn == 5 ? bclk_uart0 : bclk_uart1;
+		sprintf(name, "amba-%s", dev_name(&pdev->dev));
+		clk_register_clkdev(clks[clk_index], NULL, name,
+				    pdev->bus->number, pdev->devfn);
+		break;
+	case PCI_DEVICE_ID_STMICRO_MAC:
+		clk_register_clkdev(clks[stmmac_csr], NULL,
+				    dev_name(&pdev->dev));
+		break;
+		/* FIXME : ADD MORE ID's HERE */
+	default:
+		dev_dbg(&pdev->dev, "clk: ignoring device\n");
+		break;
+	}
+}
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, clk_new_pdev);
-- 
1.7.9.1

