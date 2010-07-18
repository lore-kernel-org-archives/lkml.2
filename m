Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0GRKex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 06:34:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:34752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab0GRKes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 06:34:48 -0400
Date: Sun, 18 Jul 2010 10:34:22 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Factor out duplicated code
Message-ID: <tip-cc5edb0eb9ce892b530e34a5d110382483587942@git.kernel.org>
Git-Commit-ID: cc5edb0eb9ce892b530e34a5d110382483587942
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 18 Jul 2010 10:34:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc5edb0eb9ce892b530e34a5d110382483587942
Gitweb:     http://git.kernel.org/tip/cc5edb0eb9ce892b530e34a5d110382483587942
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 16 Jul 2010 12:35:07 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 17 Jul 2010 15:45:55 -0300

perf hists: Factor out duplicated code

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
 
