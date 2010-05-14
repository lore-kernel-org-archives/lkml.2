Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0ENHRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:17:08 -0400
Received: from smtp.nokia.com ([192.100.122.233]:60632 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0ENHRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:17:06 -0400
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 2/2] kmemleak: test: Add a special scan test case
Date: Fri, 14 May 2010 10:16:41 +0300
Message-Id: <1273821401-26578-3-git-send-email-Hiroshi.DOYU@nokia.com>
X-Mailer: git-send-email 1.7.1.rc1
In-Reply-To: <1273821401-26578-1-git-send-email-Hiroshi.DOYU@nokia.com>
References: <1273821401-26578-1-git-send-email-Hiroshi.DOYU@nokia.com>
X-OriginalArrivalTime: 14 May 2010 07:16:49.0979 (UTC) FILETIME=[6BBC28B0:01CAF335]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

The pointer is converted to a physical address with attribution
bits. The test can be done either with special scan or without special
scan, which can be specified with the kernel module parameter,
"use_special". This can be squashed into kmemleak-test.c if necessary.

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 mm/Makefile                |    2 +-
 mm/kmemleak-special-test.c |   89 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 1 deletions(-)
 create mode 100644 mm/kmemleak-special-test.c

diff --git a/mm/Makefile b/mm/Makefile
index 6c2a73a..bad26d4 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -43,4 +43,4 @@ obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
-obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
+obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o kmemleak-special-test.o
diff --git a/mm/kmemleak-special-test.c b/mm/kmemleak-special-test.c
new file mode 100644
index 0000000..602d595
--- /dev/null
+++ b/mm/kmemleak-special-test.c
@@ -0,0 +1,89 @@
+/*
+ * kmemleak: special test
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define DEBUG
+
+#include <linux/module.h>
+#include <linux/kmemleak.h>
+
+static bool use_special;
+module_param(use_special, bool, 0644);
+MODULE_PARM_DESC(use_special, "Enable special scan mode");
+
+#define MAXELEMENT 8
+static u32 elements[MAXELEMENT];
+
+static u32 custom_conversion(u32 orig)
+{
+	u32 addr = orig;
+
+	addr &= ~1;
+	addr = (u32)phys_to_virt(addr);
+
+	pr_debug("%s: %08x -> %08x\n", __func__, orig, addr);
+
+	return addr;
+}
+
+static int __init kmemleak_special_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(elements); i++) {
+		void *virt;
+
+		virt = kmalloc(SZ_1K, GFP_KERNEL);
+		BUG_ON(!virt);
+
+		/* fill out some markers */
+		memset(virt, 0xa5, SZ_1K);
+		*(char *)virt = i;
+
+		elements[i] = virt_to_phys(virt) | 1;
+
+		pr_debug("%s(%d): store %d@%p -> %08x\n",
+			 __func__, use_special, SZ_1K, virt, elements[i]);
+	}
+
+	if (use_special) {
+		int err;
+
+
+		err = kmemleak_special_scan(elements, sizeof(elements),
+					    custom_conversion);
+		WARN_ON(err);
+	}
+
+	return 0;
+}
+module_init(kmemleak_special_init);
+
+static void __exit kmemleak_special_exit(void)
+{
+	int i;
+
+	if (use_special)
+		kmemleak_no_special(elements);
+
+	for (i = 0; i < ARRAY_SIZE(elements); i++) {
+		u32 val;
+
+		val = elements[i];
+		val &= ~1;
+		kfree(phys_to_virt(val));
+	}
+}
+module_exit(kmemleak_special_exit);
+
+MODULE_DESCRIPTION("kmemleak: special test");
+MODULE_AUTHOR("Hiroshi DOYU <Hiroshi.DOYU@nokia.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.1.rc1

