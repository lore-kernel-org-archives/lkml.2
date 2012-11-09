Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2KIR2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:28:55 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52364 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab2KIR2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:28:50 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 04/13] perf annotate: Don't try to follow jump target on PLT symbols
Date: Sat, 10 Nov 2012 02:27:15 +0900
Message-Id: <1352482044-3443-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/ui/browsers/annotate.c |   12 ++++++++++++
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
1.7.9.2

