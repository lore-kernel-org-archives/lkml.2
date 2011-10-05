Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934530Ab1JEMBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934513Ab1JEMBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:01:44 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH v2 8/9] KVM, VMX: Add support for guest/host-only profiling
Date: Wed,  5 Oct 2011 14:01:23 +0200
Message-Id: <1317816084-18026-9-git-send-email-gleb@redhat.com>
In-Reply-To: <1317816084-18026-1-git-send-email-gleb@redhat.com>
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support guest/host-only profiling by switch perf msrs on
a guest entry if needed.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/vmx.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a938ddf..d0d4afa 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -39,6 +39,7 @@
 #include <asm/mce.h>
 #include <asm/i387.h>
 #include <asm/xcr.h>
+#include <asm/perf_event.h>
 
 #include "trace.h"
 
@@ -6054,6 +6055,24 @@ static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
 }
 
+static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
+{
+	int i, nr_msrs;
+	struct perf_guest_switch_msr *msrs;
+
+	msrs = perf_guest_get_msrs(&nr_msrs);
+
+	if (!msrs)
+		return;
+
+	for (i = 0; i < nr_msrs; i++)
+		if (msrs[i].host == msrs[i].guest)
+			clear_atomic_switch_msr(vmx, msrs[i].msr);
+		else
+			add_atomic_switch_msr(vmx, msrs[i].msr, msrs[i].guest,
+					msrs[i].host);
+}
+
 #ifdef CONFIG_X86_64
 #define R "r"
 #define Q "q"
@@ -6103,6 +6122,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vmx_set_interrupt_shadow(vcpu, 0);
 
+	atomic_switch_perf_msrs(vmx);
+
 	vmx->__launched = vmx->loaded_vmcs->launched;
 	asm(
 		/* Store host registers */
-- 
1.7.5.3

