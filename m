Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1HJQba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:31:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1HJQal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:30:41 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=vhdKIqpQuCYA:10 a=lHGTug4A1S8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=SpvumKaVcxQ2gLH4gdoA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110810163037.526958442@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 10 Aug 2011 12:22:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/5][RFC] tracing: Clean up tb_fmt to not give faulty compile warning
References: <20110810162222.017387055@goodmis.org>
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


