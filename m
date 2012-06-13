Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2FMOM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:12:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62244 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2FMOM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:12:56 -0400
Date: Wed, 13 Jun 2012 16:12:52 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, jolsa@redhat.com
Subject: [PATCH] perf: fix ordering in perf_output_sample()
Message-ID: <20120613141252.GA1417@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems like the merge of commits a7ac67ea and bce38cd5
caused an ordering problem in perf_output_sample().
The watermark check must be done at the very end of the
function and not in the middle of writing data to the buffer.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f85c015..721ba28 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3979,20 +3979,6 @@ void perf_output_sample(struct perf_output_handle *handle,
 		}
 	}
 
-	if (!event->attr.watermark) {
-		int wakeup_events = event->attr.wakeup_events;
-
-		if (wakeup_events) {
-			struct ring_buffer *rb = handle->rb;
-			int events = local_inc_return(&rb->events);
-
-			if (events >= wakeup_events) {
-				local_sub(wakeup_events, &rb->events);
-				local_inc(&rb->wakeup);
-			}
-		}
-	}
-
 	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
 		if (data->br_stack) {
 			size_t size;
@@ -4010,6 +3996,20 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_put(handle, nr);
 		}
 	}
+
+	if (!event->attr.watermark) {
+		int wakeup_events = event->attr.wakeup_events;
+
+		if (wakeup_events) {
+			struct ring_buffer *rb = handle->rb;
+			int events = local_inc_return(&rb->events);
+
+			if (events >= wakeup_events) {
+				local_sub(wakeup_events, &rb->events);
+				local_inc(&rb->wakeup);
+			}
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
