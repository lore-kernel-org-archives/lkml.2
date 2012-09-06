Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2IFLed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:34:33 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:60233 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2IFLe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:34:29 -0400
X-AuditID: b753bd60-991dcba000000c4c-e9-5048890ce00f
X-AuditID: b753bd60-991dcba000000c4c-e9-5048890ce00f
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 21/21] x86: request TLB flush to slave CPU using NMI
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:29:09 +0900
Message-ID: <20120906112909.13320.88939.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For slave CPUs, it is inapropriate to request TLB flush using IPI.
because the IPI may be sent to a KVM guest when the slave CPU is running
the guest with direct interrupt routing.

Instead, it registers a TLB flush request in per-cpu bitmask and send a NMI
to interrupt execution of the guest. Then, NMI handler will check the
requests and handles the requests.

This implementation has an issue in scalability, and is just for PoC.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/tlbflush.h |    5 ++
 arch/x86/kernel/smpboot.c       |    3 +
 arch/x86/kvm/x86.c              |    5 ++
 arch/x86/mm/tlb.c               |   94 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 74a4433..bcd637b 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -168,6 +168,11 @@ static inline void reset_lazy_tlbstate(void)
 	this_cpu_write(cpu_tlbstate.active_mm, &init_mm);
 }
 
+#ifdef CONFIG_SLAVE_CPU
+DECLARE_PER_CPU(bool, slave_idle);
+void handle_slave_tlb_flush(unsigned int cpu);
+#endif	/* SLAVE_CPU */
+
 #endif	/* SMP */
 
 #ifndef CONFIG_PARAVIRT
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ba7c99b..9854087 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -395,7 +395,10 @@ notrace static void __cpuinit start_slave_cpu(void *unused)
 		rcu_note_context_switch(cpu);
 
 		if (!f.func) {
+			__this_cpu_write(slave_idle, 1);
+			handle_slave_tlb_flush(cpu);
 			native_safe_halt();
+			__this_cpu_write(slave_idle, 0);
 			continue;
 		}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9d92581..d3ee570 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -65,6 +65,7 @@
 #include <asm/cpu.h>
 #include <asm/nmi.h>
 #include <asm/mmu.h>
+#include <asm/tlbflush.h>
 
 #define MAX_IO_MSRS 256
 #define KVM_MAX_MCE_BANKS 32
@@ -5529,6 +5530,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct task_struct *task)
 
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 
+	handle_slave_tlb_flush(vcpu->cpu);
+
 	if (req_immediate_exit)
 		smp_send_reschedule(vcpu->cpu);
 
@@ -5631,6 +5634,8 @@ static void __vcpu_enter_guest_slave(void *_arg)
 
 		r = vcpu_enter_guest(vcpu, arg->task);
 
+		handle_slave_tlb_flush(cpu);
+
 		if (r <= 0)
 			break;
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 613cd83..54f1c1b 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -11,6 +11,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cache.h>
 #include <asm/apic.h>
+#include <asm/nmi.h>
 #include <asm/uv/uv.h>
 #include <linux/debugfs.h>
 
@@ -35,6 +36,10 @@ struct flush_tlb_info {
 	struct mm_struct *flush_mm;
 	unsigned long flush_start;
 	unsigned long flush_end;
+#ifdef CONFIG_SLAVE_CPU
+	cpumask_var_t mask;
+	struct list_head list;
+#endif
 };
 
 /*
@@ -97,6 +102,7 @@ EXPORT_SYMBOL_GPL(leave_mm);
 static void flush_tlb_func(void *info)
 {
 	struct flush_tlb_info *f = info;
+	int cpu = smp_processor_id();
 
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
@@ -115,9 +121,94 @@ static void flush_tlb_func(void *info)
 			}
 		}
 	} else
-		leave_mm(smp_processor_id());
+		leave_mm(cpu);
+
+#ifdef CONFIG_SLAVE_CPU
+	if (cpu_slave(cpu))
+		cpumask_test_and_clear_cpu(cpu, f->mask);
+#endif
+}
+
+#ifdef CONFIG_SLAVE_CPU
+static DEFINE_PER_CPU(atomic_t, nr_slave_tlbf);
+DEFINE_PER_CPU(bool, slave_idle);
+static LIST_HEAD(fti_list);
+static DEFINE_RWLOCK(fti_list_lock);
+
+static int slave_tlb_flush_nmi(unsigned int val, struct pt_regs *regs)
+{
+	int cpu = smp_processor_id();
+
+	if (!cpu_slave(cpu) || !atomic_read(&__get_cpu_var(nr_slave_tlbf)))
+		return NMI_DONE;
+	if (this_cpu_read(slave_idle))
+		handle_slave_tlb_flush(cpu);
+	return NMI_HANDLED;
+}
+
+static int __cpuinit register_slave_tlb_flush_nmi(void)
+{
+	register_nmi_handler(NMI_LOCAL, slave_tlb_flush_nmi,
+			     NMI_FLAG_FIRST, "slave_tlb_flush");
+	return 0;
+}
+late_initcall(register_slave_tlb_flush_nmi);
+
+void handle_slave_tlb_flush(unsigned int cpu)
+{
+	struct flush_tlb_info *info;
 
+	if (!cpu_slave(cpu) ||
+	    !atomic_read(&__get_cpu_var(nr_slave_tlbf)))
+		return;
+
+	read_lock(&fti_list_lock);
+	list_for_each_entry(info, &fti_list, list) {
+		if (cpumask_test_cpu(cpu, info->mask)) {
+			flush_tlb_func(info);
+			atomic_dec(&__get_cpu_var(nr_slave_tlbf));
+		}
+	}
+	read_unlock(&fti_list_lock);
+}
+EXPORT_SYMBOL_GPL(handle_slave_tlb_flush);
+
+static void request_slave_tlb_flush(const struct cpumask *mask,
+				    struct flush_tlb_info *info)
+{
+	int cpu;
+
+	if (!cpumask_intersects(mask, cpu_slave_mask))
+		return;
+
+	if (!alloc_cpumask_var(&info->mask, GFP_ATOMIC)) {
+		pr_err("%s: not enough memory\n", __func__);
+		return;
+	}
+
+	cpumask_and(info->mask, mask, cpu_slave_mask);
+	INIT_LIST_HEAD(&info->list);
+	write_lock(&fti_list_lock);
+	list_add(&info->list, &fti_list);
+	write_unlock(&fti_list_lock);
+
+	for_each_cpu_and(cpu, mask, cpu_slave_mask)
+		atomic_inc(&per_cpu(nr_slave_tlbf, cpu));
+
+	apic->send_IPI_mask(info->mask, NMI_VECTOR);
+	while (!cpumask_empty(info->mask))
+		cpu_relax();
+	write_lock(&fti_list_lock);
+	list_del(&info->list);
+	write_unlock(&fti_list_lock);
+	free_cpumask_var(info->mask);
+}
+#else
+static inline void request_slave_tlb_flush(const struct cpumask *mask,
+					   struct flush_tlb_info *info)
+{
 }
+#endif
 
 void native_flush_tlb_others(const struct cpumask *cpumask,
 				 struct mm_struct *mm, unsigned long start,
@@ -139,6 +230,7 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 		return;
 	}
 	smp_call_function_many(cpumask, flush_tlb_func, &info, 1);
+	request_slave_tlb_flush(cpumask, &info);
 }
 
 void flush_tlb_current_task(void)


