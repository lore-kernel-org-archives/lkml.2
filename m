Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1CJP7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:59:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1CJP7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:13 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=9igOHfL4M50A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=EbE3YELYTJvBHVwhzJYA:9 a=HTHoTyvZDDKXYkLYgUjnGsxod8EA:4 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155911.272672951@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>
Subject: [PATCH 09/15] tracing: Adjust conditional expression latency formatting.
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Adjust-conditional-expression-latency-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sharp <dhsharp@google.com>

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
-- 
1.7.2.3


