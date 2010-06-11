Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347Ab0FKNfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:35:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56614 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760232Ab0FKNfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:35:12 -0400
Message-ID: <4C123ABA.3000601@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 21:31:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 4/7] KVM: MMU: don't mark pte notrap if it's just sync transient
References: <4C1239EE.3090904@cn.fujitsu.com>
In-Reply-To: <4C1239EE.3090904@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the sync-sp just sync transient, don't mark its pte notrap

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |   11 ++++-------
 arch/x86/kvm/paging_tmpl.h      |    5 +++--
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 91631b8..fb72bd7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -241,7 +241,7 @@ struct kvm_mmu {
 	void (*prefetch_page)(struct kvm_vcpu *vcpu,
 			      struct kvm_mmu_page *page);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
-			 struct kvm_mmu_page *sp);
+			 struct kvm_mmu_page *sp, bool clear_unsync);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva);
 	hpa_t root_hpa;
 	int root_level;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2ffd673..18c14c5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1103,7 +1103,7 @@ static void nonpaging_prefetch_page(struct kvm_vcpu *vcpu,
 }
 
 static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
-			       struct kvm_mmu_page *sp)
+			       struct kvm_mmu_page *sp, bool clear_unsync)
 {
 	return 1;
 }
@@ -1228,7 +1228,7 @@ static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (clear_unsync)
 		kvm_unlink_unsync_page(vcpu->kvm, sp);
 
-	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
+	if (vcpu->arch.mmu.sync_page(vcpu, sp, clear_unsync)) {
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
 		return 1;
 	}
@@ -1237,7 +1237,6 @@ static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return 0;
 }
 
-static void mmu_convert_notrap(struct kvm_mmu_page *sp);
 static int kvm_sync_page_transient(struct kvm_vcpu *vcpu,
 				   struct kvm_mmu_page *sp)
 {
@@ -1245,9 +1244,7 @@ static int kvm_sync_page_transient(struct kvm_vcpu *vcpu,
 	int ret;
 
 	ret = __kvm_sync_page(vcpu, sp, &invalid_list, false);
-	if (!ret)
-		mmu_convert_notrap(sp);
-	else
+	if (ret)
 		kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 
 	return ret;
@@ -1273,7 +1270,7 @@ static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
 		if ((s->role.cr4_pae != !!is_pae(vcpu)) ||
-			(vcpu->arch.mmu.sync_page(vcpu, s))) {
+			(vcpu->arch.mmu.sync_page(vcpu, s, true))) {
 			kvm_mmu_prepare_zap_page(vcpu->kvm, s, &invalid_list);
 			continue;
 		}
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 876e705..3ebc5a0 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -577,7 +577,8 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
  *   can't change unless all sptes pointing to it are nuked first.
  * - Alias changes zap the entire shadow cache.
  */
-static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			    bool clear_unsync)
 {
 	int i, offset, nr_present;
 	bool reset_host_protection;
@@ -614,7 +615,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			u64 nonpresent;
 
 			rmap_remove(vcpu->kvm, &sp->spt[i]);
-			if (is_present_gpte(gpte))
+			if (is_present_gpte(gpte) || !clear_unsync)
 				nonpresent = shadow_trap_nonpresent_pte;
 			else
 				nonpresent = shadow_notrap_nonpresent_pte;
-- 
1.6.1.2


