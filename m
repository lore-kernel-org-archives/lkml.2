Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2FXQZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 12:25:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab2FXQZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 12:25:17 -0400
Date: Sun, 24 Jun 2012 19:25:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv9 8/8] kvm: host side for eoi optimization
Message-ID: <bb379f5ffc85da6bd69196c040b0a0fe21efbf1e.1340554550.git.mst@robin.redhat.com>
References: <cover.1340554550.git.mst@robin.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1340554550.git.mst@robin.redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementation of PV EOI using shared memory.
This reduces the number of exits an interrupt
causes as much as by half.

The idea is simple: there's a bit, per APIC, in guest memory,
that tells the guest that it does not need EOI.
We set it before injecting an interrupt and clear
before injecting a nested one. Guest tests it using
a test and clear operation - this is necessary
so that host can detect interrupt nesting -
and if set, it can skip the EOI MSR.

There's a new MSR to set the address of said register
in guest memory. Otherwise not much changed:
- Guest EOI is not required
- Register is tested & ISR is automatically cleared on exit

For testing results see description of previous patch
'kvm_para: guest side for eoi avoidance'.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   12 +++
 arch/x86/kvm/cpuid.c            |    1 +
 arch/x86/kvm/lapic.c            |  141 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/lapic.h            |    2 +
 arch/x86/kvm/trace.h            |   34 +++++++++
 arch/x86/kvm/x86.c              |    7 ++
 6 files changed, 193 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index db7c1f2..24b7647 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -175,6 +175,13 @@ enum {
 
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
+/*
+ * The following bit is set with PV-EOI, unset on EOI.
+ * We detect PV-EOI changes by guest by comparing
+ * this bit with PV-EOI in guest memory.
+ * See the implementation in apic_update_pv_eoi.
+ */
+#define KVM_APIC_PV_EOI_PENDING	1
 
 /*
  * We don't want allocation failures within the mmu code, so we preallocate
@@ -484,6 +491,11 @@ struct kvm_vcpu_arch {
 		u64 length;
 		u64 status;
 	} osvw;
+
+	struct {
+		u64 msr_val;
+		struct gfn_to_hva_cache data;
+	} pv_eoi;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7df1c6d..61ccbdf 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -409,6 +409,7 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
 			     (1 << KVM_FEATURE_ASYNC_PF) |
+			     (1 << KVM_FEATURE_PV_EOI) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
 
 		if (sched_info_on())
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 805d887..ce87878 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -311,6 +311,54 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq)
 			irq->level, irq->trig_mode);
 }
 
+static int pv_eoi_put_user(struct kvm_vcpu *vcpu, u8 val)
+{
+
+	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data, &val,
+				      sizeof(val));
+}
+
+static int pv_eoi_get_user(struct kvm_vcpu *vcpu, u8 *val)
+{
+
+	return kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data, val,
+				      sizeof(*val));
+}
+
+static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
+}
+
+static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
+{
+	u8 val;
+	if (pv_eoi_get_user(vcpu, &val) < 0)
+		apic_debug("Can't read EOI MSR value: 0x%llx\n",
+			   (unsigned long long)vcpi->arch.pv_eoi.msr_val);
+	return val & 0x1;
+}
+
+static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
+{
+	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0) {
+		apic_debug("Can't set EOI MSR value: 0x%llx\n",
+			   (unsigned long long)vcpi->arch.pv_eoi.msr_val);
+		return;
+	}
+	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
+}
+
+static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
+{
+	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
+		apic_debug("Can't clear EOI MSR value: 0x%llx\n",
+			   (unsigned long long)vcpi->arch.pv_eoi.msr_val);
+		return;
+	}
+	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
+}
+
 static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 {
 	int result;
@@ -527,15 +575,18 @@ int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
 	return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
 }
 
-static void apic_set_eoi(struct kvm_lapic *apic)
+static int apic_set_eoi(struct kvm_lapic *apic)
 {
 	int vector = apic_find_highest_isr(apic);
+
+	trace_kvm_eoi(apic, vector);
+
 	/*
 	 * Not every write EOI will has corresponding ISR,
 	 * one example is when Kernel check timer on setup_IO_APIC
 	 */
 	if (vector == -1)
-		return;
+		return vector;
 
 	apic_clear_isr(vector, apic);
 	apic_update_ppr(apic);
@@ -550,6 +601,7 @@ static void apic_set_eoi(struct kvm_lapic *apic)
 		kvm_ioapic_update_eoi(apic->vcpu->kvm, vector, trigger_mode);
 	}
 	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+	return vector;
 }
 
 static void apic_send_ipi(struct kvm_lapic *apic)
@@ -1132,6 +1184,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	atomic_set(&apic->lapic_timer.pending, 0);
 	if (kvm_vcpu_is_bsp(vcpu))
 		vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
+	vcpu->arch.pv_eoi.msr_val = 0;
 	apic_update_ppr(apic);
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -1332,11 +1385,51 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
 }
 
