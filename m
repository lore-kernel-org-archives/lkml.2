Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934567Ab1KJNAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:00:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659Ab1KJM6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:58:10 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCHv3 04/10] KVM: SVM: Intercept RDPMC
Date: Thu, 10 Nov 2011 14:57:24 +0200
Message-Id: <1320929850-10480-5-git-send-email-gleb@redhat.com>
In-Reply-To: <1320929850-10480-1-git-send-email-gleb@redhat.com>
References: <1320929850-10480-1-git-send-email-gleb@redhat.com>
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
1.7.7.1

