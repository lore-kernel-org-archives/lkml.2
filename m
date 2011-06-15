Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1FONzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:55:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab1FONwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:52:37 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=wRsxznEwhCEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=KafphG0z4mm1vLWHmeAA:9 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110615135233.668997490@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Jun 2011 09:48:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 04/16 v2] tracing: Add disable_on_free option
References: <20110615134841.767565350@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Add-disable_on_free-option.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add a trace option to disable tracing on free. When this option is
set, a write into the free_buffer file will not only shrink the
ring buffer down to zero, but it will also disable tracing.

Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 ++++--
 kernel/trace/trace.h |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9c557ae..42fdf3a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -425,6 +425,7 @@ static const char *trace_options[] = {
 	"graph-time",
 	"record-cmd",
 	"overwrite",
+	"disable_on_free",
 	NULL
 };
 
@@ -3518,8 +3519,9 @@ tracing_free_buffer_write(struct file *filp, const char __user *ubuf,
 static int
 tracing_free_buffer_release(struct inode *inode, struct file *filp)
 {
-	/* disable tracing */
-	tracing_off();
+	/* disable tracing ? */
+	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
+		tracing_off();
 	/* resize the ring buffer to 0 */
 	tracing_resize_ring_buffer(0);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 229f859..742f545 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -609,6 +609,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_GRAPH_TIME		= 0x80000,
 	TRACE_ITER_RECORD_CMD		= 0x100000,
 	TRACE_ITER_OVERWRITE		= 0x200000,
+	TRACE_ITER_STOP_ON_FREE		= 0x400000,
 };
 
 /*
-- 
1.7.4.4


