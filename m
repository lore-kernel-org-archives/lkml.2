Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0FDN6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:58:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63070 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab0FDN6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:58:08 -0400
Message-ID: <4C09059E.2060205@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 21:54:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 4/7] KVM: MMU: don't get free page number in the loop
References: <4C090511.60206@cn.fujitsu.com>
In-Reply-To: <4C090511.60206@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the later patch, we will modify sp's zapping way like below:

	kvm_mmu_prepare_zap_page A
	kvm_mmu_prepare_zap_page B
	kvm_mmu_prepare_zap_page C
	....
	kvm_mmu_commit_zap_page

[ zaped multiple sps only need to call kvm_mmu_commit_zap_page once ]	

In __kvm_mmu_free_some_pages() function, the free page number is
getted form 'vcpu->kvm->arch.n_free_mmu_pages' in loop, it will
hinders us to apply kvm_mmu_prepare_zap_page() and kvm_mmu_commit_zap_page()
since kvm_mmu_prepare_zap_page() not free sp.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a64c0e0..77bc4ba 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2861,13 +2861,16 @@ EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-	while (vcpu->kvm->arch.n_free_mmu_pages < KVM_REFILL_PAGES &&
+	int free_pages;
+
+	free_pages = vcpu->kvm->arch.n_free_mmu_pages;
+	while (free_pages < KVM_REFILL_PAGES &&
 	       !list_empty(&vcpu->kvm->arch.active_mmu_pages)) {
 		struct kvm_mmu_page *sp;
 
 		sp = container_of(vcpu->kvm->arch.active_mmu_pages.prev,
 				  struct kvm_mmu_page, link);
-		kvm_mmu_zap_page(vcpu->kvm, sp);
+		free_pages += kvm_mmu_zap_page(vcpu->kvm, sp);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
 }
-- 
1.6.1.2


