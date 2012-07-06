Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab2GFLIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:08:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51809 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab2GFLIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:08:22 -0400
Date: Fri, 6 Jul 2012 04:08:09 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-oxsa1qkr2eq7u8d7r0aapedu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Let filtering numbers by string use function names
Git-Commit-ID: e84c282b40251f314c429f39b044785e323f2648
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:08:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e84c282b40251f314c429f39b044785e323f2648
Gitweb:     http://git.kernel.org/tip/e84c282b40251f314c429f39b044785e323f2648
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 22 May 2012 14:45:21 +0900
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:30 +0900

tools lib traceevent: Let filtering numbers by string use function names

As a pointer can be converted into a function name, let the filters
work with the function name as well as with the pointer number.  If
the comparison expects a string, then convert numbers into functions,
but only when the number is the same size as a long.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-oxsa1qkr2eq7u8d7r0aapedu@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c |   45 +++++++++++++++++++++++++++-------
 1 files changed, 35 insertions(+), 10 deletions(-)

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
 
