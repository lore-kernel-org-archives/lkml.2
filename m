Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1GQJa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:30:29 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57564 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab1GQJaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:30:20 -0400
X-AuditID: b753bd60-a14abba0000019f4-43-4e22aba9baa8
X-AuditID: b753bd60-a14abba0000019f4-43-4e22aba9baa8
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v2 4/6] perf script: print DSOs and symbols for BTS
 branch_from addr
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Sun, 17 Jul 2011 18:31:03 +0900
Message-ID: <20110717093103.3447.98227.stgit@linux3>
In-Reply-To: <20110717093031.3447.52715.stgit@linux3>
References: <20110717093031.3447.52715.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print DSOs and symbols for branch_from address of BTS.
BTS records branch_from address in 'addr' fields,
and branch_to address in 'ip' field. Latest perf-script
resolves DSOs and symbols only for 'ip' field.
This patch resolves them for 'addr' field too.

# perf script -f ip,addr,dso,sym
3f03e016b0 (unknown) ([kernel.kallsyms]) ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e016b0    _start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04b80 _dl_start (/lib64/ld-2.14.so)       3f03e016b3 _start (/lib64/ld-2.14.so)
3f03e04b80 _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04ba6 _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04bad _dl_start (/lib64/ld-2.14.so) ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04c1d _dl_start (/lib64/ld-2.14.so)       3f03e04bfb _dl_start (/lib64/ld-2.14.so)
[snip]

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/builtin-script.c |    8 +++++++-
 tools/perf/util/event.c     |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2356198..7708d89 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -309,6 +309,12 @@ static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
 	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)))
 		return true;
 
+	/* BTS Events */
+	if ((attr->type == PERF_TYPE_HARDWARE) &&
+	    (attr->config & PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
+	    (attr->sample_period == 1))
+		return true;
+
 	return false;
 }
 
@@ -328,7 +334,7 @@ static void print_sample_addr(union perf_event *event,
 
 	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
 			      event->ip.pid, sample->addr, &al);
-	/* try to resolve for user space */
+	/* try to resolve addr_location for user space */
 	if (!al.map)
 		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
 			MAP__FUNCTION, event->ip.pid, sample->addr, &al);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 49a9315..c541d02 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -771,7 +771,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
 			      event->ip.pid, event->ip.ip, al);
-	/* try to resolve for user space */
+	/* try to resolve addr_location for user space */
 	if (!al->map)
 		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
 				MAP__FUNCTION, event->ip.pid, event->ip.ip, al);

