Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab2EVC6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:58:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:21684 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab2EVC6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:58:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102674694"
Date: Tue, 22 May 2012 11:02:06 +0800
From: Xudong Hao <xudong.hao@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com, Xiantao Zhang <xiantao.zhang@intel.com>,
        Haitao Shan <haitao.shan@intel.com>, Xudong Hao <xudong.hao@intel.com>
Subject: [PATCH v3 4/4] Enabling Access bit when doing memory swapping
Message-ID: <20120522030206.GA24827@hp-xd.sh.intel.com>
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
 arch/x86/kvm/mmu.c |   14 ++++++++------
 arch/x86/kvm/vmx.c |    6 ++++--
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 72102e0..c2fef8e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1242,7 +1242,8 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
        int young = 0;

        /*
-        * Emulate the accessed bit for EPT, by checking if this page has
+        * In case of absence of EPT Access and Dirty Bits supports,
+        * emulate the accessed bit for EPT, by checking if this page has
         * an EPT mapping, and clearing it if it does. On the next access,
         * a new EPT mapping will be established.
         * This has some overhead, but not as much as the cost of swapping
@@ -1253,11 +1254,12 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,

        for (sptep = rmap_get_first(*rmapp, &iter); sptep;
             sptep = rmap_get_next(&iter)) {
-               BUG_ON(!(*sptep & PT_PRESENT_MASK));
+               BUG_ON(!is_shadow_present_pte(*sptep));

-               if (*sptep & PT_ACCESSED_MASK) {
+               if (*sptep & shadow_accessed_mask) {
                        young = 1;
-                       clear_bit(PT_ACCESSED_SHIFT, (unsigned long *)sptep);
+                       clear_bit((ffs(shadow_accessed_mask) - 1),
+                                (unsigned long *)sptep);
                }
        }

@@ -1281,9 +1283,9 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,

        for (sptep = rmap_get_first(*rmapp, &iter); sptep;
             sptep = rmap_get_next(&iter)) {
-               BUG_ON(!(*sptep & PT_PRESENT_MASK));
+               BUG_ON(!is_shadow_present_pte(*sptep));

-               if (*sptep & PT_ACCESSED_MASK) {
+               if (*sptep & shadow_accessed_mask) {
                        young = 1;
                        break;
                }
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 32eb588..ea6390e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7275,8 +7275,10 @@ static int __init vmx_init(void)
        vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);

        if (enable_ept) {
-               kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
-                               VMX_EPT_EXECUTABLE_MASK);
+               kvm_mmu_set_mask_ptes(0ull,
+                       (enable_ept_ad_bits) ? VMX_EPT_ACCESS_BIT : 0ull,
+                       (enable_ept_ad_bits) ? VMX_EPT_DIRTY_BIT : 0ull,
+                       0ull, VMX_EPT_EXECUTABLE_MASK);
                ept_set_mmio_spte_mask();
                kvm_enable_tdp();
        } else

