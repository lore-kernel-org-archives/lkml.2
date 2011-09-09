Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1IIBOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:14:06 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30784 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab1IIBLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116679250"
Message-Id: <20110909010917.374485496@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:09:15 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch v3 28/36] Hexagon: Add ioremap support
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=ioremap.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant flush_cache_vmap.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/mm/ioremap.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/mm/ioremap.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/mm/ioremap.c	2011-09-03 20:14:59.784981559 -0500
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

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

