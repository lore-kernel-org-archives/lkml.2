Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0ITOQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:16:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65197 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab0ITOQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:16:30 -0400
Message-ID: <4C976DBA.4080909@cn.fujitsu.com>
Date: Mon, 20 Sep 2010 22:20:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/4] KVM: MMU: move reserved bits check to FNAME(update_pte)
References: <4C976D48.6020400@cn.fujitsu.com>
In-Reply-To: <4C976D48.6020400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move reserved bits check then invlpg path can use it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> 
---
 arch/x86/kvm/mmu.c         |    3 ---
 arch/x86/kvm/paging_tmpl.h |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0ccb67f..9d7da39 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3003,9 +3003,6 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 		return;
         }
 
-	if (is_rsvd_bits_set(&vcpu->arch.mmu, *(u64 *)new, PT_PAGE_TABLE_LEVEL))
-		return;
-
 	++vcpu->kvm->stat.mmu_pte_updated;
 	if (!sp->role.cr4_pae)
 		paging32_update_pte(vcpu, sp, spte, new);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ab9a594..e540118 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -311,6 +311,10 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	u64 new_spte;
 
 	gpte = *(const pt_element_t *)pte;
+
+	if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
+		return;
+
 	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
 		if (!is_present_gpte(gpte)) {
 			if (sp->unsync)
-- 
1.7.0.4

