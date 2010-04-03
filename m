Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab0DCJ2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 05:28:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:60858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab0DCJ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 05:28:29 -0400
Date: Sat, 3 Apr 2010 09:28:06 GMT
From: tip-bot for Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, julia@diku.dk, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <Pine.LNX.4.64.1003291736440.21896@ask.diku.dk>
References: <Pine.LNX.4.64.1003291736440.21896@ask.diku.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ring-buffer: Add missing unlock
Message-ID: <tip-292f60c0c4ab44aa2d589ba03c12e64a3b3c5e38@git.kernel.org>
Git-Commit-ID: 292f60c0c4ab44aa2d589ba03c12e64a3b3c5e38
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 03 Apr 2010 09:28:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  292f60c0c4ab44aa2d589ba03c12e64a3b3c5e38
Gitweb:     http://git.kernel.org/tip/292f60c0c4ab44aa2d589ba03c12e64a3b3c5e38
Author:     Julia Lawall <julia@diku.dk>
AuthorDate: Mon, 29 Mar 2010 17:37:02 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 29 Mar 2010 15:23:24 -0400

ring-buffer: Add missing unlock

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
 
