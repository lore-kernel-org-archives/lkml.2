Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab2C2JVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:21:37 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50023 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2C2JVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:21:31 -0400
Message-ID: <4F742979.3020607@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:20:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 01/13] KVM: MMU: properly assert spte on rmap_next path
References: <4F742951.7080003@linux.vnet.ibm.com>
In-Reply-To: <4F742951.7080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032909-4790-0000-0000-000001FDC1E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only test present bit is not enough since mmio spte is also set this bit,
use is_rmap_spte() instead of it

Also move the BUG_ONs to the common function to cleanup the code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index dc5f245..c759e4f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -989,7 +989,12 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)

 static u64 *rmap_next(unsigned long *rmapp, u64 *spte)
 {
-	return pte_list_next(rmapp, spte);
+	u64 *sptep;
+
+	sptep = pte_list_next(rmapp, spte);
+
+	WARN_ON(sptep && !is_rmap_spte(*sptep));
+	return sptep;
 }

 static void rmap_remove(struct kvm *kvm, u64 *spte)
@@ -1016,7 +1021,6 @@ static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level
 	int write_protected = 0;

 	while ((spte = rmap_next(rmapp, spte))) {
-		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);

 		if (!is_writable_pte(*spte))
@@ -1087,7 +1091,6 @@ static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	int need_tlb_flush = 0;

 	while ((spte = rmap_next(rmapp, NULL))) {
-		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		rmap_printk("kvm_rmap_unmap_hva: spte %p %llx\n", spte, *spte);
 		drop_spte(kvm, spte);
 		need_tlb_flush = 1;
@@ -1107,7 +1110,6 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	new_pfn = pte_pfn(*ptep);
 	spte = rmap_next(rmapp, NULL);
 	while (spte) {
-		BUG_ON(!is_shadow_present_pte(*spte));
 		rmap_printk("kvm_set_pte_rmapp: spte %p %llx\n", spte, *spte);
 		need_flush = 1;
 		if (pte_write(*ptep)) {
@@ -1200,7 +1202,6 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	while (spte) {
 		int _young;
 		u64 _spte = *spte;
-		BUG_ON(!(_spte & PT_PRESENT_MASK));
 		_young = _spte & PT_ACCESSED_MASK;
 		if (_young) {
 			young = 1;
@@ -1228,7 +1229,6 @@ static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
 	spte = rmap_next(rmapp, NULL);
 	while (spte) {
 		u64 _spte = *spte;
-		BUG_ON(!(_spte & PT_PRESENT_MASK));
 		young = _spte & PT_ACCESSED_MASK;
 		if (young) {
 			young = 1;
-- 
1.7.7.6

