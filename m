Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1HRQun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:50:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:38353 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab1HRQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:50:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/6] perf tools: Fix error handling of unknown events
Date: Thu, 18 Aug 2011 13:50:01 -0300
Message-Id: <1313686204-30295-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313686204-30295-1-git-send-email-acme@infradead.org>
References: <1313686204-30295-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

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
-- 
1.6.2.5

