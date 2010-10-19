Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0JSTmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 15:42:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53586 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab0JSTmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 15:42:06 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=ksSMnZPdK_EA:10 a=HRn4fpiT8EsA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=WuZ4ZFVFXnlC1iJpLo4A:9 a=u7klmoz3noR3SwJhM3-dfs1FW0cA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=JbYq4k0lO0tzsvLY:21 a=efMSToZSwOiIxC0E:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101019194203.513233947@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 13:54:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/5] ring-buffer: Make write slow path out of line
References: <20101019175432.854431527@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Make-write-slow-path-out-of-line.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Gcc inlines the slow path of the ring buffer write which can
hurt performance. This patch simply forces the slow path function
rb_move_tail() to always be a function.

The ring_buffer_benchmark module with reader_disabled=1 shows that
this patch changes the time to record an event from 135 ns to
132 ns. (3 ns or 2.22% improvement)

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bca9637..0b88df8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1823,7 +1823,10 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	local_sub(length, &tail_page->write);
 }
 
-static struct ring_buffer_event *
+/*
+ * This is the slow path, force gcc not to inline it.
+ */
+static noinline struct ring_buffer_event *
 rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	     unsigned long length, unsigned long tail,
 	     struct buffer_page *tail_page, u64 *ts)
@@ -1943,7 +1946,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	tail = write - length;
 
 	/* See if we shot pass the end of this buffer page */
-	if (write > BUF_PAGE_SIZE)
+	if (unlikely(write > BUF_PAGE_SIZE))
 		return rb_move_tail(cpu_buffer, length, tail,
 				    tail_page, ts);
 
-- 
1.7.1


