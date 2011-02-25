Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab1BYSHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:07:03 -0500
Received: from relay3.sgi.com ([192.48.152.1]:47157 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756369Ab1BYSGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:06:40 -0500
Message-Id: <20110225180634.147732905@gulag1.americas.sgi.com>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Feb 2011 12:06:35 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] printk: Break out printk_time
Content-Disposition: inline; filename=break-out-printk_time
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up printk_time by making it a separate function.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 kernel/printk.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -739,6 +739,24 @@ static inline void printk_delay(void)
 	}
 }
 
+/* Follow the token with the time */
+static inline int printk_emit_time(void)
+{
+	char tbuf[50], *tp;
+	unsigned tlen;
+	unsigned long long t;
+	unsigned long microsec_rem;
+
+	t = cpu_clock(printk_cpu);
+	microsec_rem = do_div(t, 1000000000) / 1000;
+	tlen = sprintf(tbuf, "[%5lu.%06lu] ", (unsigned long)t, microsec_rem);
+
+	for (tp = tbuf; tp < tbuf + tlen; tp++)
+		emit_log_char(*tp);
+
+	return tlen;
+}
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
 	int printed_len = 0;
@@ -823,23 +841,9 @@ asmlinkage int vprintk(const char *fmt,
 			printed_len += 3;
 			new_text_line = 0;
 
-			if (printk_time) {
-				/* Follow the token with the time */
-				char tbuf[50], *tp;
-				unsigned tlen;
-				unsigned long long t;
-				unsigned long nanosec_rem;
-
-				t = cpu_clock(printk_cpu);
-				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
-						(unsigned long) t,
-						nanosec_rem / 1000);
-
-				for (tp = tbuf; tp < tbuf + tlen; tp++)
-					emit_log_char(*tp);
-				printed_len += tlen;
-			}
+			/* add time if requested */
+			if (printk_time)
+				printed_len += printk_emit_time();
 
 			if (!*p)
 				break;

-- 
