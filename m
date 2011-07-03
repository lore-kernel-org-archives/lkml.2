Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1GCOP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 10:15:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52593 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab1GCOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 10:15:00 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/7] cpu: CPU notifier error injection
Date: Sun,  3 Jul 2011 23:16:18 +0900
Message-Id: <1309702581-16863-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the ability to inject artifical errors to CPU notifier
chain callbacks.  It is controlled through debugfs interface under
/sys/kernel/debug/cpu-notifier-error-inject/

Each of the files in the directory represents an event which can be
failed and contains the error code.  If the notifier call chain should
be failed with some events notified, write the error code to the files.

Example1: inject CPU offline error (-1 == -EPERM)

	# echo -1 > /sys/kernel/debug/cpu-notifier-error-inject/CPU_UP_PREPARE
	# echo 0 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: Operation not permitted

Example2: inject CPU online error (-2 == -ENOENT)

	# echo -2 > /sys/kernel/debug/cpu-notifier-error-inject/CPU_DOWN_PREPARE
	# echo 1 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: No such file or directory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 Documentation/feature-removal-schedule.txt |    8 +++++++
 kernel/cpu.c                               |   31 ++++++++++++++++++++++++++++
 lib/Kconfig.debug                          |   14 ++++++++++++
 3 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 72e2384..fe5d2b5 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -583,3 +583,11 @@ Why:	Superseded by the UVCIOC_CTRL_QUERY ioctl.
 Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 
 ----------------------------
+
+What:	Support for CPU_NOTIFIER_ERROR_INJECT (cpu-notifier-error-inejct.ko)
+When:	3.3
+Why:	Replaced with debugfs interface in
+	/sys/kernel/debug/cpu-notifier-error-inject/
+Who:	Akinobu Mita <akinobu.mita@gmail.com>
+
+----------------------------
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 12b7458..c326f4d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -170,6 +170,37 @@ void __ref unregister_cpu_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_cpu_notifier);
 
+#ifdef CONFIG_CPU_NOTIFIER_ERROR_INJECTION
+
+static struct err_inject_notifier_block err_inject_cpu_notifier = {
+	.actions = {
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_UP_PREPARE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_UP_PREPARE_FROZEN) },
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_DOWN_PREPARE) },
+		{ ERR_INJECT_NOTIFIER_ACTION(CPU_DOWN_PREPARE_FROZEN) },
+		{}
+	}
+};
+
+static int __init err_inject_cpu_notifier_init(void)
+{
+	int err;
+
+	err = err_inject_notifier_block_init(&err_inject_cpu_notifier,
+				"cpu-notifier-error-inject", -1);
+	if (err)
+		return err;
+
+	err = register_hotcpu_notifier(&err_inject_cpu_notifier.nb);
+	if (err)
+		err_inject_notifier_block_cleanup(&err_inject_cpu_notifier);
+
+	return err;
+}
+late_initcall(err_inject_cpu_notifier_init);
+
+#endif /* CONFIG_CPU_NOTIFIER_ERROR_INJECTION */
+
 static inline void check_for_tasks(int cpu)
 {
 	struct task_struct *p;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8c6ce7e..d944b32 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1029,6 +1029,20 @@ config NOTIFIER_ERROR_INJECTION
 
 	  Say N if unsure.
 
+config CPU_NOTIFIER_ERROR_INJECTION
+	bool "CPU notifier error injection"
+	depends on HOTPLUG_CPU && NOTIFIER_ERROR_INJECTION
+	help
+	  This option provides the ability to inject artifical errors to
+	  CPU notifier chain callbacks.  It is controlled through debugfs
+	  interface under /sys/kernel/debug/cpu-notifier-error-inject/
+
+	  Example1: inject CPU offline error (-1 == -EPERM)
+
+	  # echo -1 > /sys/kernel/debug/cpu-notifier-error-inject/CPU_UP_PREPARE
+	  # echo 0 > /sys/devices/system/cpu/cpu1/online
+	  bash: echo: write error: Operation not permitted
+
 config CPU_NOTIFIER_ERROR_INJECT
 	tristate "CPU notifier error injection module"
 	depends on HOTPLUG_CPU && DEBUG_KERNEL
-- 
1.7.4.4

