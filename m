Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1GZL3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 07:29:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50333 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab1GZL32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 07:29:28 -0400
Message-ID: <4E2EA58B.1030503@cn.fujitsu.com>
Date: Tue, 26 Jul 2011 19:31:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 09/11] KVM: MMU: remove the mismatch shadow page
References: <4E2EA3DB.7040403@cn.fujitsu.com>
In-Reply-To: <4E2EA3DB.7040403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 19:28:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 19:28:30,
	Serialize complete at 2011-07-26 19:28:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the shadow page has different cpu mode with current vcpu, we do better
remove them since the OS does not changes cpu mode frequently

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 931c23a..2328ee6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3603,6 +3603,18 @@ static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
 	return misaligned;
 }
 
+/*
+ * The OS hardly changes cpu mode after boot, we can zap the shadow page if
+ * it is mismatched with the current vcpu.
+ */
+static bool detect_mismatch_sp(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	union kvm_mmu_page_role mask;
+
+	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
+	return (sp->role.word ^ vcpu->arch.mmu.base_role.word) & mask.word;
+}
+
 static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 {
 	unsigned page_offset, quadrant;
@@ -3638,13 +3650,12 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes, bool repeat_write)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
-	union kvm_mmu_page_role mask = { .word = 0 };
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 	u64 entry, gentry, *spte;
 	int npte;
-	bool remote_flush, local_flush, zap_page, flooded, misaligned;
+	bool remote_flush, local_flush, zap_page, flooded;
 
 	/*
 	 * If we don't have indirect shadow pages, it means no page is
@@ -3664,10 +3675,13 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
 
 	flooded = detect_write_flooding(vcpu, gfn);
-	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
+		bool mismatch, misaligned;
+
 		misaligned = detect_write_misaligned(sp, gpa, bytes);
-		if (misaligned || flooded || repeat_write) {
+		mismatch = detect_mismatch_sp(vcpu, sp);
+
+		if (misaligned || mismatch || flooded || repeat_write) {
 			zap_page |= !!kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
 						     &invalid_list);
 			++vcpu->kvm->stat.mmu_flooded;
@@ -3682,9 +3696,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		while (npte--) {
 			entry = *spte;
 			mmu_page_zap_pte(vcpu->kvm, sp, spte);
-			if (gentry &&
-			      !((sp->role.word ^ vcpu->arch.mmu.base_role.word)
-			      & mask.word) && get_free_pte_list_desc_nr(vcpu))
+			if (gentry && get_free_pte_list_desc_nr(vcpu))
 				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
 			if (!remote_flush && need_remote_flush(entry, *spte))
 				remote_flush = true;
-- 
1.7.5.4

