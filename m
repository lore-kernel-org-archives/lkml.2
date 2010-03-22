Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0CVBi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 21:38:26 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:27447 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab0CVBiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 21:38:23 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 06/10] irq: Start the transition of irq_chip methods taking a desc
Date: Sun, 21 Mar 2010 18:36:06 -0700
Message-Id: <1269221770-9667-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BA6C9E7.01AE,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

With SPARSE_IRQ irq_to_desc becomes an unnecessary lookup operation on
the fast path of dispatching irqs to their handlers.  We can avoid
this cost by passing an irq_desc pointer instead of using an integer
irq token to the irq_chip methods.

A single patch to convert all of the architectures is an unreviewable
2000+ line patch.  A gradual transition scenario with two sets of
irq_chip methods in irq_chip is an unmanageable mess in kernel/irq.

So instead I define some macros so the generic irq code in kernel/irq/
can compile either way based on a boolean Kconfig variable
CONFIG_CHIP_PARAM_DESC.  This allows us to convert one architecture at
a time, reducing the follow on patches to manageable proportions.  It
is a little bit ugly but it is much better than the alternatives, and
as soon as we finish the transition we can kill the macros.

I introduce the macros CHIP_ARG, CHIP_VAR, and CHIP_PARAM where
appropriate.  I change a few declarations of irq as int to unsigned
int.  I normalize the variables names in the functions that call
chip methods to ensure that I have the variables irq and desc present
allowing CHIP_ARG to work properly.  Most importantly none of the irq
logic changes with this patch.

-v2: add CHIP_VAR_IRQ

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/Kconfig           |    3 ++
 include/linux/irq.h    |   60 ++++++++++++++++++++++++++++-------------------
 kernel/irq/autoprobe.c |   39 ++++++++++++++++---------------
 kernel/irq/chip.c      |   40 ++++++++++++++++----------------
 kernel/irq/handle.c    |   18 +++++++-------
 kernel/irq/internals.h |    4 +-
 kernel/irq/manage.c    |   22 ++++++++--------
 kernel/irq/migration.c |   10 ++++----
 kernel/irq/pm.c        |    6 ++--
 kernel/irq/resend.c    |    5 ++-
 kernel/irq/spurious.c  |    4 +-
 11 files changed, 114 insertions(+), 97 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index f06010f..7331bbb 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -2,6 +2,9 @@
 # General architecture dependent options
 #
 
