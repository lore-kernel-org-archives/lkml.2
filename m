Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967236Ab2EPBJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:09:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:10076 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932Ab2EPBI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:08:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153422720"
Date: Wed, 16 May 2012 09:12:30 +0800
From: Xudong Hao <xudong.hao@linux.intel.com>
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, haitao.shan@intel.com,
        xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: [PATCH 4/4] Enabling Access bit when doing memory swapping
Message-ID: <20120516011230.GE14256@hp-xd.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
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
index ff053ca..5f55f98 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1166,7 +1166,8 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
    int young = 0;

    /*
-    * Emulate the accessed bit for EPT, by checking if this page has
+    * In case of absence of EPT Access and Dirty Bits supports,
+    * emulate the accessed bit for EPT, by checking if this page has
     * an EPT mapping, and clearing it if it does. On the next access,
     * a new EPT mapping will be established.
     * This has some overhead, but not as much as the cost of swapping
@@ -1179,11 +1180,11 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
    while (spte) {
        int _young;
        u64 _spte = *spte;
-       BUG_ON(!(_spte & PT_PRESENT_MASK));
-       _young = _spte & PT_ACCESSED_MASK;
+       BUG_ON(!is_shadow_present_pte(_spte));
+       _young = _spte & shadow_accessed_mask;
        if (_young) {
            young = 1;
-           clear_bit(PT_ACCESSED_SHIFT, (unsigned long *)spte);
+           *spte &= ~shadow_accessed_mask;
        }
        spte = rmap_next(rmapp, spte);
    }
@@ -1207,8 +1208,8 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
    spte = rmap_next(rmapp, NULL);
    while (spte) {
        u64 _spte = *spte;
-       BUG_ON(!(_spte & PT_PRESENT_MASK));
-       young = _spte & PT_ACCESSED_MASK;
+       BUG_ON(!is_shadow_present_pte(_spte));
+       young = _spte & shadow_accessed_mask;
        if (young) {
            young = 1;
            break;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 89151a9..a3ef549 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7242,8 +7242,10 @@ static int __init vmx_init(void)
    vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);

    if (enable_ept) {
-       kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
-               VMX_EPT_EXECUTABLE_MASK);
+       kvm_mmu_set_mask_ptes(0ull,
+           (enable_ept_ad_bits) ? VMX_EPT_ACCESS_BIT : 0ull,
+           (enable_ept_ad_bits) ? VMX_EPT_DIRTY_BIT : 0ull,
+           0ull, VMX_EPT_EXECUTABLE_MASK);
        ept_set_mmio_spte_mask();
        kvm_enable_tdp();
    } else
--
1.7.1

