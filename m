Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab2FUIuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:50:15 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:38899 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885Ab2FUIuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:50:12 -0400
Date: Thu, 21 Jun 2012 17:49:58 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 2/6] KVM: Introduce hva_to_gfn_memslot() for
 kvm_handle_hva()
Message-Id: <20120621174958.cf4f1cf0.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
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
 arch/powerpc/kvm/book3s_64_mmu_hv.c |    6 +++---
 arch/x86/kvm/mmu.c                  |    3 +--
 include/linux/kvm_host.h            |    8 ++++++++
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index d03eb6f..3703755 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -772,10 +772,10 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 
 		end = start + (memslot->npages << PAGE_SHIFT);
 		if (hva >= start && hva < end) {
-			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
+			gfn_t gfn = hva_to_gfn_memslot(hva, memslot);
+			gfn_t gfn_offset = gfn - memslot->base_gfn;
 
-			ret = handler(kvm, &memslot->rmap[gfn_offset],
-				      memslot->base_gfn + gfn_offset);
+			ret = handler(kvm, &memslot->rmap[gfn_offset], gfn);
 			retval |= ret;
 		}
 	}
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d3e7e6a..b898bec 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1202,8 +1202,7 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 
 		end = start + (memslot->npages << PAGE_SHIFT);
 		if (hva >= start && hva < end) {
-			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
-			gfn_t gfn = memslot->base_gfn + gfn_offset;
+			gfn_t gfn = hva_to_gfn_memslot(hva, memslot);
 
 			ret = 0;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 27ac8a4..2e25d17 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -740,6 +740,14 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 		(base_gfn >> KVM_HPAGE_GFN_SHIFT(level));
 }
 
+static inline gfn_t
+hva_to_gfn_memslot(unsigned long hva, struct kvm_memory_slot *slot)
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

