Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0FAKZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:25:54 -0400
Received: from smtp.nokia.com ([192.100.105.134]:59867 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab0FAKZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:25:51 -0400
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, ext-phil.2.carmody@nokia.com,
       linux-omap@vger.kernel.org, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH v2 2/3] kmemleak: Add special scan test case
Date: Tue,  1 Jun 2010 13:25:10 +0300
Message-Id: <1275387911-13030-3-git-send-email-Hiroshi.DOYU@nokia.com>
X-Mailer: git-send-email 1.7.1.rc1
In-Reply-To: <1273821401-26578-2-git-send-email-Hiroshi.DOYU@nokia.com>
References: <1273821401-26578-2-git-send-email-Hiroshi.DOYU@nokia.com>
X-OriginalArrivalTime: 01 Jun 2010 10:25:29.0707 (UTC) FILETIME=[C24113B0:01CB0174]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

For this test case, a pointer is converted to a physical address with
attribution bits. This test can be executed either with special scan
or without special scan. For special scan case, specifying the testing
period second with the kernel module parameter "timeout". Afther that
timeout, special scan is unregistered automatically. Without this
timeout, you will get false positives with kmemleak scan.

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 mm/Makefile                |    2 +-
 mm/kmemleak-special-test.c |   94 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletions(-)
 create mode 100644 mm/kmemleak-special-test.c

diff --git a/mm/Makefile b/mm/Makefile
index 8982504..5d08581 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -44,4 +44,4 @@ obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
-obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
+obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o kmemleak-special-test.o
diff --git a/mm/kmemleak-special-test.c b/mm/kmemleak-special-test.c
new file mode 100644
index 0000000..ed6788c
--- /dev/null
+++ b/mm/kmemleak-special-test.c
@@ -0,0 +1,94 @@
+/*
+ * kmemleak: special scan test
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
+#include <linux/module.h>
+#include <linux/kmemleak.h>
+
+static int timeout;
+module_param(timeout, int, 0644);
+MODULE_PARM_DESC(timeout, "special scan mode timeout");
+
+#define MAXELEM 8
+static u32 elem[MAXELEM];
+
+static void no_special_func(struct work_struct *unused)
+{
+	kmemleak_no_special(elem);
+	pr_info("%s: Unregistered special scan %p\n", __func__, elem);
+}
+static DECLARE_DELAYED_WORK(no_special_work, no_special_func);
+
+static unsigned long custom_conversion(void *unused, unsigned long orig)
+{
+	u32 addr = orig;
+
+	addr &= ~1;
+	addr = (u32)phys_to_virt(addr);
+
+	pr_info("%s: Converted %08lx -> %08x\n", __func__, orig, addr);
+
+	return addr;
+}
+
+static int __init kmemleak_special_init(void)
+{
+	int i, err;
+
+	for (i = 0; i < ARRAY_SIZE(elem); i++) {
+		void *virt;
+
+		virt = kmalloc(SZ_1K, GFP_KERNEL);
+		if (!virt)
+			continue;
+
+		memset(virt, 0xa5, SZ_1K); /* fill out some markers */
+		*(char *)virt = i;
+
+		elem[i] = virt_to_phys(virt) | 1;
+		pr_info("Stored %d@%p -> %08x\n", SZ_1K, virt, elem[i]);
+	}
+
+	if (!timeout)
+		return 0;
+
+	err = kmemleak_special_scan(elem, sizeof(elem),
+				    custom_conversion, NULL, THIS_MODULE);
+	if (err) {
+		pr_warning("%s: Couldn't register special scan\n",
+			   __func__);
+		return -ENOMEM;
+	}
+	pr_info("%s: Registered special scan: %p\n", __func__, elem);
+
+	schedule_delayed_work(&no_special_work,
+			      msecs_to_jiffies(timeout * 1000));
+	return 0;
+}
+module_init(kmemleak_special_init);
+
+static void __exit kmemleak_special_exit(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(elem); i++) {
+		u32 val;
+
+		val = elem[i];
+		val &= ~1;
+		kfree(phys_to_virt(val));
+	}
+}
+module_exit(kmemleak_special_exit);
+
+MODULE_DESCRIPTION("kmemleak: special scan test");
+MODULE_AUTHOR("Hiroshi DOYU <Hiroshi.DOYU@nokia.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.1.rc1

