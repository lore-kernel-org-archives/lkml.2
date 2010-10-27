Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625Ab0J0JFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:05:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54737 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab0J0JFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:05:14 -0400
Message-ID: <4CC7EC55.7070201@cn.fujitsu.com>
Date: Wed, 27 Oct 2010 17:09:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 7/8] KVM: make async_pf work queue lockless
References: <4CC7EA7D.5020901@cn.fujitsu.com>
In-Reply-To: <4CC7EA7D.5020901@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The async_pf number is very few since only pending interrupt can
let it re-enter to the guest mode.

During my test(Host 4 CPU + 4G, Guest 4 VCPU + 6G), it's no
more than 10 requests in the system.

So, we can only increase the completion counter in the work queue
context, and walk vcpu->async_pf.queue list to get all completed
async_pf

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    4 +--
 virt/kvm/async_pf.c      |   50 +++++++++++++++++++--------------------------
 2 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d91add9..33c03c3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -78,7 +78,6 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 #ifdef CONFIG_KVM_ASYNC_PF
 struct kvm_async_pf {
 	struct work_struct work;
-	struct list_head link;
 	struct list_head queue;
 	struct kvm_vcpu *vcpu;
 	struct mm_struct *mm;
@@ -127,10 +126,9 @@ struct kvm_vcpu {
 
 #ifdef CONFIG_KVM_ASYNC_PF
 	struct {
+		atomic_t done;
 		u32 queued;
 		struct list_head queue;
-		struct list_head done;
-		spinlock_t lock;
 		bool wakeup;
 	} async_pf;
 #endif
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 0d1f6c4..f10de1e 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -49,9 +49,7 @@ void kvm_async_pf_deinit(void)
 
 void kvm_async_pf_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	INIT_LIST_HEAD(&vcpu->async_pf.done);
 	INIT_LIST_HEAD(&vcpu->async_pf.queue);
-	spin_lock_init(&vcpu->async_pf.lock);
 }
 
 static void async_pf_execute(struct work_struct *work)
@@ -72,11 +70,9 @@ static void async_pf_execute(struct work_struct *work)
 	up_read(&mm->mmap_sem);
 	unuse_mm(mm);
 
-	spin_lock(&vcpu->async_pf.lock);
-	list_add_tail(&apf->link, &vcpu->async_pf.done);
 	apf->page = page;
 	apf->done = true;
-	spin_unlock(&vcpu->async_pf.lock);
+	atomic_inc(&vcpu->async_pf.done);
 
 	/*
 	 * apf may be freed by kvm_check_async_pf_completion() after
@@ -101,52 +97,48 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
 				   typeof(*work), queue);
 		cancel_work_sync(&work->work);
 		list_del(&work->queue);
-		if (!work->done) /* work was canceled */
-			kmem_cache_free(async_pf_cache, work);
-	}
-
-	spin_lock(&vcpu->async_pf.lock);
-	while (!list_empty(&vcpu->async_pf.done)) {
-		struct kvm_async_pf *work =
-			list_entry(vcpu->async_pf.done.next,
-				   typeof(*work), link);
-		list_del(&work->link);
 		if (work->page)
 			put_page(work->page);
 		kmem_cache_free(async_pf_cache, work);
 	}
-	spin_unlock(&vcpu->async_pf.lock);
 
 	vcpu->async_pf.queued = 0;
+	atomic_set(&vcpu->async_pf.done, 0);
 }
 
 bool kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
 {
 	struct kvm_async_pf *work;
+	struct list_head *pos, *temp;
 
 	if (vcpu->async_pf.wakeup) {
 		vcpu->async_pf.wakeup = false;
 		return true;
 	}
 
-	if (list_empty_careful(&vcpu->async_pf.done) ||
+	if (!atomic_read(&vcpu->async_pf.done) ||
 	    !kvm_arch_can_inject_async_page_present(vcpu))
 		return false;
 
-	spin_lock(&vcpu->async_pf.lock);
-	work = list_first_entry(&vcpu->async_pf.done, typeof(*work), link);
-	list_del(&work->link);
-	spin_unlock(&vcpu->async_pf.lock);
+	list_for_each_safe(pos, temp, &vcpu->async_pf.queue) {
+		work = list_entry(pos, typeof(*work), queue);
+		if (!work->done)
+			continue;
 
-	if (work->page)
-		kvm_arch_async_page_ready(vcpu, work);
-	kvm_arch_async_page_present(vcpu, work);
+		if (work->page) {
+			kvm_arch_async_page_ready(vcpu, work);
+			put_page(work->page);
+		}
+
+		kvm_arch_async_page_present(vcpu, work);
+
+		list_del(&work->queue);
+		vcpu->async_pf.queued--;
+		kmem_cache_free(async_pf_cache, work);
+		if (atomic_dec_and_test(&vcpu->async_pf.done))
+			break;
+	}
 
-	list_del(&work->queue);
-	vcpu->async_pf.queued--;
-	if (work->page)
-		put_page(work->page);
-	kmem_cache_free(async_pf_cache, work);
 	kvm_arch_async_pf_completion(vcpu);
 
 	return true;
-- 
1.7.0.4

