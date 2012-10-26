Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab2JZUfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:35:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:22135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759089Ab2JZUa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,656,1344236400"; 
   d="scan'208";a="233093568"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 24/33] perf, tools: Move parse_events error printing to parse_events_options
Date: Fri, 26 Oct 2012 13:30:06 -0700
Message-Id: <1351283415-13170-25-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The callers of parse_events usually have their own error handling.
Move the fprintf for a bad event to parse_events_options, which
is the only one who should need it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/parse-events.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 75c7b0f..409da3e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -827,8 +827,6 @@ int parse_events(struct perf_evlist *evlist, const char *str,
 	 * Both call perf_evlist__delete in case of error, so we dont
 	 * need to bother.
 	 */
-	fprintf(stderr, "invalid or unsupported event: '%s'\n", str);
-	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
 	return ret;
 }
 
@@ -836,7 +834,13 @@ int parse_events_option(const struct option *opt, const char *str,
 			int unset __maybe_unused)
 {
 	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
-	return parse_events(evlist, str, unset);
+	int ret = parse_events(evlist, str, unset);
+
+	if (ret) {
+		fprintf(stderr, "invalid or unsupported event: '%s'\n", str);
+		fprintf(stderr, "Run 'perf list' for a list of valid events\n");
+	}
+	return ret;
 }
 
 int parse_filter(const struct option *opt, const char *str,
-- 
1.7.7.6

