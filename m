Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0HBHue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:50:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:60255 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab0HBHuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:50:32 -0400
Date: Mon, 2 Aug 2010 07:49:49 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hist: Introduce routine to measure lenght of formatted entry
Message-ID: <tip-06daaaba7c211ca6a8227b9a54dbc86dd837f034@git.kernel.org>
Git-Commit-ID: 06daaaba7c211ca6a8227b9a54dbc86dd837f034
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 07:49:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06daaaba7c211ca6a8227b9a54dbc86dd837f034
Gitweb:     http://git.kernel.org/tip/06daaaba7c211ca6a8227b9a54dbc86dd837f034
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 21 Jul 2010 17:58:25 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 27 Jul 2010 11:24:31 -0300

perf hist: Introduce routine to measure lenght of formatted entry

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
