Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1IVIz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:55:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58766 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab1IVIz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:55:27 -0400
Message-ID: <4E7AF873.4080606@cn.fujitsu.com>
Date: Thu, 22 Sep 2011 16:57:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 09/11] KVM: MMU: split kvm_mmu_pte_write function
References: <4E7AF758.7060900@cn.fujitsu.com>
In-Reply-To: <4E7AF758.7060900@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:53:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:54:05,
	Serialize complete at 2011-09-22 16:54:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_mmu_pte_write is too long, we split it for better readable

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |  194 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 119 insertions(+), 75 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7b22f3a..6e39ec5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3529,48 +3529,28 @@ static bool last_updated_pte_accessed(struct kvm_vcpu *vcpu)
 	return !!(spte && (*spte & shadow_accessed_mask));
 }
 
-void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-		       const u8 *new, int bytes)
+static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
+				    const u8 *new, int *bytes)
 {
-	gfn_t gfn = gpa >> PAGE_SHIFT;
-	union kvm_mmu_page_role mask = { .word = 0 };
-	struct kvm_mmu_page *sp;
-	struct hlist_node *node;
-	LIST_HEAD(invalid_list);
-	u64 entry, gentry, *spte;
-	unsigned pte_size, page_offset, misaligned, quadrant, offset;
-	int level, npte, r, flooded = 0;
-	bool remote_flush, local_flush, zap_page;
-
-	/*
-	 * If we don't have indirect shadow pages, it means no page is
-	 * write-protected, so we can exit simply.
-	 */
-	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
-		return;
-
-	zap_page = remote_flush = local_flush = false;
-	offset = offset_in_page(gpa);
-
-	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
+	u64 gentry;
+	int r;
 
 	/*
 	 * Assume that the pte write on a page table of the same type
 	 * as the current vcpu paging mode since we update the sptes only
 	 * when they have the same mode.
 	 */
-	if (is_pae(vcpu) && bytes == 4) {
+	if (is_pae(vcpu) && *bytes == 4) {
 		/* Handle a 32-bit guest writing two halves of a 64-bit gpte */
-		gpa &= ~(gpa_t)7;
-		bytes = 8;
-
-		r = kvm_read_guest(vcpu->kvm, gpa, &gentry, min(bytes, 8));
+		*gpa &= ~(gpa_t)7;
+		*bytes = 8;
+		r = kvm_read_guest(vcpu->kvm, *gpa, &gentry, min(*bytes, 8));
 		if (r)
 			gentry = 0;
 		new = (const u8 *)&gentry;
 	}
 
-	switch (bytes) {
+	switch (*bytes) {
 	case 4:
 		gentry = *(const u32 *)new;
 		break;
@@ -3582,71 +3562,135 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		break;
 	}
 
-	/*
-	 * No need to care whether allocation memory is successful
-	 * or not since pte prefetch is skiped if it does not have
-	 * enough objects in the cache.
-	 */
-	mmu_topup_memory_caches(vcpu);
-	spin_lock(&vcpu->kvm->mmu_lock);
-	++vcpu->kvm->stat.mmu_pte_write;
-	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
+	return gentry;
+}
+
+/*
+ * If we're seeing too many writes to a page, it may no longer be a page table,
+ * or we may be forking, in which case it is better to unmap the page.
+ */
+static bool detect_write_flooding(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	bool flooded = false;
+
 	if (gfn == vcpu->arch.last_pt_write_gfn
 	    && !last_updated_pte_accessed(vcpu)) {
 		++vcpu->arch.last_pt_write_count;
 		if (vcpu->arch.last_pt_write_count >= 3)
-			flooded = 1;
+			flooded = true;
 	} else {
 		vcpu->arch.last_pt_write_gfn = gfn;
 		vcpu->arch.last_pt_write_count = 1;
 		vcpu->arch.last_pte_updated = NULL;
 	}
 
+	return flooded;
+}
+
+/*
+ * Misaligned accesses are too much trouble to fix up; also, they usually
+ * indicate a page is not used as a page table.
+ */
+static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
+				    int bytes)
+{
+	unsigned offset, pte_size, misaligned;
+
+	pgprintk("misaligned: gpa %llx bytes %d role %x\n",
+		 gpa, bytes, sp->role.word);
+
+	offset = offset_in_page(gpa);
+	pte_size = sp->role.cr4_pae ? 8 : 4;
+	misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
+	misaligned |= bytes < 4;
+
+	return misaligned;
+}
+
+static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
+{
+	unsigned page_offset, quadrant;
+	u64 *spte;
+	int level;
+
+	page_offset = offset_in_page(gpa);
+	level = sp->role.level;
+	*nspte = 1;
+	if (!sp->role.cr4_pae) {
+		page_offset <<= 1;	/* 32->64 */
+		/*
+		 * A 32-bit pde maps 4MB while the shadow pdes map
+		 * only 2MB.  So we need to double the offset again
+		 * and zap two pdes instead of one.
+		 */
+		if (level == PT32_ROOT_LEVEL) {
+			page_offset &= ~7; /* kill rounding error */
+			page_offset <<= 1;
+			*nspte = 2;
+		}
+		quadrant = page_offset >> PAGE_SHIFT;
+		page_offset &= ~PAGE_MASK;
+		if (quadrant != sp->role.quadrant)
+			return NULL;
+	}
+
+	spte = &sp->spt[page_offset / sizeof(*spte)];
+	return spte;
+}
+
+void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+		       const u8 *new, int bytes)
+{
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	union kvm_mmu_page_role mask = { .word = 0 };
+	struct kvm_mmu_page *sp;
+	struct hlist_node *node;
+	LIST_HEAD(invalid_list);
+	u64 entry, gentry, *spte;
+	int npte;
+	bool remote_flush, local_flush, zap_page, flooded, misaligned;
+
+	/*
+	 * If we don't have indirect shadow pages, it means no page is
+	 * write-protected, so we can exit simply.
+	 */
+	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
+		return;
+
+	zap_page = remote_flush = local_flush = false;
+
+	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
+
+	gentry = mmu_pte_write_fetch_gpte(vcpu, &gpa, new, &bytes);
+
+	/*
+	 * No need to care whether allocation memory is successful
+	 * or not since pte prefetch is skiped if it does not have
+	 * enough objects in the cache.
+	 */
+	mmu_topup_memory_caches(vcpu);
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	++vcpu->kvm->stat.mmu_pte_write;
+	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
+
+	flooded = detect_write_flooding(vcpu, gfn);
 	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
-		pte_size = sp->role.cr4_pae ? 8 : 4;
-		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
-		misaligned |= bytes < 4;
+		misaligned = detect_write_misaligned(sp, gpa, bytes);
+
 		if (misaligned || flooded) {
-			/*
-			 * Misaligned accesses are too much trouble to fix
-			 * up; also, they usually indicate a page is not used
-			 * as a page table.
-			 *
-			 * If we're seeing too many writes to a page,
-			 * it may no longer be a page table, or we may be
-			 * forking, in which case it is better to unmap the
-			 * page.
-			 */
-			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
-				 gpa, bytes, sp->role.word);
 			zap_page |= !!kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
 						     &invalid_list);
 			++vcpu->kvm->stat.mmu_flooded;
 			continue;
 		}
-		page_offset = offset;
-		level = sp->role.level;
-		npte = 1;
-		if (!sp->role.cr4_pae) {
-			page_offset <<= 1;	/* 32->64 */
-			/*
-			 * A 32-bit pde maps 4MB while the shadow pdes map
-			 * only 2MB.  So we need to double the offset again
-			 * and zap two pdes instead of one.
-			 */
-			if (level == PT32_ROOT_LEVEL) {
-				page_offset &= ~7; /* kill rounding error */
-				page_offset <<= 1;
-				npte = 2;
-			}
-			quadrant = page_offset >> PAGE_SHIFT;
-			page_offset &= ~PAGE_MASK;
-			if (quadrant != sp->role.quadrant)
-				continue;
-		}
+
+		spte = get_written_sptes(sp, gpa, &npte);
+		if (!spte)
+			continue;
+
 		local_flush = true;
-		spte = &sp->spt[page_offset / sizeof(*spte)];
 		while (npte--) {
 			entry = *spte;
 			mmu_page_zap_pte(vcpu->kvm, sp, spte);
-- 
1.7.5.4

