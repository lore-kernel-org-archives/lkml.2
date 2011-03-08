Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1CHPH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:07:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57970 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab1CHPHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:07:22 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv6 4/5] picoxcell: basic clk infrastructure
Date: Tue,  8 Mar 2011 15:06:56 +0000
Message-Id: <1299596817-19879-5-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299596817-19879-1-git-send-email-jamie@jamieiles.com>
References: <1299596817-19879-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The different picoXcell device variants have different numbers of clocks
and different capabilities (PC3X2 doesn't have any gateable or
controllable clocks). Add the infrastructure necessary for device
variants to provide their own clock implementation.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 arch/arm/Kconfig                              |    1 +
 arch/arm/mach-picoxcell/Makefile              |    3 +-
 arch/arm/mach-picoxcell/clk.c                 |   83 +++++++++++++++++++++++++
 arch/arm/mach-picoxcell/include/mach/clkdev.h |   70 +++++++++++++++++++++
 arch/arm/mach-picoxcell/picoxcell_core.c      |    1 +
 5 files changed, 157 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-picoxcell/clk.c
 create mode 100644 arch/arm/mach-picoxcell/include/mach/clkdev.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 75ff454..7d67e68 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -612,6 +612,7 @@ config ARCH_PICOXCELL
 	select HAVE_SCHED_CLOCK
 	select CPU_V6K
 	select HAVE_TCM
+	select CLKDEV_LOOKUP
 	help
 	  This enables support for systems based on the Picochip picoXcell
 	  family of Femtocell devices.
diff --git a/arch/arm/mach-picoxcell/Makefile b/arch/arm/mach-picoxcell/Makefile
index 3cace37..f6fc8de 100644
--- a/arch/arm/mach-picoxcell/Makefile
+++ b/arch/arm/mach-picoxcell/Makefile
@@ -1,3 +1,4 @@
 obj-y				:= picoxcell_core.o io.o axi2cfg.o \
 				   time.o \
-				   devices.o
+				   devices.o \
+				   clk.o
diff --git a/arch/arm/mach-picoxcell/clk.c b/arch/arm/mach-picoxcell/clk.c
new file mode 100644
index 0000000..b32e478
--- /dev/null
+++ b/arch/arm/mach-picoxcell/clk.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright (c) 2010 Picochip Ltd., Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * All enquiries to support@picochip.com
+ */
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/spinlock.h>
+
+#include <mach/clkdev.h>
+
+static DEFINE_SPINLOCK(clk_lock);
+static LIST_HEAD(picoxcell_clks);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	return clk->get_rate ? clk->get_rate(clk) : clk->rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	return clk->round_rate ? clk->round_rate(clk, rate) : -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(clk_round_rate);
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	return clk->set_rate ? clk->set_rate(clk, rate) : 0;
+}
+EXPORT_SYMBOL(clk_set_rate);
+
+int __clk_enable(struct clk *clk)
+{
+	if (++clk->enable_count > 0) {
+		if (clk->enable)
+			clk->enable(clk);
+	}
+
+	return 0;
+}
+
+int clk_enable(struct clk *clk)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&clk_lock, flags);
+	ret = __clk_enable(clk);
+	spin_unlock_irqrestore(&clk_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void __clk_disable(struct clk *clk)
+{
+	if (--clk->enable_count <= 0) {
+		if (clk->disable)
+			clk->disable(clk);
+	}
+}
+
+void clk_disable(struct clk *clk)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clk_lock, flags);
+	__clk_disable(clk);
+	spin_unlock_irqrestore(&clk_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+void picoxcell_clk_add(struct clk *clk)
+{
+	list_add_tail(&clk->head, &picoxcell_clks);
+}
diff --git a/arch/arm/mach-picoxcell/include/mach/clkdev.h b/arch/arm/mach-picoxcell/include/mach/clkdev.h
new file mode 100644
index 0000000..93c6058
--- /dev/null
+++ b/arch/arm/mach-picoxcell/include/mach/clkdev.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2010 Picochip Ltd., Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * All enquiries to support@picochip.com
+ */
+#ifndef __PICOXCELL_CLKDEV_H__
+#define __PICOXCELL_CLKDEV_H__
+
+#include <linux/clkdev.h>
+
+struct clk {
+	const char	    *name;
+	struct list_head    head;
+	int		    rate;
+	unsigned	    min, max, step; /* min, max and frequency steps for
+					       variable rate clocks in KHz. */
+	int		    enable_count;
+	int		    clk_num;
+	void		    (*enable)(struct clk *clk);
+	void		    (*disable)(struct clk *clk);
+	int		    (*is_enabled)(struct clk *clk);
+	long		    (*round_rate)(struct clk *clk, unsigned long rate);
+	int		    (*set_rate)(struct clk *clk, unsigned long rate);
+	int		    (*get_rate)(struct clk *clk);
+};
+
+static inline int __clk_get(struct clk *clk)
+{
+	return 1;
+}
+
+static inline void __clk_put(struct clk *clk)
+{
+}
+
+extern void picoxcell_clk_add(struct clk *clk);
+extern int __clk_enable(struct clk *clk);
+extern void __clk_disable(struct clk *clk);
+
+/*
+ * Declare a new clock with a given rate and ID. All clocks are enabled by
+ * default.
+ */
+#define FIXED_CLK(__name, __rate, __id)					\
+	static struct clk __name ## _clk = {				\
+		.name		= #__name,				\
+		.rate		= __rate,				\
+		.clk_num	= __id,					\
+		.enable_count	= 1,					\
+	}
+
+#define VARIABLE_CLK(__name, __id, __min, __max, __step)		\
+	static struct clk __name ## _clk = {				\
+		.name		= #__name,				\
+		.clk_num	= __id,					\
+		.enable_count	= 1,					\
+		.rate		= -1,					\
+		.min		= __min,				\
+		.max		= __max,				\
+		.step		= __step,				\
+	}
+
+#define CLK_LOOKUP(__dev_id, __con_id, __clk) \
+	{ .dev_id = __dev_id, .con_id = __con_id, .clk = __clk }
+
+#endif /* __PICOXCELL_CLKDEV_H__ */
diff --git a/arch/arm/mach-picoxcell/picoxcell_core.c b/arch/arm/mach-picoxcell/picoxcell_core.c
index a54d981..3716d03 100644
--- a/arch/arm/mach-picoxcell/picoxcell_core.c
+++ b/arch/arm/mach-picoxcell/picoxcell_core.c
@@ -14,6 +14,7 @@
 #include <asm/hardware/vic.h>
 #include <asm/mach-types.h>
 
+#include <mach/clkdev.h>
 #include <mach/hardware.h>
 
 #include "picoxcell_core.h"
-- 
1.7.4

