Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0KXRoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:44:32 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56474 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab0KXRoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:44:30 -0500
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: <x86@kernel.org>, kvm@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] kvm: Use wbinvd library functions
Date: Wed, 24 Nov 2010 18:44:04 +0100
Message-Id: <1290620644-27423-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290620644-27423-1-git-send-email-bp@amd64.org>
References: <1290620644-27423-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Replace local wbinvd helpers with equivalent x86 library functions.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kvm/x86.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cdac9e5..8063ac0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -50,6 +50,7 @@
 
 #include <asm/debugreg.h>
 #include <asm/msr.h>
+#include <asm/smp.h>
 #include <asm/desc.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
@@ -2029,11 +2030,6 @@ out:
 	return r;
 }
 
-static void wbinvd_ipi(void *garbage)
-{
-	wbinvd();
-}
-
 static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.iommu_domain &&
@@ -2047,8 +2043,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (kvm_x86_ops->has_wbinvd_exit())
 			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
 		else if (vcpu->cpu != -1 && vcpu->cpu != cpu)
-			smp_call_function_single(vcpu->cpu,
-					wbinvd_ipi, NULL, 1);
+			wbinvd_on_cpu(vcpu->cpu);
 	}
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
@@ -3978,10 +3973,7 @@ int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu)
 		return X86EMUL_CONTINUE;
 
 	if (kvm_x86_ops->has_wbinvd_exit()) {
-		preempt_disable();
-		smp_call_function_many(vcpu->arch.wbinvd_dirty_mask,
-				wbinvd_ipi, NULL, 1);
-		preempt_enable();
+		wbinvd_on_cpus(vcpu->arch.wbinvd_dirty_mask);
 		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
 	}
 	wbinvd();
-- 
1.7.3.1.50.g1e633

