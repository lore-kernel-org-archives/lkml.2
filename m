Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031Ab2EWCot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:44:49 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512Ab2EWCjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:02 -0400
X-AuditID: 9c93016f-b7c3cae000001954-69-4fbc4dc4f971
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 02/22] lib/traceevent: Add support for "%.*s" in bprintk events
Date: Wed, 23 May 2012 11:36:39 +0900
Message-Id: <1337740619-27925-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The arg notation of '*' in bprintks is not handled by the parser.
Implement it so that they show up properly in the output and do not
kill the tracer from reporting events.

Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/lib/traceevent/event-parse.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 998534992197..a2f4c22c8c4f 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3286,7 +3286,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		break;
 	}
 	case PRINT_BSTRING:
-		trace_seq_printf(s, format, arg->string.string);
+		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
 	case PRINT_OP:
 		/*
@@ -3386,6 +3386,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	unsigned long long ip, val;
 	char *ptr;
 	void *bptr;
+	int vsize;
 
 	field = pevent->bprint_buf_field;
 	ip_field = pevent->bprint_ip_field;
@@ -3434,6 +3435,8 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				goto process_again;
 			case '0' ... '9':
 				goto process_again;
+			case '.':
+				goto process_again;
 			case 'p':
 				ls = 1;
 				/* fall through */
@@ -3441,23 +3444,29 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 			case 'u':
 			case 'x':
 			case 'i':
-				/* the pointers are always 4 bytes aligned */
-				bptr = (void *)(((unsigned long)bptr + 3) &
-						~3);
 				switch (ls) {
 				case 0:
-					ls = 4;
+					vsize = 4;
 					break;
 				case 1:
-					ls = pevent->long_size;
+					vsize = pevent->long_size;
 					break;
 				case 2:
-					ls = 8;
+					vsize = 8;
 				default:
+					vsize = ls; /* ? */
 					break;
 				}
-				val = pevent_read_number(pevent, bptr, ls);
-				bptr += ls;
+			/* fall through */
+			case '*':
+				if (*ptr == '*')
+					vsize = 4;
+
+				/* the pointers are always 4 bytes aligned */
+				bptr = (void *)(((unsigned long)bptr + 3) &
+						~3);
+				val = pevent_read_number(pevent, bptr, vsize);
+				bptr += vsize;
 				arg = alloc_arg();
 				arg->next = NULL;
 				arg->type = PRINT_ATOM;
@@ -3465,6 +3474,13 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				sprintf(arg->atom.atom, "%lld", val);
 				*next = arg;
 				next = &arg->next;
+				/*
+				 * The '*' case means that an arg is used as the length.
+				 * We need to continue to figure out for what.
+				 */
+				if (*ptr == '*')
+					goto process_again;
+
 				break;
 			case 's':
 				arg = alloc_arg();
-- 
1.7.10.1

