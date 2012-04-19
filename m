Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab2DSUfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:35:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33513 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab2DSUeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:34:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/13] perf symbols: Introduce symbol__size method
Date: Thu, 19 Apr 2012 17:34:03 -0300
Message-Id: <1334867644-2722-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334867644-2722-1-git-send-email-acme@infradead.org>
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Fixing some off by one cases in the process.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-fxumzufhk829z0q9anmvemea@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   10 +++++-----
 tools/perf/util/symbol.h   |    5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index ed1f89d..d8e2f41 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -101,7 +101,7 @@ int symbol__annotate_init(struct map *map __used, struct symbol *sym)
 int symbol__alloc_hist(struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
-	const size_t size = sym->end - sym->start + 1;
+	const size_t size = symbol__size(sym);
 	size_t sizeof_sym_hist = (sizeof(struct sym_hist) + size * sizeof(u64));
 
 	notes->src = zalloc(sizeof(*notes->src) + symbol_conf.nr_events * sizeof_sym_hist);
@@ -609,7 +609,7 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
-	u64 len = sym->end - sym->start, offset;
+	u64 len = symbol__size(sym), offset;
 
 	for (offset = 0; offset < len; ++offset)
 		if (h->addr[offset] != 0)
@@ -636,7 +636,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 	else
 		d_filename = basename(filename);
 
-	len = sym->end - sym->start;
+	len = symbol__size(sym);
 
 	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
 	printf("------------------------------------------------\n");
@@ -696,7 +696,7 @@ void symbol__annotate_decay_histogram(struct symbol *sym, int evidx)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
-	int len = sym->end - sym->start, offset;
+	int len = symbol__size(sym), offset;
 
 	h->sum = 0;
 	for (offset = 0; offset < len; ++offset) {
@@ -755,7 +755,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 	if (symbol__annotate(sym, map, 0) < 0)
 		return -1;
 
-	len = sym->end - sym->start;
+	len = symbol__size(sym);
 
 	if (print_lines) {
 		symbol__get_source_line(sym, map, evidx, &source_line,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ac49ef2..1f00388 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -65,6 +65,11 @@ struct symbol {
 
 void symbol__delete(struct symbol *sym);
 
+static inline size_t symbol__size(const struct symbol *sym)
+{
+	return sym->end - sym->start + 1;
+}
+
 struct strlist;
 
 struct symbol_conf {
-- 
1.7.9.2.358.g22243

