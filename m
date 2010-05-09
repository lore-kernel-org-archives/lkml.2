Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0EIQPP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 12:15:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43565 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0EIQPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 12:15:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/3] perf report: Fix leak of resolved callchains array on error path
Date: Sun,  9 May 2010 13:14:56 -0300
Message-Id: <1273421697-30138-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273421697-30138-1-git-send-email-acme@infradead.org>
References: <1273421697-30138-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1cae877..3a70c58 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -83,7 +83,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	struct map_symbol *syms = NULL;
 	struct symbol *parent = NULL;
 	bool hit;
-	int err;
+	int err = -ENOMEM;
 	struct hist_entry *he;
 	struct event_stat_id *stats;
 	struct perf_event_attr *attr;
@@ -101,26 +101,24 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	else
 		stats = get_stats(self, data->id, 0, 0);
 	if (stats == NULL)
-		return -ENOMEM;
+		goto out_free_syms;
 	he = __perf_session__add_hist_entry(&stats->hists, al, parent,
 					    data->period, &hit);
 	if (he == NULL)
-		return -ENOMEM;
+		goto out_free_syms;
 
 	if (hit)
 		__perf_session__add_count(he, al,  data->period);
 
+	err = 0;
 	if (symbol_conf.use_callchain) {
 		if (!hit)
 			callchain_init(he->callchain);
 		err = append_chain(he->callchain, data->callchain, syms);
-		free(syms);
-
-		if (err)
-			return err;
 	}
-
-	return 0;
+out_free_syms:
+	free(syms);
+	return err;
 }
 
 static int add_event_total(struct perf_session *session,
-- 
1.6.2.5

