Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1HRULW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:11:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:46770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1HRULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:11:21 -0400
Date: Thu, 18 Aug 2011 20:10:41 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-cc2d86b04d9ac28a6be6cb05da6ea8f014fd5aa0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110607161936.GA8163@quad>
References: <20110607161936.GA8163@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Fix missing event name init for default event
Git-Commit-ID: cc2d86b04d9ac28a6be6cb05da6ea8f014fd5aa0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Thu, 18 Aug 2011 20:10:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc2d86b04d9ac28a6be6cb05da6ea8f014fd5aa0
Gitweb:     http://git.kernel.org/tip/cc2d86b04d9ac28a6be6cb05da6ea8f014fd5aa0
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 7 Jun 2011 18:19:36 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 18 Aug 2011 07:20:31 -0300

perf evlist: Fix missing event name init for default event

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
