Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab2DNREK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 13:04:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:36451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2DNREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 13:04:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] perf session: Skip event correctly for unknown id/machine
Date: Sat, 14 Apr 2012 14:03:43 -0300
Message-Id: <1334423027-2220-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334423027-2220-1-git-send-email-acme@infradead.org>
References: <1334423027-2220-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

In case the perf_session__process_event function fails, we estimate the
next event offset.

This is not necessary for sample event failing on unknown ID or machine.
In such case we know proper size of the event, so we dont need to guess.
Also failure statistics are updated correctly so we don't miss any
information.

Forcing perf_session__process_event to return 0 in case of unknown ID or
machine.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1334233262-5679-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 00923cd..1efd3be 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -876,11 +876,11 @@ static int perf_session_deliver_event(struct perf_session *session,
 		dump_sample(session, event, sample);
 		if (evsel == NULL) {
 			++session->hists.stats.nr_unknown_id;
-			return -1;
+			return 0;
 		}
 		if (machine == NULL) {
 			++session->hists.stats.nr_unprocessable_samples;
-			return -1;
+			return 0;
 		}
 		return tool->sample(tool, event, sample, evsel, machine);
 	case PERF_RECORD_MMAP:
-- 
1.7.9.2.358.g22243

