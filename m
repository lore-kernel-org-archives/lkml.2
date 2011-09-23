Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab1IWXEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:04:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14049 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1IWXD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:03:58 -0400
From: Simon Glass <sjg@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Da Zheng <zhengda@chromium.org>,
        Da Zheng <zhengda@chromium.com>
Subject: [RFC PATCH 2/3] bootstage: Insert bootstage_mark to record timing for bootup.
Date: Fri, 23 Sep 2011 16:03:17 -0700
Message-Id: <1316818998-30711-3-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1316818998-30711-1-git-send-email-sjg@chromium.org>
References: <1316818998-30711-1-git-send-email-sjg@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Da Zheng <zhengda@chromium.org>

From: Da Zheng <zhengda@chromium.org>

This inserts calls to bootstage_mark() to timestamp the kernel moving
between the different initcall levels.

Signed-off-by: Da Zheng <zhengda@chromium.com>
---
 init/bootstage.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 init/main.c      |    7 +++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/init/bootstage.c b/init/bootstage.c
index 79e9761..6f4668f 100644
--- a/init/bootstage.c
+++ b/init/bootstage.c
@@ -226,3 +226,52 @@ static int __init bootstage_init(void)
 }
 
 postcore_initcall(bootstage_init);
+
+static int __init post_core_initcall(void)
+{
+	bootstage_mark("core_initcall");
+	return 0;
+}
+core_initcall_sync(post_core_initcall);
+
+static int __init post_postcore_initcall(void)
+{
+	bootstage_mark("postcore_initcall");
+	return 0;
+}
+postcore_initcall_sync(post_postcore_initcall);
+
+static int __init post_arch_initcall(void)
+{
+	bootstage_mark("arch_initcall");
+	return 0;
+}
+arch_initcall_sync(post_arch_initcall);
+
+static int __init post_subsys_initcall(void)
+{
+	bootstage_mark("subsys_initcall");
+	return 0;
+}
+subsys_initcall_sync(post_subsys_initcall);
+
+static int __init post_fs_initcall(void)
+{
+	bootstage_mark("fs_initcall");
+	return 0;
+}
+fs_initcall_sync(post_fs_initcall);
+
+static int __init post_device_initcall(void)
+{
+	bootstage_mark("device_initcall");
+	return 0;
+}
+device_initcall_sync(post_device_initcall);
+
+static int __init post_late_initcall(void)
+{
+	bootstage_mark("late_initcall");
+	return 0;
+}
+late_initcall_sync(post_late_initcall);
diff --git a/init/main.c b/init/main.c
index 9c51ee7..671d6b7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -75,6 +75,8 @@
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
 
+#include <linux/bootstage.h>
+
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/smp.h>
 #endif
@@ -489,6 +491,7 @@ asmlinkage void __init start_kernel(void)
 	page_address_init();
 	printk(KERN_NOTICE "%s", linux_banner);
 	setup_arch(&command_line);
+	bootstage_mark_early("bootstage_start");
 	mm_init_owner(&init_mm, &init_task);
 	mm_init_cpumask(&init_mm);
 	setup_command_line(command_line);
@@ -627,6 +630,7 @@ asmlinkage void __init start_kernel(void)
 	sfi_init_late();
 
 	ftrace_init();
+	bootstage_mark("before_rest_init");
 
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
@@ -722,6 +726,7 @@ static void __init do_basic_setup(void)
 	driver_init();
 	init_irq_proc();
 	do_ctors();
+	bootstage_mark("before_initcalls");
 	do_initcalls();
 }
 
@@ -806,6 +811,7 @@ static int __init kernel_init(void * unused)
 	sched_init_smp();
 
 	do_basic_setup();
+	bootstage_mark("after_basic_setup");
 
 	/* Open the /dev/console on the rootfs, this should never fail */
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
@@ -832,6 +838,7 @@ static int __init kernel_init(void * unused)
 	 * initmem segments and start the user-mode stuff..
 	 */
 
+	bootstage_mark("before_init_post");
 	init_post();
 	return 0;
 }
-- 
1.7.3.1

