Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab1KDWXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:23:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:9875 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab1KDWVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="71337192"
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
Subject: [PATCH 2/9] kernel/cpu.c: Add arch dependent cpu map update functions
Date: Fri,  4 Nov 2011 15:03:54 -0700
Message-Id: <1320444241-834-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
References: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Because resume from hibernate and suspend always starts from CPU0 on x86 BIOS,
we need to check if CPU0 is online before hibernate or suspend. This causes a
race condition on cpu_online_map.

To cope with the race condition, we add arch_cpu_maps_update_begin() and
arch_cpu_maps_update_done() during cpu_down() and cpu_up(). The functions are
empty on non x86 platforms and are overriden on x86 platforms with real
functions to deal with the race condition.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 kernel/cpu.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 12b7458..4d80365 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -20,6 +20,14 @@
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
+void __weak arch_cpu_maps_update_begin(void)
+{
+}
+
+void __weak arch_cpu_maps_update_done(void)
+{
+}
+
 /*
  * The following two API's must be used when attempting
  * to serialize the updates to cpu_online_mask, cpu_present_mask.
@@ -274,6 +282,7 @@ int __ref cpu_down(unsigned int cpu)
 	int err;
 
 	cpu_maps_update_begin();
+	arch_cpu_maps_update_begin();
 
 	if (cpu_hotplug_disabled) {
 		err = -EBUSY;
@@ -284,6 +293,7 @@ int __ref cpu_down(unsigned int cpu)
 
 out:
 	cpu_maps_update_done();
+	arch_cpu_maps_update_done();
 	return err;
 }
 EXPORT_SYMBOL(cpu_down);
@@ -367,6 +377,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 #endif
 
 	cpu_maps_update_begin();
+	arch_cpu_maps_update_begin();
 
 	if (cpu_hotplug_disabled) {
 		err = -EBUSY;
@@ -377,6 +388,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 
 out:
 	cpu_maps_update_done();
+	arch_cpu_maps_update_done();
 	return err;
 }
 
-- 
1.6.0.3

