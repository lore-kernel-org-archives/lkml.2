Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2EKASB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:18:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:46275 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab2EKASA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:18:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98756298"
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, utils: Print the original modifiers in event_name
Date: Thu, 10 May 2012 17:17:48 -0700
Message-Id: <1336695468-5464-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

We need to save the original string for perf stat output,
otherwise :t and :c are invisible.

This used to work, but broke with the parser refactoring.

Not sure if this is the best fix.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/parse-events.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 14fa682..cc561c2 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -810,6 +810,7 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 	LIST_HEAD(list_tmp);
 	YY_BUFFER_STATE buffer;
 	int ret, idx = evlist->nr_entries;
+	struct perf_evsel *evsel;
 
 	buffer = parse_events__scan_string(str);
 
@@ -818,6 +819,10 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 	parse_events__flush_buffer(buffer);
 	parse_events__delete_buffer(buffer);
 
+	/* XXX right thing for multiple events? Do all callers free? */
+	list_for_each_entry(evsel, &list, node)
+		evsel->name = strdup(str);
+
 	if (!ret) {
 		int entries = idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &list, entries);
-- 
1.7.7.6

