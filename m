Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0GMCJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:09:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab0GMCJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:09:12 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 09/18] Add helper functions for time computation
Date: Mon, 12 Jul 2010 16:08:03 -1000
Message-Id: <1278986892-11733-10-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278986892-11733-1-git-send-email-zamsden@redhat.com>
References: <1278986892-11733-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper function to compute the kernel time and convert nanoseconds
back to CPU specific cycles.  Note that these must not be called in preemptible
context, as that would mean the kernel could enter software suspend state,
which would cause non-atomic operation.

Also, convert the KVM_SET_CLOCK / KVM_GET_CLOCK ioctls to use the kernel
time helper, these should be bootbased as well.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   51 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ad6419..ad58c77 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -891,6 +891,16 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 		 hv_clock->tsc_to_system_mul);
 }
 
+static inline u64 get_kernel_ns(void)
+{
+	struct timespec ts;
+
+	WARN_ON(preemptible());
+	ktime_get_ts(&ts);
+	monotonic_to_bootbased(&ts);
+	return timespec_to_ns(&ts);
+}
+
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 
 static inline int kvm_tsc_changes_freq(void)
@@ -902,21 +912,24 @@ static inline int kvm_tsc_changes_freq(void)
 	return ret;
 }
 
+static inline u64 nsec_to_cycles(u64 nsec)
+{
+	WARN_ON(preemptible());
+	if (kvm_tsc_changes_freq())
+		printk_once(KERN_WARNING
+		 "kvm: unreliable cycle conversion on adjustable rate TSC\n");
+	return (nsec * __get_cpu_var(cpu_tsc_khz)) / USEC_PER_SEC;
+}
+
 void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
-<<<<<<< HEAD
-	struct timespec ts;
-=======
 	s64 sdiff;
->>>>>>> db4c819... oops
 
 	spin_lock(&kvm->arch.tsc_write_lock);
 	offset = data - native_read_tsc();
-	ktime_get_ts(&ts);
-	monotonic_to_bootbased(&ts);
-	ns = timespec_to_ns(&ts);
+	ns = get_kernel_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 	sdiff = data - kvm->arch.last_tsc_write;
 	if (sdiff < 0)
@@ -937,10 +950,9 @@ void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 			offset = kvm->arch.last_tsc_offset;
 			pr_debug("kvm: matched tsc offset for %llu\n", data);
 		} else {
-			u64 tsc_delta = elapsed * __get_cpu_var(cpu_tsc_khz);
-			tsc_delta = tsc_delta / USEC_PER_SEC;
-			offset += tsc_delta;
-			pr_debug("kvm: adjusted tsc offset by %llu\n", tsc_delta);
+			u64 delta = nsec_to_cycles(elapsed);
+			offset += delta;
+			pr_debug("kvm: adjusted tsc offset by %llu\n", delta);
 		}
 		ns = kvm->arch.last_tsc_nsec;
 	}
@@ -957,11 +969,11 @@ EXPORT_SYMBOL_GPL(guest_write_tsc);
 
 static int kvm_write_guest_time(struct kvm_vcpu *v)
 {
-	struct timespec ts;
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	void *shared_kaddr;
 	unsigned long this_tsc_khz;
+	s64 kernel_ns;
 
 	if ((!vcpu->time_page))
 		return 0;
@@ -969,8 +981,7 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &vcpu->hv_clock.tsc_timestamp);
-	ktime_get_ts(&ts);
-	monotonic_to_bootbased(&ts);
+	kernel_ns = get_kernel_ns();
 	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
 	local_irq_restore(flags);
 
@@ -985,9 +996,7 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 	}
 
 	/* With all the info we got, fill in the values */
-	vcpu->hv_clock.system_time = ts.tv_nsec +
-				     (NSEC_PER_SEC * (u64)ts.tv_sec) + v->kvm->arch.kvmclock_offset;
-
+	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->hv_clock.flags = 0;
 
 	/*
@@ -3270,7 +3279,6 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_SET_CLOCK: {
-		struct timespec now;
 		struct kvm_clock_data user_ns;
 		u64 now_ns;
 		s64 delta;
@@ -3284,19 +3292,16 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 
 		r = 0;
-		ktime_get_ts(&now);
-		now_ns = timespec_to_ns(&now);
+		now_ns = get_kernel_ns();
 		delta = user_ns.clock - now_ns;
 		kvm->arch.kvmclock_offset = delta;
 		break;
 	}
 	case KVM_GET_CLOCK: {
-		struct timespec now;
 		struct kvm_clock_data user_ns;
 		u64 now_ns;
 
-		ktime_get_ts(&now);
-		now_ns = timespec_to_ns(&now);
+		now_ns = get_kernel_ns();
 		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
 		user_ns.flags = 0;
 
-- 
1.7.1

