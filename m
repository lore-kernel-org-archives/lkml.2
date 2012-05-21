Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2EUDu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 23:50:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:5457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab2EUDuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 23:50:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="142675171"
From: Xudong Hao <xudong.hao@intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com, xiantao.zhang@intel.com,
        Xudong Hao <xudong.hao@intel.com>, Haitao Shan <haitao.shan@intel.com>
Subject: [PATCH v2 4/4] Enabling Access bit when doing memory swapping
Date: Mon, 21 May 2012 11:54:03 +0800
Message-Id: <1337572443-22482-4-git-send-email-xudong.hao@intel.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1337572443-22482-1-git-send-email-xudong.hao@intel.com>
References: <1337572443-22482-1-git-send-email-xudong.hao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling Access bit when doing memory swapping.

Signed-off-by: Haitao Shan <haitao.shan@intel.com>
Signed-off-by: Xudong Hao <xudong.hao@intel.com>
---
 arch/x86/kvm/mmu.c |   13 +++++++------
 arch/x86/kvm/vmx.c |    6 ++++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 07424cf..392bdf3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1232,7 +1232,8 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	int young = 0;
 
 	/*
-	 * Emulate the accessed bit for EPT, by checking if this page has
+	 * In case of absence of EPT Access and Dirty Bits supports,
+	 * emulate the accessed bit for EPT, by checking if this page has
 	 * an EPT mapping, and clearing it if it does. On the next access,
 	 * a new EPT mapping will be established.
 	 * This has some overhead, but not as much as the cost of swapping
@@ -1243,11 +1244,11 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
 	     sptep = rmap_get_next(&iter)) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
+		BUG_ON(!is_shadow_present_pte(*sptep));
 
-		if (*sptep & PT_ACCESSED_MASK) {
+		if (*sptep & shadow_accessed_mask) {
 			young = 1;
-			clear_bit(PT_ACCESSED_SHIFT, (unsigned long *)sptep);
+			*sptep &= ~shadow_accessed_mask;
 		}
 	}
 
@@ -1271,9 +1272,9 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
 	     sptep = rmap_get_next(&iter)) {
-		BUG_ON(!(*sptep & PT_PRESENT_MASK));
+		BUG_ON(!is_shadow_present_pte(*sptep));
 
-		if (*sptep & PT_ACCESSED_MASK) {
+		if (*sptep & shadow_accessed_mask) {
 			young = 1;
 			break;
 		}
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e8003b6..342ea2e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7259,8 +7259,10 @@ static int __init vmx_init(void)
 	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
 
 	if (enable_ept) {
-		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
-				VMX_EPT_EXECUTABLE_MASK);
+		kvm_mmu_set_mask_ptes(0ull,
+			(enable_ept_ad_bits) ? VMX_EPT_ACCESS_BIT : 0ull,
+			(enable_ept_ad_bits) ? VMX_EPT_DIRTY_BIT : 0ull,
+			0ull, VMX_EPT_EXECUTABLE_MASK);
 		ept_set_mmio_spte_mask();
 		kvm_enable_tdp();
 	} else
-- 
1.5.6

