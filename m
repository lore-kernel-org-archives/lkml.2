Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab1BJVbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:31:52 -0500
Received: from smtp-out.google.com ([216.239.44.51]:33784 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab1BJVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:31:51 -0500
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, santosh.shilimkar@ti.com, catalin.marinas@arm.com,
        will.deacon@arm.com, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] ARM: vfp: Use cpu pm notifiers to save vfp state
Date: Thu, 10 Feb 2011 13:31:27 -0800
Message-Id: <1297373487-23902-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297373487-23902-1-git-send-email-ccross@android.com>
References: <1297373487-23902-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/vfp/vfpmodule.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 0797cb5..8b27c18 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -21,6 +21,7 @@
 #include <asm/cputype.h>
 #include <asm/thread_notify.h>
 #include <asm/vfp.h>
+#include <asm/cpu_pm.h>
 
 #include "vfpinstr.h"
 #include "vfp.h"
@@ -149,6 +150,28 @@ static struct notifier_block vfp_notifier_block = {
 	.notifier_call	= vfp_notifier,
 };
 
+static int vfp_idle_notifier(struct notifier_block *self, unsigned long cmd,
+	void *v)
+{
+	u32 fpexc = fmrx(FPEXC);
+	unsigned int cpu = smp_processor_id();
+
+	if (cmd != CPU_PM_ENTER)
+		return NOTIFY_OK;
+
+	/* The VFP may be reset in idle, save the state */
+	if ((fpexc & FPEXC_EN) && last_VFP_context[cpu]) {
+		vfp_save_state(last_VFP_context[cpu], fpexc);
+		last_VFP_context[cpu]->hard.cpu = cpu;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block vfp_idle_notifier_block = {
+	.notifier_call = vfp_idle_notifier,
+};
+
 /*
  * Raise a SIGFPE for the current process.
  * sicode describes the signal being raised.
@@ -549,6 +572,7 @@ static int __init vfp_init(void)
 		vfp_vector = vfp_support_entry;
 
 		thread_register_notifier(&vfp_notifier_block);
+		cpu_pm_register_notifier(&vfp_idle_notifier_block);
 		vfp_pm_init();
 
 		/*
-- 
1.7.3.1

