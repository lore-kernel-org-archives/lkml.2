Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0D0Kiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:38:55 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:43447 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab0D0Kiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:38:52 -0400
X-SpamScore: 17
X-BigFish: VPS17(zzab9bhb0c3ihzz1202hzz6ff19hz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WK-01-32Q-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/22] KVM: MMU: Introduce kvm_read_guest_page_x86()
Date: Tue, 27 Apr 2010 12:38:25 +0200
Message-ID: <1272364712-17425-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:36.0011 (UTC) FILETIME=[CA784BB0:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the kvm_read_guest_page_x86 function
which reads from the physical memory of the guest. If the
guest is running in guest-mode itself with nested paging
enabled it will read from the guest's guest physical memory
instead.
The patch also changes changes the code to use this function
where it is necessary.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    7 +++++++
 arch/x86/kvm/x86.c              |   29 +++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7851bbc..d9dfc8c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -254,6 +254,13 @@ struct kvm_mmu {
 	union kvm_mmu_page_role base_role;
 	bool direct_map;
 
+	/*
+	 * If true the mmu runs in two-level mode.
+	 * vcpu->arch.nested_mmu needs to contain meaningful values in
+	 * this case.
+	 */
+	bool nested;
+
 	u64 *pae_root;
 	u64 rsvd_bits_mask[2][4];
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 558d995..317ad26 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -379,6 +379,20 @@ int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page_tdp);
 
+int kvm_read_guest_page_x86(struct kvm_vcpu *vcpu, gfn_t gfn,
+			    void *data, int offset, int len, u32 *error)
+{
+	struct kvm_mmu *mmu;
+
+	if (vcpu->arch.mmu.nested)
+		mmu = &vcpu->arch.nested_mmu;
+	else
+		mmu = &vcpu->arch.mmu;
+
+	return kvm_read_guest_page_tdp(vcpu, mmu, gfn, data, offset, len,
+				       error);
+}
+
 /*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
@@ -386,12 +400,13 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	gfn_t pdpt_gfn = cr3 >> PAGE_SHIFT;
 	unsigned offset = ((cr3 & (PAGE_SIZE-1)) >> 5) << 2;
-	int i;
+	int i, error;
 	int ret;
 	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
 
-	ret = kvm_read_guest_page(vcpu->kvm, pdpt_gfn, pdpte,
-				  offset * sizeof(u64), sizeof(pdpte));
+	ret = kvm_read_guest_page_x86(vcpu, pdpt_gfn, pdpte,
+				      offset * sizeof(u64),
+				      sizeof(pdpte), &error);
 	if (ret < 0) {
 		ret = 0;
 		goto out;
@@ -420,6 +435,9 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 {
 	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
 	bool changed = true;
+	int offset;
+	u32 error;
+	gfn_t gfn;
 	int r;
 
 	if (is_long_mode(vcpu) || !is_pae(vcpu))
@@ -429,7 +447,10 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 		      (unsigned long *)&vcpu->arch.regs_avail))
 		return true;
 
-	r = kvm_read_guest(vcpu->kvm, vcpu->arch.cr3 & ~31u, pdpte, sizeof(pdpte));
+	gfn = (vcpu->arch.cr3 & ~31u) >> PAGE_SHIFT;
+	offset = (vcpu->arch.cr3 & ~31u) & (PAGE_SIZE - 1);
+	r = kvm_read_guest_page_x86(vcpu, gfn, pdpte, offset, sizeof(pdpte),
+				    &error);
 	if (r < 0)
 		goto out;
 	changed = memcmp(pdpte, vcpu->arch.pdptrs, sizeof(pdpte)) != 0;
-- 
1.7.0.4


