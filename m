Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1JTNGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:06:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:43252 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab1JTNGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:06:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf hists: Don't decay total_period for filtered entries
Date: Thu, 20 Oct 2011 11:05:46 -0200
Message-Id: <1319115948-12060-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319115948-12060-1-git-send-email-acme@infradead.org>
References: <1319115948-12060-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Following the 'perf report' model we don't zap hist_entry instances from
the rb tree, we just keep them with he->filtered set to a mask of the
filters applied to it (thread, parent, DSO so far).

In top we need to decay even filtered entries, but we better not touch
total_period for them...

Now everything seems to work when filters are applied on top as they
worked in 'report', i.e. both dynamic and static hist entry browsing
works with filters.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-yt4xsbq20u9x9ypuwwyw2kao@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 75526d1..1f269fd 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -105,11 +105,16 @@ static void hist_entry__decay(struct hist_entry *he)
 
 static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 {
-	if (he->period == 0)
+	u64 prev_period = he->period;
+
+	if (prev_period == 0)
 		return true;
-	hists->stats.total_period -= he->period;
+
 	hist_entry__decay(he);
-	hists->stats.total_period += he->period;
+
+	if (!he->filtered)
+		hists->stats.total_period -= prev_period - he->period;
+
 	return he->period == 0;
 }
 
-- 
1.6.2.5

