Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab0EYQOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:14:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42601 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0EYQOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:14:00 -0400
X-Authority-Analysis: v=1.1 cv=Pm0qIGCwx3bIEOZlSg1a56K3RSwKBTW9sPEb+DFvEKk= c=1 sm=0 a=yG9yfhoXnIAA:10 a=Lw_SFsgOoS4A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=d7eSZY6_Nm5AFN8oLAUA:9 a=1VHoxw2qBkDpkzqNzKYA:7 a=eUwwPOB1cLSRbz9bOsDuyWkGLtIA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100525161358.966210545@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 25 May 2010 12:13:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] ring-buffer: Move zeroing out excess in page to ring buffer code
References: <20100525161259.568803673@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Move-zeroing-out-excess-in-page-to-ring-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the trace splice code zeros out the excess bytes in the page before
sending it off to userspace.

This is to make sure userspace is not getting anything it should not be
when reading the pages, because the excess data was never initialized
to zero before writing (for perfomance reasons).

But the splice code has no business in doing this work, it should be
done by the ring buffer. With the latest changes for recording lost
events, the splice code gets it wrong anyway.

Move the zeroing out of excess bytes into the ring buffer code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   11 +++++++++--
 kernel/trace/trace.c       |    6 ------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b0702ff..1da7b6e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3902,12 +3902,12 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	ret = read;
 
 	cpu_buffer->lost_events = 0;
+
+	commit = local_read(&bpage->commit);
 	/*
 	 * Set a flag in the commit field if we lost events
 	 */
 	if (missed_events) {
-		commit = local_read(&bpage->commit);
-
 		/* If there is room at the end of the page to save the
 		 * missed events, then record it there.
 		 */
@@ -3915,10 +3915,17 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 			memcpy(&bpage->data[commit], &missed_events,
 			       sizeof(missed_events));
 			local_add(RB_MISSED_STORED, &bpage->commit);
+			commit += sizeof(missed_events);
 		}
 		local_add(RB_MISSED_EVENTS, &bpage->commit);
 	}
 
+	/*
+	 * This page may be off to user land. Zero it out here.
+	 */
+	if (commit < BUF_PAGE_SIZE)
+		memset(&bpage->data[commit], 0, BUF_PAGE_SIZE - commit);
+
  out_unlock:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ba0ec81..95d0b1a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3661,7 +3661,6 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 		     size_t count, loff_t *ppos)
 {
 	struct ftrace_buffer_info *info = filp->private_data;
-	unsigned int pos;
 	ssize_t ret;
 	size_t size;
 
@@ -3688,11 +3687,6 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	if (ret < 0)
 		return 0;
 
-	pos = ring_buffer_page_len(info->spare);
-
-	if (pos < PAGE_SIZE)
-		memset(info->spare + pos, 0, PAGE_SIZE - pos);
-
 read:
 	size = PAGE_SIZE - info->read;
 	if (size > count)
-- 
1.7.0


