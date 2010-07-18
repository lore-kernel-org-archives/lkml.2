Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193Ab0GRBtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 21:49:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:39255 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab0GRBtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 21:49:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf hists: Factor out duplicated code
Date: Sat, 17 Jul 2010 22:48:56 -0300
Message-Id: <1279417736-4396-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1279417736-4396-1-git-send-email-acme@infradead.org>
References: <1279417736-4396-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Introducing hists__remove_entry_filter.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 68d288c..7b5848c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -795,6 +795,21 @@ enum hist_filter {
 	HIST_FILTER__THREAD,
 };
 
+static void hists__remove_entry_filter(struct hists *self, struct hist_entry *h,
+				       enum hist_filter filter)
+{
+	h->filtered &= ~(1 << filter);
+	if (h->filtered)
+		return;
+
+	++self->nr_entries;
+	self->stats.total_period += h->period;
+	self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
+
+	if (h->ms.sym && self->max_sym_namelen < h->ms.sym->namelen)
+		self->max_sym_namelen = h->ms.sym->namelen;
+}
+
 void hists__filter_by_dso(struct hists *self, const struct dso *dso)
 {
 	struct rb_node *nd;
@@ -814,15 +829,7 @@ void hists__filter_by_dso(struct hists *self, const struct dso *dso)
 			continue;
 		}
 
-		h->filtered &= ~(1 << HIST_FILTER__DSO);
-		if (!h->filtered) {
-			++self->nr_entries;
-			self->stats.total_period += h->period;
-			self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
-			if (h->ms.sym &&
-			    self->max_sym_namelen < h->ms.sym->namelen)
-				self->max_sym_namelen = h->ms.sym->namelen;
-		}
+		hists__remove_entry_filter(self, h, HIST_FILTER__DSO);
 	}
 }
 
@@ -841,15 +848,8 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread)
 			h->filtered |= (1 << HIST_FILTER__THREAD);
 			continue;
 		}
-		h->filtered &= ~(1 << HIST_FILTER__THREAD);
-		if (!h->filtered) {
-			++self->nr_entries;
-			self->stats.total_period += h->period;
-			self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
-			if (h->ms.sym &&
-			    self->max_sym_namelen < h->ms.sym->namelen)
-				self->max_sym_namelen = h->ms.sym->namelen;
-		}
+
+		hists__remove_entry_filter(self, h, HIST_FILTER__THREAD);
 	}
 }
 
-- 
1.6.2.5

