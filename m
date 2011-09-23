Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1IWXD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:03:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30697 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1IWXD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:03:58 -0400
From: Simon Glass <sjg@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Da Zheng <zhengda@chromium.org>,
        Da Zheng <zhengda@chromium.com>
Subject: [RFC PATCH 3/3] bootstage: Get u-boot timing from the device tree.
Date: Fri, 23 Sep 2011 16:03:18 -0700
Message-Id: <1316818998-30711-4-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1316818998-30711-1-git-send-email-sjg@chromium.org>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Da Zheng <zhengda@chromium.org>

From: Da Zheng <zhengda@chromium.org>

The bootstage driver accesses the u-boot timings in the device tree
and copies them to its array during initialization.

Signed-off-by: Da Zheng <zhengda@chromium.com>
---
 arch/arm/kernel/time.c    |   29 +++++++++++++++++++++++++++++
 include/linux/bootstage.h |    1 +
 init/bootstage.c          |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index cb634c3..524a1f5 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -24,6 +24,8 @@
 #include <linux/syscore_ops.h>
 #include <linux/timer.h>
 #include <linux/irq.h>
+#include <linux/bootstage.h>
+#include <linux/of.h>
 
 #include <linux/mc146818rtc.h>
 
@@ -156,3 +158,30 @@ void __init time_init(void)
 #endif
 }
 
+#ifdef CONFIG_BOOTSTAGE
+int get_prekernel_timing(void)
+{
+	struct device_node *node;
+	struct device_node *child;
+	int i = 0;
+
+	printk(KERN_INFO "TEST: bootstage_init is called in tegra\n");
+	node = of_find_node_by_path("/bootstage");
+	if (node == NULL)
+		return 0;
+
+	for_each_child_of_node(node, child) {
+		const char *name = of_get_property(child, "name", NULL);
+		const int *timep = of_get_property(child, "time", NULL);
+
+		if (name && timep) {
+			insert_bootstage(i, name,
+					(unsigned long) be32_to_cpu(*timep));
+			i++;
+		}
+	}
+	of_node_put(node);
+
+	return 0;
+}
+#endif
diff --git a/include/linux/bootstage.h b/include/linux/bootstage.h
index 08df102..95e837c 100644
--- a/include/linux/bootstage.h
+++ b/include/linux/bootstage.h
@@ -4,6 +4,7 @@
 #ifdef CONFIG_BOOTSTAGE
 unsigned long bootstage_mark(const char *name);
 unsigned long bootstage_mark_early(const char *name);
+void insert_bootstage(int idx, const char *name, unsigned long time);
 #else
 static inline unsigned long bootstage_mark(const char *name)
 {
diff --git a/init/bootstage.c b/init/bootstage.c
index 6f4668f..51f731d 100644
--- a/init/bootstage.c
+++ b/init/bootstage.c
@@ -75,6 +75,32 @@ static inline int __inc_bootstages(void)
 }
 
 /*
+ * Insert a new bootstage in the slot specified by `idx'.
+ * If the slot is already used, move it and slots behind it
+ * before inserting the new bootstage.
+ */
+void insert_bootstage(int idx, const char *name, unsigned long time)
+{
+	mutex_lock(&bootstage_mutex);
+
+	if (num_bootstages == cap_bootstages) {
+		if (__inc_bootstages() < 0) {
+			mutex_unlock(&bootstage_mutex);
+			return;
+		}
+	}
+
+	if (idx < num_bootstages)
+		memmove(&full_bootstages[idx + 1], &full_bootstages[idx],
+			sizeof(*full_bootstages) * (num_bootstages - idx));
+
+	strlcpy(full_bootstages[idx].name, name, MAX_NAME);
+	full_bootstages[idx].time = time;
+	num_bootstages++;
+	mutex_unlock(&bootstage_mutex);
+}
+
+/*
  * This is used during the initialization of the kernel.
  */
 unsigned long bootstage_mark(const char *name)
@@ -211,10 +237,20 @@ static const struct file_operations mark_operations = {
 	.write	= bootstage_write,
 };
 
+/*
+ * Get the timings that were recorded before the kernel is initialized.
+ */
+int __attribute__((weak)) get_prekernel_timing(void)
+{
+	return 0;
+}
+
 static int __init bootstage_init(void)
 {
 	struct dentry *dir;
 
+	get_prekernel_timing();
+
 	dir = debugfs_create_dir("bootstage", NULL);
 	if (dir && !IS_ERR(dir)) {
 		debugfs_create_file("report", S_IFREG|S_IRUSR|S_IRGRP|S_IROTH,
-- 
1.7.3.1

