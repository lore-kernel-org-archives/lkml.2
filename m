Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0IJPjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:39:42 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:41738 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab0IJPch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:37 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF42-01-7OT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/29] KVM: MMU: Introduce kvm_read_nested_guest_page()
Date: Fri, 10 Sep 2010 17:30:53 +0200
Message-ID: <1284132667-18620-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
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
 arch/x86/kvm/x86.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34bc840..540255d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -392,6 +392,13 @@ int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page_mmu);
 
+int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+			       void *data, int offset, int len, u32 access)
+{
+	return kvm_read_guest_page_mmu(vcpu, vcpu->arch.walk_mmu, gfn,
+				       data, offset, len, access);
+}
+
 /*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
@@ -403,8 +410,9 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	int ret;
 	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
 
-	ret = kvm_read_guest_page(vcpu->kvm, pdpt_gfn, pdpte,
-				  offset * sizeof(u64), sizeof(pdpte));
+	ret = kvm_read_nested_guest_page(vcpu, pdpt_gfn, pdpte,
+					 offset * sizeof(u64), sizeof(pdpte),
+					 PFERR_USER_MASK|PFERR_WRITE_MASK);
 	if (ret < 0) {
 		ret = 0;
 		goto out;
@@ -433,6 +441,8 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 {
 	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
 	bool changed = true;
+	int offset;
+	gfn_t gfn;
 	int r;
 
 	if (is_long_mode(vcpu) || !is_pae(vcpu))
@@ -442,7 +452,10 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 		      (unsigned long *)&vcpu->arch.regs_avail))
 		return true;
 
-	r = kvm_read_guest(vcpu->kvm, vcpu->arch.cr3 & ~31u, pdpte, sizeof(pdpte));
+	gfn = (vcpu->arch.cr3 & ~31u) >> PAGE_SHIFT;
+	offset = (vcpu->arch.cr3 & ~31u) & (PAGE_SIZE - 1);
+	r = kvm_read_nested_guest_page(vcpu, gfn, pdpte, offset, sizeof(pdpte),
+				       PFERR_USER_MASK | PFERR_WRITE_MASK);
 	if (r < 0)
 		goto out;
 	changed = memcmp(pdpte, vcpu->arch.pdptrs, sizeof(pdpte)) != 0;
-- 
1.7.0.4


