Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab0FYMJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:09:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57945 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab0FYMJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:09:53 -0400
Message-ID: <4C249BAD.6000609@cn.fujitsu.com>
Date: Fri, 25 Jun 2010 20:06:05 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com>
In-Reply-To: <4C2498EC.2010006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider using small page to fit guest's large page mapping:

If the mapping is writable but the dirty flag is not set, we will find
the read-only direct sp and setup the mapping, then if the write #PF
occur, we will mark this mapping writable in the read-only direct sp,
now, other real read-only mapping will happily write it without #PF.

It may hurt guest's COW

Fixed by re-install the mapping when write #PF occur.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    3 ++-
 arch/x86/kvm/paging_tmpl.h |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 556a798..0412ba4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -153,7 +153,8 @@ module_param(oos_shadow, bool, 0644);
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"
 
-#define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_NO_DIRTY		(2ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index e46eb8a..fdba751 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -325,6 +325,20 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			break;
 		}
 
+		if (*sptep & SPTE_NO_DIRTY) {
+			struct kvm_mmu_page *child;
+
+			WARN_ON(level !=  gw->level);
+			WARN_ON(!is_shadow_present_pte(*sptep));
+			if (dirty) {
+				child = page_header(*sptep &
+						      PT64_BASE_ADDR_MASK);
+				mmu_page_remove_parent_pte(child, sptep);
+				__set_spte(sptep, shadow_trap_nonpresent_pte);
+				kvm_flush_remote_tlbs(vcpu->kvm);
+			}
+		}
+
 		if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
 			continue;
 
@@ -365,6 +379,10 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			}
 		}
 
+		if (level == gw->level && !dirty &&
+		      access & gw->pte_access & ACC_WRITE_MASK)
+			spte |= SPTE_NO_DIRTY;
+
 		spte = __pa(sp->spt)
 			| PT_PRESENT_MASK | PT_ACCESSED_MASK
 			| PT_WRITABLE_MASK | PT_USER_MASK;
-- 
1.6.1.2



