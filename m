Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab2GDFjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:39:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63523 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2GDFjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:39:40 -0400
X-AuditID: 9c930179-b7cceae000004195-2d-4ff3d7198d2d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/16] tools lib traceevent: Let filtering numbers by string use function names
Date: Wed,  4 Jul 2012 14:35:15 +0900
Message-Id: <1341380130-23863-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
References: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As a pointer can be converted into a function name, let the filters
work with the function name as well as with the pointer number.  If
the comparison expects a string, then convert numbers into functions,
but only when the number is the same size as a long.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-oxsa1qkr2eq7u8d7r0aapedu@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c |   45 +++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index dfcfe2c131de..80d872a81f26 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1710,18 +1710,43 @@ static int test_num(struct event_format *event,
 
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
1.7.10.4

