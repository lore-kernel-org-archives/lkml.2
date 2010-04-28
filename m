Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab0D1D5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 23:57:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57889 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab0D1D5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 23:57:53 -0400
Message-ID: <4BD7B184.1080808@cn.fujitsu.com>
Date: Wed, 28 Apr 2010 11:54:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/10] KVM MMU: fix for calculating gpa in invlpg code
References: <4BD7AE34.5000408@cn.fujitsu.com>
In-Reply-To: <4BD7AE34.5000408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the guest is 32-bit, we should use 'quadrant' to adjust gpa
offset

Changelog v3:
- use smart way to fix this bug address Avi's suggestion

Changelog v2:
- when level is PT_DIRECTORY_LEVEL, the 'offset' should be
  'role.quadrant << 8', thanks Avi for point it out

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index d0cc07e..3464fdb 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -478,8 +478,13 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		    ((level == PT_DIRECTORY_LEVEL && is_large_pte(*sptep))) ||
 		    ((level == PT_PDPE_LEVEL && is_large_pte(*sptep)))) {
 			struct kvm_mmu_page *sp = page_header(__pa(sptep));
+			int offset, shift;
 
-			pte_gpa = (sp->gfn << PAGE_SHIFT);
+			shift = PAGE_SHIFT -
+				  (PT_LEVEL_BITS - PT64_LEVEL_BITS) * level;
+			offset = sp->role.quadrant << shift;
+
+			pte_gpa = (sp->gfn << PAGE_SHIFT) + offset;
 			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
 
 			if (is_shadow_present_pte(*sptep)) {
-- 
1.6.1.2



