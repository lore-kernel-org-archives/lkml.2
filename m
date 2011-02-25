Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab1BYSGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:06:40 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42326 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756089Ab1BYSGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:06:38 -0500
Message-Id: <20110225180634.281487428@gulag1.americas.sgi.com>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Feb 2011 12:06:36 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] printk: Minimize time zero output
Content-Disposition: inline; filename=minimize-time-zero-msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the length for time zero messages by only printing "[0] ".

Before:
	[    0.000000] <message>
After:
	[0] <message>

There will be somewhere around 4000 to 5000 messages(*) on a fully
configured large NUMA system, before allocation of the log buf can
happen.  By removing 11 bytes from each the net gain will be from
44,000 to 55,000 bytes of redundant information removed.

(* - this is after the minimize-srat-msgs patch is applied.)

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 kernel/printk.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -745,12 +745,17 @@ static inline int printk_emit_time(void)
 	char tbuf[50], *tp;
 	unsigned tlen;
 	unsigned long long t;
-	unsigned long microsec_rem;
 
 	t = cpu_clock(printk_cpu);
-	microsec_rem = do_div(t, 1000000000) / 1000;
-	tlen = sprintf(tbuf, "[%5lu.%06lu] ", (unsigned long)t, microsec_rem);
+	if (likely(t)) {
+		unsigned long microsec_rem = do_div(t, 1000000000) / 1000;
 
+		tlen = sprintf(tbuf, "[%5lu.%06lu] ",
+					(unsigned long)t, microsec_rem);
+	} else {
+		/* reduce byte count in log when time is zero */
+		tlen = sprintf(tbuf, "[0] ");
+	}
 	for (tp = tbuf; tp < tbuf + tlen; tp++)
 		emit_log_char(*tp);
 

-- 
