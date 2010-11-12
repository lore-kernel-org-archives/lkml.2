Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab0KLK0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:26:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58915 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab0KLK0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:26:04 -0500
Message-ID: <4CDD173E.8010706@cn.fujitsu.com>
Date: Fri, 12 Nov 2010 18:30:22 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/4] KVM: MMU: don't drop spte if overwrite it from W to RO
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 18:26:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 18:26:30,
	Serialize complete at 2010-11-12 18:26:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We just need flush tlb if overwrite a writable spte with a read-only one

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4b6d54c..1a93ab4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2044,6 +2044,15 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (pte_access & ACC_WRITE_MASK)
 		mark_page_dirty(vcpu->kvm, gfn);
 
+	/*
+	 * If we overwrite a writable spte with a read-only one,
+	 * flush remote TLBs. Otherwise rmap_write_protect will
+	 * find a read-only spte, even though the writable spte
+	 * might be cached on a CPU's TLB.
+	 */
+	else if (is_writable_pte(*sptep))
+		ret = 1;
+
 set_pte:
 	update_spte(sptep, spte);
 done:
@@ -2084,16 +2093,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
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
