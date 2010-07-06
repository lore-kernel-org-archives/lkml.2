Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0GFKsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:48:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55776 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab0GFKse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:48:34 -0400
Message-ID: <4C330918.6040709@cn.fujitsu.com>
Date: Tue, 06 Jul 2010 18:44:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v5 1/9] KVM: MMU: fix forgot reserved bits check in speculative
 path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the speculative path, we should check guest pte's reserved bits just as
the real processor does

Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    3 +++
 arch/x86/kvm/paging_tmpl.h |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 104756b..3dcd55d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2781,6 +2781,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		break;
 	}
 
+	if (is_rsvd_bits_set(vcpu, gentry, PT_PAGE_TABLE_LEVEL))
+		gentry = 0;
+
 	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index dfb2720..19f0077 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -628,7 +628,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
 
 		if (kvm_read_guest_atomic(vcpu->kvm, pte_gpa, &gpte,
-					  sizeof(pt_element_t)))
+					  sizeof(pt_element_t)) ||
+		      is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL))
 			return -EINVAL;
 
 		gfn = gpte_to_gfn(gpte);
-- 
1.6.1.2

