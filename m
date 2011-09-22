Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab1IVWK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:10:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab1IVWK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:27 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=KJLu93DRuIAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=SpvumKaVcxQ2gLH4gdoA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221024.727772346@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 01/21] tracing: Clean up tb_fmt to not give faulty compile warning
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Clean-up-tb_fmt-to-not-give-faulty-compile-w.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

gcc incorrectly states that the variable "fmt" is uninitialized when
CC_OPITMIZE_FOR_SIZE is set.

Instead of just blindly setting fmt to NULL, the code is cleaned up
a little to be a bit easier for humans to follow, as well as gcc
to know the variables are initialized.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_printk.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 1f06468..6fd4ffd 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -59,18 +59,19 @@ void hold_module_trace_bprintk_format(const char **start, const char **end)
 			continue;
 		}
 
+		fmt = NULL;
 		tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
-		if (tb_fmt)
+		if (tb_fmt) {
 			fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
-		if (tb_fmt && fmt) {
-			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
-			strcpy(fmt, *iter);
-			tb_fmt->fmt = fmt;
-			*iter = tb_fmt->fmt;
-		} else {
-			kfree(tb_fmt);
-			*iter = NULL;
+			if (fmt) {
+				list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
+				strcpy(fmt, *iter);
+				tb_fmt->fmt = fmt;
+			} else
+				kfree(tb_fmt);
 		}
+		*iter = fmt;
+
 	}
 	mutex_unlock(&btrace_mutex);
 }
-- 
1.7.5.4


