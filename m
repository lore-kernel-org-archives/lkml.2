Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab2BJFmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:42:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758871Ab2BJFmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:42:32 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Olaf Hering <olaf@aepfle.de>, linux-crypto@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 08/60] x86: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:29 +0800
Message-Id: <1328852421-19678-9-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Avi Kivity <avi@redhat.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 arch/x86/crypto/aesni-intel_glue.c |   24 ++++++++++++------------
 arch/x86/kernel/crash_dump_32.c    |    6 +++---
 arch/x86/kvm/lapic.c               |    8 ++++----
 arch/x86/kvm/paging_tmpl.h         |    4 ++--
 arch/x86/kvm/x86.c                 |    8 ++++----
 arch/x86/lib/usercopy_32.c         |    4 ++--
 6 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 545d0ce..152232d 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1107,12 +1107,12 @@ static int __driver_rfc4106_encrypt(struct aead_request *req)
 		one_entry_in_sg = 1;
 		scatterwalk_start(&src_sg_walk, req->src);
 		scatterwalk_start(&assoc_sg_walk, req->assoc);
-		src = scatterwalk_map(&src_sg_walk, 0);
-		assoc = scatterwalk_map(&assoc_sg_walk, 0);
+		src = scatterwalk_map(&src_sg_walk);
+		assoc = scatterwalk_map(&assoc_sg_walk);
 		dst = src;
 		if (unlikely(req->src != req->dst)) {
 			scatterwalk_start(&dst_sg_walk, req->dst);
-			dst = scatterwalk_map(&dst_sg_walk, 0);
+			dst = scatterwalk_map(&dst_sg_walk);
 		}
 
 	} else {
@@ -1136,11 +1136,11 @@ static int __driver_rfc4106_encrypt(struct aead_request *req)
 	 * back to the packet. */
 	if (one_entry_in_sg) {
 		if (unlikely(req->src != req->dst)) {
-			scatterwalk_unmap(dst, 0);
+			scatterwalk_unmap(dst);
 			scatterwalk_done(&dst_sg_walk, 0, 0);
 		}
-		scatterwalk_unmap(src, 0);
-		scatterwalk_unmap(assoc, 0);
+		scatterwalk_unmap(src);
+		scatterwalk_unmap(assoc);
 		scatterwalk_done(&src_sg_walk, 0, 0);
 		scatterwalk_done(&assoc_sg_walk, 0, 0);
 	} else {
@@ -1189,12 +1189,12 @@ static int __driver_rfc4106_decrypt(struct aead_request *req)
 		one_entry_in_sg = 1;
 		scatterwalk_start(&src_sg_walk, req->src);
 		scatterwalk_start(&assoc_sg_walk, req->assoc);
-		src = scatterwalk_map(&src_sg_walk, 0);
-		assoc = scatterwalk_map(&assoc_sg_walk, 0);
+		src = scatterwalk_map(&src_sg_walk);
+		assoc = scatterwalk_map(&assoc_sg_walk);
 		dst = src;
 		if (unlikely(req->src != req->dst)) {
 			scatterwalk_start(&dst_sg_walk, req->dst);
-			dst = scatterwalk_map(&dst_sg_walk, 0);
+			dst = scatterwalk_map(&dst_sg_walk);
 		}
 
 	} else {
@@ -1219,11 +1219,11 @@ static int __driver_rfc4106_decrypt(struct aead_request *req)
 
 	if (one_entry_in_sg) {
 		if (unlikely(req->src != req->dst)) {
-			scatterwalk_unmap(dst, 0);
+			scatterwalk_unmap(dst);
 			scatterwalk_done(&dst_sg_walk, 0, 0);
 		}
-		scatterwalk_unmap(src, 0);
-		scatterwalk_unmap(assoc, 0);
+		scatterwalk_unmap(src);
+		scatterwalk_unmap(assoc);
 		scatterwalk_done(&src_sg_walk, 0, 0);
 		scatterwalk_done(&assoc_sg_walk, 0, 0);
 	} else {
diff --git a/arch/x86/kernel/crash_dump_32.c b/arch/x86/kernel/crash_dump_32.c
index 642f75a..11891ca 100644
--- a/arch/x86/kernel/crash_dump_32.c
+++ b/arch/x86/kernel/crash_dump_32.c
@@ -62,16 +62,16 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 
 	if (!userbuf) {
 		memcpy(buf, (vaddr + offset), csize);
-		kunmap_atomic(vaddr, KM_PTE0);
+		kunmap_atomic(vaddr);
 	} else {
 		if (!kdump_buf_page) {
 			printk(KERN_WARNING "Kdump: Kdump buffer page not"
 				" allocated\n");
-			kunmap_atomic(vaddr, KM_PTE0);
+			kunmap_atomic(vaddr);
 			return -EFAULT;
 		}
 		copy_page(kdump_buf_page, vaddr);
-		kunmap_atomic(vaddr, KM_PTE0);
+		kunmap_atomic(vaddr);
 		if (copy_to_user(buf, (kdump_buf_page + offset), csize))
 			return -EFAULT;
 	}
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cfdc6e0..31bfc69 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1283,9 +1283,9 @@ void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
 	if (!irqchip_in_kernel(vcpu->kvm) || !vcpu->arch.apic->vapic_addr)
 		return;
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page, KM_USER0);
+	vapic = kmap_atomic(vcpu->arch.apic->vapic_page);
 	data = *(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr));
-	kunmap_atomic(vapic, KM_USER0);
+	kunmap_atomic(vapic);
 
 	apic_set_tpr(vcpu->arch.apic, data & 0xff);
 }
