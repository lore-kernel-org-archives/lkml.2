Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463Ab2EWPaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:30:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122Ab2EWPaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:30:19 -0400
Date: Wed, 23 May 2012 08:29:51 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-444d28663936e286c752f05feca44d6041b1fce4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1337081295-10303-3-git-send-email-eranian@google.com>
References: <1337081295-10303-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix piped mode read code
Git-Commit-ID: 444d28663936e286c752f05feca44d6041b1fce4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:29:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  444d28663936e286c752f05feca44d6041b1fce4
Gitweb:     http://git.kernel.org/tip/444d28663936e286c752f05feca44d6041b1fce4
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 15 May 2012 13:28:12 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:59:52 -0300

perf tools: Fix piped mode read code

In __perf_session__process_pipe_events(), there was a risk we would read
more than what a union perf_event struct can hold. this could happen in
case, perf is reading a file which contains new record types it does not
know about and which are larger than anything it knows about.

In general, perf is supposed to skip records it does not understand, but
in pipe mode, those have to be read and ignored.  The fixed size header
contains the size of the record, but that size may be larger than union
perf_event, yet it was used as the backing to the read in:

  union perf_event event;
  void *p;

  size = event->header.size;

  p = &event;
  p += sizeof(struct perf_event_header);
  if (size - sizeof(struct perf_event_header)) {
    err = readn(self->fd, p, size - sizeof(struct perf_event_header));

We fix this by allocating a buffer based on the size reported in the
header. We reuse the buffer as much as we can. We realloc in case it
becomes too small. In the  common case, the performance impact is
negligible.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1337081295-10303-3-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 17c9ace..93d355d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1098,8 +1098,9 @@ volatile int session_done;
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
@@ -1108,8 +1109,14 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
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
@@ -1119,13 +1126,23 @@ more:
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
@@ -1141,9 +1158,9 @@ more:
 		}
 	}
 
-	if ((skip = perf_session__process_event(self, &event, tool, head)) < 0) {
+	if ((skip = perf_session__process_event(self, event, tool, head)) < 0) {
 		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
-		       head, event.header.size, event.header.type);
+		       head, event->header.size, event->header.type);
 		err = -EINVAL;
 		goto out_err;
 	}
@@ -1158,6 +1175,7 @@ more:
 done:
 	err = 0;
 out_err:
+	free(buf);
 	perf_session__warn_about_errors(self, tool);
 	perf_session_free_sample_buffers(self);
 	return err;
