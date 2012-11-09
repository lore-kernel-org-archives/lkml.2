Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2KIVrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:47:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48169 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab2KIVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/21] perf annotate: Don't try to follow jump target on PLT symbols
Date: Fri,  9 Nov 2012 18:43:04 -0300
Message-Id: <1352497390-17716-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf annotate browser on TUI can identify a jump target for a
selected instruction.  It assumes that the jump target is within the
function but it's not the case of PLT symbols which have offset out of
the function as a target.

Since it caused a segmentation fault, do not try to follow jump target
on the PLT symbols.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1352482044-3443-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 3eff17f..5dab3ca 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -188,6 +188,12 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
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
@@ -771,6 +777,12 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
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
1.7.9.2.358.g22243

