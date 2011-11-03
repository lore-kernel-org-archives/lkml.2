Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab1KCMfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:35:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933538Ab1KCMe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:34:28 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCHv2 4/9] KVM: SVM: Intercept RDPMC
Date: Thu,  3 Nov 2011 14:33:33 +0200
Message-Id: <1320323618-10375-5-git-send-email-gleb@redhat.com>
In-Reply-To: <1320323618-10375-1-git-send-email-gleb@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>

Intercept RDPMC and forward it to the PMU emulation code.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/svm.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e32243e..5fa553b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1014,6 +1014,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	set_intercept(svm, INTERCEPT_NMI);
 	set_intercept(svm, INTERCEPT_SMI);
 	set_intercept(svm, INTERCEPT_SELECTIVE_CR0);
+	set_intercept(svm, INTERCEPT_RDPMC);
 	set_intercept(svm, INTERCEPT_CPUID);
 	set_intercept(svm, INTERCEPT_INVD);
 	set_intercept(svm, INTERCEPT_HLT);
@@ -2770,6 +2771,19 @@ static int emulate_on_interception(struct vcpu_svm *svm)
 	return emulate_instruction(&svm->vcpu, 0) == EMULATE_DONE;
 }
 
+static int rdpmc_interception(struct vcpu_svm *svm)
+{
+	int err;
+
+	if (!static_cpu_has(X86_FEATURE_NRIPS))
+		return emulate_on_interception(svm);
+
+	err = kvm_rdpmc(&svm->vcpu);
+	kvm_complete_insn_gp(&svm->vcpu, err);
+
+	return 1;
+}
+
 bool check_selective_cr0_intercepted(struct vcpu_svm *svm, unsigned long val)
 {
 	unsigned long cr0 = svm->vcpu.arch.cr0;
@@ -3190,6 +3204,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_SMI]				= nop_on_interception,
 	[SVM_EXIT_INIT]				= nop_on_interception,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
+	[SVM_EXIT_RDPMC]			= rdpmc_interception,
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
-- 
1.7.5.3

