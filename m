Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab2AMPxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:53:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63742 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab2AMPxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:53:35 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 1/7] bitops: rename for_each_set_bit_cont in favor of anologous to list.h function
Date: Sat, 14 Jan 2012 00:53:18 +0900
Message-Id: <1326470004-10096-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
References: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This renames for_each_set_bit_cont() to for_each_set_bit_from()
because it is anologous to list_for_each_entry_from() in list.h
rather than list_for_each_entry_continue().

This doesn't remove for_each_set_bit_cont() for now.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/cpu/perf_event.c       |    4 ++--
 include/linux/bitops.h                 |    5 ++++-
 tools/perf/util/include/linux/bitops.h |    2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5adce10..d594326 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -577,14 +577,14 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 	/* Prefer fixed purpose counters */
 	if (x86_pmu.num_counters_fixed) {
 		idx = X86_PMC_IDX_FIXED;
-		for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_MAX) {
+		for_each_set_bit_from(idx, c->idxmsk, X86_PMC_IDX_MAX) {
 			if (!__test_and_set_bit(idx, sched->state.used))
 				goto done;
 		}
 	}
 	/* Grab the first unused counter starting with idx */
 	idx = sched->state.counter;
-	for_each_set_bit_cont(idx, c->idxmsk, X86_PMC_IDX_FIXED) {
+	for_each_set_bit_from(idx, c->idxmsk, X86_PMC_IDX_FIXED) {
 		if (!__test_and_set_bit(idx, sched->state.used))
 			goto done;
 	}
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 3c1063a..9e79b2a 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -27,11 +27,14 @@ extern unsigned long __sw_hweight64(__u64 w);
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
 /* same as for_each_set_bit() but use bit as value to start with */
-#define for_each_set_bit_cont(bit, addr, size) \
+#define for_each_set_bit_from(bit, addr, size) \
 	for ((bit) = find_next_bit((addr), (size), (bit));	\
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
+#define for_each_set_bit_cont(bit, addr, size) \
+	for_each_set_bit_from(bit, addr, size)
+
 static __inline__ int get_bitmask_order(unsigned int count)
 {
 	int order;
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 62cdee7..f1584833 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -15,7 +15,7 @@
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
 /* same as for_each_set_bit() but use bit as value to start with */
-#define for_each_set_bit_cont(bit, addr, size) \
+#define for_each_set_bit_from(bit, addr, size) \
 	for ((bit) = find_next_bit((addr), (size), (bit));	\
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
-- 
1.7.4.4

