Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab1CXHn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:43:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:38493 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab1CXHnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:43:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,236,1299484800"; 
   d="scan'208";a="670916028"
From: Lin Ming <ming.m.lin@intel.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf probe: Add fastpath to do lookup by function name
Date: Thu, 24 Mar 2011 23:38:54 +0800
Message-Id: <1300981134-7333-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmlinux file may have thousands of CUs.
We can lookup function name from .debug_pubnames section
to avoid the slow loop on CUs.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/util/probe-finder.c |   38 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-finder.h |    1 +
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 194f9e2..b2034c2 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1876,6 +1876,30 @@ static int find_line_range_by_func(struct line_finder *lf)
 	return param.retval;
 }
 
+static int pubname_search_cb(Dwarf *dbg, Dwarf_Global *gl, void *data)
+{
+	struct line_finder *lf = data;
+	struct line_range *lr = lf->lr;
+
+	if (dwarf_offdie(dbg, gl->die_offset, &lf->sp_die)) {
+		if (dwarf_tag(&lf->sp_die) != DW_TAG_subprogram)
+			return DWARF_CB_OK;
+
+		if (die_compare_name(&lf->sp_die, lr->function)) {
+			if (!dwarf_offdie(dbg, gl->cu_offset, &lf->cu_die))
+				return DWARF_CB_OK;
+
+			if (lr->file && !cu_find_realpath(&lf->cu_die, lr->file))
+				return DWARF_CB_OK;
+
+			lf->found = 1;
+			return DWARF_CB_ABORT;
+		}
+	}
+
+	return DWARF_CB_OK;
+}
+
 int find_line_range(int fd, struct line_range *lr)
 {
 	struct line_finder lf = {.lr = lr, .found = 0};
@@ -1895,6 +1919,19 @@ int find_line_range(int fd, struct line_range *lr)
 		return -EBADF;
 	}
 
+	/* Fastpath: lookup by function name from .debug_pubnames section */
+	if (lr->function) {
+		struct dwarf_callback_param param = {.data = (void *)&lf, .retval = 0};
+
+		dwarf_getpubnames(dbg, pubname_search_cb, &lf, 0);
+		if (lf.found) {
+			lf.found = 0;
+			line_range_search_cb(&lf.sp_die, &param);
+			if (lf.found)
+				goto found;
+		}
+	}
+
 	/* Loop on CUs (Compilation Unit) */
 	while (!lf.found && ret >= 0) {
 		if (dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL) != 0)
@@ -1923,6 +1960,7 @@ int find_line_range(int fd, struct line_range *lr)
 		off = noff;
 	}
 
+found:
 	/* Store comp_dir */
 	if (lf.found) {
 		comp_dir = cu_get_comp_dir(&lf.cu_die);
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index beaefc3..4bc56a4 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -83,6 +83,7 @@ struct line_finder {
 	int			lno_s;		/* Start line number */
 	int			lno_e;		/* End line number */
 	Dwarf_Die		cu_die;		/* Current CU */
+	Dwarf_Die		sp_die;
 	int			found;
 };
 
-- 
1.7.2.3

