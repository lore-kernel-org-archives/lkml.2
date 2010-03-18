Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0CRJIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:08:41 -0400
Received: from mail-yw0-f201.google.com ([209.85.211.201]:38353 "EHLO
	mail-yw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0CRJIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TRkSMKOL7+ri+AOX4skm0WsNY3t5EB1jWJnIEoWVJJ6nka4wCMtPt93qk91ZuzGVEN
         l/sNKFVWvrjmRSAPo514ai/6gA7u+Bg4vGpUN9UgQjgUxfrw1qLN6h6Ej6gYUtN6EXbR
         MAqtFN4Brej2SlO8UE4Uyid4sZZmrmcXtDhKc=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 12/12] add CPU notifier error injection module
Date: Thu, 18 Mar 2010 18:05:24 +0900
Message-Id: <1268903124-10237-12-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I used this module to test the series of modification to the
cpu notifiers code.

Example1: inject CPU offline error (-1 == -EPERM)

	# modprobe cpu-notifier-error-inject cpu_down_prepare_error=-1
	# echo 0 > /sys/devices/system/cpu/cpu1/online0
	bash: echo: write error: Operation not permitted

Example2: inject CPU online error (-2 == -ENOENT)

	# modprobe cpu-notifier-error-inject cpu_up_prepare_error=-2
	# echo 1 > /sys/devices/system/cpu/cpu1/online0
	bash: echo: write error: No such file or directory

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/Kconfig.debug               |   12 +++++++
 lib/Makefile                    |    1 +
 lib/cpu-notifier-error-inject.c |   63 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 lib/cpu-notifier-error-inject.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8e5ec5e..ae467ed 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -885,6 +885,18 @@ config LKDTM
 	Documentation on how to use the module can be found in
 	Documentation/fault-injection/provoke-crashes.txt
 
+config CPU_NOTIFIER_ERROR_INJECT
+	tristate "CPU notifier error injection module"
+	depends on HOTPLUG_CPU && DEBUG_KERNEL
+	help
+	  This option provides a kernel module that can be used to test
+	  the error handling of the cpu notifiers
+
+	  To compile this code as a module, choose M here: the module will
+	  be called cpu-notify-inject.
+
+	  If unsure, say N.
+
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index 2e152ae..9e34be2 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 obj-$(CONFIG_SWIOTLB) += swiotlb.o
 obj-$(CONFIG_IOMMU_HELPER) += iommu-helper.o
 obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
+obj-$(CONFIG_CPU_NOTIFIER_ERROR_INJECT) += cpu-notifier-error-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/lib/cpu-notifier-error-inject.c b/lib/cpu-notifier-error-inject.c
new file mode 100644
index 0000000..4dc2032
--- /dev/null
+++ b/lib/cpu-notifier-error-inject.c
@@ -0,0 +1,63 @@
+#include <linux/kernel.h>
+#include <linux/cpu.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+
+static int priority;
+static int cpu_up_prepare_error;
+static int cpu_down_prepare_error;
+
+module_param(priority, int, 0);
+MODULE_PARM_DESC(priority, "specify cpu notifier priority");
+
+module_param(cpu_up_prepare_error, int, 0644);
+MODULE_PARM_DESC(cpu_up_prepare_error,
+		"specify error code to inject CPU_UP_PREPARE action");
+
+module_param(cpu_down_prepare_error, int, 0644);
+MODULE_PARM_DESC(cpu_down_prepare_error,
+		"specify error code to inject CPU_DOWN_PREPARE action");
+
+static int err_inject_cpu_callback(struct notifier_block *nfb,
+				unsigned long action, void *hcpu)
+{
+	int err = 0;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = cpu_up_prepare_error;
+		break;
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		err = cpu_down_prepare_error;
+		break;
+	}
+	if (err)
+		printk(KERN_INFO "Injecting error (%d) at cpu notifier\n", err);
+
+	return notifier_from_errno(err);
+}
+
+static struct notifier_block err_inject_cpu_notifier = {
+	.notifier_call = err_inject_cpu_callback,
+};
+
+static int err_inject_init(void)
+{
+	err_inject_cpu_notifier.priority = priority;
+
+	return register_hotcpu_notifier(&err_inject_cpu_notifier);
+}
+
+static void err_inject_exit(void)
+{
+	unregister_hotcpu_notifier(&err_inject_cpu_notifier);
+}
+
+module_init(err_inject_init);
+module_exit(err_inject_exit);
+
+MODULE_DESCRIPTION("CPU notifier error injection module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
-- 
1.6.0.6

