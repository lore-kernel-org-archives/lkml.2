Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2DEX34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:29:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:54142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab2DEX3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:29:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/5] perf annotate: Fix hist decay
Date: Thu,  5 Apr 2012 20:28:49 -0300
Message-Id: <1333668532-3624-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333668532-3624-1-git-send-email-acme@infradead.org>
References: <1333668532-3624-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were only decaying the entries for the offsets that were associated
with an objdump line.

That way, when we accrued the whole instruction addr range, more than
100% was appearing in some cases in the live annotation TUI.

Fix it by not traversing the source code line at all, just iterate thru
the complete addr range decaying each one.

Reported-by: Mike Galbraith <mgalbraith@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-hcae5oxa22syjrnalsxz7s6n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 199f69e..70f5a4d 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -561,16 +561,12 @@ void symbol__annotate_decay_histogram(struct symbol *sym, int evidx)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
-	struct objdump_line *pos;
-	int len = sym->end - sym->start;
+	int len = sym->end - sym->start, offset;
 
 	h->sum = 0;
-
-	list_for_each_entry(pos, &notes->src->source, node) {
-		if (pos->offset != -1 && pos->offset < len) {
-			h->addr[pos->offset] = h->addr[pos->offset] * 7 / 8;
-			h->sum += h->addr[pos->offset];
-		}
+	for (offset = 0; offset < len; ++offset) {
+		h->addr[offset] = h->addr[offset] * 7 / 8;
+		h->sum += h->addr[offset];
 	}
 }
 
-- 
1.7.9.2.358.g22243

