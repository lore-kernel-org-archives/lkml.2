Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0JETmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:42:09 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:2773 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0JETmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:42:08 -0400
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1202hzz8275bhz2dh2a8h62h)
X-Spam-TCS-SCL: 1:0
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <s.hauer@pengutronix.de>,
        <r.schwebel@pengutronix.de>, <valentin.longchamp@epfl.ch>,
        <daniel@caiaq.de>, <grant.likely@secretlab.ca>,
        <amit.kucheria@canonical.com>, <xiao-lizhang@freescale.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv3] ARM: imx: Add iram allocator functions
Date: Tue, 5 Oct 2010 14:41:55 -0500
Message-ID: <1286307715-12276-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: az33egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Add iram allocation functions using GENERIC_ALLOCATOR. The
allocation size is 4KB multiples to guarantee alignment. The
idea for these functions is for i.MX platforms to use them
to dynamically allocate IRAM usage.

Applies on 2.6.36-rc6

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Reviewed-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/plat-mxc/Kconfig                   |    9 ++++
 arch/arm/plat-mxc/Makefile                  |    1 +
 arch/arm/plat-mxc/include/mach/iram_alloc.h |   35 +++++++++++++++
 arch/arm/plat-mxc/iram.c                    |   62 +++++++++++++++++++++++++++
 4 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/iram_alloc.h
 create mode 100644 arch/arm/plat-mxc/iram.c

diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
index 6785db4..e6de0df 100644
--- a/arch/arm/plat-mxc/Kconfig
+++ b/arch/arm/plat-mxc/Kconfig
@@ -57,6 +57,15 @@ source "arch/arm/mach-mx5/Kconfig"
 
 endmenu
 
+config IRAM_ALLOC
+	bool "Enable IRAM allocator"
+	select GENERIC_ALLOCATOR
+	help
+	  Select this to have access to generic IRAM allocation functions that
+	  use the GENERIC_ALLOCATOR.  The allocation size is 4KB multiples to 
+	  guarantee alignment. The idea for these functions is for i.MX platforms
+	  to use them to dynamically allocate IRAM usage.
+
 config MXC_IRQ_PRIOR
 	bool "Use IRQ priority"
 	help
diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
index 78d405e..35cf07b 100644
--- a/arch/arm/plat-mxc/Makefile
+++ b/arch/arm/plat-mxc/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_MXC_TZIC) += tzic.o
 
 obj-$(CONFIG_IMX_HAVE_IOMUX_V1) += iomux-v1.o
 obj-$(CONFIG_ARCH_MXC_IOMUX_V3) += iomux-v3.o
+obj-$(CONFIG_IRAM_ALLOC) += iram.o
 obj-$(CONFIG_MXC_PWM)  += pwm.o
 obj-$(CONFIG_USB_EHCI_MXC) += ehci.o
 obj-$(CONFIG_MXC_ULPI) += ulpi.o
diff --git a/arch/arm/plat-mxc/include/mach/iram_alloc.h b/arch/arm/plat-mxc/include/mach/iram_alloc.h
new file mode 100644
index 0000000..12881aa
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/iram_alloc.h
@@ -0,0 +1,35 @@
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
+#ifdef CONFIG_IRAM_ALLOC
+int __init iram_init(unsigned long base, unsigned long size);
+void *iram_alloc(unsigned int size, unsigned long *dma_addr);
+void iram_free(unsigned long dma_addr, unsigned int size);
+#else
+static inline int __init iram_init(unsigned long base, unsigned long size)
+{
+	return -ENOMEM;
+}
+static inline void *iram_alloc(unsigned int size, unsigned long *dma_addr)
+{
+	return NULL;
+}
+static inline void iram_free(unsigned long base, unsigned long size) {}
+#endif
+
diff --git a/arch/arm/plat-mxc/iram.c b/arch/arm/plat-mxc/iram.c
new file mode 100644
index 0000000..d59fe75
--- /dev/null
+++ b/arch/arm/plat-mxc/iram.c
@@ -0,0 +1,62 @@
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
+
+static unsigned long iram_phys_base;
+static __iomem void *iram_virt_base;
+static struct gen_pool *iram_pool;
+
+#define iram_phys_to_virt(p) (iram_virt_base + ((p) - iram_phys_base))
+
+void *iram_alloc(unsigned int size, unsigned long *dma_addr)
+{
+	if (!iram_pool)
+		return NULL;
+
+	*dma_addr = gen_pool_alloc(iram_pool, size);
+	pr_debug("iram alloc - %dB@0x%p\n", size, (void *)*dma_addr);
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
+	gen_pool_add(iram_pool, base, size, -1);
+	iram_virt_base = ioremap(iram_phys_base, size);
+
+	pr_info("i.MX IRAM pool: %ld KB@0x%p\n", size / 1024, iram_virt_base);
+	return 0;
+}
-- 
1.6.0.4


