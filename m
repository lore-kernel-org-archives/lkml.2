Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0IFPGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:06:04 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22059 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab0IFPDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:03:36 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h)
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2P-02-4WZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/27] KVM: MMU: Introduce kvm_read_guest_page_x86()
Date: Mon, 6 Sep 2010 17:01:50 +0200
Message-ID: <1283785322-26898-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
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
 arch/x86/kvm/x86.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f1bdf4e..1f5db75 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -392,6 +392,13 @@ int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page_mmu);
 
+int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+			       void *data, int offset, int len, u32 *error)
+{
+	return kvm_read_guest_page_mmu(vcpu, vcpu->arch.walk_mmu, gfn,
+				       data, offset, len, error);
+}
+
 /*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
@@ -399,12 +406,13 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	gfn_t pdpt_gfn = cr3 >> PAGE_SHIFT;
 	unsigned offset = ((cr3 & (PAGE_SIZE-1)) >> 5) << 2;
-	int i;
+	int i, error;
 	int ret;
 	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
 
-	ret = kvm_read_guest_page(vcpu->kvm, pdpt_gfn, pdpte,
-				  offset * sizeof(u64), sizeof(pdpte));
+	ret = kvm_read_nested_guest_page(vcpu, pdpt_gfn, pdpte,
+					 offset * sizeof(u64),
+					 sizeof(pdpte), &error);
 	if (ret < 0) {
 		ret = 0;
 		goto out;
@@ -433,6 +441,9 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 {
 	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
 	bool changed = true;
+	int offset;
+	u32 error;
+	gfn_t gfn;
 	int r;
 
 	if (is_long_mode(vcpu) || !is_pae(vcpu))
@@ -442,7 +453,10 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 		      (unsigned long *)&vcpu->arch.regs_avail))
 		return true;
 
-	r = kvm_read_guest(vcpu->kvm, vcpu->arch.cr3 & ~31u, pdpte, sizeof(pdpte));
+	gfn = (vcpu->arch.cr3 & ~31u) >> PAGE_SHIFT;
+	offset = (vcpu->arch.cr3 & ~31u) & (PAGE_SIZE - 1);
+	r = kvm_read_nested_guest_page(vcpu, gfn, pdpte, offset,
+				       sizeof(pdpte), &error);
 	if (r < 0)
 		goto out;
 	changed = memcmp(pdpte, vcpu->arch.pdptrs, sizeof(pdpte)) != 0;
-- 
1.7.0.4


