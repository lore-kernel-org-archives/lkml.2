Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2C2Jxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:53:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34219 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab2C2Jxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:53:43 -0400
Date: Thu, 29 Mar 2012 02:53:32 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-f3f79e38d51f8a419f4c484a86ece4baea35b993@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20120321162234.GP24806@dhcp-26-207.brq.redhat.com>
References: <20120321162234.GP24806@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq:
  Get rid of unneeded force parameter in irq_finalize_oneshot()
Git-Commit-ID: f3f79e38d51f8a419f4c484a86ece4baea35b993
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Mar 2012 02:53:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3f79e38d51f8a419f4c484a86ece4baea35b993
Gitweb:     http://git.kernel.org/tip/f3f79e38d51f8a419f4c484a86ece4baea35b993
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Wed, 21 Mar 2012 17:22:35 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Mar 2012 11:31:53 +0200

genirq: Get rid of unneeded force parameter in irq_finalize_oneshot()

The only place irq_finalize_oneshot() is called with force parameter set
is the threaded handler error exit path. But IRQTF_RUNTHREAD is dropped
at this point and irq_wake_thread() is not going to set it again,
since PF_EXITING is set for this thread already. So irq_finalize_oneshot()
will drop the threads bit in threads_oneshot anyway and hence the force
parameter is superfluous.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/20120321162234.GP24806@dhcp-26-207.brq.redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index b0ccd1a..bf606a5 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -645,7 +645,7 @@ static int irq_wait_for_interrupt(struct irqaction *action)
  * is marked MASKED.
  */
 static void irq_finalize_oneshot(struct irq_desc *desc,
-				 struct irqaction *action, bool force)
+				 struct irqaction *action)
 {
 	if (!(desc->istate & IRQS_ONESHOT))
 		return;
@@ -679,7 +679,7 @@ again:
 	 * we would clear the threads_oneshot bit of this thread which
 	 * was just set.
 	 */
-	if (!force && test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	if (test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 		goto out_unlock;
 
 	desc->threads_oneshot &= ~action->thread_mask;
@@ -739,7 +739,7 @@ irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
 
 	local_bh_disable();
 	ret = action->thread_fn(action->irq, action->dev_id);
-	irq_finalize_oneshot(desc, action, false);
+	irq_finalize_oneshot(desc, action);
 	local_bh_enable();
 	return ret;
 }
@@ -755,7 +755,7 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
 	irqreturn_t ret;
 
 	ret = action->thread_fn(action->irq, action->dev_id);
-	irq_finalize_oneshot(desc, action, false);
+	irq_finalize_oneshot(desc, action);
 	return ret;
 }
 
@@ -844,7 +844,7 @@ void exit_irq_thread(void)
 		wake_threads_waitq(desc);
 
 	/* Prevent a stale desc->threads_oneshot */
-	irq_finalize_oneshot(desc, action, true);
+	irq_finalize_oneshot(desc, action);
 }
 
 static void irq_setup_forced_threading(struct irqaction *new)
