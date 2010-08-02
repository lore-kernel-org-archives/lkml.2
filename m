Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0HBBJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:09:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:51007 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0HBBJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:18 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/19] perf hists: Mark entries filtered by parent
Date: Sun,  1 Aug 2010 22:08:36 -0300
Message-Id: <1280711334-30000-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And don't consider them in hists__inc_nr_entries.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 7b5848c..d998d1d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -5,6 +5,12 @@
 #include "sort.h"
 #include <math.h>
 
+enum hist_filter {
+	HIST_FILTER__DSO,
+	HIST_FILTER__THREAD,
+	HIST_FILTER__PARENT,
+};
+
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
 	.min_percent = 0.5
@@ -52,11 +58,20 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 static void hists__inc_nr_entries(struct hists *self, struct hist_entry *entry)
 {
+	if (entry->filtered)
+		return;
 	if (entry->ms.sym && self->max_sym_namelen < entry->ms.sym->namelen)
 		self->max_sym_namelen = entry->ms.sym->namelen;
 	++self->nr_entries;
 }
 
+static u8 symbol__parent_filter(const struct symbol *parent)
+{
+	if (symbol_conf.exclude_other && parent == NULL)
+		return 1 << HIST_FILTER__PARENT;
+	return 0;
+}
+
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *sym_parent, u64 period)
@@ -75,6 +90,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		.level	= al->level,
 		.period	= period,
 		.parent = sym_parent,
+		.filtered = symbol__parent_filter(sym_parent),
 	};
 	int cmp;
 
@@ -790,11 +806,6 @@ print_entries:
 	return ret;
 }
 
-enum hist_filter {
-	HIST_FILTER__DSO,
-	HIST_FILTER__THREAD,
-};
-
 static void hists__remove_entry_filter(struct hists *self, struct hist_entry *h,
 				       enum hist_filter filter)
 {
-- 
1.6.2.5

