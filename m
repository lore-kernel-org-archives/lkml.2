Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab2DMKJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:09:58 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52066 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab2DMKJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:09:56 -0400
Message-ID: <4F87FB6E.5010606@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:09:50 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 01/16] KVM: MMU: cleanup __direct_map
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041300-7014-0000-0000-000000E5DA8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use link_shadow_page to link the sp to the spte in __direct_map

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 29ad6f9..151fcddc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1850,9 +1850,9 @@ static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
 {
 	u64 spte;

-	spte = __pa(sp->spt)
-		| PT_PRESENT_MASK | PT_ACCESSED_MASK
-		| PT_WRITABLE_MASK | PT_USER_MASK;
+	spte = __pa(sp->spt) | PT_PRESENT_MASK | PT_WRITABLE_MASK |
+	       shadow_user_mask | shadow_x_mask | shadow_accessed_mask;
+
 	mmu_spte_set(sptep, spte);
 }

@@ -2541,11 +2541,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
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
1.7.7.6

