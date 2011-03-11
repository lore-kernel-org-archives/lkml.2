Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1CKJuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:50:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:38571 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab1CKJur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:50:47 -0500
Date: Fri, 11 Mar 2011 09:50:31 GMT
From: tip-bot for David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
In-Reply-To: <1291421609-14665-13-git-send-email-dhsharp@google.com>
References: <1291421609-14665-13-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Adjust conditional expression latency formatting.
Message-ID: <tip-10da37a645b5e915d8572cc2b1f5eb11ada3ea4f@git.kernel.org>
Git-Commit-ID: 10da37a645b5e915d8572cc2b1f5eb11ada3ea4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:50:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10da37a645b5e915d8572cc2b1f5eb11ada3ea4f
Gitweb:     http://git.kernel.org/tip/10da37a645b5e915d8572cc2b1f5eb11ada3ea4f
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Fri, 3 Dec 2010 16:13:26 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 10 Mar 2011 10:34:35 -0500

tracing: Adjust conditional expression latency formatting.

Formatting change only to improve code readability. No code changes except to
introduce intermediate variables.

Signed-off-by: David Sharp <dhsharp@google.com>
LKML-Reference: <1291421609-14665-13-git-send-email-dhsharp@google.com>

[ Keep variable declarations and assignment separate ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 151f32e..456be90 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -533,20 +533,30 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
  */
 int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 {
-	int hardirq, softirq;
+	char hardsoft_irq;
+	char need_resched;
+	char irqs_off;
+	int hardirq;
+	int softirq;
 	int ret;
 
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
 	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
 
+	irqs_off =
+		(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
+		(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' :
+		'.';
+	need_resched =
+		(entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.';
+	hardsoft_irq =
+		(hardirq && softirq) ? 'H' :
+		hardirq ? 'h' :
+		softirq ? 's' :
+		'.';
+
 	if (!trace_seq_printf(s, "%c%c%c",
-			      (entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
-				(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
-				  'X' : '.',
-			      (entry->flags & TRACE_FLAG_NEED_RESCHED) ?
-				'N' : '.',
-			      (hardirq && softirq) ? 'H' :
-				hardirq ? 'h' : softirq ? 's' : '.'))
+			      irqs_off, need_resched, hardsoft_irq))
 		return 0;
 
 	if (entry->preempt_count)
