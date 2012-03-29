Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2C2JxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:53:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2C2Jwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:52:54 -0400
Date: Thu, 29 Mar 2012 02:52:42 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-69592db298e400a7c175c4dfbe7a086c783f349d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20120321162212.GO24806@dhcp-26-207.brq.redhat.com>
References: <20120321162212.GO24806@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq:
  Minor readablity improvement in irq_wake_thread()
Git-Commit-ID: 69592db298e400a7c175c4dfbe7a086c783f349d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Mar 2012 02:52:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69592db298e400a7c175c4dfbe7a086c783f349d
Gitweb:     http://git.kernel.org/tip/69592db298e400a7c175c4dfbe7a086c783f349d
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Wed, 21 Mar 2012 17:22:13 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 29 Mar 2012 11:31:52 +0200

genirq: Minor readablity improvement in irq_wake_thread()

exit_irq_thread() clears IRQTF_RUNTHREAD flag and drops the thread's bit in
desc->threads_oneshot then. The bit must not be set again in between and it
does not, since irq_wake_thread() sees PF_EXITING flag first and returns.

Due to above the order or checking PF_EXITING and IRQTF_RUNTHREAD flags in
irq_wake_thread() is important. This change just makes it more visible in the
source code.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/20120321162212.GO24806@dhcp-26-207.brq.redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/handle.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 6ff84e6..bdb1803 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -54,14 +54,18 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 {
 	/*
-	 * Wake up the handler thread for this action. In case the
-	 * thread crashed and was killed we just pretend that we
-	 * handled the interrupt. The hardirq handler has disabled the
-	 * device interrupt, so no irq storm is lurking. If the
+	 * In case the thread crashed and was killed we just pretend that
+	 * we handled the interrupt. The hardirq handler has disabled the
+	 * device interrupt, so no irq storm is lurking.
+	 */
+	if (action->thread->flags & PF_EXITING)
+		return;
+
+	/*
+	 * Wake up the handler thread for this action. If the
 	 * RUNTHREAD bit is already set, nothing to do.
 	 */
-	if ((action->thread->flags & PF_EXITING) ||
-	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	if (test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 		return;
 
 	/*