+config CHIP_PARAM_DESC
+       def_bool n
+
 config OPROFILE
 	tristate "OProfile system profiling"
 	depends on PROFILING
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 60f3368..5a110a4 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -83,6 +83,18 @@ typedef	void (*irq_flow_handler_t)(unsigned int irq,
 struct proc_dir_entry;
 struct msi_desc;
 
+#ifdef CONFIG_CHIP_PARAM_DESC
+#define CHIP_PARAM struct irq_desc *desc
+#define CHIP_VAR
+#define CHIP_VAR_IRQ unsigned int irq = desc->irq;
+#define CHIP_ARG   desc
+#else
+#define CHIP_PARAM unsigned int irq
+#define CHIP_VAR   struct irq_desc *desc = irq_to_desc(irq);
+#define CHIP_VAR_IRQ
+#define CHIP_ARG   irq
+#endif
+
 /**
  * struct irq_chip - hardware interrupt chip descriptor
  *
@@ -110,30 +122,30 @@ struct msi_desc;
  */
 struct irq_chip {
 	const char	*name;
-	unsigned int	(*startup)(unsigned int irq);
-	void		(*shutdown)(unsigned int irq);
-	void		(*enable)(unsigned int irq);
-	void		(*disable)(unsigned int irq);
-
-	void		(*ack)(unsigned int irq);
-	void		(*mask)(unsigned int irq);
-	void		(*mask_ack)(unsigned int irq);
-	void		(*unmask)(unsigned int irq);
-	void		(*eoi)(unsigned int irq);
-
-	void		(*end)(unsigned int irq);
-	int		(*set_affinity)(unsigned int irq,
+	unsigned int	(*startup)(CHIP_PARAM);
+	void		(*shutdown)(CHIP_PARAM);
+	void		(*enable)(CHIP_PARAM);
+	void		(*disable)(CHIP_PARAM);
+
+	void		(*ack)(CHIP_PARAM);
+	void		(*mask)(CHIP_PARAM);
+	void		(*mask_ack)(CHIP_PARAM);
+	void		(*unmask)(CHIP_PARAM);
+	void		(*eoi)(CHIP_PARAM);
+
+	void		(*end)(CHIP_PARAM);
+	int		(*set_affinity)(CHIP_PARAM,
 					const struct cpumask *dest);
-	int		(*retrigger)(unsigned int irq);
-	int		(*set_type)(unsigned int irq, unsigned int flow_type);
-	int		(*set_wake)(unsigned int irq, unsigned int on);
+	int		(*retrigger)(CHIP_PARAM);
+	int		(*set_type)(CHIP_PARAM, unsigned int flow_type);
+	int		(*set_wake)(CHIP_PARAM, unsigned int on);
 
-	void		(*bus_lock)(unsigned int irq);
-	void		(*bus_sync_unlock)(unsigned int irq);
+	void		(*bus_lock)(CHIP_PARAM);
+	void		(*bus_sync_unlock)(CHIP_PARAM);
 
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
-	void		(*release)(unsigned int irq, void *dev_id);
+	void		(*release)(CHIP_PARAM, void *dev_id);
 #endif
 	/*
 	 * For compatibility, ->typename is copied into ->name.
@@ -252,20 +264,20 @@ extern void remove_irq(unsigned int irq, struct irqaction *act);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
-void move_native_irq(int irq);
-void move_masked_irq(int irq);
+void move_native_irq(unsigned int irq);
+void move_masked_irq(unsigned int irq);
 
 #else /* CONFIG_GENERIC_PENDING_IRQ */
 
-static inline void move_irq(int irq)
+static inline void move_irq(unsigned int irq)
 {
 }
 
-static inline void move_native_irq(int irq)
+static inline void move_native_irq(unsigned int irq)
 {
 }
 
-static inline void move_masked_irq(int irq)
+static inline void move_masked_irq(unsigned int irq)
 {
 }
 
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 2295a31..2a8702f 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -33,7 +33,7 @@ unsigned long probe_irq_on(void)
 	struct irq_desc *desc;
 	unsigned long mask = 0;
 	unsigned int status;
-	int i;
+	unsigned int irq;
 
 	/*
 	 * quiesce the kernel, or at least the asynchronous portion
@@ -44,7 +44,7 @@ unsigned long probe_irq_on(void)
 	 * something may have generated an irq long ago and we want to
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
-	for_each_irq_desc_reverse(i, desc) {
+	for_each_irq_desc_reverse(irq, desc) {
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			/*
@@ -58,8 +58,8 @@ unsigned long probe_irq_on(void)
 			 * progress:
 			 */
 			if (desc->chip->set_type)
-				desc->chip->set_type(i, IRQ_TYPE_PROBE);
-			desc->chip->startup(i);
+				desc->chip->set_type(CHIP_ARG, IRQ_TYPE_PROBE);
+			desc->chip->startup(CHIP_ARG);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -72,11 +72,11 @@ unsigned long probe_irq_on(void)
 	 * (we must startup again here because if a longstanding irq
 	 * happened in the previous stage, it may have masked itself)
 	 */
-	for_each_irq_desc_reverse(i, desc) {
+	for_each_irq_desc_reverse(irq, desc) {
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->chip->startup(i))
+			if (desc->chip->startup(CHIP_ARG))
 				desc->status |= IRQ_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
@@ -90,7 +90,7 @@ unsigned long probe_irq_on(void)
 	/*
 	 * Now filter out any obviously spurious interrupts
 	 */
-	for_each_irq_desc(i, desc) {
+	for_each_irq_desc(irq, desc) {
 		raw_spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -98,10 +98,10 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(status & IRQ_WAITING)) {
 				desc->status = status & ~IRQ_AUTODETECT;
-				desc->chip->shutdown(i);
+				desc->chip->shutdown(CHIP_ARG);
 			} else
-				if (i < 32)
-					mask |= 1 << i;
+				if (irq < 32)
+					mask |= 1 << irq;
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -126,18 +126,18 @@ unsigned int probe_irq_mask(unsigned long val)
 {
 	unsigned int status, mask = 0;
 	struct irq_desc *desc;
-	int i;
+	unsigned int irq;
 
-	for_each_irq_desc(i, desc) {
+	for_each_irq_desc(irq, desc) {
 		raw_spin_lock_irq(&desc->lock);
 		status = desc->status;
 
 		if (status & IRQ_AUTODETECT) {
-			if (i < 16 && !(status & IRQ_WAITING))
-				mask |= 1 << i;
+			if (irq < 16 && !(status & IRQ_WAITING))
+				mask |= 1 << irq;
 
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc->chip->shutdown(CHIP_ARG);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -166,22 +166,23 @@ EXPORT_SYMBOL(probe_irq_mask);
  */
 int probe_irq_off(unsigned long val)
 {
-	int i, irq_found = 0, nr_of_irqs = 0;
+	int irq_found = 0, nr_of_irqs = 0;
 	struct irq_desc *desc;
 	unsigned int status;
+	unsigned int irq;
 
-	for_each_irq_desc(i, desc) {
+	for_each_irq_desc(irq, desc) {
 		raw_spin_lock_irq(&desc->lock);
 		status = desc->status;
 
 		if (status & IRQ_AUTODETECT) {
 			if (!(status & IRQ_WAITING)) {
 				if (!nr_of_irqs)
-					irq_found = i;
+					irq_found = irq;
 				nr_of_irqs++;
 			}
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc->chip->shutdown(CHIP_ARG);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 3dcdd2f..190360d 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -287,40 +287,40 @@ EXPORT_SYMBOL_GPL(set_irq_nested_thread);
 /*
  * default enable function
  */
-static void default_enable(unsigned int irq)
+static void default_enable(CHIP_PARAM)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	CHIP_VAR
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(CHIP_ARG);
 	desc->status &= ~IRQ_MASKED;
 }
 
 /*
  * default disable function
  */
-static void default_disable(unsigned int irq)
+static void default_disable(CHIP_PARAM)
 {
 }
 
 /*
  * default startup function
  */
-static unsigned int default_startup(unsigned int irq)
+static unsigned int default_startup(CHIP_PARAM)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	CHIP_VAR;
 
-	desc->chip->enable(irq);
+	desc->chip->enable(CHIP_ARG);
 	return 0;
 }
 
 /*
  * default shutdown function
  */
-static void default_shutdown(unsigned int irq)
+static void default_shutdown(CHIP_PARAM)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	CHIP_VAR;
 
-	desc->chip->mask(irq);
+	desc->chip->mask(CHIP_ARG);
 	desc->status |= IRQ_MASKED;
 }
 
@@ -353,11 +353,11 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 {
 	if (desc->chip->mask_ack)
-		desc->chip->mask_ack(irq);
+		desc->chip->mask_ack(CHIP_ARG);
 	else {
-		desc->chip->mask(irq);
+		desc->chip->mask(CHIP_ARG);
 		if (desc->chip->ack)
-			desc->chip->ack(irq);
+			desc->chip->ack(CHIP_ARG);
 	}
 	desc->status |= IRQ_MASKED;
 }
@@ -365,7 +365,7 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 static inline void mask_irq(struct irq_desc *desc, int irq)
 {
 	if (desc->chip->mask) {
-		desc->chip->mask(irq);
+		desc->chip->mask(CHIP_ARG);
 		desc->status |= IRQ_MASKED;
 	}
 }
@@ -373,7 +373,7 @@ static inline void mask_irq(struct irq_desc *desc, int irq)
 static inline void unmask_irq(struct irq_desc *desc, int irq)
 {
 	if (desc->chip->unmask) {
-		desc->chip->unmask(irq);
+		desc->chip->unmask(CHIP_ARG);
 		desc->status &= ~IRQ_MASKED;
 	}
 }
@@ -554,7 +554,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
-	desc->chip->eoi(irq);
+	desc->chip->eoi(CHIP_ARG);
 
 	raw_spin_unlock(&desc->lock);
 }
@@ -597,7 +597,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 
 	/* Start handling the irq */
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(CHIP_ARG);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -651,14 +651,14 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(CHIP_ARG);
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
 	if (desc->chip->eoi)
-		desc->chip->eoi(irq);
+		desc->chip->eoi(CHIP_ARG);
 }
 
 void
@@ -706,7 +706,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 		desc->depth = 0;
-		desc->chip->startup(irq);
+		desc->chip->startup(CHIP_ARG);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	chip_bus_sync_unlock(irq, desc);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index f30c9c7..9e4a0a0 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -295,22 +295,22 @@ void clear_kstat_irqs(struct irq_desc *desc)
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
  */
-static void ack_bad(unsigned int irq)
+static void ack_bad(CHIP_PARAM)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	CHIP_VAR;
 
-	print_irq_desc(irq, desc);
-	ack_bad_irq(irq);
+	print_irq_desc(desc->irq, desc);
+	ack_bad_irq(desc->irq);
 }
 
 /*
  * NOP functions
  */
-static void noop(unsigned int irq)
+static void noop(CHIP_PARAM)
 {
 }
 
-static unsigned int noop_ret(unsigned int irq)
+static unsigned int noop_ret(CHIP_PARAM)
 {
 	return 0;
 }
@@ -470,13 +470,13 @@ unsigned int __do_IRQ(unsigned int irq)
 			if (!noirqdebug)
 				note_interrupt(irq, desc, action_ret);
 		}
-		desc->chip->end(irq);
+		desc->chip->end(CHIP_ARG);
 		return 1;
 	}
 
 	raw_spin_lock(&desc->lock);
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(CHIP_ARG);
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
@@ -536,7 +536,7 @@ out:
 	 * The ->end() handler has to deal with interrupts which got
 	 * disabled while the handler was running.
 	 */
-	desc->chip->end(irq);
+	desc->chip->end(CHIP_ARG);
 	raw_spin_unlock(&desc->lock);
 
 	return 1;
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index c63f3bc..2a9ec5e 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -44,13 +44,13 @@ extern void irq_set_thread_affinity(struct irq_desc *desc);
 static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
 {
 	if (unlikely(desc->chip->bus_lock))
-		desc->chip->bus_lock(irq);
+		desc->chip->bus_lock(CHIP_ARG);
 }
 
 static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
 {
 	if (unlikely(desc->chip->bus_sync_unlock))
-		desc->chip->bus_sync_unlock(irq);
+		desc->chip->bus_sync_unlock(CHIP_ARG);
 }
 
 /*
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 69a3d7b..706b320 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -118,7 +118,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT) {
-		if (!desc->chip->set_affinity(irq, cpumask)) {
+		if (!desc->chip->set_affinity(CHIP_ARG, cpumask)) {
 			cpumask_copy(desc->affinity, cpumask);
 			irq_set_thread_affinity(desc);
 		}
@@ -128,7 +128,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	if (!desc->chip->set_affinity(irq, cpumask)) {
+	if (!desc->chip->set_affinity(CHIP_ARG, cpumask)) {
 		cpumask_copy(desc->affinity, cpumask);
 		irq_set_thread_affinity(desc);
 	}
@@ -161,7 +161,7 @@ static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 
 	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
-	desc->chip->set_affinity(irq, desc->affinity);
+	desc->chip->set_affinity(CHIP_ARG, desc->affinity);
 
 	return 0;
 }
@@ -207,7 +207,7 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
-		desc->chip->disable(irq);
+		desc->chip->disable(CHIP_ARG);
 	}
 }
 
@@ -321,7 +321,7 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
 	int ret = -ENXIO;
 
 	if (desc->chip->set_wake)
-		ret = desc->chip->set_wake(irq, on);
+		ret = desc->chip->set_wake(CHIP_ARG, on);
 
 	return ret;
 }
@@ -425,7 +425,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 	}
 
 	/* caller masked out all except trigger mode flags */
-	ret = chip->set_type(irq, flags);
+	ret = chip->set_type(CHIP_ARG, flags);
 
 	if (ret)
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
@@ -505,7 +505,7 @@ again:
 
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
-		desc->chip->unmask(irq);
+		desc->chip->unmask(CHIP_ARG);
 	}
 	raw_spin_unlock_irq(&desc->lock);
 	chip_bus_sync_unlock(irq, desc);
@@ -756,7 +756,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
-			desc->chip->startup(irq);
+			desc->chip->startup(CHIP_ARG);
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
@@ -890,16 +890,16 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* Currently used only by UML, might disappear one day: */
 #ifdef CONFIG_IRQ_RELEASE_METHOD
 	if (desc->chip->release)
-		desc->chip->release(irq, dev_id);
+		desc->chip->release(CHIP_ARG, dev_id);
 #endif
 
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
 		if (desc->chip->shutdown)
-			desc->chip->shutdown(irq);
+			desc->chip->shutdown(CHIP_ARG);
 		else
-			desc->chip->disable(irq);
+			desc->chip->disable(CHIP_ARG);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 2419622..5821159 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -4,7 +4,7 @@
 
 #include "internals.h"
 
-void move_masked_irq(int irq)
+void move_masked_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
@@ -43,7 +43,7 @@ void move_masked_irq(int irq)
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
 		   < nr_cpu_ids))
-		if (!desc->chip->set_affinity(irq, desc->pending_mask)) {
+		if (!desc->chip->set_affinity(CHIP_ARG, desc->pending_mask)) {
 			cpumask_copy(desc->affinity, desc->pending_mask);
 			irq_set_thread_affinity(desc);
 		}
@@ -51,7 +51,7 @@ void move_masked_irq(int irq)
 	cpumask_clear(desc->pending_mask);
 }
 
-void move_native_irq(int irq)
+void move_native_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
@@ -61,8 +61,8 @@ void move_native_irq(int irq)
 	if (unlikely(desc->status & IRQ_DISABLED))
 		return;
 
-	desc->chip->mask(irq);
+	desc->chip->mask(CHIP_ARG);
 	move_masked_irq(irq);
-	desc->chip->unmask(irq);
+	desc->chip->unmask(CHIP_ARG);
 }
 
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 0d4005d..94767d1 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -23,7 +23,7 @@
 void suspend_device_irqs(void)
 {
 	struct irq_desc *desc;
-	int irq;
+	unsigned int irq;
 
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
@@ -48,7 +48,7 @@ EXPORT_SYMBOL_GPL(suspend_device_irqs);
 void resume_device_irqs(void)
 {
 	struct irq_desc *desc;
-	int irq;
+	unsigned int irq;
 
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
@@ -69,7 +69,7 @@ EXPORT_SYMBOL_GPL(resume_device_irqs);
 int check_wakeup_irqs(void)
 {
 	struct irq_desc *desc;
-	int irq;
+	unsigned int irq;
 
 	for_each_irq_desc(irq, desc)
 		if ((desc->status & IRQ_WAKEUP) && (desc->status & IRQ_PENDING))
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 090c376..dc9dff8 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -60,7 +60,7 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 	/*
 	 * Make sure the interrupt is enabled, before resending it:
 	 */
-	desc->chip->enable(irq);
+	desc->chip->enable(CHIP_ARG);
 
 	/*
 	 * We do not resend level type interrupts. Level type
@@ -70,7 +70,8 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
-		if (!desc->chip->retrigger || !desc->chip->retrigger(irq)) {
+		if (!desc->chip->retrigger ||
+		    !desc->chip->retrigger(CHIP_ARG)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 89fb90a..6cc2cb9 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -79,7 +79,7 @@ static int try_one_irq(int irq, struct irq_desc *desc)
 	 * IRQ controller clean up too
 	 */
 	if (work && desc->chip && desc->chip->end)
-		desc->chip->end(irq);
+		desc->chip->end(CHIP_ARG);
 	raw_spin_unlock(&desc->lock);
 
 	return ok;
@@ -254,7 +254,7 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
-		desc->chip->disable(irq);
+		desc->chip->disable(CHIP_ARG);
 
 		mod_timer(&poll_spurious_irq_timer,
 			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
-- 
1.6.4.2

