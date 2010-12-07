Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab0LGCax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:30:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53180 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab0LGCaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:30:52 -0500
Message-ID: <4CFD9D6D.80404@cn.fujitsu.com>
Date: Tue, 07 Dec 2010 10:35:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 3/3] KVM: MMU: retry #PF for softmmu
References: <4CFD9D12.30709@cn.fujitsu.com>
In-Reply-To: <4CFD9D12.30709@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-07 10:30:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-07 10:30:56,
	Serialize complete at 2010-12-07 10:30:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retry #PF for softmmu only when the current vcpu has the same cr3 as the time
when #PF occurs

Changelog:
  Just compare cr3 value since It's harmless to instantiate an spte for an
  unused translation from Marcelo's comment

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    2 ++
 arch/x86/kvm/paging_tmpl.h      |   14 +++++++++-----
 arch/x86/kvm/x86.c              |    6 +++++-
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6dae67e..be49043 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -593,6 +593,7 @@ struct kvm_x86_ops {
 struct kvm_arch_async_pf {
 	u32 token;
 	gfn_t gfn;
+	unsigned long cr3;
 	bool direct_map;
 };
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 04f9033..1a953ac 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2607,9 +2607,11 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
 {
 	struct kvm_arch_async_pf arch;
+
 	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu.direct_map;
+	arch.cr3 = vcpu->arch.mmu.get_cr3(vcpu);
 
 	return kvm_setup_async_pf(vcpu, gva, gfn, &arch);
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 52b3e91..146b681 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -438,7 +438,8 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 struct guest_walker *gw,
 			 int user_fault, int write_fault, int hlevel,
-			 int *ptwrite, pfn_t pfn, bool map_writable)
+			 int *ptwrite, pfn_t pfn, bool map_writable,
+			 bool prefault)
 {
 	unsigned access = gw->pt_access;
 	struct kvm_mmu_page *sp = NULL;
@@ -512,7 +513,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access & access,
 		     user_fault, write_fault, dirty, ptwrite, it.level,
-		     gw->gfn, pfn, false, map_writable);
+		     gw->gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
 
 	return it.sptep;
@@ -568,8 +569,11 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	 */
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __func__);
-		inject_page_fault(vcpu, &walker.fault);
-		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
+		if (!prefault) {
+			inject_page_fault(vcpu, &walker.fault);
+			/* reset fork detector */
+			vcpu->arch.last_pt_write_count = 0;
+		}
 		return 0;
 	}
 
@@ -599,7 +603,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	kvm_mmu_free_some_pages(vcpu);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
-			     level, &write_pt, pfn, map_writable);
+			     level, &write_pt, pfn, map_writable, prefault);
 	(void)sptep;
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __func__,
 		 sptep, *sptep, write_pt);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ed373ba..018bb70 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6183,7 +6183,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
-	if (!vcpu->arch.mmu.direct_map || !work->arch.direct_map ||
+	if ((vcpu->arch.mmu.direct_map != work->arch.direct_map) ||
 	      is_error_page(work->page))
 		return;
 
@@ -6191,6 +6191,10 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	if (unlikely(r))
 		return;
 
+	if (!vcpu->arch.mmu.direct_map &&
+	      work->arch.cr3 != vcpu->arch.mmu.get_cr3(vcpu))
+		return;
+
 	vcpu->arch.mmu.page_fault(vcpu, work->gva, 0, true);
 }
 
-- 
1.7.0.4

