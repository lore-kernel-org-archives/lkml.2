Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1GQJa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:30:26 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37206 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab1GQJaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:30:14 -0400
X-AuditID: b753bd60-a25b2ba0000052de-b7-4e22aba34d4d
X-AuditID: b753bd60-a25b2ba0000052de-b7-4e22aba34d4d
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v2 3/6] perf script: resolve DSOs and symbols for
 user-space
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
Date: Sun, 17 Jul 2011 18:30:57 +0900
Message-ID: <20110717093057.3447.31077.stgit@linux3>
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

Resolve user-space DSOs and symbols.
Latest perf-script can resolve DSOs and symbols for only kernel
and kernel modules. This patch resolves them for other
executable binaries.

# perf script -f ip,addr,sym,dso
3f03e016b0 ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e016b0 ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04b80       3f03e016b3 _start (/lib64/ld-2.14.so)
3f03e04b80 ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04ba6 ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04bad ffffffff814675d2 irq_return ([kernel.kallsyms])
3f03e04c1d       3f03e04bfb _dl_start (/lib64/ld-2.14.so)
3f03e04c00       3f03e04c21 _dl_start (/lib64/ld-2.14.so)
3f03e04c00       3f03e04c21 _dl_start (/lib64/ld-2.14.so)
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

 tools/perf/builtin-script.c |    4 ++++
 tools/perf/util/event.c     |    5 +++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b3e0951..2356198 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -328,6 +328,10 @@ static void print_sample_addr(union perf_event *event,
 
 	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
 			      event->ip.pid, sample->addr, &al);
+	/* try to resolve for user space */
+	if (!al.map)
+		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
+			MAP__FUNCTION, event->ip.pid, sample->addr, &al);
 	if (!al.map)
 		thread__find_addr_map(thread, session, cpumode, MAP__VARIABLE,
 				      event->ip.pid, sample->addr, &al);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3c1b8a6..49a9315 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -771,6 +771,11 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
 			      event->ip.pid, event->ip.ip, al);
+	/* try to resolve for user space */
+	if (!al->map)
+		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
+				MAP__FUNCTION, event->ip.pid, event->ip.ip, al);
+
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");

