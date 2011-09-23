Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab1IWU1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:27:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35475 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab1IWU04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:26:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/12] perf top: Fix userspace sample addr map offset
Date: Fri, 23 Sep 2011 17:26:25 -0300
Message-Id: <1316809586-28529-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1316809586-28529-1-git-send-email-acme@infradead.org>
References: <1316809586-28529-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The 'perf top' tool came from the kernel where we had each DSO (vmlinux,
modules) loaded just once at a time.

But userspace may have DSOs loaded in multiple addresses (shared
libraries), requiring that we use the just resolved map instead of the
first one found.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ag53wz0yllpgers0n2w7hchp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a43433f..d28013b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -191,7 +191,8 @@ static void __zero_source_counters(struct sym_entry *syme)
 	symbol__annotate_zero_histograms(sym);
 }
 
-static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
+static void record_precise_ip(struct sym_entry *syme, struct map *map,
+			      int counter, u64 ip)
 {
 	struct annotation *notes;
 	struct symbol *sym;
@@ -205,8 +206,8 @@ static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
 	if (pthread_mutex_trylock(&notes->lock))
 		return;
 
-	ip = syme->map->map_ip(syme->map, ip);
-	symbol__inc_addr_samples(sym, syme->map, counter, ip);
+	ip = map->map_ip(map, ip);
+	symbol__inc_addr_samples(sym, map, counter, ip);
 
 	pthread_mutex_unlock(&notes->lock);
 }
@@ -810,7 +811,7 @@ static void perf_event__process_sample(const union perf_event *event,
 		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
 		assert(evsel != NULL);
 		syme->count[evsel->idx]++;
-		record_precise_ip(syme, evsel->idx, ip);
+		record_precise_ip(syme, al.map, evsel->idx, ip);
 		pthread_mutex_lock(&top.active_symbols_lock);
 		if (list_empty(&syme->node) || !syme->node.next) {
 			static bool first = true;
-- 
1.6.2.5

