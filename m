Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0C2PhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:37:11 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:48629 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0C2PhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:37:08 -0400
Date: Mon, 29 Mar 2010 17:37:02 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 12/12] kernel/trace: Add missing unlock
Message-ID: <Pine.LNX.4.64.1003291736440.21896@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

---
 kernel/trace/ring_buffer.c          |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 05a9f83..cd2e1d8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1201,18 +1201,19 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 
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
 
@@ -1229,7 +1230,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 	for (i = 0; i < nr_pages; i++) {
 		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
-			return;
+			goto out;
 		p = pages->next;
 		bpage = list_entry(p, struct buffer_page, list);
 		list_del_init(&bpage->list);
@@ -1238,6 +1239,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	rb_reset_cpu(cpu_buffer);
 	rb_check_pages(cpu_buffer);
 
+out:
 	spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
