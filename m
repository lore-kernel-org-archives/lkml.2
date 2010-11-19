Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab0KSI6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:58:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55653 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0KSI6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:58:21 -0500
Message-ID: <4CE63D2B.7090909@cn.fujitsu.com>
Date: Fri, 19 Nov 2010 17:02:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/6] KVM: MMU: don't drop spte if overwrite it from W to
 RO
References: <4CE63CF4.80502@cn.fujitsu.com>
In-Reply-To: <4CE63CF4.80502@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-19 16:58:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-19 16:58:40,
	Serialize complete at 2010-11-19 16:58:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We just need flush tlb if overwrite a writable spte with a read-only one.

And we should move this operation to set_spte() for sync_page path

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bdb9fa9..59b5bd2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1960,7 +1960,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
 		    bool can_unsync, bool reset_host_protection)
 {
-	u64 spte;
+	u64 spte, entry = *sptep;
 	int ret = 0;
 
 	/*
@@ -2031,6 +2031,14 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 set_pte:
 	update_spte(sptep, spte);
+	/*
+	 * If we overwrite a writable spte with a read-only one we
+	 * should flush remote TLBs. Otherwise rmap_write_protect
+	 * will find a read-only spte, even though the writable spte
+	 * might be cached on a CPU's TLB.
+	 */
+	if (is_writable_pte(entry) && !is_writable_pte(*sptep))
+		kvm_flush_remote_tlbs(vcpu->kvm);
 done:
 	return ret;
 }
@@ -2069,16 +2077,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				 spte_to_pfn(*sptep), pfn);
 			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
 			kvm_flush_remote_tlbs(vcpu->kvm);
-		/*
-		 * If we overwrite a writable spte with a read-only one,
-		 * drop it and flush remote TLBs. Otherwise rmap_write_protect
-		 * will find a read-only spte, even though the writable spte
-		 * might be cached on a CPU's TLB.
-		 */
-		} else if (is_writable_pte(*sptep) &&
-			  (!(pte_access & ACC_WRITE_MASK) || !dirty)) {
-			drop_spte(vcpu->kvm, sptep, shadow_trap_nonpresent_pte);
-			kvm_flush_remote_tlbs(vcpu->kvm);
 		} else
 			was_rmapped = 1;
 	}
-- 
1.7.0.4

