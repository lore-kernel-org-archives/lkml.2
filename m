Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698Ab2EJRgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:36:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53504 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674Ab2EJRgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:16 -0400
Message-Id: <20120510173136.113518528@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [ 37/52] KVM: mmu_notifier: Flush TLBs before releasing mmu_lock
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

(cherry picked from commit 565f3be2174611f364405bbea2d86e153c2e7e78)

Other threads may process the same page in that small window and skip
TLB flush and then return before these functions do flush.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -289,15 +289,15 @@ static void kvm_mmu_notifier_invalidate_
 	 */
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
+
 	kvm->mmu_notifier_seq++;
 	need_tlb_flush = kvm_unmap_hva(kvm, address) | kvm->tlbs_dirty;
-	spin_unlock(&kvm->mmu_lock);
-	srcu_read_unlock(&kvm->srcu, idx);
-
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush)
 		kvm_flush_remote_tlbs(kvm);
 
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 }
 
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
@@ -335,12 +335,12 @@ static void kvm_mmu_notifier_invalidate_
 	for (; start < end; start += PAGE_SIZE)
 		need_tlb_flush |= kvm_unmap_hva(kvm, start);
 	need_tlb_flush |= kvm->tlbs_dirty;
-	spin_unlock(&kvm->mmu_lock);
-	srcu_read_unlock(&kvm->srcu, idx);
-
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush)
 		kvm_flush_remote_tlbs(kvm);
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 }
 
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
@@ -378,13 +378,14 @@ static int kvm_mmu_notifier_clear_flush_
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
-	young = kvm_age_hva(kvm, address);
-	spin_unlock(&kvm->mmu_lock);
-	srcu_read_unlock(&kvm->srcu, idx);
 
+	young = kvm_age_hva(kvm, address);
 	if (young)
 		kvm_flush_remote_tlbs(kvm);
 
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
 	return young;
 }
 


