Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab0KAI6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:58:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50851 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab0KAI6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:58:11 -0400
Message-ID: <4CCE822B.1070909@cn.fujitsu.com>
Date: Mon, 01 Nov 2010 17:02:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 5/7] KVM: handle more completed apfs if possible
References: <4CCE8143.3090105@cn.fujitsu.com>
In-Reply-To: <4CCE8143.3090105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it's no need to inject async #PF to PV guest we can handle
more completed apfs at one time, so we can retry guest #PF
as early as possible

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    3 ++-
 arch/x86/kvm/x86.c              |    8 ++++++--
 virt/kvm/async_pf.c             |   28 ++++++++++++++++------------
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1be0058..c95b3ff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -818,7 +818,8 @@ bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
 void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work);
-void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
+/* return true if we can handle more completed apfs, false otherwise */
+bool kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work);
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 			       struct kvm_async_pf *work);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4da8485..189664a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6265,7 +6265,7 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 	}
 }
 
-void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
+bool kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work)
 {
 	trace_kvm_async_pf_ready(work->arch.token, work->gva);
@@ -6274,13 +6274,17 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	else
 		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
 
+	vcpu->arch.apf.halted = false;
+
 	if ((vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) &&
 	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
 		vcpu->arch.fault.error_code = 0;
 		vcpu->arch.fault.address = work->arch.token;
 		kvm_inject_page_fault(vcpu);
+		return false;
 	}
-	vcpu->arch.apf.halted = false;
+
+	return true;
 }
 
 bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 60df9e0..d57ec92 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -123,25 +123,29 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 {
 	struct kvm_async_pf *work;
+	bool ret;
 
 	if (list_empty_careful(&vcpu->async_pf.done) ||
 	    !kvm_arch_can_inject_async_page_present(vcpu))
 		return;
 
-	spin_lock(&vcpu->async_pf.lock);
-	work = list_first_entry(&vcpu->async_pf.done, typeof(*work), link);
-	list_del(&work->link);
-	spin_unlock(&vcpu->async_pf.lock);
+	do {
+		spin_lock(&vcpu->async_pf.lock);
+		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
+							link);
+		list_del(&work->link);
+		spin_unlock(&vcpu->async_pf.lock);
 
-	if (work->page)
-		kvm_arch_async_page_ready(vcpu, work);
-	kvm_arch_async_page_present(vcpu, work);
+		if (work->page)
+			kvm_arch_async_page_ready(vcpu, work);
+		ret = kvm_arch_async_page_present(vcpu, work);
 
-	list_del(&work->queue);
-	vcpu->async_pf.queued--;
-	if (work->page)
-		put_page(work->page);
-	kmem_cache_free(async_pf_cache, work);
+		list_del(&work->queue);
+		vcpu->async_pf.queued--;
+		if (work->page)
+			put_page(work->page);
+		kmem_cache_free(async_pf_cache, work);
+	} while (ret && !list_empty_careful(&vcpu->async_pf.done));
 }
 
 int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
-- 
1.7.0.4

