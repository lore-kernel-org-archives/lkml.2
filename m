Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab0JUBlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:41:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51294 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab0JUBlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:41:45 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=K7y9_FPR6QEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=62K199flotnm_sFGw1QA:9 a=ASs3Tvf2gvuf4oOZkf4A:7 a=Ugl5K_0-de-HwADLE2AvXzoalwQA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Zd61QFVvCyfXxbIs:21 a=wol3ApAiDMPvKDNl:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101021014143.024740462@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Oct 2010 21:39:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 2/8] ring-buffer: Pass timestamp by value and not by reference
References: <20101021013906.507064528@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Pass-timestamp-by-value-and-not-by-refer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The original code for the ring buffer had locations that modified
the timestamp and that change was used by the callers. Now,
the timestamp is not reused by the callers and there is no reason
to pass it by reference.

By changing the call to pass by value, lets gcc optimize the code
a bit more where it can store the timestamp in a register and not
worry about updating the reference.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0b88df8..c8ce6bd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1829,7 +1829,7 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 static noinline struct ring_buffer_event *
 rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	     unsigned long length, unsigned long tail,
-	     struct buffer_page *tail_page, u64 *ts)
+	     struct buffer_page *tail_page, u64 ts)
 {
 	struct buffer_page *commit_page = cpu_buffer->commit_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
@@ -1912,8 +1912,8 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		 * Nested commits always have zero deltas, so
 		 * just reread the time stamp
 		 */
-		*ts = rb_time_stamp(buffer);
-		next_page->page->time_stamp = *ts;
+		ts = rb_time_stamp(buffer);
+		next_page->page->time_stamp = ts;
 	}
 
  out_again:
@@ -1932,7 +1932,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 
 static struct ring_buffer_event *
 __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
-		  unsigned type, unsigned long length, u64 *ts)
+		  unsigned type, unsigned long length, u64 ts)
 {
 	struct buffer_page *tail_page;
 	struct ring_buffer_event *event;
@@ -1965,7 +1965,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	 * its timestamp.
 	 */
 	if (!tail)
-		tail_page->page->time_stamp = *ts;
+		tail_page->page->time_stamp = ts;
 
 	return event;
 }
@@ -2008,7 +2008,7 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 
 static int
 rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
-		  u64 *ts, u64 *delta)
+		  u64 ts, u64 *delta)
 {
 	struct ring_buffer_event *event;
 	int ret;
@@ -2016,7 +2016,7 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 	WARN_ONCE(*delta > (1ULL << 59),
 		  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
 		  (unsigned long long)*delta,
-		  (unsigned long long)*ts,
+		  (unsigned long long)ts,
 		  (unsigned long long)cpu_buffer->write_stamp);
 
 	/*
@@ -2051,7 +2051,7 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 				event->array[0] = 0;
 			}
 		}
-		cpu_buffer->write_stamp = *ts;
+		cpu_buffer->write_stamp = ts;
 		/* let the caller know this was the commit */
 		ret = 1;
 	} else {
@@ -2175,7 +2175,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 		delta = diff;
 		if (unlikely(test_time_stamp(delta))) {
 
-			commit = rb_add_time_stamp(cpu_buffer, &ts, &delta);
+			commit = rb_add_time_stamp(cpu_buffer, ts, &delta);
 			if (commit == -EBUSY)
 				goto out_fail;
 
@@ -2187,7 +2187,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 	}
 
  get_event:
-	event = __rb_reserve_next(cpu_buffer, 0, length, &ts);
+	event = __rb_reserve_next(cpu_buffer, 0, length, ts);
 	if (unlikely(PTR_ERR(event) == -EAGAIN))
 		goto again;
 
-- 
1.7.1


