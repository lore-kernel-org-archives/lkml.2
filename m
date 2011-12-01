Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1LALz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:55:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47833 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab1LALz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:55:28 -0500
From: Ido Yariv <ido@wizery.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH] irq: Fix race condition when stopping the irq thread
Date: Thu,  1 Dec 2011 13:55:08 +0200
Message-Id: <1322740508-22640-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In irq_wait_for_interrupt(), the should_stop member is verified before
setting the task's state to TASK_INTERRUPTIBLE and calling schedule().
In case kthread_stop sets should_stop and wakes up the process after
should_stop is checked by the irq thread but before the task's state is
changed, the irq thread might never exit:

kthread_stop                            irq_wait_for_interrupt
------------                            ----------------------

                                        ...
...                                     while (!kthread_should_stop()) {
kthread->should_stop = 1;
wake_up_process(k);
wait_for_completion(&kthread->exited);
...
                                            set_current_state(TASK_INTERRUPTIBLE);

                                            ...

                                            schedule();
                                        }
                                        ...

Fix this by checking if the thread should stop after modifying the
task's state.

Signed-off-by: Ido Yariv <ido@wizery.com>
Cc: stable@kernel.org
---
 kernel/irq/manage.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0e2b179..3194d5e 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -631,7 +631,11 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 			__set_current_state(TASK_RUNNING);
 			return 0;
 		}
-		schedule();
+
+		if (!kthread_should_stop())
+			schedule();
+		else
+			__set_current_state(TASK_RUNNING);
 	}
 	return -1;
 }
-- 
1.7.7.3

