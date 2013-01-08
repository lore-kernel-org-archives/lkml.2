Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3AHXvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:51:10 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53648 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab3AHXh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:29 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ido Yariv <ido@wizery.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 41/77] genirq: Fix race condition when stopping the irq thread
Date: Tue, 8 Jan 2013 18:35:20 -0500
Message-ID: <1357688156-25387-42-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ido Yariv <ido@wizery.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 550acb19269d65f32e9ac4ddb26c2b2070e37f1c upstream.

In irq_wait_for_interrupt(), the should_stop member is verified before
setting the task's state to TASK_INTERRUPTIBLE and calling schedule().
In case kthread_stop sets should_stop and wakes up the process after
should_stop is checked by the irq thread but before the task's state
is changed, the irq thread might never exit:

kthread_stop                    irq_wait_for_interrupt
------------                    ----------------------

                                 ...
...                              while (!kthread_should_stop()) {
kthread->should_stop = 1;
wake_up_process(k);
wait_for_completion(&kthread->exited);
...
                                     set_current_state(TASK_INTERRUPTIBLE);

                                     ...

                                     schedule();
                                 }

Fix this by checking if the thread should stop after modifying the
task's state.

[ tglx: Simplified it a bit ]

Signed-off-by: Ido Yariv <ido@wizery.com>
Link: http://lkml.kernel.org/r/1322740508-22640-1-git-send-email-ido@wizery.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/irq/manage.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 9080985..8668523 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -479,8 +479,9 @@ static irqreturn_t irq_nested_primary_handler(int irq, void *dev_id)
 
 static int irq_wait_for_interrupt(struct irqaction *action)
 {
+	set_current_state(TASK_INTERRUPTIBLE);
+
 	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (test_and_clear_bit(IRQTF_RUNTHREAD,
 				       &action->thread_flags)) {
@@ -488,7 +489,9 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 			return 0;
 		}
 		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
 	}
+	__set_current_state(TASK_RUNNING);
 	return -1;
 }
 
-- 
1.7.12.1

