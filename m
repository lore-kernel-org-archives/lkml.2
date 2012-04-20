Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2DTITQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:19:16 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36422 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab2DTITM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:19:12 -0400
Message-ID: <4F911BE7.30206@linux.vnet.ibm.com>
Date: Fri, 20 Apr 2012 16:18:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 4/9] KVM: MMU: introduce SPTE_ALLOW_WRITE bit
References: <4F911B74.4040305@linux.vnet.ibm.com>
In-Reply-To: <4F911B74.4040305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042008-2674-0000-0000-0000041AEC49
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
index e70ff38..dd984b6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -145,7 +145,8 @@ module_param(dbg, bool, 0644);
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"

-#define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_ALLOW_WRITE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)

@@ -1177,9 +1178,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
 			new_spte |= (u64)new_pfn << PAGE_SHIFT;

-			new_spte &= ~PT_WRITABLE_MASK;
-			new_spte &= ~SPTE_HOST_WRITEABLE;
-			new_spte &= ~shadow_accessed_mask;
+			new_spte &= ~(PT_WRITABLE_MASK | SPTE_HOST_WRITEABLE |
+				      shadow_accessed_mask | SPTE_ALLOW_WRITE);

 			mmu_spte_clear_track_bits(sptep);
 			mmu_spte_set(sptep, new_spte);
@@ -2316,7 +2316,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			goto done;
 		}

-		spte |= PT_WRITABLE_MASK;
+		spte |= PT_WRITABLE_MASK | SPTE_ALLOW_WRITE;

 		if (!vcpu->arch.mmu.direct_map
 		    && !(pte_access & ACC_WRITE_MASK)) {
@@ -2345,8 +2345,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
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

