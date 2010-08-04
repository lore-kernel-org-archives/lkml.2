Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab0HDHJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:09:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51179 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758456Ab0HDHJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:09:37 -0400
Message-ID: <4C591313.50402@cn.fujitsu.com>
Date: Wed, 04 Aug 2010 15:13:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] kvm: make mmu_shrink() fit shrinker's requirement
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mmu_shrink() should attempt to free @nr_to_scan entries.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9c69725..1034373 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3138,37 +3138,51 @@ static int mmu_shrink(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
 {
 	struct kvm *kvm;
 	struct kvm *kvm_freed = NULL;
+	struct kvm *kvm_last;
 	int cache_count = 0;
 
 	spin_lock(&kvm_lock);
 
-	list_for_each_entry(kvm, &vm_list, vm_list) {
+	if (list_empty(&vm_list))
+		goto out;
+
+	kvm_last = list_entry(vm_list.prev, struct kvm, vm_list);
+
+	for (;;) {
 		int npages, idx, freed_pages;
 		LIST_HEAD(invalid_list);
 
+		kvm = list_first_entry(&vm_list, struct kvm, vm_list);
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
 		npages = kvm->arch.n_alloc_mmu_pages -
 			 kvm->arch.n_free_mmu_pages;
-		cache_count += npages;
-		if (!kvm_freed && nr_to_scan > 0 && npages > 0) {
+		if (kvm_last)
+			cache_count += npages;
+		if (nr_to_scan > 0 && npages > 0) {
 			freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm,
 							  &invalid_list);
+			kvm_mmu_commit_zap_page(kvm, &invalid_list);
 			cache_count -= freed_pages;
 			kvm_freed = kvm;
-		}
-		nr_to_scan--;
+			nr_to_scan -= freed_pages;
+		} else if (kvm == kvm_freed)
+			nr_to_scan = 0; /* no more page to be freed, break */
 
-		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 		spin_unlock(&kvm->mmu_lock);
 		srcu_read_unlock(&kvm->srcu, idx);
-	}
-	if (kvm_freed)
 		list_move_tail(&kvm_freed->vm_list, &vm_list);
 
+		if (kvm == kvm_last) /* just scaned all vms */
+			kvm_last = NULL;
+		if (!kvm_last && (nr_to_scan <= 0 || !kvm_freed))
+			break;
+	}
+
+out:
 	spin_unlock(&kvm_lock);
 
-	return cache_count;
+	return cache_count < 0 ? 0 : cache_count;
 }
 
 static struct shrinker mmu_shrinker = {
