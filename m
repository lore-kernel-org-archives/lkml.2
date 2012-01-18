Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2ARIA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 03:00:56 -0500
Received: from mail.de.keymile.com ([195.8.104.1]:52055 "HELO
	mail.de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932089Ab2ARIAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 03:00:54 -0500
From: Gerlando Falauto <gerlando.falauto@keymile.com>
To: linux-kernel@vger.kernel.org
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Holger Brunck <holger.brunck@keymile.com>
Subject: [PATCH 1/1] genirq: drop synchronize_irq() unless CONFIG_SMP
Date: Wed, 18 Jan 2012 08:59:57 +0100
Message-Id: <1326873597-19188-2-git-send-email-gerlando.falauto@keymile.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1326873597-19188-1-git-send-email-gerlando.falauto@keymile.com>
References: <1326873597-19188-1-git-send-email-gerlando.falauto@keymile.com>
X-ESAFE-STATUS: [srvhellgate.de.keymile.net] Mail clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since synchronize_irq() only makes sense under SMP,
restore the behavior prior to:

:commit 3aa551c9b4c40018f0e261a178e3d25478dc04a9
:Author: Thomas Gleixner <tglx@linutronix.de>
:Date:   Mon Mar 23 18:28:15 2009 +0100
:
:    genirq: add threaded interrupt handler support

so that it is declared and defined only when CONFIG_SMP=y.
Note that kernel/irq/manage.c only gets compiled when
CONFIG_GENERIC_HARDIRQS=y -- if this is not the case,
you should implement your own.

This fixes startup deadlocks in SMP-unaware drivers which call
disable_irq() within its own handler, and used to work
(by chance), up until 2.6.29.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Holger Brunck <holger.brunck@keymile.com>
Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
---
 include/linux/hardirq.h |    2 +-
 kernel/irq/manage.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index ba36217..82b2e75 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -123,7 +123,7 @@
 # define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
 #endif
 
-#if defined(CONFIG_SMP) || defined(CONFIG_GENERIC_HARDIRQS)
+#if defined(CONFIG_SMP)
 extern void synchronize_irq(unsigned int irq);
 #else
 # define synchronize_irq(irq)	barrier()
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a7840a..410da46 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -28,6 +28,7 @@ static int __init setup_forced_irqthreads(char *arg)
 early_param("threadirqs", setup_forced_irqthreads);
 #endif
 
+#if defined(CONFIG_SMP)
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -72,7 +73,6 @@ void synchronize_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(synchronize_irq);
 
-#ifdef CONFIG_SMP
 cpumask_var_t irq_default_affinity;
 
 /**
-- 
1.7.1

