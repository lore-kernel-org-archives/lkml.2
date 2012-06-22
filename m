Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652Ab2FVIOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:14:45 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59941 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761624Ab2FVIO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:14:29 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-ec-4fe429604233
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/2] tools lib traceevent: Check string is really printable
Date: Fri, 22 Jun 2012 17:10:15 +0900
Message-Id: <1340352615-20737-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340352615-20737-1-git-send-email-namhyung@kernel.org>
References: <1340352615-20737-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When libtraceevent parses format fields, it assumes that
array of 1 byte is string but it's not always true. The
kvm_emulate_insn contains 15 u8 array of insn that contains
(binary) instructions. Thus when it's printed, it'll have
broken output like below:

  kvm_emulate_insn:     [FAILED TO PARSE] rip=3238197797 csbase=0 len=2 \
  insn=<89>P^]<B4>& flags=5 failed=0

With this patch:

  kvm_emulate_insn:     [FAILED TO PARSE] rip=3238197797 csbase=0 len=2 \
  insn=ARRAY[89, 10, 5d, c3, 8d, b4, 26, 00, 00, 00, 00, 55, 89, e5, 3e] flags=5 failed=0

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-c5ypr2k43uuc57ru6b8vi7ax@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 853b604b6240..eb195cbc841c 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3655,6 +3655,16 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
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
@@ -3674,7 +3684,8 @@ static void print_event_fields(struct trace_seq *s, void *data, int size,
 				len = offset >> 16;
 				offset &= 0xffff;
 			}
-			if (field->flags & FIELD_IS_STRING) {
+			if (field->flags & FIELD_IS_STRING &&
+			    is_printable_array(data + offset, len)) {
 				trace_seq_printf(s, "%s", (char *)data + offset);
 			} else {
 				trace_seq_puts(s, "ARRAY[");
@@ -3685,6 +3696,7 @@ static void print_event_fields(struct trace_seq *s, void *data, int size,
 							 *((unsigned char *)data + offset + i));
 				}
 				trace_seq_putc(s, ']');
+				field->flags &= ~FIELD_IS_STRING;
 			}
 		} else {
 			val = pevent_read_number(event->pevent, data + field->offset,
-- 
1.7.10.2

