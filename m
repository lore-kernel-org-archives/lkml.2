Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2KNHnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:43:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2KNHna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:43:30 -0500
Date: Tue, 13 Nov 2012 23:43:09 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-32ae1efd9d40645601cd4e09fa83a2711dd1ad6d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1352482044-3443-5-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Don'
 t try to follow jump target on PLT symbols
Git-Commit-ID: 32ae1efd9d40645601cd4e09fa83a2711dd1ad6d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:43:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32ae1efd9d40645601cd4e09fa83a2711dd1ad6d
Gitweb:     http://git.kernel.org/tip/32ae1efd9d40645601cd4e09fa83a2711dd1ad6d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Sat, 10 Nov 2012 02:27:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 9 Nov 2012 16:23:21 -0300

perf annotate: Don't try to follow jump target on PLT symbols

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
 1 files changed, 12 insertions(+), 0 deletions(-)

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
