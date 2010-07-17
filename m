Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab0GQLLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 07:11:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:41355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab0GQLL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 07:11:28 -0400
Date: Sat, 17 Jul 2010 11:11:03 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4C36EBE7.3060802@hitachi.com>
References: <4C36EBE7.3060802@hitachi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Support comp_dir to find an absolute source path
Message-ID: <tip-6a330a3c8a648916b3c6bda79a78c38ac093af17@git.kernel.org>
Git-Commit-ID: 6a330a3c8a648916b3c6bda79a78c38ac093af17
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 17 Jul 2010 11:11:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a330a3c8a648916b3c6bda79a78c38ac093af17
Gitweb:     http://git.kernel.org/tip/6a330a3c8a648916b3c6bda79a78c38ac093af17
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 9 Jul 2010 18:29:11 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jul 2010 11:48:09 -0300

perf probe: Support comp_dir to find an absolute source path

Gcc generates DW_AT_comp_dir and stores relative source path if building kernel
without O= option. In that case, perf probe --line sometimes doesn't work
without --source option, because it tries to access relative source path.

This adds DW_AT_comp_dir support to perf probe for finding an absolute source
path when no --source option.

LKML-Reference: <4C36EBE7.3060802@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |   34 ++++++++++++++++++++++------------
 tools/perf/util/probe-event.h  |    1 +
 tools/perf/util/probe-finder.c |   21 +++++++++++++++++++++
 3 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 8d08e75..4445a1e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -201,28 +201,38 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
  * a newly allocated path on success.
  * Return 0 if file was found and readable, -errno otherwise.
  */
-static int get_real_path(const char *raw_path, char **new_path)
+static int get_real_path(const char *raw_path, const char *comp_dir,
+			 char **new_path)
 {
-	if (!symbol_conf.source_prefix) {
-		if (access(raw_path, R_OK) == 0) {
-			*new_path = strdup(raw_path);
-			return 0;
-		} else
-			return -errno;
+	const char *prefix = symbol_conf.source_prefix;
+
+	if (!prefix) {
+		if (raw_path[0] != '/' && comp_dir)
+			/* If not an absolute path, try to use comp_dir */
+			prefix = comp_dir;
+		else {
+			if (access(raw_path, R_OK) == 0) {
+				*new_path = strdup(raw_path);
+				return 0;
+			} else
+				return -errno;
+		}
 	}
 
-	*new_path = malloc((strlen(symbol_conf.source_prefix) +
-			    strlen(raw_path) + 2));
+	*new_path = malloc((strlen(prefix) + strlen(raw_path) + 2));
 	if (!*new_path)
 		return -ENOMEM;
 
 	for (;;) {
-		sprintf(*new_path, "%s/%s", symbol_conf.source_prefix,
-			raw_path);
+		sprintf(*new_path, "%s/%s", prefix, raw_path);
 
 		if (access(*new_path, R_OK) == 0)
 			return 0;
 
+		if (!symbol_conf.source_prefix)
+			/* In case of searching comp_dir, don't retry */
+			return -errno;
+
 		switch (errno) {
 		case ENAMETOOLONG:
 		case ENOENT:
@@ -318,7 +328,7 @@ int show_line_range(struct line_range *lr)
 
 	/* Convert source file path */
 	tmp = lr->path;
-	ret = get_real_path(tmp, &lr->path);
+	ret = get_real_path(tmp, lr->comp_dir, &lr->path);
 	free(tmp);	/* Free old path */
 	if (ret < 0) {
 		pr_warning("Failed to find source file. (%d)\n", ret);
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index bc06d3e..ed362ac 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -86,6 +86,7 @@ struct line_range {
 	int			end;		/* End line number */
 	int			offset;		/* Start line offset */
 	char			*path;		/* Real path name */
+	char			*comp_dir;	/* Compile directory */
 	struct list_head	line_list;	/* Visible lines */
 };
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index a934a36..37dcdb6 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -144,6 +144,15 @@ static const char *cu_find_realpath(Dwarf_Die *cu_die, const char *fname)
 	return src;
 }
 
+/* Get DW_AT_comp_dir (should be NULL with older gcc) */
+static const char *cu_get_comp_dir(Dwarf_Die *cu_die)
+{
+	Dwarf_Attribute attr;
+	if (dwarf_attr(cu_die, DW_AT_comp_dir, &attr) == NULL)
+		return NULL;
+	return dwarf_formstring(&attr);
+}
+
 /* Compare diename and tname */
 static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 {
@@ -1374,6 +1383,7 @@ int find_line_range(int fd, struct line_range *lr)
 	size_t cuhl;
 	Dwarf_Die *diep;
 	Dwarf *dbg;
+	const char *comp_dir;
 
 	dbg = dwarf_begin(fd, DWARF_C_READ);
 	if (!dbg) {
@@ -1409,6 +1419,17 @@ int find_line_range(int fd, struct line_range *lr)
 		}
 		off = noff;
 	}
+
+	/* Store comp_dir */
+	if (lf.found) {
+		comp_dir = cu_get_comp_dir(&lf.cu_die);
+		if (comp_dir) {
+			lr->comp_dir = strdup(comp_dir);
+			if (!lr->comp_dir)
+				ret = -ENOMEM;
+		}
+	}
+
 	pr_debug("path: %s\n", lr->path);
 	dwarf_end(dbg);
 
