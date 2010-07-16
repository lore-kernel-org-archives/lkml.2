Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935424Ab0GPCMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:12:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935295Ab0GPCMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:12:36 -0400
Message-ID: <4C3FC029.3010107@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 10:12:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 2/6] kvm, ept: remove the default write bit
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ept enabled, current code set shadow_base_present_pte
including the write bit, thus all pte entries have
writabe bit, and it means guest os can always
write to any mapped page (even VMM maps RO pages for
the guest.)

we will use RO pages future, fix it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 502e53f..62cc947 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -534,7 +534,6 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
 int kvm_mmu_setup(struct kvm_vcpu *vcpu);
 void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte);
-void kvm_mmu_set_base_ptes(u64 base_pte);
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask);
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b93b94f..1f3cbb8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -181,7 +181,6 @@ static struct kmem_cache *mmu_page_header_cache;
 
 static u64 __read_mostly shadow_trap_nonpresent_pte;
 static u64 __read_mostly shadow_notrap_nonpresent_pte;
-static u64 __read_mostly shadow_base_present_pte;
 static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
@@ -200,12 +199,6 @@ void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_nonpresent_ptes);
 
-void kvm_mmu_set_base_ptes(u64 base_pte)
-{
-	shadow_base_present_pte = base_pte;
-}
-EXPORT_SYMBOL_GPL(kvm_mmu_set_base_ptes);
-
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask)
 {
@@ -1878,7 +1871,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	 * whether the guest actually used the pte (in order to detect
 	 * demand paging).
 	 */
-	spte = shadow_base_present_pte | shadow_dirty_mask;
+	spte = PT_PRESENT_MASK | shadow_dirty_mask;
 	if (!speculative)
 		spte |= shadow_accessed_mask;
 	if (!dirty)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2fdcc98..856e427 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4419,8 +4419,6 @@ static int __init vmx_init(void)
 
 	if (enable_ept) {
 		bypass_guest_pf = 0;
-		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
-			VMX_EPT_WRITABLE_MASK);
 		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
 				VMX_EPT_EXECUTABLE_MASK);
 		kvm_enable_tdp();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb08316..5f2fb50 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4237,7 +4237,6 @@ int kvm_arch_init(void *opaque)
 
 	kvm_x86_ops = ops;
 	kvm_mmu_set_nonpresent_ptes(0ull, 0ull);
-	kvm_mmu_set_base_ptes(PT_PRESENT_MASK);
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
 			PT_DIRTY_MASK, PT64_NX_MASK, 0);
 