@@ -1310,9 +1310,9 @@ void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
 		max_isr = 0;
 	data = (tpr & 0xff) | ((max_isr & 0xf0) << 8) | (max_irr << 24);
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page, KM_USER0);
+	vapic = kmap_atomic(vcpu->arch.apic->vapic_page);
 	*(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr)) = data;
-	kunmap_atomic(vapic, KM_USER0);
+	kunmap_atomic(vapic);
 }
 
 void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 1561028..df5a703 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -92,9 +92,9 @@ static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	if (unlikely(npages != 1))
 		return -EFAULT;
 
-	table = kmap_atomic(page, KM_USER0);
+	table = kmap_atomic(page);
 	ret = CMPXCHG(&table[index], orig_pte, new_pte);
-	kunmap_atomic(table, KM_USER0);
+	kunmap_atomic(table);
 
 	kvm_release_page_dirty(page);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cbfc06..bb4fd26 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1162,12 +1162,12 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	 */
 	vcpu->hv_clock.version += 2;
 
-	shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
+	shared_kaddr = kmap_atomic(vcpu->time_page);
 
 	memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
 	       sizeof(vcpu->hv_clock));
 
-	kunmap_atomic(shared_kaddr, KM_USER0);
+	kunmap_atomic(shared_kaddr);
 
 	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
 	return 0;
@@ -3848,7 +3848,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 		goto emul_write;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	kaddr += offset_in_page(gpa);
 	switch (bytes) {
 	case 1:
@@ -3866,7 +3866,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	default:
 		BUG();
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	kvm_release_page_dirty(page);
 
 	if (!exchanged)
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index e218d5d..d9b094c 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -760,9 +760,9 @@ survive:
 				break;
 			}
 
-			maddr = kmap_atomic(pg, KM_USER0);
+			maddr = kmap_atomic(pg);
 			memcpy(maddr + offset, from, len);
-			kunmap_atomic(maddr, KM_USER0);
+			kunmap_atomic(maddr);
 			set_page_dirty_lock(pg);
 			put_page(pg);
 			up_read(&current->mm->mmap_sem);
-- 
1.7.7.6

