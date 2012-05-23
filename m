Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab2EWCjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:39:03 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab2EWCjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:01 -0400
X-AuditID: 9c93016f-b7c3cae000001954-5e-4fbc4dc4532c
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/22] lib/traceevent: Let filtering numbers by string use function names
Date: Wed, 23 May 2012 11:36:38 +0900
Message-Id: <1337740619-27925-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As a pointer can be converted into a function name, let the filters
work with the function name as well as with the pointer number.
If the comparison expects a string, then convert numbers into functions,
but only when the number is the same size as a long.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/lib/traceevent/parse-filter.c |   45 +++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 2d40c5ed81d6..466579f4b02f 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1711,18 +1711,43 @@ static int test_num(struct event_format *event,
 
 static const char *get_field_str(struct filter_arg *arg, struct pevent_record *record)
 {
-	const char *val = record->data + arg->str.field->offset;
+	struct event_format *event;
+	struct pevent *pevent;
+	unsigned long long addr;
+	const char *val = NULL;
+	char hex[64];
 
-	/*
-	 * We need to copy the data since we can't be sure the field
-	 * is null terminated.
-	 */
-	if (*(val + arg->str.field->size - 1)) {
-		/* copy it */
-		memcpy(arg->str.buffer, val, arg->str.field->size);
-		/* the buffer is already NULL terminated */
-		val = arg->str.buffer;
+	/* If the field is not a string convert it */
+	if (arg->str.field->flags & FIELD_IS_STRING) {
+		val = record->data + arg->str.field->offset;
+
+		/*
+		 * We need to copy the data since we can't be sure the field
+		 * is null terminated.
+		 */
+		if (*(val + arg->str.field->size - 1)) {
+			/* copy it */
+			memcpy(arg->str.buffer, val, arg->str.field->size);
+			/* the buffer is already NULL terminated */
+			val = arg->str.buffer;
+		}
+
+	} else {
+		event = arg->str.field->event;
+		pevent = event->pevent;
+		addr = get_value(event, arg->str.field, record);
+
+		if (arg->str.field->flags & (FIELD_IS_POINTER | FIELD_IS_LONG))
+			/* convert to a kernel symbol */
+			val = pevent_find_function(pevent, addr);
+
+		if (val == NULL) {
+			/* just use the hex of the string name */
+			snprintf(hex, 64, "0x%llx", addr);
+			val = hex;
+		}
 	}
+
 	return val;
 }
 
-- 
1.7.10.1

