Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab2FLHp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:45:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45976 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2FLHpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:45:52 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-dd-4fd6f3af6337
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
Date: Tue, 12 Jun 2012 16:42:39 +0900
Message-Id: <1339486959-25241-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The pevent_strerror() sets @buf to a string that describes the
(libtraceevent-specific) error condition that is passed via @errnum.

This is similar to strerror_r() and does same thing if @errnum has a
standard errno value.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   48 ++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/event-parse.h |    2 ++
 2 files changed, 50 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 866bdca4825d..3ed2d9362e69 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4706,6 +4706,54 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	return ret;
 }
 
+/*
+ * This must have a same ordering as the enum pevent_errno.
+ */
+static const char * const pevent_error_str[] = {
+	"failed to allocate memory",
+	"failed to parse event",
+	"failed to read event id",
+	"failed to read event format",
+	"failed to read event print fmt",
+	"failed to allocate field name for ftrace",
+};
+
+int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
+		    char *buf, size_t buflen)
+{
+	int idx;
+	const char *msg;
+
+	if (errnum >= 0) {
+		strerror_r(errnum, buf, buflen);
+		return 0;
+	}
+
+	if (errnum <  __PEVENT_ERRNO__START ||
+	    errnum >= __PEVENT_ERRNO__END)
+		return -1;
+
+	idx = errnum - __PEVENT_ERRNO__START;
+	msg = pevent_error_str[idx];
+
+	switch (errnum) {
+	case PEVENT_ERRNO__MEM_ALLOC_FAILED:
+	case PEVENT_ERRNO__PARSE_EVENT_FAILED:
+	case PEVENT_ERRNO__READ_ID_FAILED:
+	case PEVENT_ERRNO__READ_FORMAT_FAILED:
+	case PEVENT_ERRNO__READ_PRINT_FAILED:
+	case PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED:
+		snprintf(buf, buflen, "%s", msg);
+		break;
+
+	default:
+		/* cannot reach here */
+		break;
+	}
+
+	return 0;
+}
+
 int get_field_val(struct trace_seq *s, struct format_field *field,
 		  const char *name, struct pevent_record *record,
 		  unsigned long long *val, int err)
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 24b7649d530b..7e90aba20850 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -576,6 +576,8 @@ int pevent_data_pid(struct pevent *pevent, struct pevent_record *rec);
 const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid);
 void pevent_event_info(struct trace_seq *s, struct event_format *event,
 		       struct pevent_record *record);
+int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
+		    char *buf, size_t buflen);
 
 struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type);
 struct format_field **pevent_event_common_fields(struct event_format *event);
-- 
1.7.10.2

