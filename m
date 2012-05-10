Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab2EJQcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:32:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:5033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453Ab2EJQ2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:28:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142389138"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v6 05/12] x86/power/cpu.c: Don't hibernate/suspend if CPU0 is offline
Date: Thu, 10 May 2012 09:16:47 -0700
Message-Id: <1336666614-21090-6-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Because x86 BIOS requires CPU0 to resume from sleep, suspend or hibernate
can't be executed if CPU0 is detected offline. To make suspend or hibernate and
further resume succeed, CPU0 must be online.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/power/cpu.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 218cdb1..3338609 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -237,3 +237,47 @@ void restore_processor_state(void)
 #ifdef CONFIG_X86_32
 EXPORT_SYMBOL(restore_processor_state);
 #endif
+
+/*
+ * When bsp_check() is called in hibernate and suspend, cpu hotplug
+ * is disabled already. So it's unnessary to handle race condition between
+ * cpumask query and cpu hotplug.
+ */
+static int bsp_check(void)
+{
+	if (cpumask_first(cpu_online_mask) != 0) {
+		printk(KERN_WARNING "CPU0 is offline.\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int bsp_pm_callback(struct notifier_block *nb, unsigned long action,
+			   void *ptr)
+{
+	int ret = 0;
+
+	switch (action) {
+	case PM_SUSPEND_PREPARE:
+	case PM_HIBERNATION_PREPARE:
+		ret = bsp_check();
+		break;
+	default:
+		break;
+	}
+	return notifier_from_errno(ret);
+}
+
+static int __init bsp_pm_check_init(void)
+{
+	/*
+	 * Set this bsp_pm_callback as lower priority than
+	 * cpu_hotplug_pm_callback. So cpu_hotplug_pm_callback will be called
+	 * earlier to disable cpu hotplug before bsp online check.
+	 */
+	pm_notifier(bsp_pm_callback, -INT_MAX);
+	return 0;
+}
+
+core_initcall(bsp_pm_check_init);
-- 
1.6.0.3

