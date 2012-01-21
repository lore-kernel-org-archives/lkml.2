Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab2AVACQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 19:02:16 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:37093 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2AVACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 19:02:14 -0500
MBOX-Line: From nobody Sat Jan 21 16:59:32 2012
Subject: [PATCH 2/8] ARM: OMAP2+: HDQ1W: add custom reset function
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>, "Avinash.H.M" <avinashhm@ti.com>
Date: Sat, 21 Jan 2012 16:59:32 -0700
Message-ID: <20120121235931.17619.78948.stgit@dusk>
In-Reply-To: <20120121235333.17619.56725.stgit@dusk>
References: <20120121235333.17619.56725.stgit@dusk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a custom reset function for the HDQ1W IP block.  This is
because the HDQ1W IP block, like I2C, has an internal clock gating bit
that needs to be toggled after setting the SOFTRESET bit to allow the
reset to propagate.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Avinash.H.M <avinashhm@ti.com>
---
 arch/arm/mach-omap2/Makefile            |    2 -
 arch/arm/mach-omap2/hdq1w.c             |   72 +++++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/hdq1w.h |   36 ++++++++++++++++
 3 files changed, 109 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-omap2/hdq1w.c
 create mode 100644 arch/arm/plat-omap/include/plat/hdq1w.h

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index fc9b238..f7fb929 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -4,7 +4,7 @@
 
 # Common support
 obj-y := id.o io.o control.o mux.o devices.o serial.o gpmc.o timer.o pm.o \
-	 common.o gpio.o dma.o wd_timer.o display.o
+	 common.o gpio.o dma.o wd_timer.o display.o hdq1w.o
 
 omap-2-3-common				= irq.o sdrc.o
 hwmod-common				= omap_hwmod.o \
diff --git a/arch/arm/mach-omap2/hdq1w.c b/arch/arm/mach-omap2/hdq1w.c
new file mode 100644
index 0000000..15849ce
--- /dev/null
+++ b/arch/arm/mach-omap2/hdq1w.c
@@ -0,0 +1,72 @@
+/*
+ * IP block integration code for the HDQ1W/1-wire IP block
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ * Paul Walmsley
+ *
+ * Based on the I2C reset code in arch/arm/mach-omap2/i2c.c by
+ *     Avinash.H.M <avinashhm@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <plat/omap_hwmod.h>
+#include <plat/hdq1w.h>
+
+#include "common.h"
+
+/* Maximum microseconds to wait for OMAP module to softreset */
+#define MAX_MODULE_SOFTRESET_WAIT	10000
+
+/**
+ * omap_hdq1w_reset - reset the OMAP HDQ1W module
+ * @oh: struct omap_hwmod *
+ *
+ * OCP soft reset the HDQ1W IP block.  Section 20.6.1.4 "HDQ1W/1-Wire
+ * Software Reset" of the OMAP34xx Technical Reference Manual Revision
+ * ZR (SWPU223R) does not include the rather important fact that, for
+ * the reset to succeed, the HDQ1W module's internal clock gate must be
+ * programmed to allow the clock to propagate to the rest of the
+ * module.  In this sense, it's rather similar to the I2C custom reset
+ * function.  Returns 0.
+ */
+int omap_hdq1w_reset(struct omap_hwmod *oh)
+{
+	u32 v;
+	int c = 0;
+
+	/* Write to the SOFTRESET bit */
+	omap_hwmod_softreset(oh);
+
+	/* Enable the module's internal clocks */
+	v = omap_hwmod_read(oh, HDQ_CTRL_STATUS_OFFSET);
+	v |= 1 << HDQ_CTRL_STATUS_CLOCKENABLE_SHIFT;
+	omap_hwmod_write(v, oh, HDQ_CTRL_STATUS_OFFSET);
+
+	/* Poll on RESETDONE bit */
+	omap_test_timeout((omap_hwmod_read(oh,
+				oh->class->sysc->syss_offs)
+				& SYSS_RESETDONE_MASK),
+				MAX_MODULE_SOFTRESET_WAIT, c);
+
+	if (c == MAX_MODULE_SOFTRESET_WAIT)
+		pr_warning("%s: %s: softreset failed (waited %d usec)\n",
+			__func__, oh->name, MAX_MODULE_SOFTRESET_WAIT);
+	else
+		pr_debug("%s: %s: softreset in %d usec\n", __func__,
+			oh->name, c);
+
+	return 0;
+}
diff --git a/arch/arm/plat-omap/include/plat/hdq1w.h b/arch/arm/plat-omap/include/plat/hdq1w.h
new file mode 100644
index 0000000..0c1efc8
--- /dev/null
+++ b/arch/arm/plat-omap/include/plat/hdq1w.h
@@ -0,0 +1,36 @@
+/*
+ * Shared macros and function prototypes for the HDQ1W/1-wire IP block
+ *
+ * Copyright (C) 2012 Texas Instruments, Inc.
+ * Paul Walmsley
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#ifndef ARCH_ARM_MACH_OMAP2_HDQ1W_H
+#define ARCH_ARM_MACH_OMAP2_HDQ1W_H
+
+#include <plat/omap_hwmod.h>
+
+/*
+ * XXX A future cleanup patch should modify
+ * drivers/w1/masters/omap_hdq.c to use these macros
+ */
+#define HDQ_CTRL_STATUS_OFFSET			0x0c
+#define HDQ_CTRL_STATUS_CLOCKENABLE_SHIFT	5
+
+
+extern int omap_hdq1w_reset(struct omap_hwmod *oh);
+
+#endif


