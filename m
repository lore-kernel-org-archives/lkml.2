Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0C3DAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 23:00:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab0C3DAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 23:00:08 -0400
X-Authority-Analysis: v=1.1 cv=8Rq9yliVGc3GxcN10kx+g7e/eWPAtZnInWtRlahw0rA= c=1 sm=0 a=Yn1NNCqElSgA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=YgwN3AOMAAAA:8 a=meVymXHHAAAA:8 a=aDKd03vN83iETk1HISEA:9 a=L-eaKcHn3eGKfouM-vUA:7 a=wTeIY82SsxzZEI_rrxVgGU2hVyUA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100330030006.132898398@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 29 Mar 2010 22:58:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>
Subject: [PATCH 2/2] ring-buffer: Add missing unlock
References: <20100330025800.713540457@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Add-missing-unlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In some error handling cases the lock is not unlocked.  The return is
converted to a goto, to share the unlock at the end of the function.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irq (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
LKML-Reference: <Pine.LNX.4.64.1003291736440.21896@ask.diku.dk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d1187ef..9a0f9bf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1209,18 +1209,19 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 
 	for (i = 0; i < nr_pages; i++) {
 		if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
-			return;
+			goto out;
 		p = cpu_buffer->pages->next;
 		bpage = list_entry(p, struct buffer_page, list);
 		list_del_init(&bpage->list);
 		free_buffer_page(bpage);
 	}
 	if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
-		return;
+		goto out;
 
 	rb_reset_cpu(cpu_buffer);
 	rb_check_pages(cpu_buffer);
 
+out:
 	spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
@@ -1237,7 +1238,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 	for (i = 0; i < nr_pages; i++) {
 		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
-			return;
+			goto out;
 		p = pages->next;
 		bpage = list_entry(p, struct buffer_page, list);
 		list_del_init(&bpage->list);
@@ -1246,6 +1247,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	rb_reset_cpu(cpu_buffer);
 	rb_check_pages(cpu_buffer);
 
+out:
 	spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
-- 
1.7.0


