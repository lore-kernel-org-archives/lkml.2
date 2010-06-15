Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0FOHea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:34:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab0FOHe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:26 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 01/17] Eliminate duplicated timer code
Date: Mon, 14 Jun 2010 21:34:03 -1000
Message-Id: <1276587259-32319-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move duplicated timer related code into arch_vcpu_load rather
than vendor callouts.  Should be an isomorphic transformation.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/svm.c |    2 --
 arch/x86/kvm/vmx.c |    3 +--
 arch/x86/kvm/x86.c |    4 ++++
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2ae0c39..09b2145 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -960,8 +960,6 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			if (is_nested(svm))
 				svm->nested.hsave->control.tsc_offset += delta;
 		}
-		vcpu->cpu = cpu;
-		kvm_migrate_timers(vcpu);
 		svm->asid_generation = 0;
 	}
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b1542b9..a657e08 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -898,14 +898,12 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		struct desc_ptr dt;
 		unsigned long sysenter_esp;
 
-		kvm_migrate_timers(vcpu);
 		set_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests);
 		local_irq_disable();
 		list_add(&vmx->local_vcpus_link,
 			 &per_cpu(vcpus_on_cpu, cpu));
 		local_irq_enable();
 
-		vcpu->cpu = cpu;
 		/*
 		 * Linux uses per-cpu TSS and GDT, so set these when switching
 		 * processors.
@@ -4106,6 +4104,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	cpu = get_cpu();
 	vmx_vcpu_load(&vmx->vcpu, cpu);
+	vmx->vcpu.cpu = cpu;
 	err = vmx_vcpu_setup(vmx);
 	vmx_vcpu_put(&vmx->vcpu);
 	put_cpu();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a4073b..05754c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1799,6 +1799,9 @@ out:
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	if (unlikely(vcpu->cpu != cpu)) {
+		kvm_migrate_timers(vcpu);
+	}
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
 	if (unlikely(per_cpu(cpu_tsc_khz, cpu) == 0)) {
 		unsigned long khz = cpufreq_quick_get(cpu);
@@ -1807,6 +1810,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		per_cpu(cpu_tsc_khz, cpu) = khz;
 	}
 	kvm_request_guest_time_update(vcpu);
+	vcpu->cpu = cpu;
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
-- 
1.7.1

