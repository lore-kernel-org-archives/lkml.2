Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab1ALHkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 02:40:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60200 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755730Ab1ALHkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 02:40:33 -0500
Message-ID: <4D2D5AEF.1070006@cn.fujitsu.com>
Date: Wed, 12 Jan 2011 15:40:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 2/3] KVM: send IPI to vcpu only when it's in guest mode
References: <4D2D5AA6.9080804@cn.fujitsu.com>
In-Reply-To: <4D2D5AA6.9080804@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-12 15:40:04,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-12 15:40:04,
	Serialize complete at 2011-01-12 15:40:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can interrupt the vcpu only when it's running in guest mode
to reduce IPI

Also
1: No need atomically to read/write ->mode in vcpu's thread

2: reorganize struct kvm_vcpu to make ->mode and ->requests
   in the same cache line explicitly

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 ++
 arch/x86/kvm/x86.c       |   16 ++++++++++------
 include/linux/kvm_host.h |   22 +++++++++++++++++-----
 virt/kvm/kvm_main.c      |    7 ++++++-
 4 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 70d224d..8213efe 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -662,6 +662,7 @@ again:
 		goto vcpu_run_fail;
 
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	vcpu->mode = IN_GUEST_MODE;
 	kvm_guest_enter();
 
 	/*
@@ -683,6 +684,7 @@ again:
 	 */
 	barrier();
 	kvm_guest_exit();
+	vcpu->mode = OUTSIDE_GUEST_MODE;
 	preempt_enable();
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b77e9c..434363e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5213,14 +5213,18 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_load_guest_fpu(vcpu);
 	kvm_load_guest_xcr0(vcpu);
 
-	atomic_set(&vcpu->guest_mode, 1);
-	smp_wmb();
+	vcpu->mode = IN_GUEST_MODE;
+
+	/* We should set ->mode before check ->requests,
+	 * see the comment in make_all_cpus_request.
+	 */
+	smp_mb();
 
 	local_irq_disable();
 
-	if (!atomic_read(&vcpu->guest_mode) || vcpu->requests
+	if (vcpu->mode == EXITING_GUEST_MODE || vcpu->requests
 	    || need_resched() || signal_pending(current)) {
-		atomic_set(&vcpu->guest_mode, 0);
+		vcpu->mode = OUTSIDE_GUEST_MODE;
 		smp_wmb();
 		local_irq_enable();
 		preempt_enable();
@@ -5256,7 +5260,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
 
-	atomic_set(&vcpu->guest_mode, 0);
+	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 	local_irq_enable();
 
@@ -6157,7 +6161,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 
 	me = get_cpu();
 	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
-		if (atomic_xchg(&vcpu->guest_mode, 0))
+		if (kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE)
 			smp_send_reschedule(cpu);
 	put_cpu();
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b5021db..b99eacd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -98,19 +98,26 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
+enum {
+	OUTSIDE_GUEST_MODE,
+	IN_GUEST_MODE,
+	EXITING_GUEST_MODE
+};
+
 struct kvm_vcpu {
 	struct kvm *kvm;
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	struct preempt_notifier preempt_notifier;
 #endif
+	int cpu;
 	int vcpu_id;
-	struct mutex mutex;
-	int   cpu;
-	atomic_t guest_mode;
-	struct kvm_run *run;
+	int srcu_idx;
+	int mode;
 	unsigned long requests;
 	unsigned long guest_debug;
-	int srcu_idx;
+
+	struct mutex mutex;
+	struct kvm_run *run;
 
 	int fpu_active;
 	int guest_fpu_loaded, guest_xcr0_loaded;
@@ -140,6 +147,11 @@ struct kvm_vcpu {
 	struct kvm_vcpu_arch arch;
 };
 
+static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
+{
+	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
+}
+
 /*
  * Some of the bitops functions do not support too long bitmaps.
  * This number must be determined not to exceed such limits.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b1b6cbb..71a4eaf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -153,7 +153,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 		if (kvm_make_check_request(req, vcpu))
 			continue;
 		cpu = vcpu->cpu;
-		if (cpus != NULL && cpu != -1 && cpu != me)
+
+		/* Set ->requests bit before we read ->mode */
+		smp_mb();
+
+		if (cpus != NULL && cpu != -1 && cpu != me &&
+		      kvm_vcpu_exiting_guest_mode(vcpu) != OUTSIDE_GUEST_MODE)
 			cpumask_set_cpu(cpu, cpus);
 	}
 	if (unlikely(cpus == NULL))
-- 
1.7.3.4


