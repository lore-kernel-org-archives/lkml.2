Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1BZQWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 11:22:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:40224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab1BZQWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 11:22:43 -0500
Date: Sat, 26 Feb 2011 16:22:27 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110223234956.483640430@linutronix.de>
References: <20110223234956.483640430@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Allow shared oneshot interrupts
Message-ID: <tip-9d591edd02a245305b1b9379e4c5571bad4d2774@git.kernel.org>
Git-Commit-ID: 9d591edd02a245305b1b9379e4c5571bad4d2774
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 26 Feb 2011 16:22:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d591edd02a245305b1b9379e4c5571bad4d2774
Gitweb:     http://git.kernel.org/tip/9d591edd02a245305b1b9379e4c5571bad4d2774
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 23 Feb 2011 23:52:16 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 25 Feb 2011 20:24:21 +0100

genirq: Allow shared oneshot interrupts

Support ONESHOT on shared interrupts, if all drivers agree on it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110223234956.483640430@linutronix.de>
---
 kernel/irq/manage.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2301de1..58c8613 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -824,10 +824,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		rand_initialize_irq(irq);
 	}
 
-	/* Oneshot interrupts are not allowed with shared */
-	if ((new->flags & IRQF_ONESHOT) && (new->flags & IRQF_SHARED))
-		return -EINVAL;
-
 	/*
 	 * Check whether the interrupt nests into another interrupt
 	 * thread.
@@ -881,10 +877,12 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 * Can't share interrupts unless both agree to and are
 		 * the same type (level, edge, polarity). So both flag
 		 * fields must have IRQF_SHARED set and the bits which
-		 * set the trigger type must match.
+		 * set the trigger type must match. Also all must
+		 * agree on ONESHOT.
 		 */
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
-		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK)) {
+		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
+		    ((old->flags ^ new->flags) & IRQF_ONESHOT)) {
 			old_name = old->name;
 			goto mismatch;
 		}
