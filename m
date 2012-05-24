Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab2EXUwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:52:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268Ab2EXUwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:52:47 -0400
Date: Thu, 24 May 2012 13:52:34 -0700
From: tip-bot for Ning Jiang <ning.n.jiang@gmail.com>
Message-ID: <tip-23812b9d9e497580d38c62ebdc6f308733b0a32a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ning.n.jiang@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ning.n.jiang@gmail.com, tglx@linutronix.de
In-Reply-To: <CAH3Oq6T905+3fkF43NAMMFvJvq7dsk_so6T2vQ8ZJrA5xiU3YA@mail.gmail.com>
References: <CAH3Oq6T905+3fkF43NAMMFvJvq7dsk_so6T2vQ8ZJrA5xiU3YA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add IRQS_PENDING for nested and simple irq
Git-Commit-ID: 23812b9d9e497580d38c62ebdc6f308733b0a32a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 13:52:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23812b9d9e497580d38c62ebdc6f308733b0a32a
Gitweb:     http://git.kernel.org/tip/23812b9d9e497580d38c62ebdc6f308733b0a32a
Author:     Ning Jiang <ning.n.jiang@gmail.com>
AuthorDate: Tue, 22 May 2012 00:19:20 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 24 May 2012 22:27:45 +0200

genirq: Add IRQS_PENDING for nested and simple irq

Every interrupt which is an active wakeup source needs the ability to
abort suspend if there is a pending irq. Right now only edge and level
irqs can do that.

            |
       +---------+
       |   INTC  |
       +---------+
               | GPIO_IRQ
            +------------+
            |  gpio-exp  |
            +------------+
              |        |
         GPIO0_IRQ  GPIO1_IRQ

In the above diagram, gpio expander has irq number GPIO_IRQ, it is
connected with two sub GPIO pins, GPIO0 and GPIO1.

During suspend, we set IRQF_NO_SUSPEND for GPIO_IRQ so that gpio
expander driver can handle the sub irq GPIO0_IRQ and GPIO1_IRQ, and
these two irqs themselves can further be handled by simple or nested
irq in some drivers(typically gpio and mfd driver). If they are used
as wakeup sources during suspend, we want them to be able to abort
suspend too.

Setting IRQS_PENDING flag in handle_nested_irq() and handle_simple_irq()
when the irq is disabled allows check_wakeup_irqs() to identify such
irqs as source for aborting suspend.

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
Cc: rjw@sisk.pl
Link: http://lkml.kernel.org/r/CAH3Oq6T905%2B3fkF43NAMMFvJvq7dsk_so6T2vQ8ZJrA5xiU3YA@mail.gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index fc275e4..eebd6d5 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -275,8 +275,10 @@ void handle_nested_irq(unsigned int irq)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	action = desc->action;
-	if (unlikely(!action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
 		goto out_unlock;
+	}
 
 	irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 	raw_spin_unlock_irq(&desc->lock);
@@ -324,8 +326,10 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
 		goto out_unlock;
+	}
 
 	handle_irq_event(desc);
 
