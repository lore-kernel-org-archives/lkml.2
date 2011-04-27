Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab1D0QAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:00:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:59411 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759306Ab1D0QAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:00:50 -0400
Date: Wed, 27 Apr 2011 16:00:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-wlaw3dvz1ly6wple8l52cfca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Fail more clearly when an invalid modifier is specified
Git-Commit-ID: ceb53fbf6dbb1df26d38379a262c6981fe73dd36
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:00:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ceb53fbf6dbb1df26d38379a262c6981fe73dd36
Gitweb:     http://git.kernel.org/tip/ceb53fbf6dbb1df26d38379a262c6981fe73dd36
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 04:06:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:55 +0200

perf stat: Fail more clearly when an invalid modifier is specified

Currently we fail without printing any error message on "perf stat -e task-clock-msecs".

The reason is that the task-clock event is matched and the "-msecs" postfix is assumed
to be an event modifier - but is not recognized.

This patch changes the code to be more informative:

 $ perf stat -e task-clock-msecs true
 invalid event modifier: '-msecs'
 Run 'perf list' for a list of valid events and modifiers

And restructures the return value of parse_event_modifier() to allow
the printing of all variants of invalid event modifiers.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-wlaw3dvz1ly6wple8l52cfca@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 8e54bdb..b686269 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -721,15 +721,19 @@ parse_numeric_event(const char **strp, struct perf_event_attr *attr)
 	return EVT_FAILED;
 }
 
-static enum event_result
+static int
 parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
 	int exclude = 0;
 	int eu = 0, ek = 0, eh = 0, precise = 0;
 
-	if (*str++ != ':')
+	if (!*str)
 		return 0;
+
+	if (*str++ != ':')
+		return -1;
+
 	while (*str) {
 		if (*str == 'u') {
 			if (!exclude)
@@ -750,14 +754,16 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 
 		++str;
 	}
-	if (str >= *strp + 2) {
-		*strp = str;
-		attr->exclude_user   = eu;
-		attr->exclude_kernel = ek;
-		attr->exclude_hv     = eh;
-		attr->precise_ip     = precise;
-		return 1;
-	}
+	if (str < *strp + 2)
+		return -1;
+
+	*strp = str;
+
+	attr->exclude_user   = eu;
+	attr->exclude_kernel = ek;
+	attr->exclude_hv     = eh;
+	attr->precise_ip     = precise;
+
 	return 0;
 }
 
@@ -800,7 +806,12 @@ parse_event_symbols(const struct option *opt, const char **str,
 	return EVT_FAILED;
 
 modifier:
-	parse_event_modifier(str, attr);
+	if (parse_event_modifier(str, attr) < 0) {
+		fprintf(stderr, "invalid event modifier: '%s'\n", *str);
+		fprintf(stderr, "Run 'perf list' for a list of valid events and modifiers\n");
+
+		return EVT_FAILED;
+	}
 
 	return ret;
 }
