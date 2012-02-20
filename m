Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab2BTRbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:31:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab2BTRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:31:33 -0500
Date: Mon, 20 Feb 2012 18:31:29 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] genirq: No need to check IRQTF_DIED before stopping a
 thread handler
Message-ID: <20120220173129.GC9313@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 63706172f332fd3f6e7458ebfb35fa6de9c21dc5 kthread_stop() is not
afraid of dead kernel threads. So no need to check if a thread is
alive before stopping it. These checks still were racy.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 kernel/irq/manage.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0fa3ce9..3feab4a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1106,8 +1106,7 @@ out_thread:
 		struct task_struct *t = new->thread;
 
 		new->thread = NULL;
-		if (likely(!test_bit(IRQTF_DIED, &new->thread_flags)))
-			kthread_stop(t);
+		kthread_stop(t);
 		put_task_struct(t);
 	}
 out_mput:
@@ -1217,8 +1216,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 #endif
 
 	if (action->thread) {
-		if (!test_bit(IRQTF_DIED, &action->thread_flags))
-			kthread_stop(action->thread);
+		kthread_stop(action->thread);
 		put_task_struct(action->thread);
 	}
 
-- 
1.7.7.6

