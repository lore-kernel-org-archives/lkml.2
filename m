Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0DVGRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:17:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50344 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab0DVGRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:17:09 -0400
Message-ID: <4BCFE92D.9000201@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 14:14:05 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/10] KVM MMU: optimize sync/update unsync-page
References: <4BCFE581.8050305@cn.fujitsu.com>
In-Reply-To: <4BCFE581.8050305@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

invlpg only need update unsync page, sp->unsync and sp->unsync_children
can help us to find it

Now, a gfn may have many shadow pages, when one sp need be synced, we
write protect sp->gfn and sync this sp but we keep other shadow pages
asynchronous

So, while gfn happen page fault, let it not touch unsync page, the unsync
page only updated at invlpg/flush TLB time

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f092e71..5bdcc17 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2299,10 +2299,11 @@ static void paging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 	for_each_shadow_entry(vcpu, gva, iterator) {
 		level = iterator.level;
 		sptep = iterator.sptep;
+		sp = page_header(__pa(sptep));
 
 		if (is_last_spte(*sptep, level)) {
-
-			sp = page_header(__pa(sptep));
+			if (!sp->unsync)
+				break;
 
 			if (!sp->role.cr4_pae)
 				offset = sp->role.quadrant << PT64_LEVEL_BITS;;
@@ -2320,7 +2321,7 @@ static void paging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 			break;
 		}
 
-		if (!is_shadow_present_pte(*sptep))
+		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
 			break;
 	}
 
@@ -2744,7 +2745,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 restart:
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link) {
-		if (sp->gfn != gfn || sp->role.direct || sp->role.invalid)
+		if (sp->gfn != gfn || sp->role.direct || sp->role.invalid ||
+			sp->unsync)
 			continue;
 		pte_size = sp->role.cr4_pae ? 8 : 4;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
-- 
1.6.1.2


