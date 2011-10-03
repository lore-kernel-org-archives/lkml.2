Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1JCNvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:51:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074Ab1JCNuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:50:39 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH 8/9] KVM, VMX: Add support for guest/host-only profiling
Date: Mon,  3 Oct 2011 15:49:54 +0200
Message-Id: <1317649795-18259-9-git-send-email-gleb@redhat.com>
In-Reply-To: <1317649795-18259-1-git-send-email-gleb@redhat.com>
References: <1317649795-18259-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support guest/host-only profiling by switch perf msrs on
a guest entry if needed.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/vmx.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e4cc3c2..fef7bd9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -39,6 +39,7 @@
 #include <asm/mce.h>
 #include <asm/i387.h>
 #include <asm/xcr.h>
+#include <asm/perf_event.h>
 
 #include "trace.h"
 
@@ -417,6 +418,9 @@ struct vcpu_vmx {
 
 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
+
+	int perf_msrs_cnt;
+	struct perf_guest_switch_msr *perf_msrs;
 };
 
 enum segment_cache_field {
@@ -6052,6 +6056,26 @@ static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
 }
 
+static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
+{
+#ifdef CONFIG_PERF_EVENTS
+	int i;
+
+	if (!cpu_has_arch_perfmon || vmx->perf_msrs_cnt <= 0)
+		return;
+
+	perf_guest_get_msrs(vmx->perf_msrs_cnt, vmx->perf_msrs);
+	for (i = 0; i < vmx->perf_msrs_cnt; i++) {
+		struct perf_guest_switch_msr *msr = &vmx->perf_msrs[i];
+		if (msr->host == msr->guest)
+			clear_atomic_switch_msr(vmx, msr->msr);
+		else
+			add_atomic_switch_msr(vmx, msr->msr, msr->guest,
+					msr->host);
+	}
+#endif
+}
+
 #ifdef CONFIG_X86_64
 #define R "r"
 #define Q "q"
@@ -6101,6 +6125,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vmx_set_interrupt_shadow(vcpu, 0);
 
+	atomic_switch_perf_msrs(vmx);
+
 	vmx->__launched = vmx->loaded_vmcs->launched;
 	asm(
 		/* Store host registers */
@@ -6306,6 +6332,15 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	vmx->nested.current_vmptr = -1ull;
 	vmx->nested.current_vmcs12 = NULL;
 
+	vmx->perf_msrs_cnt = perf_guest_get_msrs_count();
+	if (vmx->perf_msrs_cnt > 0) {
+		vmx->perf_msrs = kmalloc(vmx->perf_msrs_cnt *
+				sizeof(struct perf_guest_switch_msr),
+				GFP_KERNEL);
+		if (!vmx->perf_msrs)
+			goto free_vmcs;
+	}
+
 	return &vmx->vcpu;
 
 free_vmcs:
-- 
1.7.5.3

