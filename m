Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1ARBLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 20:11:00 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59430 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1ARBK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 20:10:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf tools: Fix handling of wildcards in tracepoint event selectors
Date: Mon, 17 Jan 2011 23:10:49 -0200
Message-Id: <1295313050-10353-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295313050-10353-1-git-send-email-acme@infradead.org>
References: <1295313050-10353-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It wasn't accounting the ':' when consuming bytes in the the event
selector string, so parse_events() would fail in this test:

                if (!(*str == 0 || *str == ',' || isspace(*str)))
                        return -1;

as *str would be pointing to '*', the last character in the '-e' arg in:

$ perf record -q -a -D -e sched:sched_* | perf script -i - -s perf-script.py

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5cb6f4b..1f4cfe5 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -555,7 +555,7 @@ static enum event_result parse_tracepoint_event(const char **strp,
 	if (evt_length >= MAX_EVENT_LENGTH)
 		return EVT_FAILED;
 	if (strpbrk(evt_name, "*?")) {
-		*strp += strlen(sys_name) + evt_length;
+		*strp += strlen(sys_name) + evt_length + 1; /* 1 == the ':' */
 		return parse_multiple_tracepoint_event(sys_name, evt_name,
 						       flags);
 	} else {
-- 
1.6.2.5

