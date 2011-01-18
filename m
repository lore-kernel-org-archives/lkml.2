Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1ARItr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 03:49:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:54282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868Ab1ARItp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 03:49:45 -0500
Date: Tue, 18 Jan 2011 08:48:54 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix handling of wildcards in tracepoint event selectors
Message-ID: <tip-dd9a9ad5e1e94894433110ccbf492ed60d75ffcb@git.kernel.org>
Git-Commit-ID: dd9a9ad5e1e94894433110ccbf492ed60d75ffcb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 08:48:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd9a9ad5e1e94894433110ccbf492ed60d75ffcb
Gitweb:     http://git.kernel.org/tip/dd9a9ad5e1e94894433110ccbf492ed60d75ffcb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 17 Jan 2011 14:25:06 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 Jan 2011 15:26:07 -0200

perf tools: Fix handling of wildcards in tracepoint event selectors

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
