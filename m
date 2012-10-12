Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab2JLQwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:52:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:10139 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759927Ab2JLQtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:49:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,577,1344236400"; 
   d="scan'208";a="233264051"
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
Subject: [PATCH v9 05/12] x86, hotplug, suspend: Online CPU0 for suspend or hibernate
Date: Fri, 12 Oct 2012 09:09:42 -0700
Message-Id: <1350058189-6769-6-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Because x86 BIOS requires CPU0 to resume from sleep, suspend or hibernate can't
be executed if CPU0 is detected offline. To make suspend or hibernate and
further resume succeed, CPU0 must be online.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/power/cpu.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 218cdb1..adde775 100644
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
+		pr_warn("CPU0 is offline.\n");
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
1.7.2

