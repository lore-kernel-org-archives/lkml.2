Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0JUBl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:41:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57408 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab0JUBlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:41:46 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=qmGXitUeCfEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=HJudcVsSSnB4qObBnHgA:9 a=SOPH0zFicfF_0Zb7ZVoA:7 a=vDhfRWXAFMIkokmurdiyBUQQhlgA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101021014144.166464421@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Oct 2010 21:39:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 6/8] ring-buffer: Remove condition to add timestamp in fast path
References: <20101021013906.507064528@goodmis.org>
Content-Disposition: inline; filename=0006-ring-buffer-Remove-condition-to-add-timestamp-in-fas.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There's a condition to check if we should add a time extend or
not in the fast path. But this condition is racey (in the sense
that we can add a unnecessary time extend, but nothing that
can break anything). We later check if the time or event time
delta should be zero or have real data in it (not racey), making
this first check redundant.

This check may help save space once in a while, but really is
not worth the hassle to try to save some space that happens at
most 134 ms at a time.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   28 ++++++----------------------
 1 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f50f431..d9f3e7a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2119,6 +2119,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 	u64 ts, delta;
 	int nr_loops = 0;
 	int add_timestamp;
+	u64 diff;
 
 	rb_start_commit(cpu_buffer);
 
@@ -2155,29 +2156,13 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 		goto out_fail;
 
 	ts = rb_time_stamp(cpu_buffer->buffer);
+	diff = ts - cpu_buffer->write_stamp;
 
-	/*
-	 * Only the first commit can update the timestamp.
-	 * Yes there is a race here. If an interrupt comes in
-	 * just after the conditional and it traces too, then it
-	 * will also check the deltas. More than one timestamp may
-	 * also be made. But only the entry that did the actual
-	 * commit will be something other than zero.
-	 */
-	if (likely(cpu_buffer->tail_page == cpu_buffer->commit_page &&
-		   rb_page_write(cpu_buffer->tail_page) ==
-		   rb_commit_index(cpu_buffer))) {
-		u64 diff;
-
-		diff = ts - cpu_buffer->write_stamp;
-
-		/* make sure this diff is calculated here */
-		barrier();
-
-		/* Did the write stamp get updated already? */
-		if (unlikely(ts < cpu_buffer->write_stamp))
-			goto get_event;
+	/* make sure this diff is calculated here */
+	barrier();
 
+	/* Did the write stamp get updated already? */
+	if (likely(ts >= cpu_buffer->write_stamp)) {
 		delta = diff;
 		if (unlikely(test_time_stamp(delta))) {
 			WARN_ONCE(delta > (1ULL << 59),
@@ -2189,7 +2174,6 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 		}
 	}
 
- get_event:
 	event = __rb_reserve_next(cpu_buffer, length, ts,
 				  delta, add_timestamp);
 	if (unlikely(PTR_ERR(event) == -EAGAIN))
-- 
1.7.1


