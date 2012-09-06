Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2IFLcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:32:18 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59857 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2IFLcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:32:15 -0400
X-AuditID: b753bd60-969d8ba000000c4c-cb-504889078771
X-AuditID: b753bd60-969d8ba000000c4c-cb-504889078771
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 20/21] KVM: Pass-through local APIC timer of on slave
 CPUs to guest VM
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:29:04 +0900
Message-ID: <20120906112904.13320.1826.stgit@kvmdev>
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

Provide direct control of local APIC timer of slave CPUs to the guest.
The timer interrupt does not cause VM exit if direct interrupt delivery is
enabled. To handle the timer correctly, this makes the guest occupy the
local APIC timer.

If the host supports x2apic, this expose TMICT and TMCCT to the guest in
order to allow guests to start the timer and to read the timer count
without VM exit. Otherwise, it sets APIC registers to specified values.
LVTT is not passed-through to avoid modifying timer interrupt vector.

Currently the guest timer interrupt vector remapping is not supported, and
guest must use the same vector as host.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/apic.h     |    4 +++
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kernel/apic/apic.c     |   11 ++++++++++
 arch/x86/kernel/smpboot.c       |   30 ++++++++++++++++++++++++++
 arch/x86/kvm/lapic.c            |   45 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.h            |    2 ++
 arch/x86/kvm/vmx.c              |    6 +++++
 arch/x86/kvm/x86.c              |    3 +++
 include/linux/cpu.h             |    5 ++++
 kernel/hrtimer.c                |    2 +-
 10 files changed, 108 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index d37ae5c..66e1155 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -44,6 +44,8 @@ static inline void generic_apic_probe(void)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
+struct clock_event_device;
+
 extern unsigned int apic_verbosity;
 extern int local_apic_timer_c2_ok;
 
@@ -245,6 +247,8 @@ extern void init_apic_mappings(void);
 void register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
 extern void setup_secondary_APIC_clock(void);
