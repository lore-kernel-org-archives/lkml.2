Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935138Ab2DMKPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:15:02 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52251 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934665Ab2DMKPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:15:00 -0400
Message-ID: <4F87FC9C.8050805@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:14:52 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 11/16] KVM: MMU: introduce SPTE_ALLOW_WRITE bit
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041301-3568-0000-0000-00000187BD25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bit indicates whether the spte is allow to be writable that
means the gpte of this spte is writable and the pfn pointed by
this spte is writable on host

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8b71908..1a06776 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -145,7 +145,8 @@ module_param(dbg, bool, 0644);
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"

-#define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_ALLOW_WRITE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)

@@ -1237,9 +1238,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
 			new_spte |= (u64)new_pfn << PAGE_SHIFT;

-			new_spte &= ~PT_WRITABLE_MASK;
-			new_spte &= ~SPTE_HOST_WRITEABLE;
-			new_spte &= ~shadow_accessed_mask;
+			new_spte &= ~(PT_WRITABLE_MASK | SPTE_HOST_WRITEABLE |
+				      shadow_accessed_mask | SPTE_ALLOW_WRITE);

 			mmu_spte_clear_track_bits(sptep);
 			mmu_spte_set(sptep, new_spte);
@@ -2386,7 +2386,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			goto done;
 		}

-		spte |= PT_WRITABLE_MASK;
+		spte |= PT_WRITABLE_MASK | SPTE_ALLOW_WRITE;

 		if (!vcpu->arch.mmu.direct_map
 		    && !(pte_access & ACC_WRITE_MASK)) {
@@ -2415,8 +2415,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				 __func__, gfn);
 			ret = 1;
 			pte_access &= ~ACC_WRITE_MASK;
-			if (is_writable_pte(spte))
-				spte &= ~PT_WRITABLE_MASK;
+			spte &= ~PT_WRITABLE_MASK;
 		}
 	}

-- 
1.7.7.6

