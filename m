Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851Ab1KAASR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:18:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60405 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934830Ab1KAASM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:18:12 -0400
Message-Id: <093448$3uejug@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132599760"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:52:53 -0500
Subject: [PATCH v5 28/36] Hexagon: Add ioremap support
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/mm/ioremap.c |   56 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/mm/ioremap.c

diff --git a/arch/hexagon/mm/ioremap.c b/arch/hexagon/mm/ioremap.c
new file mode 100644
index 0000000..3a37bc3
--- /dev/null
+++ b/arch/hexagon/mm/ioremap.c
@@ -0,0 +1,56 @@
+/*
+ * I/O remap functions for Hexagon
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
+#include <linux/io.h>
+#include <linux/vmalloc.h>
+
+void __iomem *ioremap_nocache(unsigned long phys_addr, unsigned long size)
+{
+	unsigned long last_addr, addr;
+	unsigned long offset = phys_addr & ~PAGE_MASK;
+	struct vm_struct *area;
+
+	pgprot_t prot = __pgprot(_PAGE_PRESENT|_PAGE_READ|_PAGE_WRITE
+					|(__HEXAGON_C_DEV << 6));
+
+	last_addr = phys_addr + size - 1;
+
+	/*  Wrapping not allowed  */
+	if (!size || (last_addr < phys_addr))
+		return NULL;
+
+	/*  Rounds up to next page size, including whole-page offset */
+	size = PAGE_ALIGN(offset + size);
+
+	area = get_vm_area(size, VM_IOREMAP);
+	addr = (unsigned long)area->addr;
+
+	if (ioremap_page_range(addr, addr+size, phys_addr, prot)) {
+		vunmap((void *)addr);
+		return NULL;
+	}
+
+	return (void __iomem *) (offset + addr);
+}
+
+void __iounmap(const volatile void __iomem *addr)
+{
+	vunmap((void *) ((unsigned long) addr & PAGE_MASK));
+}
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
