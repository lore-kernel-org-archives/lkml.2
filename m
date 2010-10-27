Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684Ab0J0JDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:03:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49202 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab0J0JDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:03:06 -0400
Message-ID: <4CC7EBD4.6070105@cn.fujitsu.com>
Date: Wed, 27 Oct 2010 17:07:32 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 6/8] KVM: simply wakup async pf
References: <4CC7EA7D.5020901@cn.fujitsu.com>
In-Reply-To: <4CC7EA7D.5020901@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current way is queued a complete async pf with:
	asyc_pf.page = bad_page
	async_pf.arch.gfn = 0

It has two problems while kvm_check_async_pf_completion handle this
async_pf:
- since !async_pf.page, it can retry a pseudo #PF
- it can delete gfn 0 from vcpu->arch.apf.gfns[]

Actually, we can simply record this wakeup request and let
kvm_check_async_pf_completion simply break the wait

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/async_pf.c      |   21 ++++++---------------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0c1b7c5..d91add9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -131,6 +131,7 @@ struct kvm_vcpu {
 		struct list_head queue;
 		struct list_head done;
 		spinlock_t lock;
+		bool wakeup;
 	} async_pf;
 #endif
 
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 5307a32..0d1f6c4 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -124,6 +124,11 @@ bool kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 {
 	struct kvm_async_pf *work;
 
+	if (vcpu->async_pf.wakeup) {
+		vcpu->async_pf.wakeup = false;
+		return true;
+	}
+
 	if (list_empty_careful(&vcpu->async_pf.done) ||
 	    !kvm_arch_can_inject_async_page_present(vcpu))
 		return false;
@@ -197,20 +202,6 @@ retry_sync:
 
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 {
-	struct kvm_async_pf *work;
-
-	if (!list_empty(&vcpu->async_pf.done))
-		return 0;
-
-	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
-	if (!work)
-		return -ENOMEM;
-
-	work->page = bad_page;
-	get_page(bad_page);
-	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
-
-	list_add_tail(&work->link, &vcpu->async_pf.done);
-	vcpu->async_pf.queued++;
+	vcpu->async_pf.wakeup = true;
 	return 0;
 }
-- 
1.7.0.4

