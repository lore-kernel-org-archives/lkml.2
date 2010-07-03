Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0GCKfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 06:35:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60912 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab0GCKfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 06:35:21 -0400
Message-ID: <4C2F117C.2000006@cn.fujitsu.com>
Date: Sat, 03 Jul 2010 18:31:24 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk
 and pte prefetch
References: <4C2C9DC0.8050607@cn.fujitsu.com> <4C2C9E6C.2040803@cn.fujitsu.com> <20100702170303.GC25969@amt.cnet>
In-Reply-To: <20100702170303.GC25969@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:
> On Thu, Jul 01, 2010 at 09:55:56PM +0800, Xiao Guangrong wrote:
>> Combine guest pte read between guest pte walk and pte prefetch
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/kvm/paging_tmpl.h |   48 ++++++++++++++++++++++++++++++-------------
>>  1 files changed, 33 insertions(+), 15 deletions(-)
> 
> Can't do this, it can miss invlpg:
> 
> vcpu0			vcpu1
> read guest ptes
> 			modify guest pte
> 			invlpg
> instantiate stale 
> guest pte

Ah, oops, sorry :-(

> 
> See how the pte is reread inside fetch with mmu_lock held.
> 

It looks like something is broken in 'fetch' functions, this patch will
fix it.

Subject: [PATCH] KVM: MMU: fix last level broken in FNAME(fetch)

We read the guest level out of 'mmu_lock', sometimes, the host mapping is
confusion. Consider this case:

VCPU0:                                              VCPU1

Read guest mapping, assume the mapping is:
GLV3 -> GLV2 -> GLV1 -> GFNA,
And in the host, the corresponding mapping is
HLV3 -> HLV2 -> HLV1(P=0)

                                                   Write GLV1 and cause the
                                                   mapping point to GFNB
                                                   (May occur in pte_write or
                                                      invlpg path)

Mapping GLV1 to GFNA

This issue only occurs in the last indirect mapping, since if the middle
mapping is changed, the mapping will be zapped, then it will be detected
in the FNAME(fetch) path, but when it map the last level, it not checked.

Fixed by also check the last level.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 3350c02..e617e93 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -291,6 +291,20 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     gpte_to_gfn(gpte), pfn, true, true);
 }
 
+static bool FNAME(check_level_mapping)(struct kvm_vcpu *vcpu,
+				       struct guest_walker *gw, int level)
+{
+	pt_element_t curr_pte;
+	int r;
+
+	r = kvm_read_guest_atomic(vcpu->kvm, gw->pte_gpa[level - 1],
+				     &curr_pte, sizeof(curr_pte));
+	if (r || curr_pte != gw->ptes[level - 1])
+		return false;
+
+	return true;
+}
+
 /*
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
@@ -304,11 +318,9 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	u64 spte, *sptep = NULL;
 	int direct;
 	gfn_t table_gfn;
-	int r;
 	int level;
-	bool dirty = is_dirty_gpte(gw->ptes[gw->level - 1]);
+	bool dirty = is_dirty_gpte(gw->ptes[gw->level - 1]), check = true;
 	unsigned direct_access;
-	pt_element_t curr_pte;
 	struct kvm_shadow_walk_iterator iterator;
 
 	if (!is_present_gpte(gw->ptes[gw->level - 1]))
@@ -322,6 +334,12 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		level = iterator.level;
 		sptep = iterator.sptep;
 		if (iterator.level == hlevel) {
+			if (check && level == gw->level &&
+			      !FNAME(check_level_mapping)(vcpu, gw, hlevel)) {
+				kvm_release_pfn_clean(pfn);
+				break;
+			}
+
 			mmu_set_spte(vcpu, sptep, access,
 				     gw->pte_access & access,
 				     user_fault, write_fault,
@@ -376,10 +394,10 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		sp = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
 					       direct, access, sptep);
 		if (!direct) {
-			r = kvm_read_guest_atomic(vcpu->kvm,
-						  gw->pte_gpa[level - 2],
-						  &curr_pte, sizeof(curr_pte));
-			if (r || curr_pte != gw->ptes[level - 2]) {
+			if (hlevel == level - 1)
+				check = false;
+
+			if (!FNAME(check_level_mapping)(vcpu, gw, level - 1)) {
 				kvm_mmu_put_page(sp, sptep);
 				kvm_release_pfn_clean(pfn);
 				sptep = NULL;
-- 
1.6.1.2



