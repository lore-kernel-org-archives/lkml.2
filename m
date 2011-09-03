Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab1ICOk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 10:40:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48024 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab1ICOkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 10:40:02 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <ccross@android.com>, <rjw@sisk.pl>, <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 4/5] ARM: vfp: Use cpu pm notifiers to save vfp state
Date: Sat, 3 Sep 2011 20:09:14 +0530
Message-ID: <1315060755-4613-5-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

When the cpu is powered down in a low power mode, the vfp
registers may be reset.

This patch uses CPU_PM_ENTER and CPU_PM_EXIT notifiers to save
and restore the cpu's vfp registers.

Signed-off-by: Colin Cross <ccross@android.com>
[santosh.shilimkar@ti.com: Rebased against 3.1-rc4, resolved the conflicts]
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/vfp/vfpmodule.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 79bcb43..fe4b60b 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/cpu.h>
+#include <linux/cpu_pm.h>
 #include <linux/kernel.h>
 #include <linux/notifier.h>
 #include <linux/signal.h>
@@ -436,9 +437,7 @@ static void vfp_enable(void *unused)
 	set_copro_access(access | CPACC_FULL(10) | CPACC_FULL(11));
 }
 
-#ifdef CONFIG_PM
-#include <linux/syscore_ops.h>
-
+#ifdef CONFIG_CPU_PM
 static int vfp_pm_suspend(void)
 {
 	struct thread_info *ti = current_thread_info();
@@ -468,19 +467,33 @@ static void vfp_pm_resume(void)
 	fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
 }
 
-static struct syscore_ops vfp_pm_syscore_ops = {
-	.suspend	= vfp_pm_suspend,
-	.resume		= vfp_pm_resume,
+static int vfp_cpu_pm_notifier(struct notifier_block *self, unsigned long cmd,
+	void *v)
+{
+	switch (cmd) {
+	case CPU_PM_ENTER:
+		vfp_pm_suspend();
+		break;
+	case CPU_PM_ENTER_FAILED:
+	case CPU_PM_EXIT:
+		vfp_pm_resume();
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block vfp_cpu_pm_notifier_block = {
+	.notifier_call = vfp_cpu_pm_notifier,
 };
 
 static void vfp_pm_init(void)
 {
-	register_syscore_ops(&vfp_pm_syscore_ops);
+	cpu_pm_register_notifier(&vfp_cpu_pm_notifier_block);
 }
 
 #else
 static inline void vfp_pm_init(void) { }
-#endif /* CONFIG_PM */
+#endif /* CONFIG_CPU_PM */
 
 /*
  * Ensure that the VFP state stored in 'thread->vfpstate' is up to date
-- 
1.7.4.1

