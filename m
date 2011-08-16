Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1HPOmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:42:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:34132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1HPOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:41:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/6] perf evlist: Fix missing event name init for default event (v2)
Date: Tue, 16 Aug 2011 11:41:31 -0300
Message-Id: <1313505695-20724-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313505695-20724-1-git-send-email-acme@infradead.org>
References: <1313505695-20724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

When no event is given to perf record, perf top, a default event is
initialized (cycles). However, perf_evlist__add_default() was not
setting the symbolic name for the event. Perf top worked simply because
it was reconstructing the name from the event code. But it should not
have to do this. This patch initializes the evsel->name field properly.

This second version improves the code flow on the non error path.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20110607161936.GA8163@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
[committer note: Use perf_evsel__delete() instead of plain free()]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index e03e7bc..c12bd47 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -85,10 +85,19 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 	struct perf_evsel *evsel = perf_evsel__new(&attr, 0);
 
 	if (evsel == NULL)
-		return -ENOMEM;
+		goto error;
+
+	/* use strdup() because free(evsel) assumes name is allocated */
+	evsel->name = strdup("cycles");
+	if (!evsel->name)
+		goto error_free;
 
 	perf_evlist__add(evlist, evsel);
 	return 0;
+error_free:
+	perf_evsel__delete(evsel);
+error:
+	return -ENOMEM;
 }
 
 void perf_evlist__disable(struct perf_evlist *evlist)
-- 
1.6.2.5

