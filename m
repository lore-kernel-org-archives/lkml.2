Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab0D1BjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:39:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab0D1BiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:38:08 -0400
X-Authority-Analysis: v=1.1 cv=2/WNtoURsBD4grC4Rqfj62/w1mAETqRJkFX1sgq41IM= c=1 sm=0 a=l5_svUC8jLoA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=p107fHWvrvHwk4ZKU_wA:9 a=_DJYX4KBZceK50rXYCcVX9JlhSYA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100428013806.758542898@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Apr 2010 21:27:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/8] ring-buffer: Make benchmark handle missed events
References: <20100428012723.119106602@goodmis.org>
Content-Disposition: inline; filename=0005-ring-buffer-Make-benchmark-handle-missed-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With the addition of the "missed events" flags that is stored in the
commit field of the ring buffer page, the ring_buffer_benchmark
was not updated to handle this. If events are missed, then the
missed events flag is set in the ring buffer page, the benchmark
will count that flag as part of the size of the page and will hit the BUG()
when it tries to read beyond the page.

The solution is simply to have the ring buffer benchmark mask off
the extra bits.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer_benchmark.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index dc56556..302f8a6 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -113,7 +113,8 @@ static enum event_status read_page(int cpu)
 	ret = ring_buffer_read_page(buffer, &bpage, PAGE_SIZE, cpu, 1);
 	if (ret >= 0) {
 		rpage = bpage;
-		commit = local_read(&rpage->commit);
+		/* The commit may have missed event flags set, clear them */
+		commit = local_read(&rpage->commit) & 0xfffff;
 		for (i = 0; i < commit && !kill_test; i += inc) {
 
 			if (i >= (PAGE_SIZE - offsetof(struct rb_page, data))) {
-- 
1.7.0


