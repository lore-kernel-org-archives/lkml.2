Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab1F1HlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:41:18 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53170 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab1F1Hjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:39:31 -0400
X-AuditID: b753bd60-a1ec5ba000003bac-ea-4e0985316ff8
X-AuditID: b753bd60-a1ec5ba000003bac-ea-4e0985316ff8
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip 1/4] perf script: resolve DSOs and symbols for user-space
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 28 Jun 2011 16:40:30 +0900
Message-ID: <20110628074029.4269.32165.stgit@linux3>
In-Reply-To: <20110628074019.4269.32109.stgit@linux3>
References: <20110628074019.4269.32109.stgit@linux3>
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
7f87279646b0           ([kernel.kallsyms]) ffffffff81467612 irq_return ([kernel.kallsyms])
7f87279646b0    _start (/lib64/ld-2.14.so) ffffffff81467612 irq_return ([kernel.kallsyms])
7f8727967b70 _dl_start (/lib64/ld-2.14.so)     7f87279646b3 _start (/lib64/ld-2.14.so)
7f8727967b70 _dl_start (/lib64/ld-2.14.so) ffffffff81467612 irq_return ([kernel.kallsyms])
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

 tools/perf/builtin-script.c |    3 +++
 tools/perf/util/event.c     |    4 ++++
 tools/perf/util/session.c   |    2 +-
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 3056b45..e45433f 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -327,6 +327,9 @@ static void print_sample_addr(union perf_event *event,
 	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
 			      event->ip.pid, sample->addr, &al);
 	if (!al.map)
+		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
+			MAP__FUNCTION, event->ip.pid, sample->addr, &al);
+	if (!al.map)
 		thread__find_addr_map(thread, session, cpumode, MAP__VARIABLE,
 				      event->ip.pid, sample->addr, &al);
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3c1b8a6..68e7af9 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -771,6 +771,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
 			      event->ip.pid, event->ip.ip, al);
+	if (!al->map)
+		thread__find_addr_map(thread, session, PERF_RECORD_MISC_USER,
+				MAP__FUNCTION, event->ip.pid, event->ip.ip, al);
+
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b723f21..632266f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1257,7 +1257,7 @@ void perf_session__print_ip(union perf_event *event,
 		}
 
 	} else {
-		printf("%16" PRIx64, al.addr);
+		printf("%16" PRIx64, sample->ip);
 		if (print_sym) {
 			if (al.sym && al.sym->name)
 				symname = al.sym->name;

