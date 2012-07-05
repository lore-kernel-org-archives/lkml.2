Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab2GEPtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:49:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60602 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964776Ab2GEPpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 01/20] tools lib traceevent: Let filtering numbers by string use function names
Date: Thu,  5 Jul 2012 12:44:59 -0300
Message-Id: <1341503118-13198-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
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
index dfcfe2c..80d872a 100644
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
1.7.9.2.358.g22243

