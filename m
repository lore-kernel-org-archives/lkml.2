Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1BGH45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:56:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:36465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab1BGH4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:56:55 -0500
Date: Mon, 7 Feb 2011 07:56:11 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Separate objdump parsing from actual screen rendering
Message-ID: <tip-f1e2701de02cff6d988b1dd49960620d5720cb89@git.kernel.org>
Git-Commit-ID: f1e2701de02cff6d988b1dd49960620d5720cb89
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 07 Feb 2011 07:56:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1e2701de02cff6d988b1dd49960620d5720cb89
Gitweb:     http://git.kernel.org/tip/f1e2701de02cff6d988b1dd49960620d5720cb89
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 5 Feb 2011 18:51:38 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 6 Feb 2011 13:40:31 -0200

perf annotate: Separate objdump parsing from actual screen rendering

Because in 'perf top' we'll need to parse just once and then, as samples
come, render multiple times with evolving counter values.

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
 tools/perf/util/annotate.c |   62 ++++++++++++++++++++++++++++++-------------
 tools/perf/util/annotate.h |    4 +++
 2 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 072bc8d..10cdbad 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -421,21 +421,16 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
-int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths, int min_pcnt,
-			 int max_lines)
+void symbol__annotate_printf(struct symbol *sym, struct map *map,
+			     struct list_head *head, int evidx, bool full_paths,
+			     int min_pcnt, int max_lines)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name, *d_filename;
-	struct rb_root source_line = RB_ROOT;
-	struct objdump_line *pos, *n;
-	LIST_HEAD(head);
+	struct objdump_line *pos;
 	int printed = 2;
 	u64 len;
 
-	if (symbol__annotate(sym, map, &head, 0) < 0)
-		return -1;
-
 	if (full_paths)
 		d_filename = filename;
 	else
@@ -443,28 +438,57 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	len = sym->end - sym->start;
 
-	if (print_lines) {
-		symbol__get_source_line(sym, map, evidx, &source_line,
-					len, filename);
-		print_summary(&source_line, filename);
-	}
-
 	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
 	printf("------------------------------------------------\n");
 
 	if (verbose)
 		symbol__annotate_hits(sym, evidx);
 
-	list_for_each_entry_safe(pos, n, &head, node) {
-		objdump_line__print(pos, &head, sym, evidx, len, min_pcnt);
-		list_del(&pos->node);
-		objdump_line__free(pos);
+	list_for_each_entry(pos, head, node) {
+		objdump_line__print(pos, head, sym, evidx, len, min_pcnt);
 		if (max_lines && ++printed >= max_lines)
 			break;
+
+	}
+}
+
+void objdump_line_list__purge(struct list_head *head)
+{
+	struct objdump_line *pos, *n;
+
+	list_for_each_entry_safe(pos, n, head, node) {
+		list_del(&pos->node);
+		objdump_line__free(pos);
+	}
+}
+
+int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
+			 bool print_lines, bool full_paths, int min_pcnt,
+			 int max_lines)
+{
+	struct dso *dso = map->dso;
+	const char *filename = dso->long_name;
+	struct rb_root source_line = RB_ROOT;
+	LIST_HEAD(head);
+	u64 len;
+
+	if (symbol__annotate(sym, map, &head, 0) < 0)
+		return -1;
+
+	len = sym->end - sym->start;
+
+	if (print_lines) {
+		symbol__get_source_line(sym, map, evidx, &source_line,
+					len, filename);
+		print_summary(&source_line, filename);
 	}
 
+	symbol__annotate_printf(sym, map, &head, evidx, full_paths,
+				min_pcnt, max_lines);
 	if (print_lines)
 		symbol__free_source_line(sym, len);
 
+	objdump_line_list__purge(&head);
+
 	return 0;
 }
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 6b70732..53dd92d 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -67,6 +67,10 @@ int symbol__alloc_hist(struct symbol *sym, int nevents);
 
 int symbol__annotate(struct symbol *sym, struct map *map,
 		     struct list_head *head, size_t privsize);
+void symbol__annotate_printf(struct symbol *sym, struct map *map,
+			     struct list_head *head, int evidx, bool full_paths,
+			     int min_pcnt, int max_lines);
+void objdump_line_list__purge(struct list_head *head);
 
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 bool print_lines, bool full_paths, int min_pcnt,
