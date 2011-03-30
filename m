Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1C3Cft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:35:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab1C3Cfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:35:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf probe: Add fastpath to do lookup by function name
Date: Tue, 29 Mar 2011 23:35:32 -0300
Message-Id: <1301452532-1260-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1301452532-1260-1-git-send-email-acme@infradead.org>
References: <1301452532-1260-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

v3 -> v2:
- Make pubname_search_cb more generic
- Add fastpath to find_probes also

v2 -> v1:
- Don't compare file names with cu_find_realpath(...), instead, compare
  them with the name returned by dwarf_decl_file(sp_die)

The vmlinux file may have thousands of CUs.
We can lookup function name from .debug_pubnames section
to avoid the slow loop on CUs.

1. Improvement data for find_line_range

./perf stat -e cycles -r 10 -- ./perf probe -k /home/mlin/vmlinux \
        -s /home/mlin/linux-2.6 \
        --line csum_partial_copy_to_user > tmp.log

before patch applied
=====================
       847,988,276 cycles

        0.355075856  seconds time elapsed

after patch applied
=====================
       206,102,622 cycles

        0.086883555  seconds time elapsed

2. Improvement data for find_probes

./perf stat -e cycles -r 10 -- ./perf probe -k /home/mlin/vmlinux \
        -s /home/mlin/linux-2.6 \
        --vars csum_partial_copy_to_user > tmp.log

before patch applied
=====================
       848,490,844 cycles

        0.355307901  seconds time elapsed

after patch applied
=====================
       205,684,469 cycles

        0.086694010  seconds time elapsed

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1301041668.14111.52.camel@minggr.sh.intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   72 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-finder.h |    2 +
 2 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 194f9e2..ff416b8 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1435,6 +1435,38 @@ static int find_probe_point_by_func(struct probe_finder *pf)
 	return _param.retval;
 }
 
+struct pubname_callback_param {
+	char *function;
+	char *file;
+	Dwarf_Die *cu_die;
+	Dwarf_Die *sp_die;
+	int found;
+};
+
+static int pubname_search_cb(Dwarf *dbg, Dwarf_Global *gl, void *data)
+{
+	struct pubname_callback_param *param = data;
+
+	if (dwarf_offdie(dbg, gl->die_offset, param->sp_die)) {
+		if (dwarf_tag(param->sp_die) != DW_TAG_subprogram)
+			return DWARF_CB_OK;
+
+		if (die_compare_name(param->sp_die, param->function)) {
+			if (!dwarf_offdie(dbg, gl->cu_offset, param->cu_die))
+				return DWARF_CB_OK;
+
+			if (param->file &&
+			    strtailcmp(param->file, dwarf_decl_file(param->sp_die)))
+				return DWARF_CB_OK;
+
+			param->found = 1;
+			return DWARF_CB_ABORT;
+		}
+	}
+
+	return DWARF_CB_OK;
+}
+
 /* Find probe points from debuginfo */
 static int find_probes(int fd, struct probe_finder *pf)
 {
@@ -1461,6 +1493,27 @@ static int find_probes(int fd, struct probe_finder *pf)
 
 	off = 0;
 	line_list__init(&pf->lcache);
+
+	/* Fastpath: lookup by function name from .debug_pubnames section */
+	if (pp->function) {
+		struct pubname_callback_param pubname_param = {
+			.function = pp->function,
+			.file	  = pp->file,
+			.cu_die	  = &pf->cu_die,
+			.sp_die	  = &pf->sp_die,
+		};
+		struct dwarf_callback_param probe_param = {
+			.data = pf,
+		};
+
+		dwarf_getpubnames(dbg, pubname_search_cb, &pubname_param, 0);
+		if (pubname_param.found) {
+			ret = probe_point_search_cb(&pf->sp_die, &probe_param);
+			if (ret)
+				goto found;
+		}
+	}
+
 	/* Loop on CUs (Compilation Unit) */
 	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
 		/* Get the DIE(Debugging Information Entry) of this CU */
@@ -1488,6 +1541,8 @@ static int find_probes(int fd, struct probe_finder *pf)
 		}
 		off = noff;
 	}
+
+found:
 	line_list__free(&pf->lcache);
 	if (dwfl)
 		dwfl_end(dwfl);
@@ -1895,6 +1950,22 @@ int find_line_range(int fd, struct line_range *lr)
 		return -EBADF;
 	}
 
+	/* Fastpath: lookup by function name from .debug_pubnames section */
+	if (lr->function) {
+		struct pubname_callback_param pubname_param = {
+			.function = lr->function, .file = lr->file,
+			.cu_die = &lf.cu_die, .sp_die = &lf.sp_die, .found = 0};
+		struct dwarf_callback_param line_range_param = {
+			.data = (void *)&lf, .retval = 0};
+
+		dwarf_getpubnames(dbg, pubname_search_cb, &pubname_param, 0);
+		if (pubname_param.found) {
+			line_range_search_cb(&lf.sp_die, &line_range_param);
+			if (lf.found)
+				goto found;
+		}
+	}
+
 	/* Loop on CUs (Compilation Unit) */
 	while (!lf.found && ret >= 0) {
 		if (dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL) != 0)
@@ -1923,6 +1994,7 @@ int find_line_range(int fd, struct line_range *lr)
 		off = noff;
 	}
 
+found:
 	/* Store comp_dir */
 	if (lf.found) {
 		comp_dir = cu_get_comp_dir(&lf.cu_die);
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index beaefc3..605730a 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -49,6 +49,7 @@ struct probe_finder {
 	Dwarf_Addr		addr;		/* Address */
 	const char		*fname;		/* Real file name */
 	Dwarf_Die		cu_die;		/* Current CU */
+	Dwarf_Die		sp_die;
 	struct list_head	lcache;		/* Line cache for lazy match */
 
 	/* For variable searching */
@@ -83,6 +84,7 @@ struct line_finder {
 	int			lno_s;		/* Start line number */
 	int			lno_e;		/* End line number */
 	Dwarf_Die		cu_die;		/* Current CU */
+	Dwarf_Die		sp_die;
 	int			found;
 };
 
-- 
1.6.2.5

