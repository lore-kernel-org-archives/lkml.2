Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab1BNSla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:41:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:38492 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1BNSl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:41:28 -0500
Date: Mon, 14 Feb 2011 18:40:53 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, hpa@zytor.com,
        mingo@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, jdike@addtoit.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20110206224515.322707425@linutronix.de>
References: <20110206224515.322707425@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:um/irq] um: Use proper accessors in show_interrupts()
Message-ID: <tip-d5b4eea1c575b78448fd5dc54d250ff302ca22f9@git.kernel.org>
Git-Commit-ID: d5b4eea1c575b78448fd5dc54d250ff302ca22f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:40:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5b4eea1c575b78448fd5dc54d250ff302ca22f9
Gitweb:     http://git.kernel.org/tip/d5b4eea1c575b78448fd5dc54d250ff302ca22f9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 6 Feb 2011 22:45:36 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 14 Feb 2011 19:37:40 +0100

um: Use proper accessors in show_interrupts()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20110206224515.322707425@linutronix.de>
---
 arch/um/kernel/irq.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index f771b85..64cfea8 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -35,8 +35,10 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	if (i < NR_IRQS) {
-		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
-		action = irq_desc[i].action;
+		struct irq_desc *desc = irq_to_desc(i);
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action)
 			goto skip;
 		seq_printf(p, "%3d: ",i);
@@ -46,7 +48,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
-		seq_printf(p, " %14s", irq_desc[i].chip->name);
+		seq_printf(p, " %14s", get_irq_desc_chip(desc)->name);
 		seq_printf(p, "  %s", action->name);
 
 		for (action=action->next; action; action = action->next)
@@ -54,7 +56,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 skip:
-		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS)
 		seq_putc(p, '\n');
 
