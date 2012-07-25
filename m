Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2GYKxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 06:53:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53604 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab2GYKxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 06:53:20 -0400
Date: Wed, 25 Jul 2012 03:53:04 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-dc9b229a58dc0dfed34272ff26c6d5fd17c674e0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, mtosatti@redhat.com, jan.kiszka@web.de,
        tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mtosatti@redhat.com, jan.kiszka@web.de,
        tglx@linutronix.de, avi@redhat.com
In-Reply-To: <alpine.LFD.2.02.1207132056540.32033@ionos>
References: <alpine.LFD.2.02.1207132056540.32033@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq:
  Allow irq chips to mark themself oneshot safe
Git-Commit-ID: dc9b229a58dc0dfed34272ff26c6d5fd17c674e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 03:53:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc9b229a58dc0dfed34272ff26c6d5fd17c674e0
Gitweb:     http://git.kernel.org/tip/dc9b229a58dc0dfed34272ff26c6d5fd17c674e0
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 13 Jul 2012 19:29:45 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 25 Jul 2012 12:46:38 +0200

genirq: Allow irq chips to mark themself oneshot safe

Some interrupt chips like MSI are oneshot safe by implementation. For
those interrupts we can avoid the mask/unmask sequence for threaded
interrupt handlers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1207132056540.32033@ionos
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Jan Kiszka <jan.kiszka@web.de>
---
 include/linux/irq.h |    1 +
 kernel/irq/manage.c |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 553fb66..216b0ba 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -349,6 +349,7 @@ enum {
 	IRQCHIP_MASK_ON_SUSPEND		= (1 <<  2),
 	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
 	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
+	IRQCHIP_ONESHOT_SAFE		= (1 <<  5),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8c54823..2e326d1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -960,6 +960,18 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	}
 
 	/*
+	 * Drivers are often written to work w/o knowledge about the
+	 * underlying irq chip implementation, so a request for a
+	 * threaded irq without a primary hard irq context handler
+	 * requires the ONESHOT flag to be set. Some irq chips like
+	 * MSI based interrupts are per se one shot safe. Check the
+	 * chip flags, so we can avoid the unmask dance at the end of
+	 * the threaded handler for those.
+	 */
+	if (desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)
+		new->flags &= ~IRQF_ONESHOT;
+
+	/*
 	 * The following block of code has to be executed atomically
 	 */
 	raw_spin_lock_irqsave(&desc->lock, flags);
@@ -1033,7 +1045,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		new->thread_mask = 1 << ffz(thread_mask);
 
-	} else if (new->handler == irq_default_primary_handler) {
+	} else if (new->handler == irq_default_primary_handler &&
+		   !(desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)) {
 		/*
 		 * The interrupt was requested with handler = NULL, so
 		 * we use the default primary handler for it. But it
