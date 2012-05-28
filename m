Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab2E1DuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:50:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51968 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716Ab2E1D3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:20 -0400
Message-Id: <20120528031203.013255424@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Avi Kivity <avi@redhat.com>
Subject: [ 001/117] KVM: mmu_notifier: Flush TLBs before releasing mmu_lock
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

(cherry picked from commit 565f3be2174611f364405bbea2d86e153c2e7e78

Other threads may process the same page in that small window and skip
TLB flush and then return before these functions do flush.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/kvm_main.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e401c1b..9ffac2e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -289,15 +289,15 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
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
@@ -335,12 +335,12 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
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
@@ -378,13 +378,14 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 
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
 


