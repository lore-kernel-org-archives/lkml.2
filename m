Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1FUAAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:00:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab1FTX7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:53 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Zachary Amsden <zamsden@gmail.com>
Subject: [KVM TSC emulation 1/9] Infrastructure for software and hardware based TSC rate scaling
Date: Mon, 20 Jun 2011 16:59:29 -0700
Message-Id: <1308614377-18627-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
References: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This requires some restructuring; rather than use 'virtual_tsc_khz'
to indicate whether hardware rate scaling is in effect, we consider
each VCPU to always have a virtual TSC rate.  Instead, there is new
logic above the vendor-specific hardware scaling that decides whether
it is even necessary to use and updates all rate variables used by
common code.  This means we can simply query the virtual rate at
any point, which is needed for software rate scaling.

There is also now a threshold added to the TSC rate scaling; minor
differences and variations of measured TSC rate can accidentally
provoke rate scaling to be used when it is not needed.  Instead,
we have a tolerance variable called tsc_tolerance_ppm, which is
the maximum variation from user requested rate at which scaling
will be used.  The default is 250ppm, which is the half the
threshold for NTP adjustment, allowing for some hardware variation.

In the event that hardware rate scaling is not available, we can
kludge a bit by forcing TSC catchup to turn on when a faster than
hardware speed has been requested, but there is nothing available
yet for the reverse case; this requires a trap and emulate software
implementation for RDTSC, which is still forthcoming.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    9 ++--
 arch/x86/kvm/svm.c              |   20 ++++++----
 arch/x86/kvm/vmx.c              |   16 +++++--
 arch/x86/kvm/x86.c              |   82 ++++++++++++++++++--------------------
 include/linux/kvm.h             |    1 +
 5 files changed, 68 insertions(+), 60 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index da6bbee..184cd38 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -393,10 +393,11 @@ struct kvm_vcpu_arch {
 	u64 last_kernel_ns;
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
-	u32 virtual_tsc_khz;
 	bool tsc_catchup;
-	u32  tsc_catchup_mult;
-	s8   tsc_catchup_shift;
+	bool tsc_always_catchup;
+	s8 virtual_tsc_shift;
+	u32 virtual_tsc_mult;
+	u32 virtual_tsc_khz;
 
 	bool nmi_pending;
 	bool nmi_injected;
@@ -604,7 +605,7 @@ struct kvm_x86_ops {
 
 	bool (*has_wbinvd_exit)(void);
 
-	void (*set_tsc_khz)(struct kvm_vcpu *vcpu, u32 user_tsc_khz);
+	void (*set_tsc_khz)(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale);
 	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
 
 	u64 (*compute_tsc_offset)(struct kvm_vcpu *vcpu, u64 target_tsc);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 475d1c9..47f557e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -905,20 +905,25 @@ static u64 svm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
 	return _tsc;
 }
 
-static void svm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
+static void svm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 ratio;
 	u64 khz;
 
-	/* TSC scaling supported? */
-	if (!boot_cpu_has(X86_FEATURE_TSCRATEMSR))
+	/* Guest TSC same frequency as host TSC? */
+	if (!scale) {
+		svm->tsc_ratio = TSC_RATIO_DEFAULT;
 		return;
+	}
 
-	/* TSC-Scaling disabled or guest TSC same frequency as host TSC? */
-	if (user_tsc_khz == 0) {
-		vcpu->arch.virtual_tsc_khz = 0;
-		svm->tsc_ratio = TSC_RATIO_DEFAULT;
+	/* TSC scaling supported? */
+	if (!boot_cpu_has(X86_FEATURE_TSCRATEMSR)) {
+		if (user_tsc_khz > tsc_khz) {
+			vcpu->arch.tsc_catchup = 1;
+			vcpu->arch.tsc_always_catchup = 1;
+		} else
+			WARN(1, "user requested TSC rate below hardware speed\n");
 		return;
 	}
 
@@ -933,7 +938,6 @@ static void svm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 				user_tsc_khz);
 		return;
 	}
-	vcpu->arch.virtual_tsc_khz = user_tsc_khz;
 	svm->tsc_ratio             = ratio;
 }
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f5b49c7..bc3ecfd 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1751,13 +1751,19 @@ static u64 guest_read_tsc(void)
 }
 
 /*
- * Empty call-back. Needs to be implemented when VMX enables the SET_TSC_KHZ
- * ioctl. In this case the call-back should update internal vmx state to make
- * the changes effective.
+ * Engage any workarounds for mis-matched TSC rates.  Currently limited to
+ * software catchup for faster rates on slower CPUs.
  */
