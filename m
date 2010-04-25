Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab0DYHDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 03:03:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63552 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab0DYHDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 03:03:08 -0400
Message-ID: <4BD3E870.60000@cn.fujitsu.com>
Date: Sun, 25 Apr 2010 15:00:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/10] KVM MMU: fix for calculating gpa in invlpg code
References: <4BD3E306.4020202@cn.fujitsu.com>
In-Reply-To: <4BD3E306.4020202@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the guest is 32-bit, we should use 'quadrant' to adjust gpa
offset

Changlog v2:
- when level is PT_DIRECTORY_LEVEL, the 'offset' should be
  'role.quadrant << 8', thanks Avi for point it out

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index d0cc07e..83cc72f 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -478,9 +478,18 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		    ((level == PT_DIRECTORY_LEVEL && is_large_pte(*sptep))) ||
 		    ((level == PT_PDPE_LEVEL && is_large_pte(*sptep)))) {
 			struct kvm_mmu_page *sp = page_header(__pa(sptep));
-
+			int offset = 0;
+
+			if (PTTYPE == 32) {
+				if (level == PT_DIRECTORY_LEVEL)
+					offset = PAGE_SHIFT - 4;
+				else
+					offset = PT64_LEVEL_BITS;
+				offset = sp->role.quadrant << offset;
+			}
 			pte_gpa = (sp->gfn << PAGE_SHIFT);
-			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
+			pte_gpa += (sptep - sp->spt + offset) *
+					sizeof(pt_element_t);
 
 			if (is_shadow_present_pte(*sptep)) {
 				rmap_remove(vcpu->kvm, sptep);
-- 
1.6.1.2


