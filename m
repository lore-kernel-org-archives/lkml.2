Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab2C2JXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:23:35 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54541 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2C2JX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:23:27 -0400
Message-ID: <4F742A06.8090604@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:23:18 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 05/13] KVM: MMU: reset shadow_mmio_mask
References: <4F742951.7080003@linux.vnet.ibm.com>
In-Reply-To: <4F742951.7080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032909-9574-0000-0000-00000204AA93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not use the last byte (bit 56 ~ bit 63) in shadow_mmio_mask, the late
patch will store vcpu id in the last byte

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    1 +
 arch/x86/kvm/vmx.c |    2 +-
 arch/x86/kvm/x86.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ad40647..bb4d292 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -190,6 +190,7 @@ static void mmu_spte_set(u64 *sptep, u64 spte);

 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask)
 {
+	WARN_ON(mmio_mask & (0xffull << 56));
 	shadow_mmio_mask = mmio_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2c22fc7..5ef2b35 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3706,7 +3706,7 @@ static void ept_set_mmio_spte_mask(void)
 	 * Also, magic bits (0xffull << 49) is set to quickly identify mmio
 	 * spte.
 	 */
-	kvm_mmu_set_mmio_spte_mask(0xffull << 49 | 0x6ull);
+	kvm_mmu_set_mmio_spte_mask(0xffull << 46 | 0x6ull);
 }

 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9970ee6..19ef25e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4834,7 +4834,7 @@ static void kvm_set_mmio_spte_mask(void)
 	 * Set the reserved bits and the present bit of an paging-structure
 	 * entry to generate page fault with PFER.RSV = 1.
 	 */
-	mask = ((1ull << (62 - maxphyaddr + 1)) - 1) << maxphyaddr;
+	mask = ((1ull << (55 - maxphyaddr + 1)) - 1) << maxphyaddr;
 	mask |= 1ull;

 #ifdef CONFIG_X86_64
-- 
1.7.7.6

