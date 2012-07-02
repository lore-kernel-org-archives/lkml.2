Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2GBUUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:20:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:42288 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab2GBUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:19:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/13] tools lib traceevent: Check string is really printable
Date: Mon,  2 Jul 2012 17:18:42 -0300
Message-Id: <1341260331-10204-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341260331-10204-1-git-send-email-acme@infradead.org>
References: <1341260331-10204-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When libtraceevent parses format fields, it assumes that array of 1 byte
is string but it's not always true. The kvm_emulate_insn contains 15 u8
array of insn that contains (binary) instructions. Thus when it's
printed, it'll have broken output like below:

  kvm_emulate_insn:     [FAILED TO PARSE] rip=3238197797 csbase=0 len=2 \
  insn=<89>P^]<B4>& flags=5 failed=0

With this patch:

  kvm_emulate_insn:     [FAILED TO PARSE] rip=3238197797 csbase=0 len=2 \
  insn=ARRAY[89, 10, 5d, c3, 8d, b4, 26, 00, 00, 00, 00, 55, 89, e5, 3e] flags=5 failed=0

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1340352615-20737-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5548282..b203a50 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3589,6 +3589,16 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
 	trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5]);
 }
 
+static int is_printable_array(char *p, unsigned int len)
+{
+	unsigned int i;
+
+	for (i = 0; i < len && p[i]; i++)
+		if (!isprint(p[i]))
+		    return 0;
+	return 1;
+}
+
 static void print_event_fields(struct trace_seq *s, void *data, int size,
 			       struct event_format *event)
 {
@@ -3608,7 +3618,8 @@ static void print_event_fields(struct trace_seq *s, void *data, int size,
 				len = offset >> 16;
 				offset &= 0xffff;
 			}
-			if (field->flags & FIELD_IS_STRING) {
+			if (field->flags & FIELD_IS_STRING &&
+			    is_printable_array(data + offset, len)) {
 				trace_seq_printf(s, "%s", (char *)data + offset);
 			} else {
 				trace_seq_puts(s, "ARRAY[");
@@ -3619,6 +3630,7 @@ static void print_event_fields(struct trace_seq *s, void *data, int size,
 							 *((unsigned char *)data + offset + i));
 				}
 				trace_seq_putc(s, ']');
+				field->flags &= ~FIELD_IS_STRING;
 			}
 		} else {
 			val = pevent_read_number(event->pevent, data + field->offset,
-- 
1.7.9.2.358.g22243

