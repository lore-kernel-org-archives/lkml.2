Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab2GFLJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:09:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab2GFLJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:09:18 -0400
Date: Fri, 6 Jul 2012 04:09:04 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-t0ctq7t1xz3ud6wv4v886jou@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, johannes.berg@intel.com,
        tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, johannes.berg@intel.com,
        tglx@linutronix.de, namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Add support for "%.*s"
  in bprintk events
Git-Commit-ID: c2e6dc2b268cca44d522b2ee86147f0d30d7e3e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:09:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2e6dc2b268cca44d522b2ee86147f0d30d7e3e4
Gitweb:     http://git.kernel.org/tip/c2e6dc2b268cca44d522b2ee86147f0d30d7e3e4
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 15 Nov 2011 18:47:48 -0500
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:30 +0900

tools lib traceevent: Add support for "%.*s" in bprintk events

The arg notation of '*' in bprintks is not handled by the parser.
Implement it so that they show up properly in the output and do not
kill the tracer from reporting events.

Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-t0ctq7t1xz3ud6wv4v886jou@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

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
