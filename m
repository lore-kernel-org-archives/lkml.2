Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab1BSCru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 21:47:50 -0500
Received: from relay3.sgi.com ([192.48.152.1]:42548 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753143Ab1BSCrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 21:47:11 -0500
Message-Id: <20110219024706.121740209@gulag1.americas.sgi.com>
References: <20110219024705.308511527@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Feb 2011 20:47:10 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] printk: Minimize time zero output
Content-Disposition: inline; filename=minimize-time-zero-msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the length for time zero messages by only printing "[0] ".

v2: updated to apply to x86-tip

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 kernel/printk.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -735,9 +735,14 @@ static inline int printk_emit_time(void)
 	unsigned long microsec_rem;
 
 	t = cpu_clock(printk_cpu);
-	microsec_rem = do_div(t, 1000000000) / 1000;
-	tlen = sprintf(tbuf, "[%5lu.%06lu] ", (unsigned long)t, microsec_rem);
-
+	if (likely(t)) {
+		microsec_rem = do_div(t, 1000000000) / 1000;
+		tlen = sprintf(tbuf, "[%5lu.%06lu] ",
+					(unsigned long)t, microsec_rem);
+	} else {
+		/* reduce byte count in log when time is zero */
+		tlen = sprintf(tbuf, "[0] ");
+	}
 	for (tp = tbuf; tp < tbuf + tlen; tp++)
 		emit_log_char(*tp);
 

-- 
