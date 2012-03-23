Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2CWHXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 03:23:37 -0400
Received: from fallback4.mail.ru ([94.100.176.42]:42266 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2CWHXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 03:23:36 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] Fix build error with !SMP && !GENERIC_HARDIRQS
Date: Fri, 23 Mar 2012 11:23:04 +0400
Message-Id: <1332487384-13803-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compile kernel with !SMP && !GENERIC_HARDIRQS we are have
following error:
  CC      kernel/irq/manage.o
kernel/irq/manage.c:41: error: expected identifier or '(' before 'asm'

This error appears because header contain other definition for
synchronize_irq in include/linux/hardirq.h.
extern void synchronize_irq(unsigned int irq);

This patch fix this problem.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 kernel/irq/manage.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index b0ccd1a..854a463 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -28,6 +28,7 @@ static int __init setup_forced_irqthreads(char *arg)
 early_param("threadirqs", setup_forced_irqthreads);
 #endif
 
+#if !defined(synchronize_irq)
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -71,6 +72,7 @@ void synchronize_irq(unsigned int irq)
 	wait_event(desc->wait_for_threads, !atomic_read(&desc->threads_active));
 }
 EXPORT_SYMBOL(synchronize_irq);
+#endif
 
 #ifdef CONFIG_SMP
 cpumask_var_t irq_default_affinity;
-- 
1.7.3.4

