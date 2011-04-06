Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1DFLAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:00:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1DFLAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:00:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] perf probe: Fix to ensure function declared file
Date: Wed,  6 Apr 2011 08:00:19 -0300
Message-Id: <1302087623-14724-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1302087623-14724-1-git-send-email-acme@infradead.org>
References: <1302087623-14724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix to ensure function declared file matches given file name. This fixes
a potential bug.

As I've commented on Lin Ming's fastpath enhancement, decl_file should
be checked on each probe point if user gives a probe point as func@file.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110330092541.2132.3584.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 194f9e2..3bcd140 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1395,6 +1395,10 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 	    !die_compare_name(sp_die, pp->function))
 		return DWARF_CB_OK;
 
+	/* Check declared file */
+	if (pp->file && strtailcmp(pp->file, dwarf_decl_file(sp_die)))
+		return DWARF_CB_OK;
+
 	pf->fname = dwarf_decl_file(sp_die);
 	if (pp->line) { /* Function relative line */
 		dwarf_decl_line(sp_die, &pf->lno);
@@ -1840,6 +1844,10 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 	struct line_finder *lf = param->data;
 	struct line_range *lr = lf->lr;
 
+	/* Check declared file */
+	if (lr->file && strtailcmp(lr->file, dwarf_decl_file(sp_die)))
+		return DWARF_CB_OK;
+
 	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
 	    die_compare_name(sp_die, lr->function)) {
 		lf->fname = dwarf_decl_file(sp_die);
-- 
1.6.2.5

