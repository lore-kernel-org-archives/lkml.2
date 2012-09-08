Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2IHLkQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:40:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39506 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2IHLkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:40:13 -0400
Date: Sat, 8 Sep 2012 04:39:54 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-0ca8da00ad170c12c12350c3a2500591a7bec535@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1346986187-5170-2-git-send-email-namhyung@kernel.org>
References: <1346986187-5170-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of die()
  from pevent_register_event_handler
Git-Commit-ID: 0ca8da00ad170c12c12350c3a2500591a7bec535
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:40:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ca8da00ad170c12c12350c3a2500591a7bec535
Gitweb:     http://git.kernel.org/tip/0ca8da00ad170c12c12350c3a2500591a7bec535
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 7 Sep 2012 11:49:46 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 12:15:07 -0300

tools lib traceevent: Get rid of die() from pevent_register_event_handler

If memory allocation for handler fails, return gracefully instead of
calling die().  Note that casts to void * are needed because gcc
complained about discarding 'const' qualifier during implicit argument
cast.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1346986187-5170-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 6d5e759..17fd01d 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5183,7 +5183,12 @@ int pevent_register_event_handler(struct pevent *pevent,
 
  not_found:
 	/* Save for later use. */
-	handle = malloc_or_die(sizeof(*handle));
+	handle = malloc(sizeof(*handle));
+	if (!handle) {
+		do_warning("Failed to allocate event handler");
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+	}
+
 	memset(handle, 0, sizeof(*handle));
 	handle->id = id;
 	if (event_name)
@@ -5193,7 +5198,11 @@ int pevent_register_event_handler(struct pevent *pevent,
 
 	if ((event_name && !handle->event_name) ||
 	    (sys_name && !handle->sys_name)) {
-		die("Failed to allocate event/sys name");
+		do_warning("Failed to allocate event/sys name");
+		free((void *)handle->event_name);
+		free((void *)handle->sys_name);
+		free(handle);
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 	}
 
 	handle->func = func;
