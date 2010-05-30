Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0E3Mpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 08:45:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51709 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab0E3Mpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 08:45:41 -0400
Message-ID: <4C025D1F.3060102@cn.fujitsu.com>
Date: Sun, 30 May 2010 20:42:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 5/5] KVM: MMU: reduce remote tlb flush in kvm_mmu_pte_write()
References: <4C025BDC.1020304@cn.fujitsu.com>
In-Reply-To: <4C025BDC.1020304@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

collect remote tlb flush in kvm_mmu_pte_write() path

Have tested with xp/vista64, fedora12 32/64 guests, and it not broken

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index be75cba..cbd8d9c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2629,11 +2629,15 @@ static bool need_remote_flush(u64 old, u64 new)
 	return (old & ~new & PT64_PERM_MASK) != 0;
 }
 
-static void mmu_pte_write_flush_tlb(struct kvm_vcpu *vcpu, u64 old, u64 new)
+static void mmu_pte_write_flush_tlb(struct kvm_vcpu *vcpu, bool zap_page,
+				    bool remote_flush, bool local_flush)
 {
-	if (need_remote_flush(old, new))
+	if (zap_page)
+		return;
+
+	if (remote_flush)
 		kvm_flush_remote_tlbs(vcpu->kvm);
-	else
+	else if (local_flush)
 		kvm_mmu_flush_tlb(vcpu);
 }
 
@@ -2697,6 +2701,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int npte;
 	int r;
 	int invlpg_counter;
+	bool remote_flush, local_flush, zap_page;
+
+	zap_page = remote_flush = local_flush = false;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
 
@@ -2770,6 +2777,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			 */
 			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
 				 gpa, bytes, sp->role.word);
+			zap_page = true;
 			kvm_mmu_prepare_zap_page(vcpu->kvm, sp);
 			++vcpu->kvm->stat.mmu_flooded;
 			continue;
@@ -2794,16 +2802,20 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			if (quadrant != sp->role.quadrant)
 				continue;
 		}
+
+		local_flush = true;
 		spte = &sp->spt[page_offset / sizeof(*spte)];
 		while (npte--) {
 			entry = *spte;
 			mmu_pte_write_zap_pte(vcpu, sp, spte);
 			if (gentry)
 				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
-			mmu_pte_write_flush_tlb(vcpu, entry, *spte);
+			if (!remote_flush && need_remote_flush(entry, *spte))
+				remote_flush = true;
 			++spte;
 		}
 	}
+	mmu_pte_write_flush_tlb(vcpu, zap_page, remote_flush, local_flush);
 	kvm_mmu_commit_zap_page(vcpu->kvm);
 	kvm_mmu_audit(vcpu, "post pte write");
 	spin_unlock(&vcpu->kvm->mmu_lock);
-- 
1.6.1.2

