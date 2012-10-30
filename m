Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2J3L7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 07:59:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40778 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2J3L7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 07:59:40 -0400
Date: Tue, 30 Oct 2012 04:58:58 -0700
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-9175ce1f1244edd9f4d39605aa06ce5b0a50b8e0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        jolsa@redhat.com, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        ak@linux.intel.com, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1351283415-13170-25-git-send-email-andi@firstfloor.org>
References: <1351283415-13170-25-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move parse_events error printing to parse_events_options
Git-Commit-ID: 9175ce1f1244edd9f4d39605aa06ce5b0a50b8e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 04:59:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9175ce1f1244edd9f4d39605aa06ce5b0a50b8e0
Gitweb:     http://git.kernel.org/tip/9175ce1f1244edd9f4d39605aa06ce5b0a50b8e0
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 26 Oct 2012 13:30:06 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 28 Oct 2012 11:29:52 -0200

perf tools: Move parse_events error printing to parse_events_options

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
 1 files changed, 7 insertions(+), 3 deletions(-)

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
