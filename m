Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab1LGQZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:25:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934009Ab1LGQZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:22 2011
Message-Id: <20111207161222.180814538@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:32 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Ido Yariv <ido@wizery.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [090/104] genirq: Fix race condition when stopping the irq thread
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Yariv <ido@wizery.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/manage.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -620,8 +620,9 @@ static irqreturn_t irq_nested_primary_ha
 
 static int irq_wait_for_interrupt(struct irqaction *action)
 {
+	set_current_state(TASK_INTERRUPTIBLE);
+
 	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (test_and_clear_bit(IRQTF_RUNTHREAD,
 				       &action->thread_flags)) {
@@ -629,7 +630,9 @@ static int irq_wait_for_interrupt(struct
 			return 0;
 		}
 		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
 	}
+	__set_current_state(TASK_RUNNING);
 	return -1;
 }
 