+/*
+ * apic_sync_pv_eoi_from_guest - called on vmexit or cancel interrupt
+ *
+ * Detect whether guest triggered PV EOI since the
+ * last entry. If yes, set EOI on guests's behalf.
+ * Clear PV EOI in guest memory in any case.
+ */
+static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
+					struct kvm_lapic *apic)
+{
+	bool pending;
+	int vector;
+	/*
+	 * PV EOI state is derived from KVM_APIC_PV_EOI_PENDING in host
+	 * and KVM_PV_EOI_ENABLED in guest memory as follows:
+	 *
+	 * KVM_APIC_PV_EOI_PENDING is unset:
+	 * 	-> host disabled PV EOI.
+	 * KVM_APIC_PV_EOI_PENDING is set, KVM_PV_EOI_ENABLED is set:
+	 * 	-> host enabled PV EOI, guest did not execute EOI yet.
+	 * KVM_APIC_PV_EOI_PENDING is set, KVM_PV_EOI_ENABLED is unset:
+	 * 	-> host enabled PV EOI, guest executed EOI.
+	 */
+	BUG_ON(!pv_eoi_enabled(vcpu));
+	pending = pv_eoi_get_pending(vcpu);
+	/*
+	 * Clear pending bit in any case: it will be set again on vmentry.
+	 * While this might not be ideal from performance point of view,
+	 * this makes sure pv eoi is only enabled when we know it's safe.
+	 */
+	pv_eoi_clr_pending(vcpu);
+	if (pending)
+		return;
+	vector = apic_set_eoi(apic);
+	trace_kvm_pv_eoi(apic, vector);
+}
+
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
 {
 	u32 data;
 	void *vapic;
 
+	if (test_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention))
+		apic_sync_pv_eoi_from_guest(vcpu, vcpu->arch.apic);
+
 	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
 		return;
 
@@ -1347,17 +1440,44 @@ void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
 	apic_set_tpr(vcpu->arch.apic, data & 0xff);
 }
 
+/*
+ * apic_sync_pv_eoi_to_guest - called before vmentry
+ *
+ * Detect whether it's safe to enable PV EOI and
+ * if yes do so.
+ */
+static void apic_sync_pv_eoi_to_guest(struct kvm_vcpu *vcpu,
+					struct kvm_lapic *apic)
+{
+	if (!pv_eoi_enabled(vcpu) ||
+	    /* IRR set or many bits in ISR: could be nested. */
+	    apic->irr_pending ||
+	    /* Cache not set: could be safe but we don't bother. */
+	    apic->highest_isr_cache == -1 ||
+	    /* Need EOI to update ioapic. */
+	    kvm_ioapic_handles_vector(vcpu->kvm, apic->highest_isr_cache)) {
+		/*
+		 * PV EOI was disabled by apic_sync_pv_eoi_from_guest
+		 * so we need not do anything here.
+		 */
+		return;
+	}
+
+	pv_eoi_set_pending(apic->vcpu);
+}
+
 void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
 {
 	u32 data, tpr;
 	int max_irr, max_isr;
-	struct kvm_lapic *apic;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 	void *vapic;
 
+	apic_sync_pv_eoi_to_guest(vcpu, apic);
+
 	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
 		return;
 
-	apic = vcpu->arch.apic;
 	tpr = apic_get_reg(apic, APIC_TASKPRI) & 0xff;
 	max_irr = apic_find_highest_irr(apic);
 	if (max_irr < 0)
@@ -1443,3 +1563,16 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
 
 	return 0;
 }
+
+int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data)
+{
+	u64 addr = data & ~KVM_MSR_ENABLED;
+	if (!IS_ALIGNED(addr, 4))
+		return 1;
+
+	vcpu->arch.pv_eoi.msr_val = data;
+	if (!pv_eoi_enabled(vcpu))
+		return 0;
+	return kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.pv_eoi.data,
+					 addr);
+}
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 5ac9e5e..4af5405 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -69,4 +69,6 @@ static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.hv_vapic & HV_X64_MSR_APIC_ASSIST_PAGE_ENABLE;
 }
+
+int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data);
 #endif
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 911d264..851914e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -517,6 +517,40 @@ TRACE_EVENT(kvm_apic_accept_irq,
 		  __entry->coalesced ? " (coalesced)" : "")
 );
 
+TRACE_EVENT(kvm_eoi,
+	    TP_PROTO(struct kvm_lapic *apic, int vector),
+	    TP_ARGS(apic, vector),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		apicid		)
+		__field(	int,		vector		)
+	),
+
+	TP_fast_assign(
+		__entry->apicid		= apic->vcpu->vcpu_id;
+		__entry->vector		= vector;
+	),
+
+	TP_printk("apicid %x vector %d", __entry->apicid, __entry->vector)
+);
+
+TRACE_EVENT(kvm_pv_eoi,
+	    TP_PROTO(struct kvm_lapic *apic, int vector),
+	    TP_ARGS(apic, vector),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		apicid		)
+		__field(	int,		vector		)
+	),
+
+	TP_fast_assign(
+		__entry->apicid		= apic->vcpu->vcpu_id;
+		__entry->vector		= vector;
+	),
+
+	TP_printk("apicid %x vector %d", __entry->apicid, __entry->vector)
+);
+
 /*
  * Tracepoint for nested VMRUN
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cb19d3b..3913fb1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -795,6 +795,7 @@ static u32 msrs_to_save[] = {
 	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
 	HV_X64_MSR_APIC_ASSIST_PAGE, MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
+	MSR_KVM_PV_EOI_EN,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_STAR,
 #ifdef CONFIG_X86_64
@@ -1653,6 +1654,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 
 		break;
+	case MSR_KVM_PV_EOI_EN:
+		if (kvm_lapic_enable_pv_eoi(vcpu, data))
+			return 1;
+		break;
 
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
@@ -5394,6 +5399,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 cancel_injection:
 	kvm_x86_ops->cancel_injection(vcpu);
+	if (unlikely(vcpu->arch.apic_attention))
+		kvm_lapic_sync_from_vapic(vcpu);
 out:
 	return r;
 }
-- 
1.6.3.2.307.gdf0b
