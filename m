Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0DXCGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:06:33 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:43965 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab0DXCFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=UrZV2Fxj8AMl8CxunogheVdc6TfCsA9pQ/VCWVu3EUPRtkPNdQ2geFaf6MFxwheCkP
         TbckNPkXBvzdV0l5ZsPoz3SZHIFKNk8y/S2ou+r3p/QiWOqrnAiUs2as4ibVdIpxNo9E
         MNzhJmPyOYLk6exIOd+4geRuFTE8t13w84Mlk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 7/9] perf: Use generic sample reordering in perf timechart
Date: Sat, 24 Apr 2010 04:05:40 +0200
Message-Id: <1272074742-3654-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic sample events reordering from perf timechart,
this drops the ad hoc sample reordering it was using before.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/builtin-timechart.c |  112 ++--------------------------------------
 1 files changed, 5 insertions(+), 107 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 96f4a09..c35aa44 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -143,9 +143,6 @@ struct wake_event {
 static struct power_event    *power_events;
 static struct wake_event     *wake_events;
 
-struct sample_wrapper *all_samples;
-
-
 struct process_filter;
 struct process_filter {
 	char			*name;
@@ -566,88 +563,6 @@ static void end_sample_processing(void)
 	}
 }
 
-static u64 sample_time(event_t *event, const struct perf_session *session)
-{
-	int cursor;
-
-	cursor = 0;
-	if (session->sample_type & PERF_SAMPLE_IP)
-		cursor++;
-	if (session->sample_type & PERF_SAMPLE_TID)
-		cursor++;
-	if (session->sample_type & PERF_SAMPLE_TIME)
-		return event->sample.array[cursor];
-	return 0;
-}
-
-
-/*
- * We first queue all events, sorted backwards by insertion.
- * The order will get flipped later.
- */
-static int queue_sample_event(event_t *event, struct perf_session *session)
-{
-	struct sample_wrapper *copy, *prev;
-	int size;
-
-	size = event->sample.header.size + sizeof(struct sample_wrapper) + 8;
-
-	copy = malloc(size);
-	if (!copy)
-		return 1;
-
-	memset(copy, 0, size);
-
-	copy->next = NULL;
-	copy->timestamp = sample_time(event, session);
-
-	memcpy(&copy->data, event, event->sample.header.size);
-
-	/* insert in the right place in the list */
-
-	if (!all_samples) {
-		/* first sample ever */
-		all_samples = copy;
-		return 0;
-	}
-
-	if (all_samples->timestamp < copy->timestamp) {
-		/* insert at the head of the list */
-		copy->next = all_samples;
-		all_samples = copy;
-		return 0;
-	}
-
-	prev = all_samples;
-	while (prev->next) {
-		if (prev->next->timestamp < copy->timestamp) {
-			copy->next = prev->next;
-			prev->next = copy;
-			return 0;
-		}
-		prev = prev->next;
-	}
-	/* insert at the end of the list */
-	prev->next = copy;
-
-	return 0;
-}
-
-static void sort_queued_samples(void)
-{
-	struct sample_wrapper *cursor, *next;
-
-	cursor = all_samples;
-	all_samples = NULL;
-
-	while (cursor) {
-		next = cursor->next;
-		cursor->next = all_samples;
-		all_samples = cursor;
-		cursor = next;
-	}
-}
-
 /*
  * Sort the pid datastructure
  */
@@ -1011,26 +926,12 @@ static void write_svg_file(const char *filename)
 	svg_close();
 }
 
-static void process_samples(struct perf_session *session)
-{
-	struct sample_wrapper *cursor;
-	event_t *event;
-
-	sort_queued_samples();
-
-	cursor = all_samples;
-	while (cursor) {
-		event = (void *)&cursor->data;
-		cursor = cursor->next;
-		process_sample_event(event, session);
-	}
-}
-
 static struct perf_event_ops event_ops = {
-	.comm	= process_comm_event,
-	.fork	= process_fork_event,
-	.exit	= process_exit_event,
-	.sample	= queue_sample_event,
+	.comm			= process_comm_event,
+	.fork			= process_fork_event,
+	.exit			= process_exit_event,
+	.sample			= process_sample_event,
+	.ordered_samples	= true,
 };
 
 static int __cmd_timechart(void)
@@ -1048,8 +949,6 @@ static int __cmd_timechart(void)
 	if (ret)
 		goto out_delete;
 
-	process_samples(session);
-
 	end_sample_processing();
 
 	sort_pids();
@@ -1072,7 +971,6 @@ static const char *record_args[] = {
 	"record",
 	"-a",
 	"-R",
-	"-M",
 	"-f",
 	"-c", "1",
 	"-e", "power:power_start",
-- 
1.6.2.3

