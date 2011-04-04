Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1DDTSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 15:18:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42850 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab1DDTSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 15:18:33 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=pDOKfcMg7l0A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Iwdc0ePNTnk39Rv0CJYA:9 a=lSu7IAUlkRtUQclLTHkA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110404191831.917976310@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 04 Apr 2011 15:16:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/6] tracing: Convert trace_printk() formats for module to const char *
References: <20110404191654.006849945@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Convert-trace_printk-formats-for-module-to-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The trace_printk() formats for modules do not show up in the
debugfs/tracing/printk_formats file. Only the formats that are
for trace_printk()s that are in the kernel core.

To facilitate the change to add trace_printk() formats from modules
into that file as well, we need to convert the structure that
holds the formats from char fmt[], into const char *fmt,
and allocate them separately.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_printk.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 2547d88..b8b2681 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -32,7 +32,7 @@ static DEFINE_MUTEX(btrace_mutex);
 
 struct trace_bprintk_fmt {
 	struct list_head list;
-	char fmt[0];
+	const char *fmt;
 };
 
 static inline struct trace_bprintk_fmt *lookup_format(const char *fmt)
@@ -49,6 +49,7 @@ static
 void hold_module_trace_bprintk_format(const char **start, const char **end)
 {
 	const char **iter;
+	char *fmt;
 
 	mutex_lock(&btrace_mutex);
 	for (iter = start; iter < end; iter++) {
@@ -58,14 +59,18 @@ void hold_module_trace_bprintk_format(const char **start, const char **end)
 			continue;
 		}
 
-		tb_fmt = kmalloc(offsetof(struct trace_bprintk_fmt, fmt)
-				+ strlen(*iter) + 1, GFP_KERNEL);
-		if (tb_fmt) {
+		tb_fmt = kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
+		if (tb_fmt)
+			fmt = kmalloc(strlen(*iter) + 1, GFP_KERNEL);
+		if (tb_fmt && fmt) {
 			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
-			strcpy(tb_fmt->fmt, *iter);
+			strcpy(fmt, *iter);
+			tb_fmt->fmt = fmt;
 			*iter = tb_fmt->fmt;
-		} else
+		} else {
+			kfree(tb_fmt);
 			*iter = NULL;
+		}
 	}
 	mutex_unlock(&btrace_mutex);
 }
-- 
1.7.2.3


