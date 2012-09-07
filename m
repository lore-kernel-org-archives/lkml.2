Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab2IGC5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:57:35 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57681 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2IGC5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:57:09 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-fb-50496280db37
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/3] tools lib traceevent: Get rid of die() from pevent_register_event_handler
Date: Fri,  7 Sep 2012 11:49:46 +0900
Message-Id: <1346986187-5170-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346986187-5170-1-git-send-email-namhyung@kernel.org>
References: <1346986187-5170-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If memory allocation for handler fails, return gracefully instead of
calling die().  Note that casts to void * are needed because gcc
complained about discarding 'const' qualifier during implicit argument
cast.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 6d5e75987a3d..17fd01d46e60 100644
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
1.7.11.4

