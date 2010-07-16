Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935565Ab0GPD3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 23:29:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51563 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935392Ab0GPD3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 23:29:17 -0400
Message-ID: <4C3FD11D.1060104@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 11:25:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 3/6] KVM: MMU: fix page dirty tracking lost while sync
 page
References: <4C3FCFD7.5070005@cn.fujitsu.com>
In-Reply-To: <4C3FCFD7.5070005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sync-page path, if spte.writable is changed, it will lose page dirty
tracking, for example:

assume spte.writable = 0 in a unsync-page, when it's synced, it map spte
to writable(that is spte.writable = 1), later guest write spte.gfn, it means
spte.gfn is dirty, then guest changed this mapping to read-only, after it's
synced,  spte.writable = 0

So, when host release the spte, it detect spte.writable = 0 and not mark page
dirty

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5937054..b3896bf 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1981,6 +1981,8 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		mark_page_dirty(vcpu->kvm, gfn);
 
 set_pte:
+	if (is_writable_pte(*sptep) && !is_writable_pte(spte))
+		kvm_set_pfn_dirty(pfn);
 	update_spte(sptep, spte);
 done:
 	return ret;
@@ -1994,7 +1996,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 bool reset_host_protection)
 {
 	int was_rmapped = 0;
-	int was_writable = is_writable_pte(*sptep);
 	int rmap_count;
 
 	pgprintk("%s: spte %llx access %x write_fault %d"
@@ -2044,15 +2045,10 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	page_header_update_slot(vcpu->kvm, sptep, gfn);
 	if (!was_rmapped) {
 		rmap_count = rmap_add(vcpu, sptep, gfn);
-		kvm_release_pfn_clean(pfn);
 		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
 			rmap_recycle(vcpu, sptep, gfn);
-	} else {
-		if (was_writable)
-			kvm_release_pfn_dirty(pfn);
-		else
-			kvm_release_pfn_clean(pfn);
 	}
+	kvm_release_pfn_clean(pfn);
 	if (speculative) {
 		vcpu->arch.last_pte_updated = sptep;
 		vcpu->arch.last_pte_gfn = gfn;
-- 
1.6.1.2



