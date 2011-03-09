Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1CISbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:31:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab1CISbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:31:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/10] perf top: Fix events overflow in top command
Date: Wed,  9 Mar 2011 15:31:25 -0300
Message-Id: <1299695491-15786-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299695491-15786-1-git-send-email-acme@infradead.org>
References: <1299695491-15786-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The snprintf function returns number of printed characters even if it
cross the size parameter. So passing enough events via '-e' parameter
will cause segmentation fault.

It's reproduced by following command:

perf top -e `perf list | grep Tracepoint | awk -F'[' '\
{gsub(/[[:space:]]+/,"",$1);array[FNR]=$1}END{outputs=array[1];\
for (i=2;i<=FNR;i++){ outputs=outputs "," array[i];};print outputs}'`

Attached patch is adding SNPRINTF macro that provides the overflow check
and returns actuall number of printed characters.

Reported-by: Han Pingtian <phan@redhat.com>
Cc: Han Pingtian <phan@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1299528821-17521-2-git-send-email-jolsa@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/top.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 70a9c13..4f869da 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -61,6 +61,12 @@ static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
 	rb_insert_color(&se->rb_node, tree);
 }
 
+#define SNPRINTF(buf, size, fmt, args...) \
+({ \
+	size_t r = snprintf(buf, size, fmt, ## args); \
+	r > size ?  size : r; \
+})
+
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 {
 	struct perf_evsel *counter;
@@ -70,7 +76,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 	size_t ret = 0;
 
 	if (!perf_guest) {
-		ret = snprintf(bf, size,
+		ret = SNPRINTF(bf, size,
 			       "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%%"
 			       "  exact: %4.1f%% [", samples_per_sec,
 			       100.0 - (100.0 * ((samples_per_sec - ksamples_per_sec) /
@@ -81,7 +87,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 		float guest_kernel_samples_per_sec = top->guest_kernel_samples / top->delay_secs;
 		float guest_us_samples_per_sec = top->guest_us_samples / top->delay_secs;
 
-		ret = snprintf(bf, size,
+		ret = SNPRINTF(bf, size,
 			       "   PerfTop:%8.0f irqs/sec  kernel:%4.1f%% us:%4.1f%%"
 			       " guest kernel:%4.1f%% guest us:%4.1f%%"
 			       " exact: %4.1f%% [", samples_per_sec,
@@ -101,38 +107,38 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 	if (top->evlist->nr_entries == 1 || !top->display_weighted) {
 		struct perf_evsel *first;
 		first = list_entry(top->evlist->entries.next, struct perf_evsel, node);
-		ret += snprintf(bf + ret, size - ret, "%" PRIu64 "%s ",
+		ret += SNPRINTF(bf + ret, size - ret, "%" PRIu64 "%s ",
 				(uint64_t)first->attr.sample_period,
 				top->freq ? "Hz" : "");
 	}
 
 	if (!top->display_weighted) {
-		ret += snprintf(bf + ret, size - ret, "%s",
+		ret += SNPRINTF(bf + ret, size - ret, "%s",
 				event_name(top->sym_evsel));
 	} else list_for_each_entry(counter, &top->evlist->entries, node) {
-		ret += snprintf(bf + ret, size - ret, "%s%s",
+		ret += SNPRINTF(bf + ret, size - ret, "%s%s",
 				counter->idx ? "/" : "", event_name(counter));
 	}
 
-	ret += snprintf(bf + ret, size - ret, "], ");
+	ret += SNPRINTF(bf + ret, size - ret, "], ");
 
 	if (top->target_pid != -1)
-		ret += snprintf(bf + ret, size - ret, " (target_pid: %d",
+		ret += SNPRINTF(bf + ret, size - ret, " (target_pid: %d",
 				top->target_pid);
 	else if (top->target_tid != -1)
-		ret += snprintf(bf + ret, size - ret, " (target_tid: %d",
+		ret += SNPRINTF(bf + ret, size - ret, " (target_tid: %d",
 				top->target_tid);
 	else
-		ret += snprintf(bf + ret, size - ret, " (all");
+		ret += SNPRINTF(bf + ret, size - ret, " (all");
 
 	if (top->cpu_list)
-		ret += snprintf(bf + ret, size - ret, ", CPU%s: %s)",
+		ret += SNPRINTF(bf + ret, size - ret, ", CPU%s: %s)",
 				top->evlist->cpus->nr > 1 ? "s" : "", top->cpu_list);
 	else {
 		if (top->target_tid != -1)
-			ret += snprintf(bf + ret, size - ret, ")");
+			ret += SNPRINTF(bf + ret, size - ret, ")");
 		else
-			ret += snprintf(bf + ret, size - ret, ", %d CPU%s)",
+			ret += SNPRINTF(bf + ret, size - ret, ", %d CPU%s)",
 					top->evlist->cpus->nr,
 					top->evlist->cpus->nr > 1 ? "s" : "");
 	}
-- 
1.6.2.5

