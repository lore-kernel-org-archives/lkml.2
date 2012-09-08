Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357Ab2IHCH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:07:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41321 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab2IHCHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:07:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/13] tools lib traceevent: Get rid of die() from pevent_register_event_handler
Date: Fri,  7 Sep 2012 23:07:02 -0300
Message-Id: <1347070032-4161-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347070032-4161-1-git-send-email-acme@infradead.org>
References: <1347070032-4161-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
 1 file changed, 11 insertions(+), 2 deletions(-)

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
-- 
1.7.9.2.358.g22243