+extern void override_local_apic_timer(int cpu,
+	void (*handler)(struct clock_event_device *));
 extern int APIC_init_uniprocessor(void);
 extern int apic_force_enable(unsigned long addr);
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f43680e..a95bb62 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1035,6 +1035,7 @@ int kvm_arch_vcpu_run_prevented(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_SLAVE_CPU
 void kvm_get_slave_cpu_mask(struct kvm *kvm, struct cpumask *mask);
+struct kvm_vcpu *get_slave_vcpu(int cpu);
 
 struct kvm_assigned_dev_kernel;
 extern void assign_slave_msi(struct kvm *kvm,
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 24deb30..90ed84a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -901,6 +901,17 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
+void override_local_apic_timer(int cpu,
+			       void (*handler)(struct clock_event_device *))
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	per_cpu(lapic_events, cpu).event_handler = handler;
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(override_local_apic_timer);
+
 int setup_profiling_timer(unsigned int multiplier)
 {
 	return -EINVAL;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 45dfc1d..ba7c99b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -133,6 +133,7 @@ static void __ref remove_cpu_from_maps(int cpu);
 #ifdef CONFIG_SLAVE_CPU
 /* Notify slave cpu up and down */
 static RAW_NOTIFIER_HEAD(slave_cpu_chain);
+struct notifier_block *slave_timer_nb;
 
 int register_slave_cpu_notifier(struct notifier_block *nb)
 {
@@ -140,6 +141,13 @@ int register_slave_cpu_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(register_slave_cpu_notifier);
 
+int register_slave_cpu_timer_notifier(struct notifier_block *nb)
+{
+	slave_timer_nb = nb;
+	return register_slave_cpu_notifier(nb);
+}
+EXPORT_SYMBOL(register_slave_cpu_timer_notifier);
+
 void unregister_slave_cpu_notifier(struct notifier_block *nb)
 {
 	raw_notifier_chain_unregister(&slave_cpu_chain, nb);
@@ -155,6 +163,8 @@ static int slave_cpu_notify(unsigned long val, int cpu)
 
 	return notifier_to_errno(ret);
 }
+
+static void slave_cpu_disable_timer(int cpu);
 #endif
 
 /*
@@ -1013,10 +1023,30 @@ int __cpuinit slave_cpu_up(unsigned int cpu)
 
 	cpu_maps_update_done();
 
+	/* Timer may be used only in starting the slave CPU */
+	slave_cpu_disable_timer(cpu);
+
 	return ret;
 }
 EXPORT_SYMBOL(slave_cpu_up);
 
+static void __slave_cpu_disable_timer(void *hcpu)
+{
+	int cpu = (long)hcpu;
+
+	pr_info("Disabling timer on slave cpu %d\n", cpu);
+	BUG_ON(!slave_timer_nb);
+	slave_timer_nb->notifier_call(slave_timer_nb, CPU_SLAVE_DYING, hcpu);
+}
+
+static void slave_cpu_disable_timer(int cpu)
+{
+	void *hcpu = (void *)(long)cpu;
+
+	slave_cpu_call_function(cpu, __slave_cpu_disable_timer, hcpu);
+	slave_timer_nb->notifier_call(slave_timer_nb, CPU_SLAVE_DEAD, hcpu);
+}
+
 static void __slave_cpu_down(void *dummy)
 {
 	__this_cpu_write(cpu_state, CPU_DYING);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index bf8e351..47288b5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -652,6 +652,9 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 	if (apic_get_reg(apic, APIC_TMICT) == 0)
 		return 0;
 
+	if (vcpu_has_slave_cpu(apic->vcpu))
+		return apic_read(APIC_TMCCT);
+
 	remaining = hrtimer_get_remaining(&apic->lapic_timer.timer);
 	if (ktime_to_ns(remaining) < 0)
 		remaining = ktime_set(0, 0);
@@ -799,6 +802,10 @@ static void start_apic_timer(struct kvm_lapic *apic)
 	atomic_set(&apic->lapic_timer.pending, 0);
 
 	if (apic_lvtt_period(apic) || apic_lvtt_oneshot(apic)) {
+		if (vcpu_has_slave_cpu(apic->vcpu)) {
+			apic_write(APIC_TMICT, apic_get_reg(apic, APIC_TMICT));
+			return;
+		}
 		/* lapic timer in oneshot or peroidic mode */
 		now = apic->lapic_timer.timer.base->get_time();
 		apic->lapic_timer.period = (u64)apic_get_reg(apic, APIC_TMICT)
@@ -845,6 +852,15 @@ static void start_apic_timer(struct kvm_lapic *apic)
 		unsigned long this_tsc_khz = vcpu->arch.virtual_tsc_khz;
 		unsigned long flags;
 
+		if (vcpu_has_slave_cpu(apic->vcpu)) {
+			local_irq_save(flags);
+			guest_tsc = kvm_x86_ops->read_l1_tsc(vcpu);
+			wrmsrl(MSR_IA32_TSCDEADLINE,
+			       tscdeadline - guest_tsc + native_read_tsc());
+			local_irq_restore(flags);
+			return;
+		}
+
 		if (unlikely(!tscdeadline || !this_tsc_khz))
 			return;
 
@@ -971,6 +987,16 @@ static int apic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 			val |= APIC_LVT_MASKED;
 		val &= (apic_lvt_mask[0] | apic->lapic_timer.timer_mode_mask);
 		apic_set_reg(apic, APIC_LVTT, val);
+		if (vcpu_has_slave_cpu(apic->vcpu)) {
+			u8 vector = val & 0xff;
+
+			if (vector && vector != LOCAL_TIMER_VECTOR) {
+				pr_err("slave lapic: vector %x unsupported\n",
+				       vector);
+				ret = -EINVAL;
+			} else
+				apic_write(reg, val);
+		}
 		break;
 
 	case APIC_TMICT:
@@ -987,6 +1013,8 @@ static int apic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 			apic_debug("KVM_WRITE:TDCR %x\n", val);
 		apic_set_reg(apic, APIC_TDCR, val);
 		update_divide_count(apic);
+		if (vcpu_has_slave_cpu(apic->vcpu))
+			apic_write(reg, val);
 		break;
 
 	case APIC_ESR:
@@ -1267,6 +1295,17 @@ static const struct kvm_io_device_ops apic_mmio_ops = {
 	.write    = apic_mmio_write,
 };
 
+#ifdef CONFIG_SLAVE_CPU
+void slave_lapic_timer_fn(struct clock_event_device *dev)
+{
+	int cpu = raw_smp_processor_id();
+	struct kvm_vcpu *vcpu = get_slave_vcpu(cpu);
+
+	BUG_ON(!vcpu || !vcpu->arch.apic);
+	kvm_timer_fn(&vcpu->arch.apic->lapic_timer.timer);
+}
+#endif
+
 int kvm_create_lapic(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic;
@@ -1295,6 +1334,12 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	apic->lapic_timer.kvm = vcpu->kvm;
 	apic->lapic_timer.vcpu = vcpu;
 
+#ifdef CONFIG_SLAVE_CPU
+	if (vcpu_has_slave_cpu(vcpu))
+		override_local_apic_timer(vcpu->arch.slave_cpu,
+					  slave_lapic_timer_fn);
+#endif
+
 	apic->base_address = APIC_DEFAULT_PHYS_BASE;
 	vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE;
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4af5405..e8e51ca 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -55,6 +55,8 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
 void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data);
 
+void slave_lapic_timer_fn(struct clock_event_device *dev);
+
 void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f93e08c..0aa9423 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7557,6 +7557,12 @@ static int __init vmx_init(void)
 	       vmx_msr_bitmap_longmode, PAGE_SIZE);
 	vmx_disable_intercept_for_msr_slave(
 		APIC_BASE_MSR + (APIC_EOI >> 4), false);
+
+	/* Allow guests on slave CPU to access local APIC timer directly */
+	vmx_disable_intercept_for_msr_slave(
+		APIC_BASE_MSR + (APIC_TMICT >> 4), false);
+	vmx_disable_intercept_for_msr_slave(
+		APIC_BASE_MSR + (APIC_TMCCT >> 4), false);
 #endif
 
 	if (enable_ept) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 609ab62..9d92581 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2707,6 +2707,9 @@ static int kvm_arch_vcpu_ioctl_set_slave_cpu(struct kvm_vcpu *vcpu,
 			goto out;
 		BUG_ON(!cpu_slave(slave));
 		per_cpu(slave_vcpu, slave) = vcpu;
+
+		if (vcpu->arch.apic)
+			override_local_apic_timer(slave, slave_lapic_timer_fn);
 	}
 
 	vcpu->arch.slave_cpu = slave;
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index f1aa3cc..f072c6a 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -223,6 +223,7 @@ static inline void enable_nonboot_cpus(void) {}
 
 #ifdef CONFIG_SLAVE_CPU
 int register_slave_cpu_notifier(struct notifier_block *nb);
+int register_slave_cpu_timer_notifier(struct notifier_block *nb);
 void unregister_slave_cpu_notifier(struct notifier_block *nb);
 
 /* CPU notifier constants for slave processors */
@@ -240,6 +241,10 @@ static inline int register_slave_cpu_notifier(struct notifier_block *nb)
 {
 	return 0;
 }
+static inline int register_slave_cpu_timer_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 static inline void unregister_slave_cpu_notifier(struct notifier_block *nb) {}
 #endif
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e899a2c..61d1706 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1773,7 +1773,7 @@ void __init hrtimers_init(void)
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
-	register_slave_cpu_notifier(&hrtimers_slave_nb);
+	register_slave_cpu_timer_notifier(&hrtimers_slave_nb);
 #ifdef CONFIG_HIGH_RES_TIMERS
 	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
 #endif


