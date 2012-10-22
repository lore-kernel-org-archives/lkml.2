Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2JVJsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:48:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57004 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2JVJsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:48:13 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v5 5/6] perf tools: fix using --sysroot with addr2line
Date: Mon, 22 Oct 2012 12:46:11 +0300
Message-Id: <1350899172-16965-6-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350899172-16965-1-git-send-email-irina.tirdea@gmail.com>
References: <1350899172-16965-1-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

When cross-compiling --sysroot can be used to point to the directory
with header files and libraries for the target architecture.

perf annotate -l and perf report --sort srcline call addr2line to get the
source line number. addr2line will not prefix the libraries with sysroot
and the symbols will not be found:
  i686-linux-android-addr2line: '/system/lib/libpixelflinger.so': No such file

Add the sysroot prefix for addr2line so that the libraries are found.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/util/annotate.c |   10 +++++++++-
 tools/perf/util/sort.c     |    9 ++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 9c0fa54..bf5573f 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -895,10 +895,18 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	struct source_line *src_line;
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
+	char symfs_filename[PATH_MAX];
 
 	if (!h->sum)
 		return 0;
 
+	snprintf(symfs_filename, sizeof(symfs_filename), "%s%s",
+		symbol_conf.symfs, filename);
+	if (access(symfs_filename, R_OK)) {
+		snprintf(symfs_filename, sizeof(symfs_filename), "%s",
+			 filename);
+	}
+
 	src_line = notes->src->lines = calloc(len, sizeof(struct source_line));
 	if (!notes->src->lines)
 		return -1;
@@ -918,7 +926,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 		offset = start + i;
 		sprintf(cmd, "%s -e %s %016" PRIx64,
 			addr2line_path ? addr2line_path : "addr2line",
-			filename, offset);
+			symfs_filename, offset);
 		fp = popen(cmd, "r");
 		if (!fp)
 			continue;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f014bfa..88e41b7 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -257,6 +257,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	FILE *fp;
 	char cmd[PATH_MAX + 2], *path = self->srcline, *nl;
 	size_t line_len;
+	char symfs_dso_name[PATH_MAX];
 
 	if (path != NULL)
 		goto out_path;
@@ -269,9 +270,15 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	     strlen(PERF_TMP_DIR "/perf-")))
 		goto out_ip;
 
+	snprintf(symfs_dso_name, sizeof(symfs_dso_name), "%s%s",
+		 symbol_conf.symfs, self->ms.map->dso->long_name);
+	if (access(symfs_dso_name, R_OK))
+		snprintf(symfs_dso_name, sizeof(symfs_dso_name), "%s",
+			 self->ms.map->dso->long_name);
 	snprintf(cmd, sizeof(cmd), "%s -e %s %016" PRIx64,
 		 addr2line_path ? addr2line_path : "addr2line",
-		 self->ms.map->dso->long_name, self->ip);
+		 symfs_dso_name, self->ip);
+
 	fp = popen(cmd, "r");
 	if (!fp)
 		goto out_ip;
-- 
1.7.9.5

