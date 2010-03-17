Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0CQLbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:31:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:36238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab0CQLbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:31:44 -0400
Date: Wed, 17 Mar 2010 11:29:55 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100316220619.32050.48702.stgit@localhost6.localdomain6>
References: <20100316220619.32050.48702.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: List probes with line number and file name
Message-ID: <tip-fb1587d869a399554220e166d4b90b581a8ade01@git.kernel.org>
Git-Commit-ID: fb1587d869a399554220e166d4b90b581a8ade01
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 11:29:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb1587d869a399554220e166d4b90b581a8ade01
Gitweb:     http://git.kernel.org/tip/fb1587d869a399554220e166d4b90b581a8ade01
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 16 Mar 2010 18:06:19 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 11:32:32 +0100

perf probe: List probes with line number and file name

Improve --list to show current exist probes with line number and
file name. This enables user easily to check which line is
already probed.

for example:

 ./perf probe --list
 probe:vfs_read       (on vfs_read:8@linux-2.6-tip/fs/read_write.c)

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100316220619.32050.48702.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c  |   57 ++++++++++++++++++++++++--------
 tools/perf/util/probe-finder.c |   70 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-finder.h |    4 ++
 3 files changed, 117 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b44ddfb..4e3c1ae 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -70,7 +70,6 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 	return ret;
 }
 
-
 static struct map_groups kmap_groups;
 static struct map *kmaps[MAP__NR_TYPES];
 
@@ -357,27 +356,39 @@ void parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
 /* Compose only probe point (not argument) */
 static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 {
-	char *buf;
-	char offs[64] = "", line[64] = "";
-	int ret;
+	char *buf, *tmp;
+	char offs[32] = "", line[32] = "", file[32] = "";
+	int ret, len;
 
 	buf = xzalloc(MAX_CMDLEN);
 	if (pp->offset) {
-		ret = e_snprintf(offs, 64, "+%lu", pp->offset);
+		ret = e_snprintf(offs, 32, "+%lu", pp->offset);
 		if (ret <= 0)
 			goto error;
 	}
 	if (pp->line) {
-		ret = e_snprintf(line, 64, ":%d", pp->line);
+		ret = e_snprintf(line, 32, ":%d", pp->line);
+		if (ret <= 0)
+			goto error;
+	}
+	if (pp->file) {
+		len = strlen(pp->file) - 32;
+		if (len < 0)
+			len = 0;
+		tmp = strchr(pp->file + len, '/');
+		if (!tmp)
+			tmp = pp->file + len - 1;
+		ret = e_snprintf(file, 32, "@%s", tmp + 1);
 		if (ret <= 0)
 			goto error;
 	}
 
 	if (pp->function)
-		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s%s%s", pp->function,
-				 offs, pp->retprobe ? "%return" : "", line);
+		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s%s%s%s", pp->function,
+				 offs, pp->retprobe ? "%return" : "", line,
+				 file);
 	else
-		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s", pp->file, line);
+		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s", file, line);
 	if (ret <= 0)
 		goto error;
 
