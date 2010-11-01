Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab0KAJAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:00:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54748 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab0KAJAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:00:37 -0400
Message-ID: <4CCE82BC.3090000@cn.fujitsu.com>
Date: Mon, 01 Nov 2010 17:05:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [RFC PATCH v2 7/7] KVM: KVM: don't break vcpu 'halt' state due to
 apfs
References: <4CCE8143.3090105@cn.fujitsu.com>
In-Reply-To: <4CCE8143.3090105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't make a KVM_REQ_UNHALT request after async pf is completed since it
can break guest's 'HLT' instruction.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c       |   13 ++++++++++---
 include/linux/kvm_host.h |    6 ++++++
 virt/kvm/kvm_main.c      |    9 ++++++++-
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 189664a..c57fb38 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6105,13 +6105,20 @@ void kvm_arch_flush_shadow(struct kvm *kvm)
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
+	if ((vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted)
-		|| !list_empty_careful(&vcpu->async_pf.done)
 		|| vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED
 		|| vcpu->arch.nmi_pending ||
 		(kvm_arch_interrupt_allowed(vcpu) &&
-		 kvm_cpu_has_interrupt(vcpu));
+		 kvm_cpu_has_interrupt(vcpu)))
+		return 1;
+
+	if (!list_empty_careful(&vcpu->async_pf.done)) {
+		vcpu->arch.apf.halted = false;
+		return 2;
+	}
+
+	return 0;
 }
 
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 462b982..8def043 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -436,6 +436,12 @@ void kvm_arch_hardware_disable(void *garbage);
 int kvm_arch_hardware_setup(void);
 void kvm_arch_hardware_unsetup(void);
 void kvm_arch_check_processor_compat(void *rtn);
+
+/*
+ * return value: > 0 if the vcpu is runnable, 0 if not.
+ * Especially, if the return value == 1, we should make a
+ * 'KVM_REQ_UNHALT' request.
+ */
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 
 void kvm_free_physmem(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dbe1d6a..9ccf105 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1375,14 +1375,21 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
 	DEFINE_WAIT(wait);
+	int ret;
 
 	for (;;) {
 		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 
-		if (kvm_arch_vcpu_runnable(vcpu)) {
+		ret = kvm_arch_vcpu_runnable(vcpu);
+
+		if (ret == 1) {
 			kvm_make_request(KVM_REQ_UNHALT, vcpu);
 			break;
 		}
+
+		if (ret > 1)
+			break;
+
 		if (kvm_cpu_has_pending_timer(vcpu))
 			break;
 		if (signal_pending(current))
-- 
1.7.0.4

