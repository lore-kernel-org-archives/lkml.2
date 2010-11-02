Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0KBJbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 05:31:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57199 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab0KBJbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 05:31:12 -0400
Message-ID: <4CCFDB67.9050401@cn.fujitsu.com>
Date: Tue, 02 Nov 2010 17:35:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 5/7] KVM: handle more completed apfs if possible
References: <4CCE8143.3090105@cn.fujitsu.com> <4CCE822B.1070909@cn.fujitsu.com> <20101101092457.GY26191@redhat.com>
In-Reply-To: <20101101092457.GY26191@redhat.com>
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
 virt/kvm/async_pf.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 60df9e0..100c66e 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -124,24 +124,24 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 {
 	struct kvm_async_pf *work;
 
-	if (list_empty_careful(&vcpu->async_pf.done) ||
-	    !kvm_arch_can_inject_async_page_present(vcpu))
-		return;
-
-	spin_lock(&vcpu->async_pf.lock);
-	work = list_first_entry(&vcpu->async_pf.done, typeof(*work), link);
-	list_del(&work->link);
-	spin_unlock(&vcpu->async_pf.lock);
+	while (!list_empty_careful(&vcpu->async_pf.done) &&
+	      kvm_arch_can_inject_async_page_present(vcpu)) {
+		spin_lock(&vcpu->async_pf.lock);
+		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
+					      link);
+		list_del(&work->link);
+		spin_unlock(&vcpu->async_pf.lock);
 
-	if (work->page)
-		kvm_arch_async_page_ready(vcpu, work);
-	kvm_arch_async_page_present(vcpu, work);
+		if (work->page)
+			kvm_arch_async_page_ready(vcpu, work);
+		kvm_arch_async_page_present(vcpu, work);
 
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
+	}
 }
 
 int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
-- 
1.7.0.4

