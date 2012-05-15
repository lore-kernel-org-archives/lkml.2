Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab2EOOgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:36:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846Ab2EOOgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:36:24 -0400
Date: Tue, 15 May 2012 17:36:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 7/8] kvm: host side for eoi optimization
Message-ID: <b245c020a1e03a1622f4e51d5773a64123853322.1337091955.git.mst@redhat.com>
References: <cover.1337091955.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1337091955.git.mst@redhat.com>
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

For tetsing results see description of patch 7 of the series.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    6 ++
 arch/x86/include/asm/kvm_para.h |    2 +
 arch/x86/kvm/cpuid.c            |    1 +
 arch/x86/kvm/irq.c              |    2 +-
 arch/x86/kvm/lapic.c            |  110 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.h            |    2 +
 arch/x86/kvm/trace.h            |   34 ++++++++++++
 arch/x86/kvm/x86.c              |    8 +++-
 8 files changed, 158 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32297f2..7673f4d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -174,6 +174,7 @@ enum {
 
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
+#define KVM_APIC_EOI_PENDING	1
 
 /*
  * We don't want allocation failures within the mmu code, so we preallocate
@@ -485,6 +486,11 @@ struct kvm_vcpu_arch {
 		u64 length;
 		u64 status;
 	} osvw;
+
+	struct {
+		u64 msr_val;
+		struct gfn_to_hva_cache data;
+	} eoi;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 734c376..195840d 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -22,6 +22,7 @@
 #define KVM_FEATURE_CLOCKSOURCE2        3
 #define KVM_FEATURE_ASYNC_PF		4
 #define KVM_FEATURE_STEAL_TIME		5
+#define KVM_FEATURE_EOI			6
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -37,6 +38,7 @@
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
+#define MSR_KVM_EOI_EN      0x4b564d04
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index eba8345..bda4877 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -408,6 +408,7 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
 			     (1 << KVM_FEATURE_ASYNC_PF) |
+			     (1 << KVM_FEATURE_EOI) |
 			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
 
 		if (sched_info_on())
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 7e06ba1..07bdfab 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -48,7 +48,7 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 	if (!irqchip_in_kernel(v->kvm))
 		return v->arch.interrupt.pending;
 
-	if (kvm_apic_has_interrupt(v) == -1) {	/* LAPIC */
+	if (kvm_apic_has_interrupt(v) < 0) {	/* LAPIC */
 		if (kvm_apic_accept_pic_intr(v)) {
 			s = pic_irqchip(v->kvm);	/* PIC */
 			return s->output;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 93c1574..c7e6ffb 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -270,6 +270,54 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq)
 			irq->level, irq->trig_mode);
 }
 
+static int eoi_put_user(struct kvm_vcpu *vcpu, u8 val)
+{
+
+	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.eoi.data, &val,
+				      sizeof(val));
+}
+
+static int eoi_get_user(struct kvm_vcpu *vcpu, u8 *val)
+{
+
+	return kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.eoi.data, val,
+				      sizeof(*val));
+}
+
+static inline bool eoi_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.eoi.msr_val & KVM_MSR_ENABLED;
+}
+
+static bool eoi_get_pending(struct kvm_vcpu *vcpu)
+{
+	u8 val;
+	if (eoi_get_user(vcpu, &val) < 0)
+		apic_debug("Can't read EOI MSR value: 0x%llx\n",
+			   (unsigned long long)vcpi->arch.eoi.msr_val);
+	return val & 0x1;
+}
+
+static void eoi_set_pending(struct kvm_vcpu *vcpu)
+{
+	if (eoi_put_user(vcpu, 0x1) < 0) {
+		apic_debug("Can't set EOI MSR value: 0x%llx\n",
+			   (unsigned long long)vcpi->arch.eoi.msr_val);
+		return;
+	}
+	__set_bit(KVM_APIC_EOI_PENDING, &vcpu->arch.apic_attention);
+}
+
+static void eoi_clr_pending(struct kvm_vcpu *vcpu)
+{
+	if (eoi_put_user(vcpu, 0x0) < 0) {
+		apic_debug("Can't clear EOI MSR value: 0x%llx\n",
+			   (unsigned long long)vcpi->arch.eoi.msr_val);
+		return;
+	}
+	__clear_bit(KVM_APIC_EOI_PENDING, &vcpu->arch.apic_attention);
+}
+
 static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 {
 	int result;
@@ -482,16 +530,21 @@ int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
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
 
+	if (eoi_enabled(apic->vcpu))
+		eoi_clr_pending(apic->vcpu);
 	apic_clear_vector(vector, apic->regs + APIC_ISR);
 	apic_update_ppr(apic);
 
@@ -505,6 +558,7 @@ static void apic_set_eoi(struct kvm_lapic *apic)
 		kvm_ioapic_update_eoi(apic->vcpu->kvm, vector, trigger_mode);
 	}
 	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+	return vector;
 }
 
 static void apic_send_ipi(struct kvm_lapic *apic)
