Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab1LPKOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:14:39 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54545 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1LPKOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:14:32 -0500
Message-ID: <4EEB1A00.8090707@linux.vnet.ibm.com>
Date: Fri, 16 Dec 2011 18:14:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/8] KVM: MMU: set the dirty bit for the upper shadow page
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
In-Reply-To: <4EEB19AF.5070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121610-9574-0000-0000-0000008DC622
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upper page do not need to be tracked the status bit, it is safe to set the
dirty and let cpu to happily prefetch it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6913a16..a2d28aa 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -150,6 +150,9 @@ module_param(dbg, bool, 0644);
 #define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
+#define SHADOW_PAGE_TABLE						\
+	(PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask |	\
+	 shadow_x_mask | shadow_accessed_mask | shadow_dirty_mask)

 static bool sp_is_unsync(struct kvm_mmu_page *sp)
 {
@@ -1808,9 +1811,7 @@ static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
 {
 	u64 spte;

-	spte = __pa(sp->spt)
-		| PT_PRESENT_MASK | PT_ACCESSED_MASK
-		| PT_WRITABLE_MASK | PT_USER_MASK;
+	spte = __pa(sp->spt) | SHADOW_PAGE_TABLE;
 	mmu_spte_set(sptep, spte);
 }

@@ -2497,11 +2498,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 				return -ENOMEM;
 			}

-			mmu_spte_set(iterator.sptep,
-				     __pa(sp->spt)
-				     | PT_PRESENT_MASK | PT_WRITABLE_MASK
-				     | shadow_user_mask | shadow_x_mask
-				     | shadow_accessed_mask);
+			link_shadow_page(iterator.sptep, sp);
 		}
 	}
 	return emulate;
-- 
1.7.7.4

