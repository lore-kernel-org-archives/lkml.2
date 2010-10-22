Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab0JVTNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:13:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759362Ab0JVTNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=pcFNGlgx2cPVQikXjH0p1B3YcF0hWXl/P8TnldzYeFBQSagFOY/InM8iMNJ9NRdScp
         D7X1SxYgTcSoAA33V7h2CHXWXf2FugcZvJTy997YuSXrN7V7V/4bqe+axeY9GmYYC9MA
         3Ecjc/sknXKZoqmWWw8kMf5fgu6yx3emubi3w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC PATCH 10/11] perf: Support user regs and stack in sample parsing
Date: Fri, 22 Oct 2010 21:13:11 +0200
Message-Id: <1287774792-23123-11-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
References: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be needed for stack unwinding.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---
 tools/perf/builtin-kmem.c      |    2 +-
 tools/perf/builtin-lock.c      |    2 +-
 tools/perf/builtin-sched.c     |    2 +-
 tools/perf/builtin-timechart.c |    2 +-
 tools/perf/builtin-trace.c     |    2 +-
 tools/perf/util/event.c        |   28 ++++++++++++++++++++++++++--
 tools/perf/util/event.h        |   15 ++++++++++++++-
 tools/perf/util/header.c       |   33 +++++++++++++++++++++++++++++++--
 tools/perf/util/header.h       |    3 ++-
 tools/perf/util/session.c      |    4 ++--
 tools/perf/util/session.h      |    6 ++++++
 11 files changed, 86 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 31f60a2..2fee906 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -314,7 +314,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	data.cpu = -1;
 	data.period = 1;
 
-	event__parse_sample(event, session->sample_type, &data);
+	event__parse_sample(event, session, &data);
 
 	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
 		    data.pid, data.tid, data.ip, data.period);
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 821c158..5791a25 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -840,7 +840,7 @@ static int process_sample_event(event_t *self, struct perf_session *s)
 	struct thread *thread;
 
 	bzero(&data, sizeof(data));
-	event__parse_sample(self, s->sample_type, &data);
+	event__parse_sample(self, s, &data);
 
 	thread = perf_session__findnew(s, data.tid);
 	if (thread == NULL) {
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 55f3b5d..5ef6075 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1619,7 +1619,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	data.cpu = -1;
 	data.period = -1;
 
-	event__parse_sample(event, session->sample_type, &data);
+	event__parse_sample(event, session, &data);
 
 	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
 		    data.pid, data.tid, data.ip, data.period);
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 9bcc38f..7d752d5 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -477,7 +477,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	memset(&data, 0, sizeof(data));
 
-	event__parse_sample(event, session->sample_type, &data);
+	event__parse_sample(event, session, &data);
 
 	if (session->sample_type & PERF_SAMPLE_TIME) {
 		if (!first_time || first_time > data.time)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 40a6a29..224c586 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -74,7 +74,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	data.cpu = -1;
 	data.period = 1;
 
-	event__parse_sample(event, session->sample_type, &data);
+	event__parse_sample(event, session, &data);
 
 	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
 		    data.pid, data.tid, data.ip, data.period);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index dab9e75..567f97a 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -676,7 +676,7 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread;
 
-	event__parse_sample(self, session->sample_type, data);
+	event__parse_sample(self, session, data);
 
 	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld cpu:%d\n",
 		    self->header.misc, data->pid, data->tid, data->ip,
@@ -766,9 +766,11 @@ out_filtered:
 	return 0;
 }
 
