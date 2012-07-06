Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab2GFKxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:53:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab2GFKxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:53:46 -0400
Date: Fri, 6 Jul 2012 03:53:26 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-600da3cfe19496485c5d8d52ff703590a0bd53f6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1340352615-20737-2-git-send-email-namhyung@kernel.org>
References: <1340352615-20737-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Check string is really printable
Git-Commit-ID: 600da3cfe19496485c5d8d52ff703590a0bd53f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:53:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  600da3cfe19496485c5d8d52ff703590a0bd53f6
Gitweb:     http://git.kernel.org/tip/600da3cfe19496485c5d8d52ff703590a0bd53f6
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 22 Jun 2012 17:10:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 29 Jun 2012 13:28:12 -0300

tools lib traceevent: Check string is really printable

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
 1 files changed, 13 insertions(+), 1 deletions(-)

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
