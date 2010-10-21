Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab0JUBnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:43:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab0JUBlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:41:45 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=djPu0a7obAEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=r6aLdKM3-xg4F1t_Hb8A:9 a=ufeoqORMrshB0DV-i85YR-ma3m8A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101021014143.306896272@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Oct 2010 21:39:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 3/8] ring-buffer: Pass delta by value and not by reference
References: <20101021013906.507064528@goodmis.org>
Content-Disposition: inline; filename=0003-ring-buffer-Pass-delta-by-value-and-not-by-reference.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The delta between events is passed to the timestamp code by reference
and the timestamp code will reset the value. But it can be reset
from the caller. No need to pass it in by reference.

By changing the call to pass by value, lets gcc optimize the code
a bit more where it can store the delta in a register and not
worry about updating the reference.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c8ce6bd..3af77cd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2008,14 +2008,14 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 
 static int
 rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
-		  u64 ts, u64 *delta)
+		  u64 ts, u64 delta)
 {
 	struct ring_buffer_event *event;
 	int ret;
 
-	WARN_ONCE(*delta > (1ULL << 59),
+	WARN_ONCE(delta > (1ULL << 59),
 		  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
-		  (unsigned long long)*delta,
+		  (unsigned long long)delta,
 		  (unsigned long long)ts,
 		  (unsigned long long)cpu_buffer->write_stamp);
 
@@ -2041,8 +2041,8 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		 * and if we can't just make it zero.
 		 */
 		if (rb_event_index(event)) {
-			event->time_delta = *delta & TS_MASK;
-			event->array[0] = *delta >> TS_SHIFT;
+			event->time_delta = delta & TS_MASK;
+			event->array[0] = delta >> TS_SHIFT;
 		} else {
 			/* try to discard, since we do not need this */
 			if (!rb_try_to_discard(cpu_buffer, event)) {
@@ -2064,8 +2064,6 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		ret = 0;
 	}
 
-	*delta = 0;
-
 	return ret;
 }
 
@@ -2175,7 +2173,9 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 		delta = diff;
 		if (unlikely(test_time_stamp(delta))) {
 
-			commit = rb_add_time_stamp(cpu_buffer, ts, &delta);
+			commit = rb_add_time_stamp(cpu_buffer, ts, delta);
+			delta = 0;
+
 			if (commit == -EBUSY)
 				goto out_fail;
 
-- 
1.7.1


