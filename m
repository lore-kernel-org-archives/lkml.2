Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab0KQEHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:07:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62351 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab0KQEH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:07:28 -0500
Message-ID: <4CE355FD.70804@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 12:11:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 3/6] KVM: MMU: don't mark spte notrap if reserved bit set
References: <4CE355A0.6020907@cn.fujitsu.com>
In-Reply-To: <4CE355A0.6020907@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:07:45,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:07:46,
	Serialize complete at 2010-11-17 12:07:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If reserved bit is set, we need inject the #PF with PFEC.RSVD=1,
but shadow_notrap_nonpresent_pte injects #PF with PFEC.RSVD=0 only

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 58b4d9a..ca0e5e8 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -395,8 +395,10 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 
 		gpte = gptep[i];
 
-		if (!is_present_gpte(gpte) ||
-		      is_rsvd_bits_set(mmu, gpte, PT_PAGE_TABLE_LEVEL)) {
+		if (is_rsvd_bits_set(mmu, gpte, PT_PAGE_TABLE_LEVEL))
+			continue;
+
+		if (!is_present_gpte(gpte)) {
 			if (!sp->unsync)
 				__set_spte(spte, shadow_notrap_nonpresent_pte);
 			continue;
@@ -760,6 +762,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		pt_element_t gpte;
 		gpa_t pte_gpa;
 		gfn_t gfn;
+		bool rsvd_bits_set;
 
 		if (!is_shadow_present_pte(sp->spt[i]))
 			continue;
@@ -771,12 +774,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			return -EINVAL;
 
 		gfn = gpte_to_gfn(gpte);
-		if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL)
-		      || gfn != sp->gfns[i] || !is_present_gpte(gpte)
-		      || !(gpte & PT_ACCESSED_MASK)) {
+		rsvd_bits_set = is_rsvd_bits_set(&vcpu->arch.mmu, gpte,
+						 PT_PAGE_TABLE_LEVEL);
+		if (rsvd_bits_set || gfn != sp->gfns[i] ||
+		      !is_present_gpte(gpte) || !(gpte & PT_ACCESSED_MASK)) {
 			u64 nonpresent;
 
-			if (is_present_gpte(gpte) || !clear_unsync)
+			if (rsvd_bits_set || is_present_gpte(gpte) ||
+			      !clear_unsync)
 				nonpresent = shadow_trap_nonpresent_pte;
 			else
 				nonpresent = shadow_notrap_nonpresent_pte;
-- 
1.7.0.4

