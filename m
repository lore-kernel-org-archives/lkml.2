Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1C3Jc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:32:29 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51483 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab1C3Jc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:32:27 -0400
X-AuditID: b753bd60-a64bdba000004916-34-4d92f8a866e3
X-AuditID: b753bd60-a64bdba000004916-34-4d92f8a866e3
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 01/12] [BUGFIX]perf probe: Fix to ensure function
	declared file
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Mar 2011 18:25:41 +0900
Message-ID: <20110330092541.2132.3584.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to ensure function declared file matches given file
name. This fixes a potential bug.
As I've commented on Lin Ming's fastpath enhancement, decl_file
should be checked on each probe point if user gives a
probe point as func@file.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/util/probe-finder.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 23fc9eb..30915bb 100644
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
@@ -1891,6 +1895,10 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 	struct line_finder *lf = param->data;
 	struct line_range *lr = lf->lr;
 
+	/* Check declared file */
+	if (lr->file && strtailcmp(lr->file, dwarf_decl_file(sp_die)))
+		return DWARF_CB_OK;
+
 	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
 	    die_compare_name(sp_die, lr->function)) {
 		lf->fname = dwarf_decl_file(sp_die);

