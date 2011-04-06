Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1DFLNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:13:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:42857 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab1DFLNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:13:15 -0400
Date: Wed, 6 Apr 2011 11:12:52 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        peterz@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110330092541.2132.3584.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092541.2132.3584.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix to ensure function declared file
Message-ID: <tip-7d21635ac5c78abe162fb3f56b37c30bcbfa019f@git.kernel.org>
Git-Commit-ID: 7d21635ac5c78abe162fb3f56b37c30bcbfa019f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 06 Apr 2011 11:12:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d21635ac5c78abe162fb3f56b37c30bcbfa019f
Gitweb:     http://git.kernel.org/tip/7d21635ac5c78abe162fb3f56b37c30bcbfa019f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 30 Mar 2011 18:25:41 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 5 Apr 2011 15:34:53 -0300

perf probe: Fix to ensure function declared file

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
