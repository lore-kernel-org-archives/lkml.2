Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1HRULf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:11:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:46778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab1HRULd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:11:33 -0400
Date: Thu, 18 Aug 2011 20:11:17 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-777d1d71db622a5e1ff703495741c3d257b532e5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110723021043.GA20178@quad>
References: <20110723021043.GA20178@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix error handling of unknown events
Git-Commit-ID: 777d1d71db622a5e1ff703495741c3d257b532e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Thu, 18 Aug 2011 20:11:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  777d1d71db622a5e1ff703495741c3d257b532e5
Gitweb:     http://git.kernel.org/tip/777d1d71db622a5e1ff703495741c3d257b532e5
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Sat, 23 Jul 2011 04:10:43 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 18 Aug 2011 07:21:13 -0300

perf tools: Fix error handling of unknown events

There was a problem with the parse_events() code not printing the
correct event name when an event was unknown and starting with an 'r'.
The source of the problem was the way raw notation was parsed.

Without the patch:
	$ perf stat -e retired_foo
	invalid event modifier: 'tired_foo'

With the patch:
	$ perf stat -e retired_foo
	invalid or unsupported event: 'retired_foo'

This also covers the case where the name of the event was not printed at
all when perf was linked with libpfm4.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20110723021043.GA20178@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d93f3ce..928918b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -697,7 +697,11 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
-		*strp = str + n + 1;
+		const char *end = str + n + 1;
+		if (*end != '\0' && *end != ',' && *end != ':')
+			return EVT_FAILED;
+
+		*strp = end;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
 		return EVT_HANDLED;
