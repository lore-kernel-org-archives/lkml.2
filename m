Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934897Ab1KJOhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:37:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:49359 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934648Ab1KJOhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:37:53 -0500
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, robert.richter@amd.com, mingo@elte.hu,
        ming.m.lin@intel.com, ak@linux.intel.com
Date: Thu, 10 Nov 2011 15:37:40 +0100
In-Reply-To: <20111107110149.GA5177@quad>
References: <20111107110149.GA5177@quad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320935860.13800.25.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just throwing this out there (hasn't event been compiled etc..).

The idea is to try the fixed counters first so that we don't
'accidentally' fill a GP counter with something that could have lived on
the fixed purpose one and then end up under utilizing the PMU that way.

It ought to solve the most common PMU programming fail on Intel
thingies.

---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -558,14 +558,22 @@ int x86_schedule_events(struct cpu_hw_ev
 			if (c->weight != w)
 				continue;
 
-			for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
+			if (x86_pmu.num_counters_fixed) {
+				j = X86_PMC_IDX_FIXED - 1;
+				for_each_set_bit_cont(j, c->idxmsk, X86_PMC_IDX_MAX) {
+					if (!test_bit(k, used_mask))
+						goto assign;
+				}
+			}
+
+			for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_FIXED) {
 				if (!test_bit(j, used_mask))
-					break;
+					goto assign;
 			}
 
-			if (j == X86_PMC_IDX_MAX)
-				break;
+			break;
 
+assign:
 			__set_bit(j, used_mask);
 
 			if (assign)
Index: linux-2.6/include/linux/bitops.h
===================================================================
--- linux-2.6.orig/include/linux/bitops.h
+++ linux-2.6/include/linux/bitops.h
@@ -26,6 +26,12 @@ extern unsigned long __sw_hweight64(__u6
 	     (bit) < (size); \
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
+#define for_each_set_bit_cont(bit, addr, size) \
+	for ((bit) = find_next_bit((addr), (size), (bit) + 1); \
+	     (bit) < (size); \
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+
 static __inline__ int get_bitmask_order(unsigned int count)
 {
 	int order;

