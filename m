Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab2D0IcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:32:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34238 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2D0IcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:32:03 -0400
Date: Fri, 27 Apr 2012 01:31:36 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-fxumzufhk829z0q9anmvemea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Introduce symbol__size method
Git-Commit-ID: 1b2e2df4e395293e65dbda49e58cb4c7abeb7507
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:31:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b2e2df4e395293e65dbda49e58cb4c7abeb7507
Gitweb:     http://git.kernel.org/tip/1b2e2df4e395293e65dbda49e58cb4c7abeb7507
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Apr 2012 10:57:06 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Apr 2012 10:57:06 -0300

perf symbols: Introduce symbol__size method

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
