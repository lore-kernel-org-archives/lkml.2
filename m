Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710Ab0J0JBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:01:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58598 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760620Ab0J0JBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:01:36 -0400
Message-ID: <4CC7EB75.9030709@cn.fujitsu.com>
Date: Wed, 27 Oct 2010 17:05:57 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/8] KVM: don't touch vcpu stat after async pf is complete
References: <4CC7EA7D.5020901@cn.fujitsu.com>
In-Reply-To: <4CC7EA7D.5020901@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't make a KVM_REQ_UNHALT request after async pf is completed since it
can break guest's 'halt' instruction.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |    5 +++++
 virt/kvm/async_pf.c             |    1 +
 virt/kvm/kvm_main.c             |    7 +++++--
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1be0058..d01677b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -822,6 +822,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work);
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 			       struct kvm_async_pf *work);
+void kvm_arch_async_pf_completion(struct kvm_vcpu *vcpu);
 bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu);
 extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b2c420..c0e7ad0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6280,6 +6280,11 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	}
 }
 
+void kvm_arch_async_pf_completion(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.apf.halted = false;
+}
+
 bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
 {
 	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index e213ca4..5307a32 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -142,6 +142,7 @@ bool kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 	if (work->page)
 		put_page(work->page);
 	kmem_cache_free(async_pf_cache, work);
+	kvm_arch_async_pf_completion(vcpu);
 
 	return true;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9aed28..23a8b06 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1347,11 +1347,14 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	for (;;) {
 		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 
-		if (kvm_arch_vcpu_runnable(vcpu) ||
-		     kvm_check_async_pf_completion(vcpu)) {
+		if (kvm_arch_vcpu_runnable(vcpu)) {
 			kvm_make_request(KVM_REQ_UNHALT, vcpu);
 			break;
 		}
+
+		if (kvm_check_async_pf_completion(vcpu))
+			break;
+
 		if (kvm_cpu_has_pending_timer(vcpu))
 			break;
 		if (signal_pending(current))
-- 
1.7.0.4

