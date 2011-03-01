Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1CABMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 20:12:12 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4838 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1CABLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 20:11:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6271"; a="77024116"
From: Kenneth Heitke <kheitke@codeaurora.org>
To: davidb@codeaurora.org, bryanh@codeaurora.org, dwalker@fifo99.com
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.intradead.org,
        yanhe@codeaurora.org, palnatim@codeaurora.org, subhashj@codeaurora.org,
        Amir Samuelovi <amirs@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 3/5] RFC: msm: sps: Pipe Memory Manager
Date: Mon, 28 Feb 2011 18:11:30 -0700
Message-Id: <1298941892-25173-4-git-send-email-kheitke@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1298941892-25173-1-git-send-email-kheitke@codeaurora.org>
References: <1298941892-25173-1-git-send-email-kheitke@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Samuelovi <amirs@codeaurora.org>

The Smart Peripheral Subsystem (SPS) includes embedded memory, referred
to as "pipe memory", that is available to serve as buffer space for
transfers between BAM pipes.  The BAM is designed such that it can use
system-accessible memory for buffers but the pipe memory provides the
highest performance.  The genalloc kernel driver is used to manage the
pipe memory pool.

Signed-off-by: Amir Samuelov <amirs@codeaurora.org>
Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
---
 arch/arm/mach-msm/sps/sps_mem.c |  156 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 156 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/sps/sps_mem.c

diff --git a/arch/arm/mach-msm/sps/sps_mem.c b/arch/arm/mach-msm/sps/sps_mem.c
new file mode 100644
index 0000000..3aee4ba
--- /dev/null
+++ b/arch/arm/mach-msm/sps/sps_mem.c
@@ -0,0 +1,156 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/**
+ * Pipe-Memory allocation/free management.
+ */
+
+#include <linux/types.h>	/* u32 */
+#include <linux/kernel.h>	/* pr_info() */
+#include <linux/io.h>		/* ioremap() */
+#include <linux/mutex.h>	/* mutex */
+#include <linux/list.h>		/* list_head */
+#include <linux/genalloc.h>	/* gen_pool_alloc() */
+#include <linux/errno.h>	/* ENOMEM */
+
+#include "sps_bam.h"
+#include "spsi.h"
+
+static u32 iomem_phys;
+static void *iomem_virt;
+static u32 iomem_size;
+static u32 iomem_offset;
+static struct gen_pool *pool;
+static u32 nid = 0xaa;
+
+/* Debug */
+static u32 total_alloc;
+static u32 total_free;
+
+/**
+ * Translate physical to virtual address
+ *
+ */
+void *spsi_get_mem_ptr(u32 phys_addr)
+{
+	void *virt = NULL;
+
+	if ((phys_addr >= iomem_phys) &&
+	    (phys_addr < (iomem_phys + iomem_size))) {
+		virt = (u8 *) iomem_virt + (phys_addr - iomem_phys);
+	} else {
+		virt = phys_to_virt(phys_addr);
+		SPS_ERR("sps:spsi_get_mem_ptr.invalid phys addr=0x%x.",
+			phys_addr);
+	}
+	return virt;
+}
+
+/**
+ * Allocate I/O (pipe) memory
+ *
+ */
+u32 sps_mem_alloc_io(u32 bytes)
+{
+	u32 phys_addr = SPS_ADDR_INVALID;
+	u32 virt_addr = 0;
+
+	virt_addr = gen_pool_alloc(pool, bytes);
+	if (virt_addr) {
+		iomem_offset = virt_addr - (u32) iomem_virt;
+		phys_addr = iomem_phys + iomem_offset;
+		total_alloc += bytes;
+	} else {
+		SPS_ERR("sps:gen_pool_alloc %d bytes fail.", bytes);
+		return SPS_ADDR_INVALID;
+	}
+
+	SPS_DBG("sps:sps_mem_alloc_io.phys=0x%x.virt=0x%x.size=0x%x.",
+		phys_addr, virt_addr, bytes);
+
+	return phys_addr;
+}
+
+/**
+ * Free I/O memory
+ *
+ */
+void sps_mem_free_io(u32 phys_addr, u32 bytes)
+{
+	u32 virt_addr = 0;
+
+	iomem_offset = phys_addr - iomem_phys;
+	virt_addr = (u32) iomem_virt + iomem_offset;
+
+	SPS_DBG("sps:sps_mem_free_io.phys=0x%x.virt=0x%x.size=0x%x.",
+		phys_addr, virt_addr, bytes);
+
+	gen_pool_free(pool, virt_addr, bytes);
+	total_free += bytes;
+}
+
+/**
+ * Initialize driver memory module
+ *
+ */
+int sps_mem_init(u32 pipemem_phys_base, u32 pipemem_size)
+{
+	int res;
+	/* 2^8=128. The desc-fifo and data-fifo minimal allocation. */
+	int min_alloc_order = 8;
+
+	iomem_phys = pipemem_phys_base;
+	iomem_size = pipemem_size;
+
+	if (iomem_phys == 0) {
+		SPS_ERR("sps:Invalid Pipe-Mem address");
+		return SPS_ERROR;
+	} else {
+		iomem_virt = ioremap(iomem_phys, iomem_size);
+		if (!iomem_virt) {
+			SPS_ERR("sps:Failed to IO map pipe memory.\n");
+			return -ENOMEM;
+		}
+	}
+
+	iomem_offset = 0;
+	SPS_DBG("sps:sps_mem_init.iomem_phys=0x%x,iomem_virt=0x%x.",
+		iomem_phys, (u32) iomem_virt);
+
+	pool = gen_pool_create(min_alloc_order, nid);
+	res = gen_pool_add(pool, (u32) iomem_virt, iomem_size, nid);
+	if (res)
+		return res;
+
+	return 0;
+}
+
+/**
+ * De-initialize driver memory module
+ *
+ */
+int sps_mem_de_init(void)
+{
+	if (iomem_virt != NULL) {
+		gen_pool_destroy(pool);
+		pool = NULL;
+		iounmap(iomem_virt);
+		iomem_virt = NULL;
+	}
+
+	if (total_alloc == total_free)
+		return 0;
+	else {
+		SPS_ERR("sps:sps_mem_de_init:some memory not free");
+		return SPS_ERROR;
+	}
+}
-- 
1.7.3.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
