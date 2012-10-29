Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab2J2PJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:09:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34781 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2J2PJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:09:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/14] perf tools: Move parse_events error printing to parse_events_options
Date: Mon, 29 Oct 2012 13:09:00 -0200
Message-Id: <1351523353-27982-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351523353-27982-1-git-send-email-acme@infradead.org>
References: <1351523353-27982-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The callers of parse_events usually have their own error handling.  Move
the fprintf for a bad event to parse_events_options, which is the only
one who should need it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1351283415-13170-25-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3a3efcf..c0b785b 100644
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
1.7.9.2.358.g22243

