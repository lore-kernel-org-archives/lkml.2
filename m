Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1BGH4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:56:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:36442 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab1BGH4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:56:16 -0500
Date: Mon, 7 Feb 2011 07:55:47 GMT
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
Subject: [tip:perf/core] perf annotate: Config options for symbol__tty_annotate
Message-ID: <tip-d040bd363824f9f0ad6610b91ee6c65f292c066c@git.kernel.org>
Git-Commit-ID: d040bd363824f9f0ad6610b91ee6c65f292c066c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 07 Feb 2011 07:55:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d040bd363824f9f0ad6610b91ee6c65f292c066c
Gitweb:     http://git.kernel.org/tip/d040bd363824f9f0ad6610b91ee6c65f292c066c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 5 Feb 2011 15:37:31 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 5 Feb 2011 15:37:31 -0200

perf annotate: Config options for symbol__tty_annotate

Max line# that should be printed, minimum percentage filter, just like
'perf top', alas, due to it :-)

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
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/util/annotate.c    |   14 ++++++++++----
 tools/perf/util/annotate.h    |    3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index f3e4423..ea6a116 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -95,7 +95,7 @@ static int process_sample_event(union perf_event *event,
 static int hist_entry__tty_annotate(struct hist_entry *he, int evidx)
 {
 	return symbol__tty_annotate(he->ms.sym, he->ms.map, evidx,
-				    print_line, full_paths);
+				    print_line, full_paths, 0, 0);
 }
 
 static void hists__find_annotations(struct hists *self)
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7488fe9..072bc8d 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -87,7 +87,7 @@ struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
 
 static void objdump_line__print(struct objdump_line *oline,
 				struct list_head *head, struct symbol *sym,
-				int evidx, u64 len)
+				int evidx, u64 len, int min_pcnt)
 {
 	static const char *prev_line;
 	static const char *prev_color;
@@ -118,6 +118,9 @@ static void objdump_line__print(struct objdump_line *oline,
 		if (src_line == NULL && h->sum)
 			percent = 100.0 * hits / h->sum;
 
+		if (percent < min_pcnt)
+			return;
+
 		color = get_percent_color(percent);
 
 		/*
@@ -419,13 +422,15 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 }
 
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths)
+			 bool print_lines, bool full_paths, int min_pcnt,
+			 int max_lines)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name, *d_filename;
 	struct rb_root source_line = RB_ROOT;
 	struct objdump_line *pos, *n;
 	LIST_HEAD(head);
+	int printed = 2;
 	u64 len;
 
 	if (symbol__annotate(sym, map, &head, 0) < 0)
@@ -444,7 +449,6 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 		print_summary(&source_line, filename);
 	}
 
-	printf("\n\n------------------------------------------------\n");
 	printf(" Percent |	Source code & Disassembly of %s\n", d_filename);
 	printf("------------------------------------------------\n");
 
@@ -452,9 +456,11 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 		symbol__annotate_hits(sym, evidx);
 
 	list_for_each_entry_safe(pos, n, &head, node) {
-		objdump_line__print(pos, &head, sym, evidx, len);
+		objdump_line__print(pos, &head, sym, evidx, len, min_pcnt);
 		list_del(&pos->node);
 		objdump_line__free(pos);
+		if (max_lines && ++printed >= max_lines)
+			break;
 	}
 
 	if (print_lines)
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 0a5069ca..6b70732 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -69,7 +69,8 @@ int symbol__annotate(struct symbol *sym, struct map *map,
 		     struct list_head *head, size_t privsize);
 
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths);
+			 bool print_lines, bool full_paths, int min_pcnt,
+			 int max_lines);
 
 #ifdef NO_NEWT_SUPPORT
 static inline int symbol__tui_annotate(symbol *sym __used,
