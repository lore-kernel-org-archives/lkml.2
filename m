Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0I2Owk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:52:40 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:10473
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943Ab0I2Owi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:52:38 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzz8275bh8275dhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9IJZC-01-4RG-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 16:52:25 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] oprofile, arm: proper release resources on failure
Message-ID: <20100929145225.GJ13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

the patch below fixes a resource leak I found during code review. Can
you please review and test it (I don't have an ARM environment for
this available). If you are fine with the change, please ack. I want
to send it upstream via tip/perf/urgent.

Though you reworked the code already, parts of the fix are still valid
for latest oprofile code in oprofile/core.

Ingo,

if Will agrees with it, please apply it directly to tip/perf/urgent.

Thanks,

-Robert

--

>From 6cb93a9063c579ec0183406933bfe07e8cc92c34 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 29 Sep 2010 16:03:11 +0200
Subject: [PATCH] oprofile, arm: proper release resources on failure

This patch fixes a resource leak on failure, where the oprofilefs and
some counters may not released properly.

Fix is also for 2.6.35-stable.

Cc: Will Deacon <will.deacon@arm.com>
Cc: stable@kernel.org
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/arm/oprofile/common.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..72e09eb 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -102,6 +102,7 @@ static int op_create_counter(int cpu, int event)
 	if (IS_ERR(pevent)) {
 		ret = PTR_ERR(pevent);
 	} else if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
+		perf_event_release_kernel(pevent);
 		pr_warning("oprofile: failed to enable event %d "
 				"on CPU %d\n", event, cpu);
 		ret = -EBUSY;
@@ -365,6 +366,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	ret = init_driverfs();
 	if (ret) {
 		kfree(counter_config);
+		counter_config = NULL;
 		return ret;
 	}
 
@@ -402,7 +404,6 @@ void oprofile_arch_exit(void)
 	struct perf_event *event;
 
 	if (*perf_events) {
-		exit_driverfs();
 		for_each_possible_cpu(cpu) {
 			for (id = 0; id < perf_num_counters; ++id) {
 				event = perf_events[cpu][id];
@@ -413,8 +414,10 @@ void oprofile_arch_exit(void)
 		}
 	}
 
-	if (counter_config)
+	if (counter_config) {
 		kfree(counter_config);
+		exit_driverfs();
+	}
 }
 #else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
-- 
1.7.2.2



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

