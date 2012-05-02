Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab2EBRos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:44:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab2EBRoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:44:46 -0400
Date: Wed, 2 May 2012 10:44:06 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-5622c07b4741e0afd7607bce6e850b76eeb23210@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org, joro@8bytes.org,
        gleb@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, joro@8bytes.org,
        peterz@infradead.org, gleb@redhat.com, robert.richter@amd.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120427124538.GA7230@quad>
References: <20120427124538.GA7230@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat: Fix case where guest/
 host monitoring is not supported by kernel
Git-Commit-ID: 5622c07b4741e0afd7607bce6e850b76eeb23210
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 02 May 2012 10:44:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5622c07b4741e0afd7607bce6e850b76eeb23210
Gitweb:     http://git.kernel.org/tip/5622c07b4741e0afd7607bce6e850b76eeb23210
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 27 Apr 2012 14:45:38 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 1 May 2012 14:20:00 -0300

perf stat: Fix case where guest/host monitoring is not supported by kernel

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
 1 files changed, 29 insertions(+), 4 deletions(-)

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
