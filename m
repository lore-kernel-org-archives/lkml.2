Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2AXXK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:10:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59169 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2AXXIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 9/9] perf tools: Fix strlen() bug in perf_event__synthesize_event_type()
Date: Tue, 24 Jan 2012 21:08:01 -0200
Message-Id: <1327446481-5505-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327446481-5505-1-git-send-email-acme@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

The event_type record has a max length for the event name.

It's called MAX_EVENT_NAME.

The name may be truncated to fit the max length. But the header.size still
reflects the original name length. If that length is > MAX_EVENT_NAME, then the
header.size field is bogus. Fix this by using the length of the name after the
potential truncation.

Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120120094912.GA4882@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3e7e0b0..ecd7f4d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2105,7 +2105,7 @@ int perf_event__synthesize_event_type(struct perf_tool *tool,
 	strncpy(ev.event_type.event_type.name, name, MAX_EVENT_NAME - 1);
 
 	ev.event_type.header.type = PERF_RECORD_HEADER_EVENT_TYPE;
-	size = strlen(name);
+	size = strlen(ev.event_type.event_type.name);
 	size = ALIGN(size, sizeof(u64));
 	ev.event_type.header.size = sizeof(ev.event_type) -
 		(sizeof(ev.event_type.event_type.name) - size);
-- 
1.7.9.rc2.1.g69204

