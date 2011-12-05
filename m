Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab1LETEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:04:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56459 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab1LETEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:04:38 -0500
Date: Mon, 5 Dec 2011 20:03:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fix
Message-ID: <20111205190302.GA29557@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

 Thanks,

	Ingo

------------------>
Ido Yariv (1):
      genirq: Fix race condition when stopping the irq thread


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
 
