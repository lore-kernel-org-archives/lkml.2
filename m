Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0EOK5F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 06:57:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab0EOK5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 06:57:02 -0400
Message-ID: <4BEE7D2F.8080201@cn.fujitsu.com>
Date: Sat, 15 May 2010 18:53:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 3/3] KVM: MMU: only update unsync page in invlpg path
References: <4BEE7CAC.5020603@cn.fujitsu.com> <4BEE7CF2.3080502@cn.fujitsu.com>
In-Reply-To: <4BEE7CF2.3080502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only unsync pages need updated at invlpg time since other shadow
pages are write-protected

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 71c73fe..dfbc8c7 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -463,6 +463,7 @@ out_unlock:
 static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_mmu_page *sp;
 	gpa_t pte_gpa = -1;
 	int level;
 	u64 *sptep;
@@ -474,10 +475,13 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		level = iterator.level;
 		sptep = iterator.sptep;
 
+		sp = page_header(__pa(sptep));
 		if (is_last_spte(*sptep, level)) {
-			struct kvm_mmu_page *sp = page_header(__pa(sptep));
 			int offset, shift;
 
+			if (!sp->unsync)
+				break;
+
 			shift = PAGE_SHIFT -
 				  (PT_LEVEL_BITS - PT64_LEVEL_BITS) * level;
 			offset = sp->role.quadrant << shift;
@@ -495,7 +499,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 			break;
 		}
 
-		if (!is_shadow_present_pte(*sptep))
+		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
 			break;
 	}
 
-- 
1.6.1.2


