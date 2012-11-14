Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423571Ab2KNWld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:41:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45457 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab2KNWlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:41:32 -0500
Date: Wed, 14 Nov 2012 13:25:45 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-209efae12981f3d2d694499b761def10895c078c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1352835171-3958-6-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-6-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bsp-hotplug] x86, hotplug, suspend:
  Online CPU0 for suspend or hibernate
Git-Commit-ID: 209efae12981f3d2d694499b761def10895c078c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 14 Nov 2012 14:41:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  209efae12981f3d2d694499b761def10895c078c
Gitweb:     http://git.kernel.org/tip/209efae12981f3d2d694499b761def10895c078c
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 13 Nov 2012 11:32:42 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 Nov 2012 09:39:49 -0800

x86, hotplug, suspend: Online CPU0 for suspend or hibernate

Because x86 BIOS requires CPU0 to resume from sleep, suspend or hibernate can't
be executed if CPU0 is detected offline. To make suspend or hibernate and
further resume succeed, CPU0 must be online.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1352835171-3958-6-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/power/cpu.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

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
