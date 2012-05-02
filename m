Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2EBQ1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 12:27:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38522 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2EBQ1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 12:27:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Joerg Roedel <joro@8bytes.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf stat: Fix case where guest/host monitoring is not supported by kernel
Date: Wed,  2 May 2012 13:27:04 -0300
Message-Id: <1335976024-13067-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335976024-13067-1-git-send-email-acme@infradead.org>
References: <1335976024-13067-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

By default, perf stat sets exclude_guest = 1. But when you run perf on a
kernel which does not support  host/guest filtering, then you get an
error saying the event in unsupported. This comes from the fact that
when the perf_event_attr struct passed by the user is larger than the
one known to the kernel there is safety check which ensures that all
unknown bits are zero. But here, exclude_guest is 1 (part of the unknown
bits) and thus the perf_event_open() syscall return EINVAL.

To my surprise, running perf record on the same kernel did not exhibit
the problem. The reason is that perf record handles the problem by
catching the error and retrying with guest/host excludes set to zero.
For some reason, this was not done with perf stat. This patch fixes this
problem.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Link: http://lkml.kernel.org/r/20120427124538.GA7230@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c941bb6..4532a78 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -283,6 +283,8 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 {
 	struct perf_event_attr *attr = &evsel->attr;
 	struct xyarray *group_fd = NULL;
+	bool exclude_guest_missing = false;
+	int ret;
 
 	if (group && evsel != first)
 		group_fd = first->fd;
@@ -293,16 +295,39 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 
 	attr->inherit = !no_inherit;
 
-	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
+retry:
+	if (exclude_guest_missing)
+		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
+
+	if (system_wide) {
+		ret = perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
+		if (ret)
+			goto check_ret;
+		return 0;
+	}
+
 	if (!target_pid && !target_tid && (!group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, evsel_list->threads,
-					   group, group_fd);
+	ret = perf_evsel__open_per_thread(evsel, evsel_list->threads,
+					  group, group_fd);
+	if (!ret)
+		return 0;
+	/* fall through */
+check_ret:
+	if (ret && errno == EINVAL) {
+		if (!exclude_guest_missing &&
+		    (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
+			pr_debug("Old kernel, cannot exclude "
+				 "guest or host samples.\n");
+			exclude_guest_missing = true;
+			goto retry;
+		}
+	}
+	return ret;
 }
 
 /*
-- 
1.7.9.2.358.g22243