@@ -1085,6 +1139,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	atomic_set(&apic->lapic_timer.pending, 0);
 	if (kvm_vcpu_is_bsp(vcpu))
 		vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
+	vcpu->arch.eoi.msr_val = 0;
 	apic_update_ppr(apic);
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -1211,9 +1266,10 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 
 	apic_update_ppr(apic);
 	highest_irr = apic_find_highest_irr(apic);
-	if ((highest_irr == -1) ||
-	    ((highest_irr & 0xF0) <= apic_get_reg(apic, APIC_PROCPRI)))
+	if (highest_irr == -1)
 		return -1;
+	if (((highest_irr & 0xF0) <= apic_get_reg(apic, APIC_PROCPRI)))
+		return -2;
 	return highest_irr;
 }
 
@@ -1245,9 +1301,20 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	int vector = kvm_apic_has_interrupt(vcpu);
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (vector == -1)
+	/* Detect interrupt nesting and disable EOI optimization */
+	if (eoi_enabled(vcpu) && vector == -2)
+		eoi_clr_pending(vcpu);
+
+	if (vector < 0)
 		return -1;
 
+	if (eoi_enabled(vcpu)) {
+		if (kvm_ioapic_handles_vector(vcpu->kvm, vector))
+			eoi_clr_pending(vcpu);
+		else
+			eoi_set_pending(vcpu);
+	}
+
 	apic_set_vector(vector, apic->regs + APIC_ISR);
 	apic_update_ppr(apic);
 	apic_clear_irr(vector, apic);
@@ -1262,6 +1329,14 @@ void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu)
 			     MSR_IA32_APICBASE_BASE;
 	kvm_apic_set_version(vcpu);
 
+	if (eoi_enabled(apic->vcpu)) {
+		if (eoi_get_pending(apic->vcpu))
+			__set_bit(KVM_APIC_EOI_PENDING,
+				  &vcpu->arch.apic_attention);
+		else
+			__clear_bit(KVM_APIC_EOI_PENDING,
+				    &vcpu->arch.apic_attention);
+	}
 	apic_update_ppr(apic);
 	hrtimer_cancel(&apic->lapic_timer.timer);
 	update_divide_count(apic);
@@ -1283,11 +1358,25 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
 }
 
+static void apic_update_eoi(struct kvm_lapic *apic)
+{
+	int vector;
+	BUG_ON(!eoi_enabled(apic->vcpu));
+	if (eoi_get_pending(apic->vcpu))
+		return;
+	__clear_bit(KVM_APIC_EOI_PENDING, &apic->vcpu->arch.apic_attention);
+	vector = apic_set_eoi(apic);
+	trace_kvm_pv_eoi(apic, vector);
+}
+
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
 {
 	u32 data;
 	void *vapic;
 
+	if (test_bit(KVM_APIC_EOI_PENDING, &vcpu->arch.apic_attention))
+		apic_update_eoi(vcpu->arch.apic);
+
 	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
 		return;
 
@@ -1394,3 +1483,14 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
 
 	return 0;
 }
+
+int kvm_pv_enable_apic_eoi(struct kvm_vcpu *vcpu, u64 data)
+{
+	u64 addr = data & ~KVM_MSR_ENABLED;
+	if (eoi_enabled(vcpu))
+		eoi_clr_pending(vcpu);
+	vcpu->arch.eoi.msr_val = data;
+	if (!eoi_enabled(vcpu))
+		return 0;
+	return kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.eoi.data, addr);
+}
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 6f4ce25..042dace 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -60,4 +60,6 @@ static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.hv_vapic & HV_X64_MSR_APIC_ASSIST_PAGE_ENABLE;
 }
+
+int kvm_pv_enable_apic_eoi(struct kvm_vcpu *vcpu, u64 data);
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
index 185a2b8..bfcd97d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -795,6 +795,7 @@ static u32 msrs_to_save[] = {
 	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
 	HV_X64_MSR_APIC_ASSIST_PAGE, MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
+	MSR_KVM_EOI_EN,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_STAR,
 #ifdef CONFIG_X86_64
@@ -1653,6 +1654,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 
 		break;
+	case MSR_KVM_EOI_EN:
+		if (kvm_pv_enable_apic_eoi(vcpu, data))
+			return 1;
+		break;
 
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
@@ -5370,7 +5375,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (unlikely(vcpu->arch.tsc_always_catchup))
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
-	kvm_lapic_sync_from_vapic(vcpu);
+	if (unlikely(vcpu->arch.apic_attention))
+		kvm_lapic_sync_from_vapic(vcpu);
 
 	r = kvm_x86_ops->handle_exit(vcpu);
 out:
-- 
MST

