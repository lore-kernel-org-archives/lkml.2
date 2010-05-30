Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0E3Mlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 08:41:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63756 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab0E3Mlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 08:41:39 -0400
Message-ID: <4C025C24.9010200@cn.fujitsu.com>
Date: Sun, 30 May 2010 20:37:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 2/5] KVM: MMU: split the operations of kvm_mmu_zap_page()
References: <4C025BDC.1020304@cn.fujitsu.com>
In-Reply-To: <4C025BDC.1020304@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using kvm_mmu_prepare_zap_page() and kvm_mmu_commit_zap_page() to
split kvm_mmu_zap_page() function, then we can:

- traverse hlist safely
- easily to gather remote tlb flush which occurs during page zapped

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   42 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |    1 +
 3 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0cd0f29..e4df1cf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -388,6 +388,7 @@ struct kvm_arch {
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+	struct list_head invalid_mmu_pages;
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	int iommu_flags;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 84c705e..0c957bf 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -915,6 +915,7 @@ static int is_empty_shadow_page(u64 *spt)
 static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
+	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	__free_page(virt_to_page(sp->spt));
 	if (!sp->role.direct)
@@ -1560,6 +1561,46 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 	return zapped;
 }
 
+static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	int ret;
+
+	trace_kvm_mmu_zap_page(sp);
+	++kvm->stat.mmu_shadow_zapped;
+	ret = mmu_zap_unsync_children(kvm, sp);
+	kvm_mmu_page_unlink_children(kvm, sp);
+	kvm_mmu_unlink_parents(kvm, sp);
+	if (!sp->role.invalid && !sp->role.direct)
+		unaccount_shadowed(kvm, sp->gfn);
+	if (sp->unsync)
+		kvm_unlink_unsync_page(kvm, sp);
+	if (!sp->root_count)
+		/* Count self */
+		ret++;
+	else
+		kvm_reload_remote_mmus(kvm);
+
+	sp->role.invalid = 1;
+	list_move(&sp->link, &kvm->arch.invalid_mmu_pages);
+	kvm_mmu_reset_last_pte_updated(kvm);
+	return ret;
+}
+
+static void kvm_mmu_commit_zap_page(struct kvm *kvm)
+{
+	struct kvm_mmu_page *sp, *n;
+
+	if (list_empty(&kvm->arch.invalid_mmu_pages))
+		return;
+
+	kvm_flush_remote_tlbs(kvm);
+	list_for_each_entry_safe(sp, n, &kvm->arch.invalid_mmu_pages, link) {
+		WARN_ON(!sp->role.invalid);
+		if (!sp->root_count)
+			kvm_mmu_free_page(kvm, sp);
+	}
+}
+
 static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	int ret;
@@ -1577,7 +1618,6 @@ static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	if (!sp->root_count) {
 		/* Count self */
 		ret++;
-		hlist_del(&sp->hash_link);
 		kvm_mmu_free_page(kvm, sp);
 	} else {
 		sp->role.invalid = 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e5cd8d..225c3c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5331,6 +5331,7 @@ struct  kvm *kvm_arch_create_vm(void)
 	}
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.invalid_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
-- 
1.6.1.2



