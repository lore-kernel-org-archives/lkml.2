Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1KLFoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 00:44:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:36876 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab1KLFnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 00:43:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,498,1315206000"; 
   d="scan'208";a="73897242"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan van de Ven" <arjan.van.de.ven@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v4 7/7] x86/power/cpu.c: Don't hibernate/suspend if CPU0 is offline
Date: Fri, 11 Nov 2011 21:26:32 -0800
Message-Id: <1321075592-31600-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Because x86 BIOS requires CPU0 to resume from sleep, suspend or hibernate
can't be executed if CPU0 is detected offline.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/power/cpu.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index f10c0af..a4ec084 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -236,3 +236,47 @@ void restore_processor_state(void)
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

