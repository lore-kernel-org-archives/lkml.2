Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0KLG7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 01:59:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63256 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab0KLG7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:59:47 -0500
Message-ID: <4CDCE367.1020207@cn.fujitsu.com>
Date: Fri, 12 Nov 2010 14:49:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 3/5] KVM: MMU: support apf for nonpaing guest
References: <4CDCE2B0.7000601@cn.fujitsu.com>
In-Reply-To: <4CDCE2B0.7000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 14:45:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-12 15:00:12,
	Serialize complete at 2010-11-12 15:00:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's support apf for nonpaing guest

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f3fad4f..5ee5b97 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2286,7 +2286,11 @@ static int kvm_handle_bad_page(struct kvm *kvm, gfn_t gfn, pfn_t pfn)
 	return 1;
 }
 
-static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
+static bool try_async_pf(struct kvm_vcpu *vcpu, bool no_apf, gfn_t gfn,
+			 gva_t gva, pfn_t *pfn, bool write, bool *writable);
+
+static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
+			 bool no_apf)
 {
 	int r;
 	int level;
@@ -2307,7 +2311,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
-	pfn = gfn_to_pfn_prot(vcpu->kvm, gfn, write, &map_writable);
+
+	if (try_async_pf(vcpu, no_apf, gfn, v, &pfn, write, &map_writable))
+		return 0;
 
 	/* mmio */
 	if (is_error_pfn(pfn))
@@ -2594,7 +2600,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	gfn = gva >> PAGE_SHIFT;
 
 	return nonpaging_map(vcpu, gva & PAGE_MASK,
-			     error_code & PFERR_WRITE_MASK, gfn);
+			     error_code & PFERR_WRITE_MASK, gfn, no_apf);
 }
 
 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
-- 
1.7.0.4

