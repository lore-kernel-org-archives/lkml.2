Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab1AUUZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:25:51 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49022 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab1AUUZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:25:06 -0500
Message-Id: <20110121202504.796868924@gulag1.americas.sgi.com>
References: <20110121202502.090169599@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 21 Jan 2011 14:25:08 -0600
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <len.brown@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] printk: Minimize time zero output
Content-Disposition: inline; filename=minimize-time-zero-msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the length for time zero messages by only printing "[0] ".

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 kernel/printk.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/kernel/printk.c
+++ linux-2.6.32/kernel/printk.c
@@ -805,11 +805,14 @@ asmlinkage int vprintk(const char *fmt,
 				unsigned long nanosec_rem;
 
 				t = cpu_clock(printk_cpu);
-				nanosec_rem = do_div(t, 1000000000);
-				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
+				if (likely(t)) {
+					nanosec_rem = do_div(t, 1000000000);
+					tlen = sprintf(tbuf, "[%5lu.%06lu] ",
 						(unsigned long) t,
 						nanosec_rem / 1000);
-
+				} else {
+					tlen = sprintf(tbuf, "[0] ");
+				}
 				for (tp = tbuf; tp < tbuf + tlen; tp++)
 					emit_log_char(*tp);
 				printed_len += tlen;

-- 
