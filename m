Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2JPMHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:07:14 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37353 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab2JPMHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:07:12 -0400
Message-ID: <507D4DE7.5080708@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2012 20:07:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 1/6] KVM: MMU: fix release noslot pfn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101612-5490-0000-0000-0000024B99B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can not directly call kvm_release_pfn_clean to release the pfn
since we can meet noslot pfn which is used to cache mmio info into
spte

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c  |    3 +--
 virt/kvm/kvm_main.c |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d289fee..6f85fe0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2497,8 +2497,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		}
 	}

-	if (!is_error_pfn(pfn))
-		kvm_release_pfn_clean(pfn);
+	kvm_release_pfn_clean(pfn);
 }

 static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c353b45..a65bc02 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1322,9 +1322,7 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);

 void kvm_release_pfn_clean(pfn_t pfn)
 {
-	WARN_ON(is_error_pfn(pfn));
-
-	if (!kvm_is_mmio_pfn(pfn))
+	if (!is_error_pfn(pfn) && !kvm_is_mmio_pfn(pfn))
 		put_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
-- 
1.7.7.6

