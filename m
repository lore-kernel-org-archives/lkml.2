Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1KDWWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:22:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:9875 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab1KDWVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="71337211"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 6/9] kernel/power/suspend.c,hibernate.c: Don't hibernate/suspend if CPU0 is offline
Date: Fri,  4 Nov 2011 15:03:58 -0700
Message-Id: <1320444241-834-7-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
References: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Because x86 BIOS requires CPU0 to resume from sleep, suspend/resume or hibernate
can't be executed if CPU0 is detected offline.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 kernel/power/hibernate.c |    5 +++++
 kernel/power/main.c      |    5 +++++
 kernel/power/suspend.c   |    4 ++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 1c53f7f..b9d1a37 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -612,6 +612,11 @@ int hibernate(void)
 	int error;
 
 	mutex_lock(&pm_mutex);
+
+	error = arch_state_check();
+	if (error)
+		goto Unlock;
+
 	/* The snapshot device should not be opened while we're running */
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
 		error = -EBUSY;
diff --git a/kernel/power/main.c b/kernel/power/main.c
index a52e884..863d05d 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -447,4 +447,9 @@ static int __init pm_init(void)
 	return sysfs_create_group(power_kobj, &attr_group);
 }
 
+int __weak arch_state_check(void)
+{
+	return 0;
+}
+
 core_initcall(pm_init);
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index fdd4263..f86ff6b 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -284,6 +284,10 @@ int enter_state(suspend_state_t state)
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
+	error = arch_state_check();
+	if (error)
+		goto Unlock;
+
 	printk(KERN_INFO "PM: Syncing filesystems ... ");
 	sys_sync();
 	printk("done.\n");
-- 
1.6.0.3

