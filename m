Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1JOSgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:36:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60687 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1JOSgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:36:20 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf tools: Fix double count of total period
Date: Sat, 15 Oct 2011 20:36:11 +0200
Message-Id: <1318703773-6846-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we resort the entries to fix the order of the hists after
we collapsed them, we count all the hists one more time,
recalculing the cols len, the stats, etc...

However we forget to reset the total period before doing that.
So the ending count is buggy.

When we resort the entries, we don't change their total numbers
or their content. So we can avoid to recompute the total period
and the len of the cols there.

This fixes the issue.

Before:

	# Events: 23  cycles
	#
	# Overhead  Command      Shared Object                 Symbol
	# ........  .......  .................  .....................
	#
	    18.35%     perf  [kernel.kallsyms]  [k] add_preempt_count
	    15.76%     perf  [kernel.kallsyms]  [k] lock_is_held
	    15.22%     sshd  [kernel.kallsyms]  [k] register_lock_class
	     0.17%  swapper  [kernel.kallsyms]  [k] lock_release
	     0.17%     perf  [kernel.kallsyms]  [k] lock_release
	     0.17%  swapper  [kernel.kallsyms]  [k] __perf_event_enable
	     0.16%  swapper  [kernel.kallsyms]  [k] native_write_msr_safe
	     0.00%     perf  [kernel.kallsyms]  [k] native_write_msr_safe

After:

	# Events: 23  cycles
	#
	# Overhead  Command      Shared Object                 Symbol
	# ........  .......  .................  .....................
	#
	    36.70%     perf  [kernel.kallsyms]  [k] add_preempt_count
	    31.52%     perf  [kernel.kallsyms]  [k] lock_is_held
	    30.43%     sshd  [kernel.kallsyms]  [k] register_lock_class
	     0.35%  swapper  [kernel.kallsyms]  [k] lock_release
	     0.34%     perf  [kernel.kallsyms]  [k] lock_release
	     0.34%  swapper  [kernel.kallsyms]  [k] __perf_event_enable
	     0.32%  swapper  [kernel.kallsyms]  [k] native_write_msr_safe
	     0.01%     perf  [kernel.kallsyms]  [k] native_write_msr_safe

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/hist.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a7193c5..bac6520 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -413,15 +413,11 @@ static void __hists__output_resort(struct hists *hists, bool threaded)
 	next = rb_first(root);
 	hists->entries = RB_ROOT;
 
-	hists->nr_entries = 0;
-	hists__reset_col_len(hists);
-
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node_in);
 		next = rb_next(&n->rb_node_in);
 
 		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
-		hists__inc_nr_entries(hists, n);
 	}
 }
 
-- 
1.7.5.4

