Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140Ab2D0I1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:27:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34117 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab2D0I06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:26:58 -0400
Date: Fri, 27 Apr 2012 01:26:37 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-6aazb9f5o3d9zi28e6rruv12@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Parse instruction
Git-Commit-ID: 5145418b06fa907883ff1f62301d534a0d26ba18
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:26:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5145418b06fa907883ff1f62301d534a0d26ba18
Gitweb:     http://git.kernel.org/tip/5145418b06fa907883ff1f62301d534a0d26ba18
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sun, 15 Apr 2012 15:52:18 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 16 Apr 2012 12:15:07 -0300

perf annotate: Parse instruction

For lines with instructions find the name and operands, breaking those
tokens for consumption by the browser.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6aazb9f5o3d9zi28e6rruv12@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   65 +++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/annotate.h |    3 ++
 2 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index ef1d57d..a72585a 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -80,16 +80,50 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privsize)
 {
-	struct disasm_line *dl = malloc(sizeof(*dl) + privsize);
+	struct disasm_line *dl = zalloc(sizeof(*dl) + privsize);
 
 	if (dl != NULL) {
 		dl->offset = offset;
 		dl->line = strdup(line);
 		if (dl->line == NULL)
 			goto out_delete;
+
+		if (offset != -1) {
+			char *name = dl->line, tmp;
+
+			while (isspace(name[0]))
+				++name;
+
+			if (name[0] == '\0')
+				goto out_delete;
+
+			dl->operands = name + 1;
+
+			while (dl->operands[0] != '\0' &&
+			       !isspace(dl->operands[0]))
+				++dl->operands;
+
+			tmp = dl->operands[0];
+			dl->operands[0] = '\0';
+			dl->name = strdup(name);
+
+			if (dl->name == NULL)
+				goto out_free_line;
+
+			dl->operands[0] = tmp;
+
+			if (dl->operands[0] != '\0') {
+				dl->operands++;
+				while (isspace(dl->operands[0]))
+					++dl->operands;
+			}
+		}
 	}
 
 	return dl;
+
+out_free_line:
+	free(dl->line);
 out_delete:
 	free(dl);
 	return NULL;
@@ -98,6 +132,7 @@ out_delete:
 void disasm_line__free(struct disasm_line *dl)
 {
 	free(dl->line);
+	free(dl->name);
 	free(dl);
 }
 
@@ -591,6 +626,34 @@ void disasm__purge(struct list_head *head)
 	}
 }
 
+static size_t disasm_line__fprintf(struct disasm_line *dl, FILE *fp)
+{
+	size_t printed;
+
+	if (dl->offset == -1)
+		return fprintf(fp, "%s\n", dl->line);
+
+	printed = fprintf(fp, "%#" PRIx64 " %s", dl->offset, dl->name);
+
+	if (dl->operands[0] != '\0') {
+		printed += fprintf(fp, "%.*s %s\n", 6 - (int)printed, " ",
+				   dl->operands);
+	}
+
+	return printed + fprintf(fp, "\n");
+}
+
+size_t disasm__fprintf(struct list_head *head, FILE *fp)
+{
+	struct disasm_line *pos;
+	size_t printed = 0;
+
+	list_for_each_entry(pos, head, node)
+		printed += disasm_line__fprintf(pos, fp);
+
+	return printed;
+}
+
 int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 bool print_lines, bool full_paths, int min_pcnt,
 			 int max_lines)
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 8bb68bb..dd7636d 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -11,10 +11,13 @@ struct disasm_line {
 	struct list_head node;
 	s64		 offset;
 	char		 *line;
+	char		 *name;
+	char		 *operands;
 };
 
 void disasm_line__free(struct disasm_line *dl);
 struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disasm_line *pos);
+size_t disasm__fprintf(struct list_head *head, FILE *fp);
 
 struct sym_hist {
 	u64		sum;
