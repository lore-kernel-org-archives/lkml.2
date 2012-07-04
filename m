Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab2GDFjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:39:43 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63523 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2GDFjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:39:41 -0400
X-AuditID: 9c930179-b7cceae000004195-36-4ff3d71ac3d7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 02/16] tools lib traceevent: Add support for "%.*s" in bprintk events
Date: Wed,  4 Jul 2012 14:35:16 +0900
Message-Id: <1341380130-23863-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341380130-23863-1-git-send-email-namhyung@kernel.org>
References: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
 <1341380130-23863-1-git-send-email-namhyung@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-t0ctq7t1xz3ud6wv4v886jou@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 83f0a8add177..0644c2a23ad6 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3370,7 +3370,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		break;
 	}
 	case PRINT_BSTRING:
-		trace_seq_printf(s, format, arg->string.string);
+		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
 	case PRINT_OP:
 		/*
@@ -3471,6 +3471,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	unsigned long long ip, val;
 	char *ptr;
 	void *bptr;
+	int vsize;
 
 	field = pevent->bprint_buf_field;
 	ip_field = pevent->bprint_ip_field;
@@ -3519,6 +3520,8 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				goto process_again;
 			case '0' ... '9':
 				goto process_again;
+			case '.':
+				goto process_again;
 			case 'p':
 				ls = 1;
 				/* fall through */
@@ -3526,23 +3529,29 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
@@ -3550,6 +3559,13 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
1.7.10.4

