Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2KTA10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:27:26 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33205 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2KTA1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:27:25 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 1/2] clocksource: add common of_clksrc_init() function
Date: Mon, 19 Nov 2012 17:27:16 -0700
Message-Id: <1353371237-2482-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

It is desirable to move all clocksource drivers to drivers/clocksource,
yet each requires its own initialization function. We'd rather not
pollute <linux/> with a header for each function. Instead, create a
single of_clksrc_init() function which will determine which clocksource
driver to initialize based on device tree.

Based on a similar patch for drivers/irqchip by Thomas Petazzoni.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: New patch.

This series is based on the ARM sys_timer rework that I reposted today.

I hope that these patches can be taken through arm-soc tree for 3.9;
I will repost them based on 3.8-rc1 at the appropriate time.
---
 drivers/clocksource/Kconfig     |    3 +++
 drivers/clocksource/Makefile    |    1 +
 drivers/clocksource/clksrc-of.c |   37 +++++++++++++++++++++++++++++++++++++
 drivers/clocksource/clksrc-of.h |   20 ++++++++++++++++++++
 include/linux/clocksource.h     |    2 ++
 5 files changed, 63 insertions(+)
 create mode 100644 drivers/clocksource/clksrc-of.c
 create mode 100644 drivers/clocksource/clksrc-of.h

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index c9f67de..4f300c5 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -1,3 +1,6 @@
+config CLKSRC_OF
+	bool
+
 config CLKSRC_I8253
 	bool
 
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 24fb888..29017a3 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_CLKSRC_OF)	+= clksrc-of.o
 obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_clksrc.o
 obj-$(CONFIG_X86_CYCLONE_TIMER)	+= cyclone.o
 obj-$(CONFIG_X86_PM_TIMER)	+= acpi_pm.o
diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
new file mode 100644
index 0000000..aeec8d2
--- /dev/null
+++ b/drivers/clocksource/clksrc-of.c
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/init.h>
+#include <linux/of.h>
+
+#include "clksrc-of.h"
+
+static const struct of_device_id clksrc_of_match[] __initconst = {
+	{ }
+};
+
+void __init clocksource_of_init(void)
+{
+	struct device_node *np;
+	const struct of_device_id *match;
+	void (*init_func)(void);
+
+	for_each_matching_node(np, clksrc_of_match) {
+		match = of_match_node(clksrc_of_match, np);
+		init_func = match->data;
+		init_func();
+	}
+}
diff --git a/drivers/clocksource/clksrc-of.h b/drivers/clocksource/clksrc-of.h
new file mode 100644
index 0000000..4e2191a
--- /dev/null
+++ b/drivers/clocksource/clksrc-of.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _CLKSRC_OF_H
+#define _CLKSRC_OF_H
+
+#endif
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 4dceaf8..a063b84 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -332,4 +332,6 @@ extern int clocksource_mmio_init(void __iomem *, const char *,
 
 extern int clocksource_i8253_init(void);
 
+extern void clocksource_of_init(void);
+
 #endif /* _LINUX_CLOCKSOURCE_H */
-- 
1.7.10.4

