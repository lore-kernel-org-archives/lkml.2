Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2FSOjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:39:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37856 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab2FSOjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:39:45 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, namhyung.kim@lge.com,
        mingo@kernel.org, peterz@infradead.org
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd plugins
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
	<87lijlhv9v.fsf@sejong.aot.lge.com> <4FDF3D5C.1030209@gmail.com>
	<87d34wi0y3.fsf@sejong.aot.lge.com>
	<1340067793.25903.158.camel@gandalf.stny.rr.com>
	<878vfkhzr8.fsf@sejong.aot.lge.com>
	<1340069162.25903.176.camel@gandalf.stny.rr.com>
	<874nq8hyfa.fsf@sejong.aot.lge.com>
	<1340072171.25903.181.camel@gandalf.stny.rr.com>
	<87vcinhn90.fsf@sejong.aot.lge.com>
	<1340106882.25903.206.camel@gandalf.stny.rr.com>
Date: Tue, 19 Jun 2012 23:39:34 +0900
In-Reply-To: <1340106882.25903.206.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Tue, 19 Jun 2012 07:54:42 -0400")
Message-ID: <87vcin9xi1.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012 07:54:42 -0400, Steven Rostedt wrote:
> We could simply check if all the characters in the array passes
> 'isprint()' and if it does then print the string, otherwise print the
> hex. Do this for all events, and if it one fails, then mark it always to
> print hex.
>

Ok, checking it at parse time is not possible because we cannot access
to its data. You meant something like this?


diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 853b604b6240..7dae44b74e0b 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3655,6 +3655,16 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
        trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5]);
 }
 
+static int is_printable_array(char *p, unsigned int len)
+{
+       unsigned int i;
+
+       for (i = 0; i < len && p[i]; i++)
+               if (!isprint(p[i]))
+                       return 0;
+       return 1;
+}
+
 static void print_event_fields(struct trace_seq *s, void *data, int size,
                               struct event_format *event)
 {
@@ -3674,7 +3684,8 @@ static void print_event_fields(struct trace_seq *s, void *data, int size,
                                len = offset >> 16;
                                offset &= 0xffff;
                        }
-                       if (field->flags & FIELD_IS_STRING) {
+                       if ((field->flags & FIELD_IS_STRING) &&
+                           is_printable_array(data + offset, len)) {
                                trace_seq_printf(s, "%s", (char *)data + offset);
                        } else {
                                trace_seq_puts(s, "ARRAY[");
@@ -3685,6 +3696,7 @@ static void print_event_fields(struct trace_seq *s, void *data, int size,
                                                         *((unsigned char *)data + offset + i));
                                }
                                trace_seq_putc(s, ']');
+                               field->flags &= ~FIELD_IS_STRING;
                        }
                } else {
                        val = pevent_read_number(event->pevent, data + field->offset,

