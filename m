Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab1CDK7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:59:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53334 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1CDK7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:59:05 -0500
Message-ID: <4D70C630.1080100@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 19:00:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 6/10] KVM: MMU: don not record gfn in kvm_mmu_pte_write
References: <4D70C569.1030107@cn.fujitsu.com>
In-Reply-To: <4D70C569.1030107@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:57:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:57:54,
	Serialize complete at 2011-03-04 18:57:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to record the gfn to verifier the pte has the same mode as
current vcpu, it's because we only speculatively update the pte only
if the pte and vcpu have the same mode

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/mmu.c              |    6 ++----
 arch/x86/kvm/paging_tmpl.h      |    2 --
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 37bd730..f08314f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -336,7 +336,6 @@ struct kvm_vcpu_arch {
 	gfn_t last_pte_gfn;
 
 	struct {
-		gfn_t gfn;	/* presumed gfn during guest pte update */
 		pfn_t pfn;	/* pfn corresponding to that gfn */
 		unsigned long mmu_seq;
 	} update_pte;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6e9cb35..cd35e71 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3228,7 +3228,6 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		kvm_release_pfn_clean(pfn);
 		return;
 	}
-	vcpu->arch.update_pte.gfn = gfn;
 	vcpu->arch.update_pte.pfn = pfn;
 }
 
@@ -3275,9 +3274,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	/*
 	 * Assume that the pte write on a page table of the same type
-	 * as the current vcpu paging mode.  This is nearly always true
-	 * (might be false while changing modes).  Note it is verified later
-	 * by update_pte().
+	 * as the current vcpu paging mode since we update the sptes only
+	 * when they have the same mode.
 	 */
 	if ((is_pae(vcpu) && bytes == 4) || !new) {
 		/* Handle a 32-bit guest writing two halves of a 64-bit gpte */
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6bccc24..b3862ee 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -339,8 +339,6 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
 	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
-	if (gpte_to_gfn(gpte) != vcpu->arch.update_pte.gfn)
-		return;
 	pfn = vcpu->arch.update_pte.pfn;
 	if (is_error_pfn(pfn))
 		return;
-- 
1.7.4

