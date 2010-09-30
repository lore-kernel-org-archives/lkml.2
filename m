Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0I3DCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:02:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab0I3DCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:02:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH perf/core/urgent] perf, x86: Handle in flight IRQs on P4 platform
Date: Wed, 29 Sep 2010 23:01:38 -0400
Message-Id: <1285815698-4298-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Stephane reported we've forgot to guard the P4 platform
against spurious in-flight performance IRQs. Fix it.

[ the patch is a complement to commit 63e6be6d98e1 ]

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Robert Richter <robert.richter@amd.com>
CC: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index b560db3..2490151 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -660,8 +660,12 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		int overflow;
 
-		if (!test_bit(idx, cpuc->active_mask))
+		if (!test_bit(idx, cpuc->active_mask)) {
+			/* catch in-flight IRQs */
+			if (__test_and_clear_bit(idx, cpuc->running))
+				handled++;
 			continue;
+		}
 
 		event = cpuc->events[idx];
 		hwc = &event->hw;
-- 
1.7.2.3

