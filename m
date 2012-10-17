Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab2JQCYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:24:42 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45661 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2JQCYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:24:40 -0400
Subject: [PATCH RFC V2 3/5] Add the code to send the consigned time from the
 host to the guest
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, avi@redhat.com,
        anthony@codemonkey.ws
Date: Tue, 16 Oct 2012 21:24:27 -0500
Message-ID: <20121017022426.16949.85496.stgit@lambeau>
In-Reply-To: <20121017022249.16949.2775.stgit@lambeau>
References: <20121017022249.16949.2775.stgit@lambeau>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101702-5140-0000-0000-0000023699BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the code to send the consigned time from the host to the guest

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/include/asm/kvm_para.h |    3 ++-
 arch/x86/include/asm/paravirt.h |    4 ++--
 arch/x86/kernel/kvm.c           |    3 ++-
 arch/x86/kvm/x86.c              |    2 ++
 include/linux/kernel_stat.h     |    1 +
 kernel/sched/cputime.c          |   21 +++++++++++++++++++--
 kernel/sched/sched.h            |    2 ++
 8 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1eaa6b0..bd4e412 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -409,6 +409,7 @@ struct kvm_vcpu_arch {
 		u64 msr_val;
 		u64 last_steal;
 		u64 accum_steal;
+		u64 accum_consigned;
 		struct gfn_to_hva_cache stime;
 		struct kvm_steal_time steal;
 	} st;
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 2f7712e..debe72e 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -42,9 +42,10 @@
 
 struct kvm_steal_time {
 	__u64 steal;
+	__u64 consigned;
 	__u32 version;
 	__u32 flags;
-	__u32 pad[12];
+	__u32 pad[10];
 };
 
 #define KVM_STEAL_ALIGNMENT_BITS 5
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a5f9f30..d39e8d0 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -196,9 +196,9 @@ struct static_key;
 extern struct static_key paravirt_steal_enabled;
 extern struct static_key paravirt_steal_rq_enabled;
 
-static inline u64 paravirt_steal_clock(int cpu, u64 *steal)
+static inline u64 paravirt_steal_clock(int cpu, u64 *steal, u64 *consigned)
 {
-	PVOP_VCALL2(pv_time_ops.steal_clock, cpu, steal);
+	PVOP_VCALL3(pv_time_ops.steal_clock, cpu, steal, consigned);
 }
 
 static inline unsigned long long paravirt_read_pmc(int counter)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 91b3b2a..4e5582a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -368,7 +368,7 @@ static struct notifier_block kvm_pv_reboot_nb = {
 	.notifier_call = kvm_pv_reboot_notify,
 };
 
-static u64 kvm_steal_clock(int cpu, u64 *steal)
+static u64 kvm_steal_clock(int cpu, u64 *steal, u64 *consigned)
 {
 	struct kvm_steal_time *src;
 	int version;
@@ -378,6 +378,7 @@ static u64 kvm_steal_clock(int cpu, u64 *steal)
 		version = src->version;
 		rmb();
 		*steal = src->steal;
+		*consigned = src->consigned;
 		rmb();
 	} while ((version & 1) || (version != src->version));
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1f09552..801cfa8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1554,8 +1554,10 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->arch.st.steal.steal += vcpu->arch.st.accum_steal;
+	vcpu->arch.st.steal.consigned += vcpu->arch.st.accum_consigned;
 	vcpu->arch.st.steal.version += 2;
 	vcpu->arch.st.accum_steal = 0;
+	vcpu->arch.st.accum_consigned = 0;
 
 	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.st.stime,
 		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time));
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index c0b0095..253fdce 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -125,6 +125,7 @@ extern unsigned long long task_delta_exec(struct task_struct *);
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
 extern void account_steal_time(cputime_t);
+extern void account_consigned_time(cputime_t);
 extern void account_idle_time(cputime_t);
 
 extern void account_process_tick(struct task_struct *, int user);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index dd3fd46..bf2025a 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -244,6 +244,18 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 }
 
 /*
+ * This accounts for the time that is split out of steal time.
+ * Consigned time represents the amount of time that the cpu was
+ * expected to be somewhere else.
+ */
+void account_consigned_time(cputime_t cputime)
+{
+	u64 *cpustat =  kcpustat_this_cpu->cpustat;
+
+	cpustat[CPUTIME_CONSIGN] += (__force u64) cputime;
+}
+
+/*
  * Account for involuntary wait time.
  * @cputime: the cpu time spent in involuntary wait
  */
@@ -274,15 +286,20 @@ static __always_inline bool steal_account_process_tick(void)
 #ifdef CONFIG_PARAVIRT
 	if (static_key_false(&paravirt_steal_enabled)) {
 		u64 steal, st = 0;
+		u64 consigned, cs = 0;
 
-		paravirt_steal_clock(smp_processor_id(), &steal);
+		paravirt_steal_clock(smp_processor_id(), &steal, &consigned);
 		steal -= this_rq()->prev_steal_time;
+		consigned -= this_rq()->prev_consigned_time;
 
 		st = steal_ticks(steal);
+		cs = steal_ticks(consigned);
 		this_rq()->prev_steal_time += st * TICK_NSEC;
+		this_rq()->prev_consigned_time += cs * TICK_NSEC;
 
 		account_steal_time(st);
-		return st;
+		account_consigned_time(cs);
+		return st || cs;
 	}
 #endif
 	return false;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3060136..64e4cf9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -436,9 +436,11 @@ struct rq {
 #endif
 #ifdef CONFIG_PARAVIRT
 	u64 prev_steal_time;
+	u64 prev_consigned_time;
 #endif
 #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
 	u64 prev_steal_time_rq;
+	u64 prev_consigned_time_rq;
 #endif
 
 	/* calc_load related fields */

