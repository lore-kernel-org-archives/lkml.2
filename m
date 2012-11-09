Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2KIBKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 20:10:44 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56025 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2KIBKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 20:10:41 -0500
X-AuditID: 9c93016f-b7bccae000000e33-78-509c580da6d4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/3] perf annotate: Don't try to follow jump target on PLT symbols
Date: Fri,  9 Nov 2012 10:10:12 +0900
Message-Id: <1352423412-4895-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352423412-4895-1-git-send-email-namhyung@kernel.org>
References: <1352423412-4895-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf annotate browser on TUI can identify a jump target for a
selected instruction.  It assumes that the jump target is within the
function but it's not the case of PLT symbols which have offset out of
the function as a target.  Since it caused a segmentation fault, do
not try to follow jump target on the PLT symbols.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/annotate.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index aec11f34d394..bb393dd26ba2 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -190,6 +190,12 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	struct disasm_line *cursor = ab->selection, *target;
 	struct browser_disasm_line *btarget, *bcursor;
 	unsigned int from, to;
+	struct map_symbol *ms = ab->b.priv;
+	struct symbol *sym = ms->sym;
+
+	/* PLT symbols contain external offsets */
+	if (strstr(sym->name, "@plt"))
+		return;
 
 	if (!cursor || !cursor->ins || !ins__is_jump(cursor->ins) ||
 	    !disasm_line__has_offset(cursor))
@@ -773,6 +779,12 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
 						size_t size)
 {
 	u64 offset;
+	struct map_symbol *ms = browser->b.priv;
+	struct symbol *sym = ms->sym;
+
+	/* PLT symbols contain external offsets */
+	if (strstr(sym->name, "@plt"))
+		return;
 
 	for (offset = 0; offset < size; ++offset) {
 		struct disasm_line *dl = browser->offsets[offset], *dlt;
-- 
1.7.11.7