-static void vmx_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
+static void vmx_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 {
-	/* Nothing to do here */
+	if (!scale)
+		return;
+
+	if (user_tsc_khz > tsc_khz) {
+		vcpu->arch.tsc_catchup = 1;
+		vcpu->arch.tsc_always_catchup = 1;
+	} else
+		WARN(1, "user requested TSC rate below hardware speed\n");
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b803f0..776895a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -95,6 +95,10 @@ EXPORT_SYMBOL_GPL(kvm_has_tsc_control);
 u32  kvm_max_guest_tsc_khz;
 EXPORT_SYMBOL_GPL(kvm_max_guest_tsc_khz);
 
+/* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
+static u32 tsc_tolerance_ppm = 250;
+module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
+
 #define KVM_NR_SHARED_MSRS 16
 
 struct kvm_shared_msrs_global {
@@ -991,49 +995,43 @@ static inline u64 get_kernel_ns(void)
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 unsigned long max_tsc_khz;
 
-static inline int kvm_tsc_changes_freq(void)
-{
-	int cpu = get_cpu();
-	int ret = !boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
-		  cpufreq_quick_get(cpu) != 0;
-	put_cpu();
-	return ret;
-}
-
-static u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.virtual_tsc_khz)
-		return vcpu->arch.virtual_tsc_khz;
-	else
-		return __this_cpu_read(cpu_tsc_khz);
-}
-
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
-	u64 ret;
-
-	WARN_ON(preemptible());
-	if (kvm_tsc_changes_freq())
-		printk_once(KERN_WARNING
-		 "kvm: unreliable cycle conversion on adjustable rate TSC\n");
-	ret = nsec * vcpu_tsc_khz(vcpu);
-	do_div(ret, USEC_PER_SEC);
-	return ret;
+	return pvclock_scale_delta(nsec, vcpu->arch.virtual_tsc_mult,
+				   vcpu->arch.virtual_tsc_shift);
 }
 
-static void kvm_init_tsc_catchup(struct kvm_vcpu *vcpu, u32 this_tsc_khz)
+static void kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 this_tsc_khz)
 {
+	u32 thresh_lo, thresh_hi;
+	int use_scaling = 0;
+
 	/* Compute a scale to convert nanoseconds in TSC cycles */
 	kvm_get_time_scale(this_tsc_khz, NSEC_PER_SEC / 1000,
-			   &vcpu->arch.tsc_catchup_shift,
-			   &vcpu->arch.tsc_catchup_mult);
+			   &vcpu->arch.virtual_tsc_shift,
+			   &vcpu->arch.virtual_tsc_mult);
+	vcpu->arch.virtual_tsc_khz = this_tsc_khz;
+
+	/*
+	 * Compute the variation in TSC rate which is acceptable
+	 * within the range of tolerance and decide if the
+	 * rate being applied is within that bounds of the hardware
+	 * rate.  If so, no scaling or compensation need be done.
+	 */
+	thresh_lo = (u64)tsc_khz * (1000000 - tsc_tolerance_ppm) / 1000000;
+	thresh_hi = (u64)tsc_khz * (1000000 + tsc_tolerance_ppm) / 1000000;
+	if (this_tsc_khz < thresh_lo || this_tsc_khz > thresh_hi) {
+		pr_debug("kvm: requested TSC rate %u falls outside tolerance [%u,%u]\n", this_tsc_khz, thresh_lo, thresh_hi);
+		use_scaling = 1;
+	}
+	kvm_x86_ops->set_tsc_khz(vcpu, this_tsc_khz, use_scaling);	
 }
 
 static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
 {
 	u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.last_tsc_nsec,
-				      vcpu->arch.tsc_catchup_mult,
-				      vcpu->arch.tsc_catchup_shift);
+				      vcpu->arch.virtual_tsc_mult,
+				      vcpu->arch.virtual_tsc_shift);
 	tsc += vcpu->arch.last_tsc_write;
 	return tsc;
 }
@@ -1100,7 +1098,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
 	kernel_ns = get_kernel_ns();
-	this_tsc_khz = vcpu_tsc_khz(v);
+	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
 	if (unlikely(this_tsc_khz == 0)) {
 		local_irq_restore(flags);
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
@@ -2018,6 +2016,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
 	case KVM_CAP_GET_TSC_KHZ:
+	case KVM_CAP_SET_TSC_KHZ:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -3176,26 +3175,21 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		u32 user_tsc_khz;
 
 		r = -EINVAL;
-		if (!kvm_has_tsc_control)
-			break;
-
 		user_tsc_khz = (u32)arg;
 
 		if (user_tsc_khz >= kvm_max_guest_tsc_khz)
 			goto out;
 
-		kvm_x86_ops->set_tsc_khz(vcpu, user_tsc_khz);
+		if (user_tsc_khz == 0)
+			user_tsc_khz = tsc_khz;
+
+		kvm_set_tsc_khz(vcpu, user_tsc_khz);
 
 		r = 0;
 		goto out;
 	}
 	case KVM_GET_TSC_KHZ: {
-		r = -EIO;
-		if (check_tsc_unstable())
-			goto out;
-
-		r = vcpu_tsc_khz(vcpu);
-
+		r = vcpu->arch.virtual_tsc_khz;
 		goto out;
 	}
 	default:
@@ -5581,6 +5575,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		profile_hit(KVM_PROFILING, (void *)rip);
 	}
 
+	if (unlikely(vcpu->arch.tsc_always_catchup))
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
 	kvm_lapic_sync_from_vapic(vcpu);
 
@@ -6277,7 +6273,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	}
 	vcpu->arch.pio_data = page_address(page);
 
-	kvm_init_tsc_catchup(vcpu, max_tsc_khz);
+	kvm_set_tsc_khz(vcpu, max_tsc_khz);
 
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 9c9ca7c..31adf3d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -544,6 +544,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_TSC_CONTROL 60
 #define KVM_CAP_GET_TSC_KHZ 61
 #define KVM_CAP_PPC_BOOKE_SREGS 62
+#define KVM_CAP_SET_TSC_KHZ 63
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.7.1

