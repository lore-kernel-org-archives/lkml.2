Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2FOLc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:32:27 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:39709 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2FOLc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:32:26 -0400
Date: Fri, 15 Jun 2012 20:31:44 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 2/4] KVM: Introduce hva_to_gfn() for kvm_handle_hva()
Message-Id: <20120615203144.2cbcd88f.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This restricts hva handling in mmu code and makes it easier to extend
kvm_handle_hva() so that it can treat a range of addresses later in this
patch series.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Alexander Graf <agraf@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c |   12 +++++-------
 arch/x86/kvm/mmu.c                  |   10 +++-------
 include/linux/kvm_host.h            |    7 +++++++
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index d03eb6f..53716dd 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -767,15 +767,13 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots) {
-		unsigned long start = memslot->userspace_addr;
-		unsigned long end;
+		gfn_t gfn = hva_to_gfn(hva, memslot);
 
-		end = start + (memslot->npages << PAGE_SHIFT);
-		if (hva >= start && hva < end) {
-			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
+		if (gfn >= memslot->base_gfn &&
+		    gfn < memslot->base_gfn + memslot->npages) {
+			gfn_t gfn_offset = gfn - memslot->base_gfn;
 
-			ret = handler(kvm, &memslot->rmap[gfn_offset],
-				      memslot->base_gfn + gfn_offset);
+			ret = handler(kvm, &memslot->rmap[gfn_offset], gfn);
 			retval |= ret;
 		}
 	}
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a2f3969..ba57b3b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1199,14 +1199,10 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 	slots = kvm_memslots(kvm);
 
 	kvm_for_each_memslot(memslot, slots) {
-		unsigned long start = memslot->userspace_addr;
-		unsigned long end;
-
-		end = start + (memslot->npages << PAGE_SHIFT);
-		if (hva >= start && hva < end) {
-			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
-			gfn_t gfn = memslot->base_gfn + gfn_offset;
+		gfn_t gfn = hva_to_gfn(hva, memslot);
 
+		if (gfn >= memslot->base_gfn &&
+		    gfn < memslot->base_gfn + memslot->npages) {
 			ret = 0;
 
 			for (j = PT_PAGE_TABLE_LEVEL;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 27ac8a4..92b2029 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -740,6 +740,13 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 		(base_gfn >> KVM_HPAGE_GFN_SHIFT(level));
 }
 
+static inline gfn_t hva_to_gfn(unsigned long hva, struct kvm_memory_slot *slot)
+{
+	gfn_t gfn_offset = (hva - slot->userspace_addr) >> PAGE_SHIFT;
+
+	return slot->base_gfn + gfn_offset;
+}
+
 static inline unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
 					       gfn_t gfn)
 {
-- 
1.7.5.4

