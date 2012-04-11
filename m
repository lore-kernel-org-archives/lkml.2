Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2DKJDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:03:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56078 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab2DKJDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:03:23 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, dsahern@gmail.com,
        namhyung.kim@lge.com
Subject: [PATCH 2/5] perf tools: fix piped mode read code
Date: Wed, 11 Apr 2012 11:01:26 +0200
Message-Id: <1334134889-20312-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1334134889-20312-1-git-send-email-eranian@google.com>
References: <1334134889-20312-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __perf_session__process_pipe_events(), there was a risk
we would read more than what a union perf_event struct can
hold. this could happen in case, perf is reading a file which
contains new record types it does not know about and which are
larger than anything it knows about.

In general, perf is supposed to skip records it does not
understand, but in pipe mode, those have to be read and ignored.
The fixed size header contains the size of the record, but that
size may be larger than union perf_event, yet it was used as
the backing to the read in:

  union perf_event event;
  void *p;

  size = event->header.size;

  p = &event;
  p += sizeof(struct perf_event_header);
  if (size - sizeof(struct perf_event_header)) {
    err = readn(self->fd, p, size - sizeof(struct perf_event_header));

We fix this by allocating a buffer based on the size reported in
the header. We reuse the buffer as much as we can. We realloc in
case it becomes too small. In the  common case, the performance
impact is negligible.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9412e3b..d13e915 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1056,8 +1056,9 @@ volatile int session_done;
 static int __perf_session__process_pipe_events(struct perf_session *self,
 					       struct perf_tool *tool)
 {
-	union perf_event event;
-	uint32_t size;
+	union perf_event *event;
+	uint32_t size, cur_size = 0;
+	void *buf = NULL;
 	int skip = 0;
 	u64 head;
 	int err;
@@ -1066,8 +1067,14 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
 	perf_tool__fill_defaults(tool);
 
 	head = 0;
+	cur_size = sizeof(union perf_event);
+
+	buf = malloc(cur_size);
+	if (!buf)
+		return -errno;
 more:
-	err = readn(self->fd, &event, sizeof(struct perf_event_header));
+	event = buf;
+	err = readn(self->fd, event, sizeof(struct perf_event_header));
 	if (err <= 0) {
 		if (err == 0)
 			goto done;
@@ -1077,13 +1084,23 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
 	}
 
 	if (self->header.needs_swap)
-		perf_event_header__bswap(&event.header);
+		perf_event_header__bswap(&event->header);
 
-	size = event.header.size;
+	size = event->header.size;
 	if (size == 0)
 		size = 8;
 
-	p = &event;
+	if (size > cur_size) {
+		void *new = realloc(buf, size);
+		if (!new) {
+			pr_err("failed to allocate memory to read event\n");
+			goto out_err;
+		}
+		buf = new;
+		cur_size = size;
+		event = buf;
+	}
+	p = event;
 	p += sizeof(struct perf_event_header);
 
 	if (size - sizeof(struct perf_event_header)) {
@@ -1099,9 +1116,10 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
 		}
 	}
 
-	if ((skip = perf_session__process_event(self, &event, tool, head)) < 0) {
+	skip = perf_session__process_event(self, event, tool, head);
+	if (skip < 0) {
 		dump_printf("%#" PRIx64 " [%#x]: skipping unknown header type: %d\n",
-			    head, event.header.size, event.header.type);
+			    head, event->header.size, event->header.type);
 		/*
 		 * assume we lost track of the stream, check alignment, and
 		 * increment a single u64 in the hope to catch on again 'soon'.
@@ -1122,6 +1140,7 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
 done:
 	err = 0;
 out_err:
+	free(buf);
 	perf_session__warn_about_errors(self, tool);
 	perf_session_free_sample_buffers(self);
 	return err;
-- 
1.7.4.1

