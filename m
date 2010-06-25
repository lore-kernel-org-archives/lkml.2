Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0FYMJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:09:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab0FYMJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:09:16 -0400
Message-ID: <4C249B84.4080703@cn.fujitsu.com>
Date: Fri, 25 Jun 2010 20:05:24 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 1/10] KVM: MMU: fix writable sync sp mapping
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we sync the unsync sp, we may mapping the spte writable, it's
dangerous, if one unsync sp's mapping gfn is another unsync page's gfn.

For example:
have two unsync pages SP1, SP2 and:

SP1.pte[0] = P
SP2.gfn's pfn = P
[SP1.pte[0] = SP2.gfn's pfn]

First, we unsync SP2, it will write protect for SP2.gfn since
SP1.pte[0] is mapping to this page, it will mark read only.

Then, we unsync SP1, SP1.pte[0] may mark to writable.

Now, we will write SP2.gfn by SP1.pte[0] mapping

This bug will corrupt guest's page table, fixed by mark read-only mapping
if the mapped gfn has shadow page

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 045a0f9..556a798 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1810,11 +1810,14 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	bool need_unsync = false;
 
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
+		if (!can_unsync)
+			return 1;
+
 		if (s->role.level != PT_PAGE_TABLE_LEVEL)
 			return 1;
 
 		if (!need_unsync && !s->unsync) {
-			if (!can_unsync || !oos_shadow)
+			if (!oos_shadow)
 				return 1;
 			need_unsync = true;
 		}
@@ -1877,15 +1880,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (!tdp_enabled && !(pte_access & ACC_WRITE_MASK))
 			spte &= ~PT_USER_MASK;
 
-		/*
-		 * Optimization: for pte sync, if spte was writable the hash
-		 * lookup is unnecessary (and expensive). Write protection
-		 * is responsibility of mmu_get_page / kvm_sync_page.
-		 * Same reasoning can be applied to dirty page accounting.
-		 */
-		if (!can_unsync && is_writable_pte(*sptep))
-			goto set_pte;
-
 		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
 				 __func__, gfn);
-- 
1.6.1.2


