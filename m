Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1FMAoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 20:44:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26227 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1FMAoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 20:44:17 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>
Subject: [PATCH 3/3] ARM: vfp: Use cpu pm notifiers to save vfp state
Date: Sun, 12 Jun 2011 17:43:45 -0700
Message-Id: <1307925825-28566-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307925825-28566-1-git-send-email-ccross@android.com>
References: <1307925825-28566-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the cpu is powered down in a low power mode, the vfp
registers may be reset.

This patch uses CPU_PM_ENTER and CPU_PM_EXIT notifiers to save
and restore the cpu's vfp registers.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/vfp/vfpmodule.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index f25e7ec..6f08dbe 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -21,6 +21,7 @@
 #include <asm/cputype.h>
 #include <asm/thread_notify.h>
 #include <asm/vfp.h>
+#include <asm/cpu_pm.h>
 
 #include "vfpinstr.h"
 #include "vfp.h"
@@ -169,6 +170,44 @@ static struct notifier_block vfp_notifier_block = {
 	.notifier_call	= vfp_notifier,
 };
 
+#ifdef CONFIG_CPU_PM
+static int vfp_cpu_pm_notifier(struct notifier_block *self, unsigned long cmd,
+	void *v)
+{
+	u32 fpexc = fmrx(FPEXC);
+	unsigned int cpu = smp_processor_id();
+
+	switch (cmd) {
+	case CPU_PM_ENTER:
+		if (last_VFP_context[cpu]) {
+			fmxr(FPEXC, fpexc | FPEXC_EN);
+			vfp_save_state(last_VFP_context[cpu], fpexc);
+			/* force a reload when coming back from idle */
+			last_VFP_context[cpu] = NULL;
+			fmxr(FPEXC, fpexc & ~FPEXC_EN);
+		}
+		break;
+	case CPU_PM_ENTER_FAILED:
+	case CPU_PM_EXIT:
+		/* make sure VFP is disabled when leaving idle */
+		fmxr(FPEXC, fpexc & ~FPEXC_EN);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block vfp_cpu_pm_notifier_block = {
+	.notifier_call = vfp_cpu_pm_notifier,
+};
+
+static void vfp_cpu_pm_init(void)
+{
+	cpu_pm_register_notifier(&vfp_cpu_pm_notifier_block);
+}
+#else
+static inline void vfp_cpu_pm_init(void) { }
+#endif
+
 /*
  * Raise a SIGFPE for the current process.
  * sicode describes the signal being raised.
@@ -563,6 +602,7 @@ static int __init vfp_init(void)
 		vfp_vector = vfp_support_entry;
 
 		thread_register_notifier(&vfp_notifier_block);
+		vfp_cpu_pm_init();
 		vfp_pm_init();
 
 		/*
-- 
1.7.4.1

