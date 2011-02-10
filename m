Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1BJGpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:45:06 -0500
Received: from smtp-out.google.com ([74.125.121.67]:20124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1BJGoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:44:10 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/15] ARM: tegra: Add api to control internal powergating
Date: Wed,  9 Feb 2011 22:43:11 -0800
Message-Id: <1297320204-31882-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/Makefile                 |    1 +
 arch/arm/mach-tegra/include/mach/powergate.h |   40 +++++
 arch/arm/mach-tegra/powergate.c              |  212 ++++++++++++++++++++++++++
 3 files changed, 253 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/powergate.h
 create mode 100644 arch/arm/mach-tegra/powergate.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index cdbc68e..00a6ba3 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -5,6 +5,7 @@ obj-y                                   += clock.o
 obj-y                                   += timer.o
 obj-y                                   += gpio.o
 obj-y                                   += pinmux.o
+obj-y                                   += powergate.o
 obj-y					+= fuse.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clock.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
diff --git a/arch/arm/mach-tegra/include/mach/powergate.h b/arch/arm/mach-tegra/include/mach/powergate.h
new file mode 100644
index 0000000..401d1b7
--- /dev/null
+++ b/arch/arm/mach-tegra/include/mach/powergate.h
@@ -0,0 +1,40 @@
+/*
+ * drivers/regulator/tegra-regulator.c
+ *
+ * Copyright (c) 2010 Google, Inc
+ *
+ * Author:
+ *	Colin Cross <ccross@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _MACH_TEGRA_POWERGATE_H_
+#define _MACH_TEGRA_POWERGATE_H_
+
+#define TEGRA_POWERGATE_CPU	0
+#define TEGRA_POWERGATE_3D	1
+#define TEGRA_POWERGATE_VENC	2
+#define TEGRA_POWERGATE_PCIE	3
+#define TEGRA_POWERGATE_VDEC	4
+#define TEGRA_POWERGATE_L2	5
+#define TEGRA_POWERGATE_MPE	6
+#define TEGRA_NUM_POWERGATE	7
+
+int tegra_powergate_power_on(int id);
+int tegra_powergate_power_off(int id);
+bool tegra_powergate_is_powered(int id);
+int tegra_powergate_remove_clamping(int id);
+
+/* Must be called with clk disabled, and returns with clk enabled */
+int tegra_powergate_sequence_power_up(int id, struct clk *clk);
+
+#endif /* _MACH_TEGRA_POWERGATE_H_ */
diff --git a/arch/arm/mach-tegra/powergate.c b/arch/arm/mach-tegra/powergate.c
new file mode 100644
index 0000000..3cee9aa
--- /dev/null
+++ b/arch/arm/mach-tegra/powergate.c
@@ -0,0 +1,212 @@
+/*
+ * drivers/powergate/tegra-powergate.c
+ *
+ * Copyright (c) 2010 Google, Inc
+ *
+ * Author:
+ *	Colin Cross <ccross@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/seq_file.h>
+#include <linux/spinlock.h>
+
+#include <mach/clk.h>
+#include <mach/iomap.h>
+#include <mach/powergate.h>
+
+#define PWRGATE_TOGGLE		0x30
+#define  PWRGATE_TOGGLE_START	(1 << 8)
+
+#define REMOVE_CLAMPING		0x34
+
+#define PWRGATE_STATUS		0x38
+
+static DEFINE_SPINLOCK(tegra_powergate_lock);
+
+static void __iomem *pmc = IO_ADDRESS(TEGRA_PMC_BASE);
+
+static u32 pmc_read(unsigned long reg)
+{
+	return readl(pmc + reg);
+}
+
+static void pmc_write(u32 val, unsigned long reg)
+{
+	writel(val, pmc + reg);
+}
+
+static int tegra_powergate_set(int id, bool new_state)
+{
+	bool status;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tegra_powergate_lock, flags);
+
+	status = pmc_read(PWRGATE_STATUS) & (1 << id);
+
+	if (status == new_state) {
+		spin_unlock_irqrestore(&tegra_powergate_lock, flags);
+		return -EINVAL;
+	}
+
+	pmc_write(PWRGATE_TOGGLE_START | id, PWRGATE_TOGGLE);
+
+	spin_unlock_irqrestore(&tegra_powergate_lock, flags);
+
+	return 0;
+}
+
+int tegra_powergate_power_on(int id)
+{
+	if (id < 0 || id >= TEGRA_NUM_POWERGATE)
+		return -EINVAL;
+
+	return tegra_powergate_set(id, true);
+}
+
+int tegra_powergate_power_off(int id)
+{
+	if (id < 0 || id >= TEGRA_NUM_POWERGATE)
+		return -EINVAL;
+
+	return tegra_powergate_set(id, false);
+}
+
+bool tegra_powergate_is_powered(int id)
+{
+	u32 status;
+
+	if (id < 0 || id >= TEGRA_NUM_POWERGATE)
+		return -EINVAL;
+
+	status = pmc_read(PWRGATE_STATUS) & (1 << id);
+	return !!status;
+}
+
+int tegra_powergate_remove_clamping(int id)
+{
+	u32 mask;
+
+	if (id < 0 || id >= TEGRA_NUM_POWERGATE)
+		return -EINVAL;
+
+	/*
+	 * Tegra 2 has a bug where PCIE and VDE clamping masks are
+	 * swapped relatively to the partition ids
+	 */
+	if (id ==  TEGRA_POWERGATE_VDEC)
+		mask = (1 << TEGRA_POWERGATE_PCIE);
+	else if	(id == TEGRA_POWERGATE_PCIE)
+		mask = (1 << TEGRA_POWERGATE_VDEC);
+	else
+		mask = (1 << id);
+
+	pmc_write(mask, REMOVE_CLAMPING);
+
+	return 0;
+}
+
+/* Must be called with clk disabled, and returns with clk enabled */
+int tegra_powergate_sequence_power_up(int id, struct clk *clk)
+{
+	int ret;
+
+	tegra_periph_reset_assert(clk);
+
+	ret = tegra_powergate_power_on(id);
+	if (ret)
+		goto err_power;
+
+	ret = clk_enable(clk);
+	if (ret)
+		goto err_clk;
+
+	udelay(10);
+
+	ret = tegra_powergate_remove_clamping(id);
+	if (ret)
+		goto err_clamp;
+
+	udelay(10);
+	tegra_periph_reset_deassert(clk);
+
+	return 0;
+
+err_clamp:
+	clk_disable(clk);
+err_clk:
+	tegra_powergate_power_off(id);
+err_power:
+	return ret;
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+static const char * const powergate_name[] = {
+	[TEGRA_POWERGATE_CPU]	= "cpu",
+	[TEGRA_POWERGATE_3D]	= "3d",
+	[TEGRA_POWERGATE_VENC]	= "venc",
+	[TEGRA_POWERGATE_VDEC]	= "vdec",
+	[TEGRA_POWERGATE_PCIE]	= "pcie",
+	[TEGRA_POWERGATE_L2]	= "l2",
+	[TEGRA_POWERGATE_MPE]	= "mpe",
+};
+
+static int powergate_show(struct seq_file *s, void *data)
+{
+	int i;
+
+	seq_printf(s, " powergate powered\n");
+	seq_printf(s, "------------------\n");
+
+	for (i = 0; i < TEGRA_NUM_POWERGATE; i++)
+		seq_printf(s, " %9s %7s\n", powergate_name[i],
+			tegra_powergate_is_powered(i) ? "yes" : "no");
+	return 0;
+}
+
+static int powergate_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, powergate_show, inode->i_private);
+}
+
+static const struct file_operations powergate_fops = {
+	.open		= powergate_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init powergate_debugfs_init(void)
+{
+	struct dentry *d;
+	int err = -ENOMEM;
+
+	d = debugfs_create_file("powergate", S_IRUGO, NULL, NULL,
+		&powergate_fops);
+	if (!d)
+		return -ENOMEM;
+
+	return err;
+}
+
+late_initcall(powergate_debugfs_init);
+
+#endif
-- 
1.7.3.1

