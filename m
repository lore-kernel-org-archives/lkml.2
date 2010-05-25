Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab0EYQO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:14:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42601 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab0EYQOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:14:01 -0400
X-Authority-Analysis: v=1.1 cv=Pm0qIGCwx3bIEOZlSg1a56K3RSwKBTW9sPEb+DFvEKk= c=1 sm=0 a=ZFhThlrqerAA:10 a=yQWWgrYGNuUA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=YsutFaGuW-MPxZOjv9QA:9 a=q1HI4eE6oqj9MaDlzGcA:7 a=315Fj_-sZPZMndpp597v4DjSCrIA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100525161358.685469182@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 25 May 2010 12:13:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] ring-buffer: Reset "real_end" when page is filled
References: <20100525161259.568803673@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Reset-real_end-when-page-is-filled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code to store the "lost events" requires knowing the real end
of the page. Since the 'commit' includes the padding at the end of
a page a "real_end" variable was used to keep track of the end not
including the padding.

If events were lost, the reader can place the count of events in
the padded area if there is enough room.

The bug this patch fixes is that when we fill the page we do not
reset the real_end variable, and if the writer had wrapped a few
times, the real_end would be incorrect.

This patch simply resets the real_end if the page was filled.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7f6059c..b0702ff 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1768,6 +1768,14 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	 * must fill the old tail_page with padding.
 	 */
 	if (tail >= BUF_PAGE_SIZE) {
+		/*
+		 * If the page was filled, then we still need
+		 * to update the real_end. Reset it to zero
+		 * and the reader will ignore it.
+		 */
+		if (tail == BUF_PAGE_SIZE)
+			tail_page->real_end = 0;
+
 		local_sub(length, &tail_page->write);
 		return;
 	}
-- 
1.7.0


