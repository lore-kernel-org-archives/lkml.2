Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0EOBmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 21:42:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:41549 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab0EOBmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 21:42:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=KRhf3aAQFNbdclQHnaW1MEtraBwdVg7iiL+YRf9ZkHi5BtOw3OV5/BGglMdGoKDz2
	P2ZxY66qEwm9KH9buB0AQ==
From: Venkatesh Pallipadi <venki@google.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venki@google.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH] x86: Export tsc related information in sysfs
Date: Fri, 14 May 2010 18:40:35 -0700
Message-Id: <1273887635-27610-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Magenheimer <dan.magenheimer@oracle.com>

Kernel information about calibrated value of tsc_khz and
tsc_stability (result of tsc warp test) are useful bits of information
for any app that wants to use TSC directly. Export this read_only
information in sysfs.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 arch/x86/kernel/tsc.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 9faf91a..24dd484 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -10,6 +10,7 @@
 #include <linux/clocksource.h>
 #include <linux/percpu.h>
 #include <linux/timex.h>
+#include <linux/sysdev.h>
 
 #include <asm/hpet.h>
 #include <asm/timer.h>
@@ -857,6 +858,81 @@ static void __init init_tsc_clocksource(void)
 	clocksource_register(&clocksource_tsc);
 }
 
+#ifdef CONFIG_SYSFS
+/*
+ * Export TSC related info to user land. This reflects kernel usage of TSC
+ * as hints to userspace users of TSC. The read_only info provided here:
+ * - tsc_stable: 1 implies system has TSC that always counts at a constant
+ *   rate, sync across CPUs and has passed the kernel warp test.
+ * - tsc_khz: TSC frequency in khz.
+ * - tsc_mult and tsc_shift: multiplier and shift to optimally convert
+ *   TSC delta to ns; ns = ((u64) delta * mult) >> shift
+ */
+
+#define define_show_var_function(_name, _var) \
+static ssize_t show_##_name( \
+	struct sys_device *dev, struct sysdev_attribute *attr, char *buf) \
+{ \
+	return sprintf(buf, "%u\n", (unsigned int) _var);\
+}
+
+define_show_var_function(tsc_stable, !tsc_unstable);
+define_show_var_function(tsc_khz, tsc_khz);
+define_show_var_function(tsc_mult, clocksource_tsc.mult);
+define_show_var_function(tsc_shift, clocksource_tsc.shift);
+
+static SYSDEV_ATTR(tsc_stable, 0444, show_tsc_stable, NULL);
+static SYSDEV_ATTR(tsc_khz, 0444, show_tsc_khz, NULL);
+static SYSDEV_ATTR(tsc_mult, 0444, show_tsc_mult, NULL);
+static SYSDEV_ATTR(tsc_shift, 0444, show_tsc_shift, NULL);
+
+static struct sysdev_attribute *tsc_attrs[] = {
+	&attr_tsc_stable,
+	&attr_tsc_khz,
+	&attr_tsc_mult,
+	&attr_tsc_shift,
+};
+
+static struct sysdev_class tsc_sysclass = {
+	.name = "tsc",
+};
+
+static struct sys_device device_tsc = {
+	.id = 0,
+	.cls = &tsc_sysclass,
+};
+
+static int __init init_tsc_sysfs(void)
+{
+	int err, i = 0;
+
+	err = sysdev_class_register(&tsc_sysclass);
+	if (err)
+		return err;
+
+	err = sysdev_register(&device_tsc);
+	if (err)
+		goto fail;
+
+	for (i = 0; i < ARRAY_SIZE(tsc_attrs); i++) {
+		err = sysdev_create_file(&device_tsc, tsc_attrs[i]);
+		if (err)
+			goto fail;
+	}
+
+	return 0;
+
+fail:
+	while (--i >= 0)
+		sysdev_remove_file(&device_tsc, tsc_attrs[i]);
+
+	sysdev_unregister(&device_tsc);
+	sysdev_class_unregister(&tsc_sysclass);
+	return err;
+}
+device_initcall(init_tsc_sysfs);
+#endif
+
 #ifdef CONFIG_X86_64
 /*
  * calibrate_cpu is used on systems with fixed rate TSCs to determine
-- 
1.7.0.1

