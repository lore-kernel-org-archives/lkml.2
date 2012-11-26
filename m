Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab2KZVFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:05:43 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:53999 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2KZVFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:05:40 -0500
Subject: [PATCH 2/5] Expand the steal time msr to also contain the consigned
 time.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com
Date: Mon, 26 Nov 2012 15:05:28 -0600
Message-ID: <20121126210528.407.50092.stgit@lambeau>
In-Reply-To: <20121126210432.407.50742.stgit@lambeau>
References: <20121126210432.407.50742.stgit@lambeau>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12112621-6102-0000-0000-000002A03D0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a consigned field.  This field will hold the time lost due to capping or overcommit.
The rest of the time will still show up in the steal-time field.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 arch/x86/include/asm/paravirt.h       |    4 ++--
 arch/x86/include/asm/paravirt_types.h |    2 +-
 arch/x86/kernel/kvm.c                 |    7 ++-----
 kernel/sched/core.c                   |   10 +++++++++-
 kernel/sched/cputime.c                |    2 +-
 5 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a0facf3..a5f9f30 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -196,9 +196,9 @@ struct static_key;
 extern struct static_key paravirt_steal_enabled;
 extern struct static_key paravirt_steal_rq_enabled;
 
-static inline u64 paravirt_steal_clock(int cpu)
+static inline u64 paravirt_steal_clock(int cpu, u64 *steal)
 {
-	return PVOP_CALL1(u64, pv_time_ops.steal_clock, cpu);
+	PVOP_VCALL2(pv_time_ops.steal_clock, cpu, steal);
 }
 
 static inline unsigned long long paravirt_read_pmc(int counter)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 142236e..5d4fc8b 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -95,7 +95,7 @@ struct pv_lazy_ops {
 
 struct pv_time_ops {
 	unsigned long long (*sched_clock)(void);
-	unsigned long long (*steal_clock)(int cpu);
+	void (*steal_clock)(int cpu, unsigned long long *steal);
 	unsigned long (*get_tsc_khz)(void);
 };
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 4180a87..ac357b3 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -372,9 +372,8 @@ static struct notifier_block kvm_pv_reboot_nb = {
 	.notifier_call = kvm_pv_reboot_notify,
 };
 
-static u64 kvm_steal_clock(int cpu)
+static void kvm_steal_clock(int cpu, u64 *steal)
 {
-	u64 steal;
 	struct kvm_steal_time *src;
 	int version;
 
@@ -382,11 +381,9 @@ static u64 kvm_steal_clock(int cpu)
 	do {
 		version = src->version;
 		rmb();
-		steal = src->steal;
+		*steal = src->steal;
 		rmb();
 	} while ((version & 1) || (version != src->version));
-
-	return steal;
 }
 
 void kvm_disable_steal_time(void)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c2e077c..b21d92d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -748,6 +748,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
  */
 #if defined(CONFIG_IRQ_TIME_ACCOUNTING) || defined(CONFIG_PARAVIRT_TIME_ACCOUNTING)
 	s64 steal = 0, irq_delta = 0;
+	u64 consigned = 0;
 #endif
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
@@ -776,8 +777,15 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
 	if (static_key_false((&paravirt_steal_rq_enabled))) {
 		u64 st;
+		u64 cs;
 
-		steal = paravirt_steal_clock(cpu_of(rq));
+		paravirt_steal_clock(cpu_of(rq), &steal, &consigned);
+		/*
+		 * since we are not assigning the steal time to cpustats
+		 * here, just combine the steal and consigned times to
+		 * do the rest of the calculations.
+		 */
+		steal += consigned;
 		steal -= rq->prev_steal_time_rq;
 
 		if (unlikely(steal > delta))
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 8d859da..593b647 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -275,7 +275,7 @@ static __always_inline bool steal_account_process_tick(void)
 	if (static_key_false(&paravirt_steal_enabled)) {
 		u64 steal, st = 0;
 
-		steal = paravirt_steal_clock(smp_processor_id());
+		paravirt_steal_clock(smp_processor_id(), &steal);
 		steal -= this_rq()->prev_steal_time;
 
 		st = steal_ticks(steal);

