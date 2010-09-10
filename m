Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0IJPhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:37:04 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:34697 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0IJPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:42 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF43-01-7P3-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 22/29] KVM: MMU: Refactor mmu_alloc_roots function
Date: Fri, 10 Sep 2010 17:30:59 +0200
Message-ID: <1284132667-18620-23-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch factors out the direct-mapping paths of the
mmu_alloc_roots function into a seperate function. This
makes it a lot easier to avoid all the unnecessary checks
done in the shadow path which may break when running direct.
In fact, this patch already fixes a problem when running PAE
guests on a PAE shadow page table.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |   82 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a25173a..9cd5a71 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2357,42 +2357,77 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 	return ret;
 }
 
-static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
+static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_page *sp;
+	int i;
+
+	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+		spin_lock(&vcpu->kvm->mmu_lock);
+		kvm_mmu_free_some_pages(vcpu);
+		sp = kvm_mmu_get_page(vcpu, 0, 0, PT64_ROOT_LEVEL,
+				      1, ACC_ALL, NULL);
+		++sp->root_count;
+		spin_unlock(&vcpu->kvm->mmu_lock);
+		vcpu->arch.mmu.root_hpa = __pa(sp->spt);
+	} else if (vcpu->arch.mmu.shadow_root_level == PT32E_ROOT_LEVEL) {
+		for (i = 0; i < 4; ++i) {
+			hpa_t root = vcpu->arch.mmu.pae_root[i];
+
+			ASSERT(!VALID_PAGE(root));
+			spin_lock(&vcpu->kvm->mmu_lock);
+			kvm_mmu_free_some_pages(vcpu);
+			sp = kvm_mmu_get_page(vcpu, i << 30, i << 30,
+					      PT32_ROOT_LEVEL, 1, ACC_ALL,
+					      NULL);
+			root = __pa(sp->spt);
+			++sp->root_count;
+			spin_unlock(&vcpu->kvm->mmu_lock);
+			vcpu->arch.mmu.pae_root[i] = root | PT_PRESENT_MASK;
+			vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
+		}
+	} else
+		BUG();
+
+	return 0;
+}
+
+static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
 	gfn_t root_gfn;
 	struct kvm_mmu_page *sp;
-	int direct = 0;
 	u64 pdptr;
 
 	root_gfn = vcpu->arch.mmu.get_cr3(vcpu) >> PAGE_SHIFT;
 
-	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+	if (mmu_check_root(vcpu, root_gfn))
+		return 1;
+
+	/*
+	 * Do we shadow a long mode page table? If so we need to
+	 * write-protect the guests page table root.
+	 */
+	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		ASSERT(!VALID_PAGE(root));
-		if (mmu_check_root(vcpu, root_gfn))
-			return 1;
-		if (vcpu->arch.mmu.direct_map) {
-			direct = 1;
-			root_gfn = 0;
-		}
+
 		spin_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_free_some_pages(vcpu);
-		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
-				      PT64_ROOT_LEVEL, direct,
-				      ACC_ALL, NULL);
+		sp = kvm_mmu_get_page(vcpu, root_gfn, 0, PT64_ROOT_LEVEL,
+				      0, ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
 		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu.root_hpa = root;
 		return 0;
 	}
-	direct = !is_paging(vcpu);
-
-	if (mmu_check_root(vcpu, root_gfn))
-		return 1;
 
+	/*
+	 * We shadow a 32 bit page table. This may be a legacy 2-level
+	 * or a PAE 3-level page table.
+	 */
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
@@ -2406,16 +2441,11 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 			root_gfn = pdptr >> PAGE_SHIFT;
 			if (mmu_check_root(vcpu, root_gfn))
 				return 1;
-		} else if (vcpu->arch.mmu.root_level == 0)
-			root_gfn = 0;
-		if (vcpu->arch.mmu.direct_map) {
-			direct = 1;
-			root_gfn = i << 30;
 		}
 		spin_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_free_some_pages(vcpu);
 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
-				      PT32_ROOT_LEVEL, direct,
+				      PT32_ROOT_LEVEL, 0,
 				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
@@ -2427,6 +2457,14 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.mmu.direct_map)
+		return mmu_alloc_direct_roots(vcpu);
+	else
+		return mmu_alloc_shadow_roots(vcpu);
+}
+
 static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
-- 
1.7.0.4


