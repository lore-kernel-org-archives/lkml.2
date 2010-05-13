Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab0EMCLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:11:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49789 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab0EMCLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:11:21 -0400
Message-ID: <4BEB5F08.3010604@cn.fujitsu.com>
Date: Thu, 13 May 2010 10:08:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] KVM MMU: fix for got gfn when sync shadow pages
References: <4BEB5E8A.7030606@cn.fujitsu.com> <4BEB5EC4.6070802@cn.fujitsu.com>
In-Reply-To: <4BEB5EC4.6070802@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sp->gfns[] are not mapping gfn since it has cooked by unalias_gfn()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 11d8a16..71c73fe 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -588,7 +588,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		unsigned pte_access;
 		pt_element_t gpte;
 		gpa_t pte_gpa;
-		gfn_t gfn = sp->gfns[i];
+		gfn_t gfn;
 
 		if (!is_shadow_present_pte(sp->spt[i]))
 			continue;
@@ -599,8 +599,9 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 					  sizeof(pt_element_t)))
 			return -EINVAL;
 
-		if (gpte_to_gfn(gpte) != gfn || !is_present_gpte(gpte) ||
-		    !(gpte & PT_ACCESSED_MASK)) {
+		gfn = gpte_to_gfn(gpte);
+		if (unalias_gfn(vcpu->kvm, gfn) != sp->gfns[i] ||
+		      !is_present_gpte(gpte) || !(gpte & PT_ACCESSED_MASK)) {
 			u64 nonpresent;
 
 			rmap_remove(vcpu->kvm, &sp->spt[i]);
-- 
1.6.1.2


