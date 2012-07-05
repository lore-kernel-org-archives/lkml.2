Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192Ab2GEPpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:45:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:59080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964775Ab2GEPp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 02/20] tools lib traceevent: Add support for "%.*s" in bprintk events
Date: Thu,  5 Jul 2012 12:45:00 -0300
Message-Id: <1341503118-13198-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
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
index 83f0a8a..0644c2a 100644
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
1.7.9.2.358.g22243

