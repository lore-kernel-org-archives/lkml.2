Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab0KLKa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:30:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60231 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab0KLKaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:30:24 -0500
Message-ID: <4CDD1841.9010300@cn.fujitsu.com>
Date: Fri, 12 Nov 2010 18:34:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/4] KVM: MMU: notrap it if gpte's reserved is set
References: <4CDD173E.8010706@cn.fujitsu.com>
In-Reply-To: <4CDD173E.8010706@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 18:30:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 18:30:48,
	Serialize complete at 2010-11-12 18:30:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can past the page fault to guest directly if gpte's reserved
is set

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 291342d..952357a 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -760,6 +760,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		pt_element_t gpte;
 		gpa_t pte_gpa;
 		gfn_t gfn;
+		bool gpte_invalid;
 
 		if (!is_shadow_present_pte(sp->spt[i]))
 			continue;
@@ -771,12 +772,13 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			return -EINVAL;
 
 		gfn = gpte_to_gfn(gpte);
-		if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL)
-		      || gfn != sp->gfns[i] || !is_present_gpte(gpte)
-		      || !(gpte & PT_ACCESSED_MASK)) {
+		gpte_invalid = is_present_gpte(gpte) ||
+		   is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL);
+		if (gpte_invalid || gfn != sp->gfns[i] ||
+		      !(gpte & PT_ACCESSED_MASK)) {
 			u64 nonpresent;
 
-			if (is_present_gpte(gpte) || !clear_unsync)
+			if (gpte_invalid || !clear_unsync)
 				nonpresent = shadow_trap_nonpresent_pte;
 			else
 				nonpresent = shadow_notrap_nonpresent_pte;
-- 
1.7.0.4

