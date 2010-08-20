Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab0HTBL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:11:26 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53659 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab0HTBLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:11:23 -0400
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Thu, 19 Aug 2010 18:11:14 -0700
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 2/4 v2] kvm: rename x86 kvm->arch.n_alloc_mmu_pages
Message-ID: <20100820011113.GC11297@tpepper-t61p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

[PATCH 2/4 v2] kvm: rename x86 kvm->arch.n_alloc_mmu_pages

Again, I think this is a poor choice of names.  This value truly
means, "the number of pages which _may_ be allocated".  But,
reading the value, "n_alloc_mmu_pages", I'm unable to think of
anything it should mean other than "the number of allocated mmu
pages", which is dead wrong.

It's really the high watermark, so let's give it a name to match:
nr_max_mmu_pages.  This change will make the next few patches
much more obvious and easy to read.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---

  arch/x86/include/asm/kvm_host.h |    2 +-
  arch/x86/kvm/mmu.c              |    8 ++++----
  arch/x86/kvm/x86.c              |    2 +-
  3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 502e53f..f0f02cf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -369,7 +369,7 @@ struct kvm_vcpu_arch {
 struct kvm_arch {
 	unsigned int n_free_mmu_pages;
 	unsigned int n_requested_mmu_pages;
-	unsigned int n_alloc_mmu_pages;
+	unsigned int n_max_mmu_pages;
 	atomic_t invlpg_counter;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3c15d10..02e414d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1672,7 +1672,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 	int used_pages;
 	LIST_HEAD(invalid_list);
 
-	used_pages = kvm->arch.n_alloc_mmu_pages - kvm_mmu_available_pages(kvm);
+	used_pages = kvm->arch.n_max_mmu_pages - kvm_mmu_available_pages(kvm);
 	used_pages = max(0, used_pages);
 
 	/*
@@ -1697,9 +1697,9 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 	}
 	else
 		kvm->arch.n_free_mmu_pages += kvm_nr_mmu_pages
-					 - kvm->arch.n_alloc_mmu_pages;
+					 - kvm->arch.n_max_mmu_pages;
 
-	kvm->arch.n_alloc_mmu_pages = kvm_nr_mmu_pages;
+	kvm->arch.n_max_mmu_pages = kvm_nr_mmu_pages;
 }
 
 static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
@@ -3119,7 +3119,7 @@ static int mmu_shrink(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
 
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
-		npages = kvm->arch.n_alloc_mmu_pages -
+		npages = kvm->arch.n_max_mmu_pages -
 			 kvm_mmu_available_pages(kvm);
 		cache_count += npages;
 		if (!kvm_freed && nr_to_scan > 0 && npages > 0) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 25f1907..9a1266d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2759,7 +2759,7 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 
 static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 {
-	return kvm->arch.n_alloc_mmu_pages;
+	return kvm->arch.n_max_mmu_pages;
 }
 
 static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
