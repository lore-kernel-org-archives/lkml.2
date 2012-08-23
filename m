Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab2HWPMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:12:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50064 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2HWPK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:10:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/12] tools lib traceevent: Introduce pevent_strerror
Date: Thu, 23 Aug 2012 12:09:54 -0300
Message-Id: <1345734596-7601-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345734596-7601-1-git-send-email-acme@infradead.org>
References: <1345734596-7601-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The pevent_strerror() sets @buf to a string that describes the
(libtraceevent-specific) error condition that is passed via @errnum.

This is similar to strerror_r() and does same thing if @errnum has a
standard errno value.

To sync error string with its code, define PEVENT_ERRORS with _PE()
macro and use it as suggested by Steven.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1345618831-9148-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   43 ++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/event-parse.h |   20 +++++++++++-----
 2 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index a46cae7..1373e4c 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4795,6 +4795,49 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	return ret;
 }
 
+#undef _PE
+#define _PE(code, str) str
+static const char * const pevent_error_str[] = {
+	PEVENT_ERRORS
+};
+#undef _PE
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
+	if (errnum <= __PEVENT_ERRNO__START ||
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
index 3c48229..527df03 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -345,6 +345,16 @@ enum pevent_flag {
 	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
 };
 
+#define PEVENT_ERRORS 							      \
+	_PE(MEM_ALLOC_FAILED,	"failed to allocate memory"),		      \
+	_PE(PARSE_EVENT_FAILED,	"failed to parse event"),		      \
+	_PE(READ_ID_FAILED,	"failed to read event id"),		      \
+	_PE(READ_FORMAT_FAILED,	"failed to read event format"),		      \
+	_PE(READ_PRINT_FAILED,	"failed to read event print fmt"), 	      \
+	_PE(OLD_FTRACE_ARG_FAILED,"failed to allocate field name for ftrace")
+
+#undef _PE
+#define _PE(__code, __str) PEVENT_ERRNO__ ## __code
 enum pevent_errno {
 	PEVENT_ERRNO__SUCCESS			= 0,
 
@@ -357,15 +367,11 @@ enum pevent_errno {
 	 */
 	__PEVENT_ERRNO__START			= -100000,
 
-	PEVENT_ERRNO__MEM_ALLOC_FAILED		= __PEVENT_ERRNO__START,
-	PEVENT_ERRNO__PARSE_EVENT_FAILED,
-	PEVENT_ERRNO__READ_ID_FAILED,
-	PEVENT_ERRNO__READ_FORMAT_FAILED,
-	PEVENT_ERRNO__READ_PRINT_FAILED,
-	PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED,
+	PEVENT_ERRORS,
 
 	__PEVENT_ERRNO__END,
 };
+#undef _PE
 
 struct cmdline;
 struct cmdline_list;
@@ -583,6 +589,8 @@ int pevent_data_pid(struct pevent *pevent, struct pevent_record *rec);
 const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid);
 void pevent_event_info(struct trace_seq *s, struct event_format *event,
 		       struct pevent_record *record);
+int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
+		    char *buf, size_t buflen);
 
 struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type);
 struct format_field **pevent_event_common_fields(struct event_format *event);
-- 
1.7.1

