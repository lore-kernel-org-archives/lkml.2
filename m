Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422688Ab2CPKeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:34:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36755 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161594Ab2CPKem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:34:42 -0400
Date: Fri, 16 Mar 2012 03:34:31 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-e04268b0effc0ceea366c50b3107baad9edadafa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@redhat.com, ido@wizery.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, ido@wizery.com
In-Reply-To: <20120315190755.GA6732@dhcp-26-207.brq.redhat.com>
References: <20120315190755.GA6732@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Remove paranoid warnons and bogus fixups
Git-Commit-ID: e04268b0effc0ceea366c50b3107baad9edadafa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 16 Mar 2012 03:34:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e04268b0effc0ceea366c50b3107baad9edadafa
Gitweb:     http://git.kernel.org/tip/e04268b0effc0ceea366c50b3107baad9edadafa
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Mar 2012 22:55:21 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 Mar 2012 11:27:28 +0100

genirq: Remove paranoid warnons and bogus fixups

Alexander pointed out that the warnons in the regular exit path are
bogus and the thread_mask one actually could be triggered when
__setup_irq() hands out that thread_mask again after __free_irq()
dropped irq_desc->lock.

Thinking more about it, neither IRQTF_RUNTHREAD nor the bit in
thread_mask can be set as this is the regular exit path. We come here
due to:
	__free_irq()
	   remove action from desc
	   synchronize_irq()
	   kthread_stop()

So synchronize_irq() makes sure that the thread finished running and
cleaned up both the thread_active count and thread_mask. After that
point nothing can set IRQTF_RUNTHREAD on this action. So the warnons
and the cleanups are pointless.

Reported-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Ido Yariv <ido@wizery.com>
Link: http://lkml.kernel.org/r/20120315190755.GA6732@dhcp-26-207.brq.redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 453feed..b0ccd1a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -804,17 +804,11 @@ static int irq_thread(void *data)
 	 * This is the regular exit path. __free_irq() is stopping the
 	 * thread via kthread_stop() after calling
 	 * synchronize_irq(). So neither IRQTF_RUNTHREAD nor the
-	 * oneshot mask bit should be set.
+	 * oneshot mask bit can be set. We cannot verify that as we
+	 * cannot touch the oneshot mask at this point anymore as
+	 * __setup_irq() might have given out currents thread_mask
+	 * again.
 	 *
-	 * Verify that this is true.
-	 */
-	if (WARN_ON(test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags)))
-		wake_threads_waitq(desc);
-
-	if (WARN_ON(desc->threads_oneshot & action->thread_mask))
-		irq_finalize_oneshot(desc, action, true);
-
-	/*
 	 * Clear irq_thread. Otherwise exit_irq_thread() would make
 	 * fuzz about an active irq thread going into nirvana.
 	 */
