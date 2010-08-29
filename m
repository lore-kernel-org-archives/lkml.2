Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0H2Swn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:52:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35474 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906Ab0H2Swk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:52:40 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Robert Richter <robert.richter@amd.com>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/3] ARM: oprofile: fix and simplify init/exit functions
Date: Sun, 29 Aug 2010 19:52:00 +0100
Message-Id: <1283107921-21464-3-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283107921-21464-2-git-send-email-will.deacon@arm.com>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
 <1283107921-21464-2-git-send-email-will.deacon@arm.com>
X-OriginalArrivalTime: 29 Aug 2010 18:52:18.0173 (UTC) FILETIME=[4DE082D0:01CB47AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that oprofile_arch_exit is only called when the OProfile module
is unloaded, it can assume that init completed successfully and not
have to worry about double frees or releasing NULL perf events.

This patch ensures that oprofile_arch_init fails gracefully on ARM
and simplifies the exit code based on the above.

Cc: Robert Richter <robert.richter@amd.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/oprofile/common.c |   47 +++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..c2c4a2e 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -275,7 +275,7 @@ out:
 	return ret;
 }
 
-static void  exit_driverfs(void)
+static void __exit exit_driverfs(void)
 {
 	platform_device_unregister(oprofile_pdev);
 	platform_driver_unregister(&oprofile_driver);
@@ -359,14 +359,13 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	if (!counter_config) {
 		pr_info("oprofile: failed to allocate %d "
 				"counters\n", perf_num_counters);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	ret = init_driverfs();
-	if (ret) {
-		kfree(counter_config);
-		return ret;
-	}
+	if (ret)
+		goto out;
 
 	for_each_possible_cpu(cpu) {
 		perf_events[cpu] = kcalloc(perf_num_counters,
@@ -374,9 +373,8 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 		if (!perf_events[cpu]) {
 			pr_info("oprofile: failed to allocate %d perf events "
 					"for cpu %d\n", perf_num_counters, cpu);
-			while (--cpu >= 0)
-				kfree(perf_events[cpu]);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto out;
 		}
 	}
 
@@ -393,28 +391,33 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	else
 		pr_info("oprofile: using %s\n", ops->cpu_type);
 
+out:
+	if (ret) {
+		kfree(counter_config);
+		for_each_possible_cpu(cpu)
+			kfree(perf_events[cpu]);
+	}
+
 	return ret;
 }
 
-void oprofile_arch_exit(void)
+void __exit oprofile_arch_exit(void)
 {
 	int cpu, id;
 	struct perf_event *event;
 
-	if (*perf_events) {
-		exit_driverfs();
-		for_each_possible_cpu(cpu) {
-			for (id = 0; id < perf_num_counters; ++id) {
-				event = perf_events[cpu][id];
-				if (event != NULL)
-					perf_event_release_kernel(event);
-			}
-			kfree(perf_events[cpu]);
+	for_each_possible_cpu(cpu) {
+		for (id = 0; id < perf_num_counters; ++id) {
+			event = perf_events[cpu][id];
+			if (event)
+				perf_event_release_kernel(event);
 		}
+
+		kfree(perf_events[cpu]);
 	}
 
-	if (counter_config)
-		kfree(counter_config);
+	kfree(counter_config);
+	exit_driverfs();
 }
 #else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
@@ -422,5 +425,5 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	pr_info("oprofile: hardware counters not available\n");
 	return -ENODEV;
 }
-void oprofile_arch_exit(void) {}
+void __exit oprofile_arch_exit(void) {}
 #endif /* CONFIG_HW_PERF_EVENTS */
-- 
1.6.3.3

