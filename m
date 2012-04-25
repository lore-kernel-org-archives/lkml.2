Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2DYEDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:03:01 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52250 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2DYEDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:03:00 -0400
Message-ID: <4F97775C.9080302@linux.vnet.ibm.com>
Date: Wed, 25 Apr 2012 12:02:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 04/10] KVM: MMU: introduce SPTE_MMU_WRITEABLE bit
References: <4F9776D2.7020506@linux.vnet.ibm.com>
In-Reply-To: <4F9776D2.7020506@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042417-5490-0000-0000-000001379F09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bit indicates whether the gpte of this spte is writable

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e70ff38..46bde3f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -145,7 +145,8 @@ module_param(dbg, bool, 0644);
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"

-#define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)

@@ -2290,8 +2291,13 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= shadow_x_mask;
 	else
 		spte |= shadow_nx_mask;
+
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
+
+	if (pte_access & ACC_WRITE_MASK)
+		spte |= SPTE_MMU_WRITEABLE;
+
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
@@ -2345,8 +2351,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
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

