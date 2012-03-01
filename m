Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2CARZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:25:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:60886 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab2CARZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:25:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf evlist: Return first evsel for non-sample event on old kernel
Date: Thu,  1 Mar 2012 14:25:25 -0300
Message-Id: <1330622728-12759-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1330622728-12759-1-git-send-email-acme@infradead.org>
References: <1330622728-12759-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

On old kernels that don't support sample_id_all feature,
perf_evlist__id2evsel() returns NULL for non-sampling events.

This breaks perf top when multiple events are given on command line. Fix
it by using first evsel in the evlist. This will also prevent getting
the same (potential) problem in such new tool/ old kernel combo.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1329702447-25045-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3f16e08..ea32a06 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -349,6 +349,10 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	hlist_for_each_entry(sid, pos, head, node)
 		if (sid->id == id)
 			return sid->evsel;
+
+	if (!perf_evlist__sample_id_all(evlist))
+		return list_entry(evlist->entries.next, struct perf_evsel, node);
+
 	return NULL;
 }
 
-- 
1.7.9.123.g65da0