-int event__parse_sample(const event_t *event, u64 type, struct sample_data *data)
+int event__parse_sample(const event_t *event, struct perf_session *session,
+			struct sample_data *data)
 {
 	const u64 *array = event->sample.array;
+	u64 type = session->sample_type;
 
 	if (type & PERF_SAMPLE_IP) {
 		data->ip = event->ip.ip;
@@ -830,6 +832,28 @@ int event__parse_sample(const event_t *event, u64 type, struct sample_data *data
 		data->raw_size = *p;
 		p++;
 		data->raw_data = p;
+		array += 1 + (data->raw_size * sizeof(u64));
+	}
+
+	if (session->sample_uregs_nr) {
+		data->uregs.version = *array++;
+
+		if (data->uregs.version) {
+			data->uregs.regs = (u64 *)array;
+			array += session->sample_uregs_nr;
+		}
+	}
+
+	if (session->sample_ustack) {
+		u64 size = *array++;
+
+		if (!size) {
+			data->stack.size = 0;
+		} else {
+			data->stack.data = (char *)array;
+			array += size / sizeof(*array);
+			data->stack.size = *array;
+		}
 	}
 
 	return 0;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 8e790da..5a05396 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -61,6 +61,16 @@ struct sample_event {
 	u64 array[];
 };
 
+struct user_regs {
+	u64 version;
+	u64 *regs;
+};
+
+struct user_stack_dump {
+	u64 size;
+	char *data;
+};
+
 struct sample_data {
 	u64 ip;
 	u32 pid, tid;
@@ -73,6 +83,8 @@ struct sample_data {
 	u32 raw_size;
 	void *raw_data;
 	struct ip_callchain *callchain;
+	struct user_regs uregs;
+	struct user_stack_dump stack;
 };
 
 #define BUILD_ID_SIZE 20
@@ -160,7 +172,8 @@ struct addr_location;
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
 			     struct addr_location *al, struct sample_data *data,
 			     symbol_filter_t filter);
-int event__parse_sample(const event_t *event, u64 type, struct sample_data *data);
+int event__parse_sample(const event_t *event, struct perf_session *session,
+			struct sample_data *data);
 
 extern const char *event__name[];
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d7e67b1..b73f481 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -922,9 +922,26 @@ out_errno:
 	return -errno;
 }
 
-u64 perf_header__sample_type(struct perf_header *header)
+static int regs_weight(u64 user_regs)
+{
+	int i, bits = 0;
+
+	for (i = 0; i < (int)sizeof(u64) * 8 && user_regs; i++) {
+		if (user_regs & 1)
+			bits++;
+
+		user_regs >>= 1;
+	}
+
+	return bits;
+}
+
+void perf_header__sample_type(struct perf_header *header,
+			      struct perf_session *session)
 {
 	u64 type = 0;
+	u64 uregs = 0;
+	int uregs_nr = 0, ustack = false;
 	int i;
 
 	for (i = 0; i < header->attrs; i++) {
@@ -934,9 +951,21 @@ u64 perf_header__sample_type(struct perf_header *header)
 			type = attr->attr.sample_type;
 		else if (type != attr->attr.sample_type)
 			die("non matching sample_type");
+
+		if (i == 0) {
+			uregs = attr->attr.user_regs;
+			uregs_nr = regs_weight(uregs);
+			ustack = !!attr->attr.ustack_dump_size;
+		} else if (uregs != attr->attr.user_regs ||
+			   ustack != !!attr->attr.ustack_dump_size) {
+			die("non matching sample_type");
+		}
 	}
 
-	return type;
+	session->sample_type = type;
+	session->sample_uregs = uregs;
+	session->sample_uregs_nr = uregs_nr;
+	session->sample_ustack = ustack;
 }
 
 struct perf_event_attr *
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 402ac24..6ec6af2 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -80,7 +80,8 @@ void perf_header_attr__delete(struct perf_header_attr *self);
 
 int perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 
-u64 perf_header__sample_type(struct perf_header *header);
+void perf_header__sample_type(struct perf_header *header,
+			      struct perf_session *session);
 struct perf_event_attr *
 perf_header__find_attr(u64 id, struct perf_header *header);
 void perf_header__set_feat(struct perf_header *self, int feat);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fa9d652..f0e427e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -67,7 +67,7 @@ out_close:
 
 void perf_session__update_sample_type(struct perf_session *self)
 {
-	self->sample_type = perf_header__sample_type(&self->header);
+	perf_header__sample_type(&self->header, self);
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
@@ -576,7 +576,7 @@ static int perf_session__process_sample(event_t *event, struct perf_session *s,
 		return ops->sample(event, s);
 
 	bzero(&data, sizeof(struct sample_data));
-	event__parse_sample(event, s->sample_type, &data);
+	event__parse_sample(event, s, &data);
 
 	queue_sample_event(event, &data, s);
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 9fa0fc2..ab9ebbc 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -39,6 +39,12 @@ struct perf_session {
 	 */
 	struct hists		hists;
 	u64			sample_type;
+	u64			sample_uregs;
+	/* We should probably use a quick hweight64() in sample_uregs to get
+	 * this instead of storing it.
+	 */
+	int			sample_uregs_nr;
+	bool			sample_ustack;
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
-- 
1.6.2.3

