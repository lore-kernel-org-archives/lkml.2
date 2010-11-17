Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab0KQEJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:09:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56929 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759680Ab0KQEJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:09:00 -0500
Message-ID: <4CE3565D.4080004@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 12:13:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 5/6] KVM: MMU: remove 'clear_unsync' parameter
References: <4CE355A0.6020907@cn.fujitsu.com>
In-Reply-To: <4CE355A0.6020907@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:09:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 12:09:21,
	Serialize complete at 2010-11-17 12:09:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove it since we can jude it by sp->unsync

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |    8 ++++----
 arch/x86/kvm/paging_tmpl.h      |    5 ++---
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b04c0fa..ce8c1e4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -250,7 +250,7 @@ struct kvm_mmu {
 	void (*prefetch_page)(struct kvm_vcpu *vcpu,
 			      struct kvm_mmu_page *page);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
-			 struct kvm_mmu_page *sp, bool clear_unsync);
+			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva);
 	hpa_t root_hpa;
 	int root_level;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c4531a3..0668f4b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1162,7 +1162,7 @@ static void nonpaging_prefetch_page(struct kvm_vcpu *vcpu,
 }
 
 static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
-			       struct kvm_mmu_page *sp, bool clear_unsync)
+			       struct kvm_mmu_page *sp)
 {
 	return 1;
 }
@@ -1292,7 +1292,7 @@ static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (clear_unsync)
 		kvm_unlink_unsync_page(vcpu->kvm, sp);
 
-	if (vcpu->arch.mmu.sync_page(vcpu, sp, clear_unsync)) {
+	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
 		return 1;
 	}
@@ -1333,12 +1333,12 @@ static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 			continue;
 
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
+		kvm_unlink_unsync_page(vcpu->kvm, s);
 		if ((s->role.cr4_pae != !!is_pae(vcpu)) ||
-			(vcpu->arch.mmu.sync_page(vcpu, s, true))) {
+			(vcpu->arch.mmu.sync_page(vcpu, s))) {
 			kvm_mmu_prepare_zap_page(vcpu->kvm, s, &invalid_list);
 			continue;
 		}
-		kvm_unlink_unsync_page(vcpu->kvm, s);
 		flush = true;
 	}
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 57619ed..60f00db 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -740,8 +740,7 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
  * - The spte has a reference to the struct page, so the pfn for a given gfn
  *   can't change unless all sptes pointing to it are nuked first.
  */
-static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			    bool clear_unsync)
+static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
 	int i, offset, nr_present;
 	bool host_writable;
@@ -781,7 +780,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			u64 nonpresent;
 
 			if (rsvd_bits_set || is_present_gpte(gpte) ||
-			      !clear_unsync)
+			      sp->unsync)
 				nonpresent = shadow_trap_nonpresent_pte;
 			else
 				nonpresent = shadow_notrap_nonpresent_pte;
-- 
1.7.0.4

