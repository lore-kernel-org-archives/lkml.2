Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab1CXIjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:39:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:26317 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933710Ab1CXIjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:39:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,236,1299484800"; 
   d="scan'208";a="901014981"
Subject: Re: [PATCH] perf probe: Add fastpath to do lookup by function name
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110324075830.GA28885@elte.hu>
References: <1300981134-7333-1-git-send-email-ming.m.lin@intel.com>
	 <20110324075830.GA28885@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 16:38:43 +0800
Message-ID: <1300955923.14111.29.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 15:58 +0800, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > The vmlinux file may have thousands of CUs.
> > We can lookup function name from .debug_pubnames section
> > to avoid the slow loop on CUs.
> 
> Mind including before/after perf stat --repeat 10 results in the changelog, of 
> an affected command which got faster?


>From 611a823a34e655d47a80f92994b004391e2b244c Mon Sep 17 00:00:00 2001
From: Lin Ming <ming.m.lin@intel.com>
Date: Thu, 24 Mar 2011 23:22:24 +0800
Subject: [PATCH] perf probe: Add fastpath to do lookup by function name

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



