Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0IFPDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:03:33 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34748 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0IFPCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:49 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2Q-01-AOG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 21/27] KVM: MMU: Introduce kvm_pdptr_read_mmu
Date: Mon, 6 Sep 2010 17:01:56 +0200
Message-ID: <1283785322-26898-22-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is implemented to load the pdptr pointers of
the currently running guest (l1 or l2 guest). Therefore it
takes care about the current paging mode and can read pdptrs
out of l2 guest physical memory.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/kvm_cache_regs.h |    7 +++++++
 arch/x86/kvm/mmu.c            |    2 +-
 arch/x86/kvm/paging_tmpl.h    |    2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index a37abe2..975bb45 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -45,6 +45,13 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 	return vcpu->arch.walk_mmu->pdptrs[index];
 }
 
+static inline u64 kvm_pdptr_read_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, int index)
+{
+	load_pdptrs(vcpu, mmu, mmu->get_cr3(vcpu));
+
+	return mmu->pdptrs[index];
+}
+
 static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
 {
 	ulong tmask = mask & KVM_POSSIBLE_CR0_GUEST_BITS;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7bc8d67..3663d1c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2398,7 +2398,7 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 
 		ASSERT(!VALID_PAGE(root));
 		if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
-			pdptr = kvm_pdptr_read(vcpu, i);
+			pdptr = kvm_pdptr_read_mmu(vcpu, &vcpu->arch.mmu, i);
 			if (!is_present_gpte(pdptr)) {
 				vcpu->arch.mmu.pae_root[i] = 0;
 				continue;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 20fc815..c0aac98 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -137,7 +137,7 @@ walk:
 
 #if PTTYPE == 64
 	if (walker->level == PT32E_ROOT_LEVEL) {
-		pte = kvm_pdptr_read(vcpu, (addr >> 30) & 3);
+		pte = kvm_pdptr_read_mmu(vcpu, mmu, (addr >> 30) & 3);
 		trace_kvm_mmu_paging_element(pte, walker->level);
 		if (!is_present_gpte(pte)) {
 			present = false;
-- 
1.7.0.4


