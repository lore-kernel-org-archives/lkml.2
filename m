Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab2EKG0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:26:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56971 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab2EKGZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:25:59 -0400
Date: Thu, 10 May 2012 23:25:29 -0700
From: tip-bot for Ulrich Drepper <drepper@akkadia.org>
Message-ID: <tip-f3054c778e367d624ca0dfe68b8498b5c463a9d1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, robert.richter@amd.com, drepper@gmail.com,
        drepper@akkadia.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, robert.richter@amd.com, drepper@gmail.com,
        dsahern@gmail.com, drepper@akkadia.org, tglx@linutronix.de
In-Reply-To: <201204231304.q3ND4TFe020805@drepperk.user.openhosting.com>
References: <201204231304.q3ND4TFe020805@drepperk.user.openhosting.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Cleanup realloc use
Git-Commit-ID: f3054c778e367d624ca0dfe68b8498b5c463a9d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:25:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3054c778e367d624ca0dfe68b8498b5c463a9d1
Gitweb:     http://git.kernel.org/tip/f3054c778e367d624ca0dfe68b8498b5c463a9d1
Author:     Ulrich Drepper <drepper@akkadia.org>
AuthorDate: Mon, 23 Apr 2012 09:04:29 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 23 Apr 2012 15:33:05 -0300

perf tools: Cleanup realloc use

The if branch is completely unnecessary since 'realloc' handles NULL
pointers for the first parameter.

This is really only a cleanup and submitted mainly to prevent
proliferation of bad practices.

Signed-off-by: Ulrich Drepper <drepper@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/201204231304.q3ND4TFe020805@drepperk.user.openhosting.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c7c2d7..6e618ba 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -31,21 +31,16 @@ static const char **header_argv;
 
 int perf_header__push_event(u64 id, const char *name)
 {
+	struct perf_trace_event_type *nevents;
+
 	if (strlen(name) > MAX_EVENT_NAME)
 		pr_warning("Event %s will be truncated\n", name);
 
-	if (!events) {
-		events = malloc(sizeof(struct perf_trace_event_type));
-		if (events == NULL)
-			return -ENOMEM;
-	} else {
-		struct perf_trace_event_type *nevents;
+	nevents = realloc(events, (event_count + 1) * sizeof(*events));
+	if (nevents == NULL)
+		return -ENOMEM;
+	events = nevents;
 
-		nevents = realloc(events, (event_count + 1) * sizeof(*events));
-		if (nevents == NULL)
-			return -ENOMEM;
-		events = nevents;
-	}
 	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
 	events[event_count].event_id = id;
 	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
