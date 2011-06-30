Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab1F3IRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:17:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65223 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758530Ab1F3IRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:17:48 -0400
Message-ID: <4E0C319D.7000207@cn.fujitsu.com>
Date: Thu, 30 Jun 2011 16:19:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 02/19] KVM: MMU: do not update slot bitmap if spte is nonpresent
References: <4E0C3178.2080603@cn.fujitsu.com>
In-Reply-To: <4E0C3178.2080603@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:17:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:17:12,
	Serialize complete at 2011-06-30 16:17:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set slot bitmap only if the spte is present

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 03323dc..02c839f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -743,9 +743,6 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	struct kvm_mmu_page *sp;
 	unsigned long *rmapp;
 
-	if (!is_rmap_spte(*spte))
-		return 0;
-
 	sp = page_header(__pa(spte));
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
@@ -2087,11 +2084,13 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (!was_rmapped && is_large_pte(*sptep))
 		++vcpu->kvm->stat.lpages;
 
-	page_header_update_slot(vcpu->kvm, sptep, gfn);
-	if (!was_rmapped) {
-		rmap_count = rmap_add(vcpu, sptep, gfn);
-		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-			rmap_recycle(vcpu, sptep, gfn);
+	if (is_shadow_present_pte(*sptep)) {
+		page_header_update_slot(vcpu->kvm, sptep, gfn);
+		if (!was_rmapped) {
+			rmap_count = rmap_add(vcpu, sptep, gfn);
+			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
+				rmap_recycle(vcpu, sptep, gfn);
+		}
 	}
 	kvm_release_pfn_clean(pfn);
 	if (speculative) {
-- 
1.7.5.4

