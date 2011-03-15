Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab1COUFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:05:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:39019 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab1COUFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:05:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 02/12] perf top: Remove redundant syme->origin field
Date: Tue, 15 Mar 2011 17:04:51 -0300
Message-Id: <1300219501-15085-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1300219501-15085-1-git-send-email-acme@infradead.org>
References: <1300219501-15085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We can get it from syme->map->dso->kernel (that should be renamed to
origin, but leave this for another patch).

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    1 -
 tools/perf/util/top.c    |    4 ++--
 tools/perf/util/top.h    |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4bf6e02..4976400 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -782,7 +782,6 @@ static void perf_event__process_sample(const union perf_event *event,
 	if (!syme->skip) {
 		struct perf_evsel *evsel;
 
-		syme->origin = origin;
 		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
 		assert(evsel != NULL);
 		syme->count[evsel->idx]++;
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index fcfb777..a11f607 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -184,9 +184,9 @@ float perf_top__decay_samples(struct perf_top *top, struct rb_root *root)
 		if (syme->snap_count != 0) {
 
 			if ((top->hide_user_symbols &&
-			     syme->origin == PERF_RECORD_MISC_USER) ||
+			     syme->map->dso->kernel == DSO_TYPE_USER) ||
 			    (top->hide_kernel_symbols &&
-			     syme->origin == PERF_RECORD_MISC_KERNEL)) {
+			     syme->map->dso->kernel == DSO_TYPE_KERNEL)) {
 				perf_top__remove_active_sym(top, syme);
 				continue;
 			}
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 96a7831..ba111b2 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -17,7 +17,6 @@ struct sym_entry {
 	unsigned long		snap_count;
 	double			weight;
 	int			skip;
-	u8			origin;
 	struct map		*map;
 	unsigned long		count[0];
 };
-- 
1.6.2.5

