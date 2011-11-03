Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1KCMc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120Ab1KCMcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:32:25 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCH 5/9] KVM: VMX: Intercept RDPMC
Date: Thu,  3 Nov 2011 14:31:34 +0200
Message-Id: <1320323498-10233-6-git-send-email-gleb@redhat.com>
In-Reply-To: <1320323498-10233-1-git-send-email-gleb@redhat.com>
References: <1320323498-10233-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>

Intercept RDPMC and forward it to the PMU emulation code.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/vmx.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6e28d58..a6535ba 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1956,6 +1956,7 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 #endif
 		CPU_BASED_MOV_DR_EXITING | CPU_BASED_UNCOND_IO_EXITING |
 		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_EXITING |
+		CPU_BASED_RDPMC_EXITING |
 		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	/*
 	 * We can allow some features even when not supported by the
@@ -2414,7 +2415,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 	      CPU_BASED_USE_TSC_OFFSETING |
 	      CPU_BASED_MWAIT_EXITING |
 	      CPU_BASED_MONITOR_EXITING |
-	      CPU_BASED_INVLPG_EXITING;
+	      CPU_BASED_INVLPG_EXITING |
+	      CPU_BASED_RDPMC_EXITING;
 
 	if (yield_on_hlt)
 		min |= CPU_BASED_HLT_EXITING;
@@ -4615,6 +4617,16 @@ static int handle_invlpg(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_rdpmc(struct kvm_vcpu *vcpu)
+{
+	int err;
+
+	err = kvm_rdpmc(vcpu);
+	kvm_complete_insn_gp(vcpu, err);
+
+	return 1;
+}
+
 static int handle_wbinvd(struct kvm_vcpu *vcpu)
 {
 	skip_emulated_instruction(vcpu);
@@ -5565,6 +5577,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_HLT]                     = handle_halt,
 	[EXIT_REASON_INVD]		      = handle_invd,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
+	[EXIT_REASON_RDPMC]                   = handle_rdpmc,
 	[EXIT_REASON_VMCALL]                  = handle_vmcall,
 	[EXIT_REASON_VMCLEAR]	              = handle_vmclear,
 	[EXIT_REASON_VMLAUNCH]                = handle_vmlaunch,
-- 
1.7.5.3

