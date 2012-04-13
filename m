Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2DMSJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:09:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51510 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2DMSJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:09:50 -0400
Date: Fri, 13 Apr 2012 11:09:12 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-44a7kl2atf9jxlg9npmotzdg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui annotate browser:
  Add list based search for addr offset
Git-Commit-ID: b0ffb2c48a924fdacb65a2320554ddc779a65eb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:09:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0ffb2c48a924fdacb65a2320554ddc779a65eb2
Gitweb:     http://git.kernel.org/tip/b0ffb2c48a924fdacb65a2320554ddc779a65eb2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 3 Apr 2012 15:32:45 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 7 Apr 2012 16:11:33 -0300

perf ui annotate browser: Add list based search for addr offset

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
 1 files changed, 16 insertions(+), 9 deletions(-)

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
