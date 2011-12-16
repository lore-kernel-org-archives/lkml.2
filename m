Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab1LPKSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:18:37 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:57097 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab1LPKSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:18:32 -0500
Message-ID: <4EEB1AE2.1000300@linux.vnet.ibm.com>
Date: Fri, 16 Dec 2011 18:18:10 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 7/8] KVM: MMU: remove the redundant get_written_sptes
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
In-Reply-To: <4EEB19AF.5070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121610-4790-0000-0000-0000007026E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_written_sptes is called twice in kvm_mmu_pte_write, one of them can be
removed

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 16e0642..5d0f0e3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3575,7 +3575,7 @@ static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
  * If we're seeing too many writes to a page, it may no longer be a page table,
  * or we may be forking, in which case it is better to unmap the page.
  */
-static bool detect_write_flooding(struct kvm_mmu_page *sp, u64 *spte)
+static bool detect_write_flooding(struct kvm_mmu_page *sp)
 {
 	/*
 	 * Skip write-flooding detected for the sp whose level is 1, because
@@ -3684,10 +3684,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,

 	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
-		spte = get_written_sptes(sp, gpa, &npte);
-
 		if (detect_write_misaligned(sp, gpa, bytes) ||
-		      detect_write_flooding(sp, spte)) {
+		      detect_write_flooding(sp)) {
 			zap_page |= !!kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
 						     &invalid_list);
 			++vcpu->kvm->stat.mmu_flooded;
-- 
1.7.7.4

