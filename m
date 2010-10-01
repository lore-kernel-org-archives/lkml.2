Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0JAQCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:02:35 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:59659
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab0JAQCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:02:06 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9MCH4-02-D84-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt@console-pimps.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/5] oprofile, ARM: Use oprofile_arch_exit() to cleanup on failure
Date: Fri, 1 Oct 2010 17:56:24 +0200
Message-ID: <1285948587-24521-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
References: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is duplicate cleanup code in the init and exit functions. Now,
oprofile_arch_exit() is also used if oprofile_arch_init() fails.

Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/arm/oprofile/common.c |   53 +++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index bd7426f..7ae9eeb 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -348,10 +348,33 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
 		tail = user_backtrace(tail);
 }
 
+void oprofile_arch_exit(void)
+{
+	int cpu, id;
+	struct perf_event *event;
+
+	for_each_possible_cpu(cpu) {
+		for (id = 0; id < perf_num_counters; ++id) {
+			event = perf_events[cpu][id];
+			if (event)
+				perf_event_release_kernel(event);
+		}
+
+		kfree(perf_events[cpu]);
+	}
+
+	kfree(counter_config);
+	exit_driverfs();
+}
+
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
 	int cpu, ret = 0;
 
+	ret = init_driverfs();
+	if (ret)
+		return ret;
+
 	memset(&perf_events, 0, sizeof(perf_events));
 
 	perf_num_counters = armpmu_get_max_events();
@@ -363,13 +386,10 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 		pr_info("oprofile: failed to allocate %d "
 				"counters\n", perf_num_counters);
 		ret = -ENOMEM;
+		perf_num_counters = 0;
 		goto out;
 	}
 
-	ret = init_driverfs();
-	if (ret)
-		goto out;
-
 	for_each_possible_cpu(cpu) {
 		perf_events[cpu] = kcalloc(perf_num_counters,
 				sizeof(struct perf_event *), GFP_KERNEL);
@@ -395,33 +415,12 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 		pr_info("oprofile: using %s\n", ops->cpu_type);
 
 out:
-	if (ret) {
-		for_each_possible_cpu(cpu)
-			kfree(perf_events[cpu]);
-		kfree(counter_config);
-	}
+	if (ret)
+		oprofile_arch_exit();
 
 	return ret;
 }
 
-void __exit oprofile_arch_exit(void)
-{
-	int cpu, id;
-	struct perf_event *event;
-
-	for_each_possible_cpu(cpu) {
-		for (id = 0; id < perf_num_counters; ++id) {
-			event = perf_events[cpu][id];
-			if (event)
-				perf_event_release_kernel(event);
-		}
-
-		kfree(perf_events[cpu]);
-	}
-
-	kfree(counter_config);
-	exit_driverfs();
-}
 #else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
-- 
1.7.2.2


