Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0DVGP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:15:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61507 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab0DVGPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:15:23 -0400
Message-ID: <4BCFE8C2.9080102@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 14:12:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/10] KVM MMU: fix for calculating gpa in invlpg code
References: <4BCFE3D5.5070105@cn.fujitsu.com>
In-Reply-To: <4BCFE3D5.5070105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the guest is 32-bit, we should use 'quadrant' to adjust gpa
offset

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index d0cc07e..46d80d6 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -478,9 +478,14 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		    ((level == PT_DIRECTORY_LEVEL && is_large_pte(*sptep))) ||
 		    ((level == PT_PDPE_LEVEL && is_large_pte(*sptep)))) {
 			struct kvm_mmu_page *sp = page_header(__pa(sptep));
+			int offset = 0;
+
+			if (PTTYPE == 32)
+				offset = sp->role.quadrant << PT64_LEVEL_BITS;;
 
 			pte_gpa = (sp->gfn << PAGE_SHIFT);
-			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
+			pte_gpa += (sptep - sp->spt + offset) *
+					sizeof(pt_element_t);
 
 			if (is_shadow_present_pte(*sptep)) {
 				rmap_remove(vcpu->kvm, sptep);
-- 
1.6.1.2


