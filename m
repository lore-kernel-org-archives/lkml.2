Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab0JLQ2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:28:21 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:58846
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757777Ab0JLQ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:28:19 -0400
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <r.schwebel@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <amit.kucheria@canonical.com>,
        <xiao-lizhang@freescale.com>, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv7] ARM: imx: Add iram allocator functions
Date: Tue, 12 Oct 2010 11:29:01 -0500
Message-ID: <1286900941-18123-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Add IRAM(Internal RAM) allocation functions using GENERIC_ALLOCATOR.
The allocation size is 4KB multiples to guarantee alignment. The
idea for these functions is for i.MX platforms to use them
to dynamically allocate IRAM usage.

Applies on 2.6.36-rc7

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Reviewed-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/plat-mxc/Kconfig             |    4 ++
 arch/arm/plat-mxc/Makefile            |    1 +
 arch/arm/plat-mxc/include/mach/iram.h |   41 ++++++++++++++++++
 arch/arm/plat-mxc/iram_alloc.c        |   73 +++++++++++++++++++++++++++++++++
 4 files changed, 119 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/iram.h
 create mode 100644 arch/arm/plat-mxc/iram_alloc.c

diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
index 6785db4..0e99bb4 100644
--- a/arch/arm/plat-mxc/Kconfig
+++ b/arch/arm/plat-mxc/Kconfig
@@ -110,4 +110,8 @@ config ARCH_MXC_AUDMUX_V1
 config ARCH_MXC_AUDMUX_V2
 	bool
 
+config IRAM_ALLOC
+	bool
+	select GENERIC_ALLOCATOR
+
 endif
diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
index 78d405e..1ddfb13 100644
--- a/arch/arm/plat-mxc/Makefile
+++ b/arch/arm/plat-mxc/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_MXC_TZIC) += tzic.o
 
 obj-$(CONFIG_IMX_HAVE_IOMUX_V1) += iomux-v1.o
 obj-$(CONFIG_ARCH_MXC_IOMUX_V3) += iomux-v3.o
+obj-$(CONFIG_IRAM_ALLOC) += iram_alloc.o
 obj-$(CONFIG_MXC_PWM)  += pwm.o
 obj-$(CONFIG_USB_EHCI_MXC) += ehci.o
 obj-$(CONFIG_MXC_ULPI) += ulpi.o
diff --git a/arch/arm/plat-mxc/include/mach/iram.h b/arch/arm/plat-mxc/include/mach/iram.h
new file mode 100644
index 0000000..022690c
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/iram.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA 02110-1301, USA.
+ */
+#include <linux/errno.h>
+
+#ifdef CONFIG_IRAM_ALLOC
+
+int __init iram_init(unsigned long base, unsigned long size);
+void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr);
+void iram_free(unsigned long dma_addr, unsigned int size);
+
+#else
+
+static inline int __init iram_init(unsigned long base, unsigned long size)
+{
+	return -ENOMEM;
+}
+
+static inline void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
+{
+	return NULL;
+}
+
+static inline void iram_free(unsigned long base, unsigned long size) {}
+
+#endif
diff --git a/arch/arm/plat-mxc/iram_alloc.c b/arch/arm/plat-mxc/iram_alloc.c
new file mode 100644
index 0000000..074c386
--- /dev/null
+++ b/arch/arm/plat-mxc/iram_alloc.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA 02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/genalloc.h>
+#include <mach/iram.h>
+
+static unsigned long iram_phys_base;
+static void __iomem *iram_virt_base;
+static struct gen_pool *iram_pool;
+
+static inline void __iomem *iram_phys_to_virt(unsigned long p)
+{
+	return iram_virt_base + (p - iram_phys_base);
+}
+
+void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
+{
+	if (!iram_pool)
+		return NULL;
+
+	*dma_addr = gen_pool_alloc(iram_pool, size);
+	pr_debug("iram alloc - %dB@0x%lX\n", size, *dma_addr);
+	if (!*dma_addr)
+		return NULL;
+	return iram_phys_to_virt(*dma_addr);
+}
+EXPORT_SYMBOL(iram_alloc);
+
+void iram_free(unsigned long addr, unsigned int size)
+{
+	if (!iram_pool)
+		return;
+
+	gen_pool_free(iram_pool, addr, size);
+}
+EXPORT_SYMBOL(iram_free);
+
+int __init iram_init(unsigned long base, unsigned long size)
+{
+	iram_phys_base = base;
+
+	iram_pool = gen_pool_create(PAGE_SHIFT, -1);
+	if (!iram_pool)
+		return -ENOMEM;
+
+	gen_pool_add(iram_pool, base, size, -1);
+	iram_virt_base = ioremap(iram_phys_base, size);
+	if (!iram_virt_base)
+		return -EIO;
+
+	pr_debug("i.MX IRAM pool: %ld KB@0x%p\n", size / 1024, iram_virt_base);
+	return 0;
+}
-- 
1.6.0.4


