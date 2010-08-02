Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab0HBBJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:09:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37994 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0HBBJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/19] perf hist: Introduce routine to measure lenght of formatted entry
Date: Sun,  1 Aug 2010 22:08:39 -0300
Message-Id: <1280711334-30000-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used to figure out the window width needed in the new tree
widget.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   27 +++++++++++++++++++++++++++
 tools/perf/util/hist.h |    3 +++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 0bc6790..f93095f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -850,6 +850,33 @@ print_entries:
 	return ret;
 }
 
+/*
+ * See hists__fprintf to match the column widths
+ */
+unsigned int hists__sort_list_width(struct hists *self)
+{
+	struct sort_entry *se;
+	int ret = 9; /* total % */
+
+	if (symbol_conf.show_cpu_utilization) {
+		ret += 7; /* count_sys % */
+		ret += 6; /* count_us % */
+		if (perf_guest) {
+			ret += 13; /* count_guest_sys % */
+			ret += 12; /* count_guest_us % */
+		}
+	}
+
+	if (symbol_conf.show_nr_samples)
+		ret += 11;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list)
+		if (!se->elide)
+			ret += 2 + hists__col_len(self, se->se_width_idx);
+
+	return ret;
+}
+
 static void hists__remove_entry_filter(struct hists *self, struct hist_entry *h,
 				       enum hist_filter filter)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 92962b2..65a48db 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -141,4 +141,7 @@ int hist_entry__tui_annotate(struct hist_entry *self);
 
 int hists__tui_browse_tree(struct rb_root *self, const char *help);
 #endif
+
+unsigned int hists__sort_list_width(struct hists *self);
+
 #endif	/* __PERF_HIST_H */
-- 
1.6.2.5