@@ -511,15 +522,32 @@ void convert_to_perf_probe_event(struct kprobe_trace_event *tev,
 {
 	char buf[64];
 	int i;
+#ifndef NO_DWARF_SUPPORT
+	struct symbol *sym;
+	int fd, ret = 0;
 
-	pev->event = xstrdup(tev->event);
-	pev->group = xstrdup(tev->group);
-
+	sym = map__find_symbol_by_name(kmaps[MAP__FUNCTION],
+				       tev->point.symbol, NULL);
+	if (sym) {
+		fd = open_vmlinux();
+		ret = find_perf_probe_point(fd, sym->start + tev->point.offset,
+					    &pev->point);
+		close(fd);
+	}
+	if (ret <= 0) {
+		pev->point.function = xstrdup(tev->point.symbol);
+		pev->point.offset = tev->point.offset;
+	}
+#else
 	/* Convert trace_point to probe_point */
 	pev->point.function = xstrdup(tev->point.symbol);
 	pev->point.offset = tev->point.offset;
+#endif
 	pev->point.retprobe = tev->point.retprobe;
 
+	pev->event = xstrdup(tev->event);
+	pev->group = xstrdup(tev->group);
+
 	/* Convert trace_arg to probe_arg */
 	pev->nargs = tev->nargs;
 	pev->args = xzalloc(sizeof(struct perf_probe_arg) * pev->nargs);
@@ -650,7 +678,7 @@ static void show_perf_probe_event(struct perf_probe_event *pev)
 	ret = e_snprintf(buf, 128, "%s:%s", pev->group, pev->event);
 	if (ret < 0)
 		die("Failed to copy event: %s", strerror(-ret));
-	printf("  %-40s (on %s", buf, place);
+	printf("  %-20s (on %s", buf, place);
 
 	if (pev->nargs > 0) {
 		printf(" with");
@@ -671,6 +699,7 @@ void show_perf_probe_events(void)
 	struct str_node *ent;
 
 	setup_pager();
+	init_vmlinux();
 
 	memset(&tev, 0, sizeof(tev));
 	memset(&pev, 0, sizeof(pev));
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 251b4c4..e02b607 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -693,6 +693,76 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	return pf.ntevs;
 }
 
+/* Reverse search */
+int find_perf_probe_point(int fd, unsigned long addr,
+			  struct perf_probe_point *ppt)
+{
+	Dwarf_Die cudie, spdie, indie;
+	Dwarf *dbg;
+	Dwarf_Line *line;
+	Dwarf_Addr laddr, eaddr;
+	const char *tmp;
+	int lineno, ret = 0;
+
+	dbg = dwarf_begin(fd, DWARF_C_READ);
+	if (!dbg)
+		return -ENOENT;
+
+	/* Find cu die */
+	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr, &cudie))
+		return -EINVAL;
+
+	/* Find a corresponding line */
+	line = dwarf_getsrc_die(&cudie, (Dwarf_Addr)addr);
+	if (line) {
+		dwarf_lineaddr(line, &laddr);
+		if ((Dwarf_Addr)addr == laddr) {
+			dwarf_lineno(line, &lineno);
+			ppt->line = lineno;
+
+			tmp = dwarf_linesrc(line, NULL, NULL);
+			DIE_IF(!tmp);
+			ppt->file = xstrdup(tmp);
+			ret = 1;
+		}
+	}
+
+	/* Find a corresponding function */
+	if (die_find_real_subprogram(&cudie, (Dwarf_Addr)addr, &spdie)) {
+		tmp = dwarf_diename(&spdie);
+		if (!tmp)
+			goto end;
+
+		dwarf_entrypc(&spdie, &eaddr);
+		if (!lineno) {
+			/* We don't have a line number, let's use offset */
+			ppt->function = xstrdup(tmp);
+			ppt->offset = addr - (unsigned long)eaddr;
+			ret = 1;
+			goto end;
+		}
+		if (die_find_inlinefunc(&spdie, (Dwarf_Addr)addr, &indie)) {
+			/* addr in an inline function */
+			tmp = dwarf_diename(&indie);
+			if (!tmp)
+				goto end;
+			dwarf_decl_line(&indie, &lineno);
+		} else {
+			if (eaddr == addr)	/* No offset: function entry */
+				lineno = ppt->line;
+			else
+				dwarf_decl_line(&spdie, &lineno);
+		}
+		ppt->function = xstrdup(tmp);
+		ppt->line -= lineno;	/* Make a relative line number */
+	}
+
+end:
+	dwarf_end(dbg);
+	return ret;
+}
+
+
 /* Find line range from its line number */
 static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 {
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 4949526..2f2307d 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -20,6 +20,10 @@ static inline int is_c_varname(const char *name)
 extern int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 				    struct kprobe_trace_event **tevs);
 
+/* Find a perf_probe_point from debuginfo */
+extern int find_perf_probe_point(int fd, unsigned long addr,
+				 struct perf_probe_point *ppt);
+
 extern int find_line_range(int fd, struct line_range *lr);
 
 #include <dwarf.h>
