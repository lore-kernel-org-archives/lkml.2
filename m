Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2LRHxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:53:39 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:41749 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2LRHxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:53:35 -0500
X-Greylist: delayed 1593 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 02:53:30 EST
Date: Tue, 18 Dec 2012 16:30:03 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: mtosatti@redhat.com, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] KVM: Make kvm_mmu_slot_remove_write_access() take
 mmu_lock by itself
Message-Id: <20121218163003.0185affe.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better to place mmu_lock handling and TLB flushing code together since
this is a self-contained function.

Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |    3 +++
 arch/x86/kvm/x86.c |    5 +----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fc7d84a..b7a1235 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4199,6 +4199,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 	memslot = id_to_memslot(kvm->memslots, slot);
 	last_gfn = memslot->base_gfn + memslot->npages - 1;
 
+	spin_lock(&kvm->mmu_lock);
+
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		unsigned long *rmapp;
@@ -4214,6 +4216,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 	}
 
 	kvm_flush_remote_tlbs(kvm);
+	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_mmu_zap_all(struct kvm *kvm)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d9d0f6b..aa183e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6900,11 +6900,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * not be created until the end of the logging.
 	 */
 	if ((mem->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
-	    !(old.flags & KVM_MEM_LOG_DIRTY_PAGES)) {
-		spin_lock(&kvm->mmu_lock);
+	    !(old.flags & KVM_MEM_LOG_DIRTY_PAGES))
 		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
-		spin_unlock(&kvm->mmu_lock);
-	}
 	/*
 	 * If memory slot is created, or moved, we need to clear all
 	 * mmio sptes.
-- 
1.7.5.4

