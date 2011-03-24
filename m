Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab1CXOJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:09:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:16023 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab1CXOJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,237,1299484800"; 
   d="scan'208";a="724310546"
Subject: [PATCH v2 -tip] perf probe: Add fastpath to do lookup by function
 name
From: Lin Ming <ming.m.lin@intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1300974448.2283.17.camel@localhost>
References: <1300981134-7333-1-git-send-email-ming.m.lin@intel.com>
	 <4D8B0A13.8000008@hitachi.com>  <1300974448.2283.17.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 22:09:13 +0800
Message-Id: <1300975753.2283.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 -> v1:
- Don't compare file names with cu_find_realpath(...), instead, compare them
  with the name returned by dwarf_decl_file(sp_die) 

The vmlinux file may have thousands of CUs.
We can lookup function name from .debug_pubnames section
to avoid the slow loop on CUs.

./perf stat -r 10 -- ./perf probe -k /home/mlin/vmlinux \
        -s /home/mlin/linux-2.6 \
	--line csum_partial_copy_to_user > tmp.log

before patch applied
=====================
        364.535892 task-clock-msecs         #      0.997 CPUs
                 0 context-switches         #      0.000 M/sec
                 0 CPU-migrations           #      0.000 M/sec
            29,993 page-faults              #      0.082 M/sec
       865,862,109 cycles                   #   2375.245 M/sec
     1,255,259,630 instructions             #      1.450 IPC
       252,400,884 branches                 #    692.390 M/sec
         3,429,376 branch-misses            #      1.359 %
         1,386,990 cache-references         #      3.805 M/sec
           687,188 cache-misses             #      1.885 M/sec

        0.365792170  seconds time elapsed

after patch applied
=====================
         89.896405 task-clock-msecs         #      0.991 CPUs
                 1 context-switches         #      0.000 M/sec
                 0 CPU-migrations           #      0.000 M/sec
            10,145 page-faults              #      0.113 M/sec
       214,553,875 cycles                   #   2386.679 M/sec
       226,915,559 instructions             #      1.058 IPC
        44,536,614 branches                 #    495.422 M/sec
           613,074 branch-misses            #      1.377 %
           860,787 cache-references         #      9.575 M/sec
           442,380 cache-misses             #      4.921 M/sec

        0.090716032  seconds time elapsed

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/util/probe-finder.c |   39 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-finder.h |    1 +
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 194f9e2..5cf044c 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1876,6 +1876,31 @@ static int find_line_range_by_func(struct line_finder *lf)
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
+			if (lr->file &&
+			    strtailcmp(lr->file, dwarf_decl_file(&lf->sp_die)))
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
@@ -1895,6 +1920,19 @@ int find_line_range(int fd, struct line_range *lr)
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
@@ -1923,6 +1961,7 @@ int find_line_range(int fd, struct line_range *lr)
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



