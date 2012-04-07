Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2DGUyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 16:54:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:46279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2DGUyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 16:54:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/8] perf ui annotate browser: Add list based search for addr offset
Date: Sat,  7 Apr 2012 17:54:06 -0300
Message-Id: <1333832049-2399-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333832049-2399-1-git-send-email-acme@infradead.org>
References: <1333832049-2399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

>From the hit sorted rb_tree, so that we can use it in the upcoming jump
instruction support.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-44a7kl2atf9jxlg9npmotzdg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index dbf8d3f..c52543c 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -157,17 +157,13 @@ static void objdump__insert_line(struct rb_root *self,
 }
 
 static void annotate_browser__set_top(struct annotate_browser *self,
-				      struct rb_node *nd)
+				      struct objdump_line *pos, u32 idx)
 {
-	struct objdump_line_rb_node *rbpos;
-	struct objdump_line *pos;
 	unsigned back;
 
 	ui_browser__refresh_dimensions(&self->b);
 	back = self->b.height / 2;
-	rbpos = rb_entry(nd, struct objdump_line_rb_node, rb_node);
-	pos = ((struct objdump_line *)rbpos) - 1;
-	self->b.top_idx = self->b.index = rbpos->idx;
+	self->b.top_idx = self->b.index = idx;
 
 	while (self->b.top_idx != 0 && back != 0) {
 		pos = list_entry(pos->node.prev, struct objdump_line, node);
@@ -177,7 +173,18 @@ static void annotate_browser__set_top(struct annotate_browser *self,
 	}
 
 	self->b.top = pos;
-	self->curr_hot = nd;
+}
+
+static void annotate_browser__set_rb_top(struct annotate_browser *browser,
+					 struct rb_node *nd)
+{
+	struct objdump_line_rb_node *rbpos;
+	struct objdump_line *pos;
+
+	rbpos = rb_entry(nd, struct objdump_line_rb_node, rb_node);
+	pos = ((struct objdump_line *)rbpos) - 1;
+	annotate_browser__set_top(browser, pos, rbpos->idx);
+	browser->curr_hot = nd;
 }
 
 static void annotate_browser__calc_percent(struct annotate_browser *browser,
@@ -308,7 +315,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 	annotate_browser__calc_percent(self, evidx);
 
 	if (self->curr_hot)
-		annotate_browser__set_top(self, self->curr_hot);
+		annotate_browser__set_rb_top(self, self->curr_hot);
 
 	nd = self->curr_hot;
 
@@ -382,7 +389,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		}
 
 		if (nd != NULL)
-			annotate_browser__set_top(self, nd);
+			annotate_browser__set_rb_top(self, nd);
 	}
 out:
 	ui_browser__hide(&self->b);
-- 
1.7.9.2.358.g22243

