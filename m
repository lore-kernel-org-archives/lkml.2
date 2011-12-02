Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1LBLAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:00:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab1LBLAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:00:07 -0500
Date: Fri, 2 Dec 2011 02:59:45 -0800
From: tip-bot for Ido Yariv <ido@wizery.com>
Message-ID: <tip-550acb19269d65f32e9ac4ddb26c2b2070e37f1c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ido@wizery.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, ido@wizery.com
In-Reply-To: <1322740508-22640-1-git-send-email-ido@wizery.com>
References: <1322740508-22640-1-git-send-email-ido@wizery.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Fix race condition when stopping the irq thread
Git-Commit-ID: 550acb19269d65f32e9ac4ddb26c2b2070e37f1c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 02 Dec 2011 02:59:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  550acb19269d65f32e9ac4ddb26c2b2070e37f1c
Gitweb:     http://git.kernel.org/tip/550acb19269d65f32e9ac4ddb26c2b2070e37f1c
Author:     Ido Yariv <ido@wizery.com>
AuthorDate: Thu, 1 Dec 2011 13:55:08 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 2 Dec 2011 11:54:24 +0100

genirq: Fix race condition when stopping the irq thread

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
Cc: stable@kernel.org
---
 kernel/irq/manage.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0e2b179..1da999f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -623,8 +623,9 @@ static irqreturn_t irq_nested_primary_handler(int irq, void *dev_id)
 
 static int irq_wait_for_interrupt(struct irqaction *action)
 {
+	set_current_state(TASK_INTERRUPTIBLE);
+
 	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (test_and_clear_bit(IRQTF_RUNTHREAD,
 				       &action->thread_flags)) {
@@ -632,7 +633,9 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 			return 0;
 		}
 		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
 	}
+	__set_current_state(TASK_RUNNING);
 	return -1;
 }
 
