Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1CKJrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:47:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:46001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab1CKJrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:47:10 -0500
Date: Fri, 11 Mar 2011 09:46:38 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, phan@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, phan@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1299528821-17521-2-git-send-email-jolsa@redhat.com>
References: <1299528821-17521-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Fix events overflow in top command
Message-ID: <tip-b9a46bba88001504235459c8410f17e6a7e38008@git.kernel.org>
Git-Commit-ID: b9a46bba88001504235459c8410f17e6a7e38008
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:46:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9a46bba88001504235459c8410f17e6a7e38008
Gitweb:     http://git.kernel.org/tip/b9a46bba88001504235459c8410f17e6a7e38008
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 7 Mar 2011 21:13:40 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 10 Mar 2011 10:54:13 -0300

perf top: Fix events overflow in top command

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
