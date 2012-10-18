Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab2JRXY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:24:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:4639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab2JRXT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:19:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,609,1344236400"; 
   d="scan'208";a="229462628"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 25/34] perf, tools: Move parse_events error printing to parse_events_options
Date: Thu, 18 Oct 2012 16:19:33 -0700
Message-Id: <1350602382-12771-26-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
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
index aed38e4..401b088 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -824,8 +824,6 @@ int parse_events(struct perf_evlist *evlist, const char *str,
 	 * Both call perf_evlist__delete in case of error, so we dont
 	 * need to bother.
 	 */
-	fprintf(stderr, "invalid or unsupported event: '%s'\n", str);
-	fprintf(stderr, "Run 'perf list' for a list of valid events\n");
 	return ret;
 }
 
@@ -833,7 +831,13 @@ int parse_events_option(const struct option *opt, const char *str,
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

