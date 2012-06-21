Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab2FUIvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:51:31 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:58575 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907Ab2FUIv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:51:29 -0400
Date: Thu, 21 Jun 2012 17:51:14 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 4/6] KVM: Introduce kvm_unmap_hva_range() for
 kvm_mmu_notifier_invalidate_range_start()
Message-Id: <20120621175114.eed3285c.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we tested KVM under memory pressure, with THP enabled on the host,
we noticed that MMU notifier took a long time to invalidate huge pages.

Since the invalidation was done with mmu_lock held, it not only wasted
the CPU but also made the host harder to respond.

This patch mitigates this by using kvm_handle_hva_range().

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Alexander Graf <agraf@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/asm/kvm_host.h |    2 ++
 arch/powerpc/kvm/book3s_64_mmu_hv.c |    7 +++++++
 arch/x86/include/asm/kvm_host.h     |    1 +
 arch/x86/kvm/mmu.c                  |    5 +++++
 virt/kvm/kvm_main.c                 |    3 +--
 5 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 50ea12f..572ad01 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -52,6 +52,8 @@
 
 struct kvm;
 extern int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
+extern int kvm_unmap_hva_range(struct kvm *kvm,
+			       unsigned long start, unsigned long end);
 extern int kvm_age_hva(struct kvm *kvm, unsigned long hva);
 extern int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 extern void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index aec8046..33a6dc2 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -865,6 +865,13 @@ int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 	return 0;
 }
 
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
+{
+	if (kvm->arch.using_mmu_notifiers)
+		kvm_handle_hva_range(kvm, start, end, kvm_unmap_rmapp);
+	return 0;
+}
+
 static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			 unsigned long gfn)
 {
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index db7c1f2..d6ad50d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -930,6 +930,7 @@ extern bool kvm_rebooting;
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_age_hva(struct kvm *kvm, unsigned long hva);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f995b8a..0659376 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1243,6 +1243,11 @@ int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 	return kvm_handle_hva(kvm, hva, 0, kvm_unmap_rmapp);
 }
 
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
+{
+	return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
+}
+
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
 	kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 02cb440..44e44c0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -332,8 +332,7 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * count is also read inside the mmu_lock critical section.
 	 */
 	kvm->mmu_notifier_count++;
-	for (; start < end; start += PAGE_SIZE)
-		need_tlb_flush |= kvm_unmap_hva(kvm, start);
+	need_tlb_flush = kvm_unmap_hva_range(kvm, start, end);
 	need_tlb_flush |= kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush)
-- 
1.7.5.4

