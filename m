Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2GCGby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:31:54 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44359 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2GCGbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:31:52 -0400
Message-ID: <4FF291CF.2030100@linux.vnet.ibm.com>
Date: Tue, 03 Jul 2012 14:31:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: MMU: fix shrinking page from the empty mmu
References: <4FF291A5.5090803@linux.vnet.ibm.com>
In-Reply-To: <4FF291A5.5090803@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12070220-9264-0000-0000-000001D3B449
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

 [ 3190.059226] BUG: unable to handle kernel NULL pointer dereference at           (null)
 [ 3190.062224] IP: [<ffffffffa02aac66>] mmu_page_zap_pte+0x10/0xa7 [kvm]
 [ 3190.063760] PGD 104f50067 PUD 112bea067 PMD 0
 [ 3190.065309] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
 [ 3190.066860] CPU 1
[ ...... ]
 [ 3190.109629] Call Trace:
 [ 3190.111342]  [<ffffffffa02aada6>] kvm_mmu_prepare_zap_page+0xa9/0x1fc [kvm]
 [ 3190.113091]  [<ffffffffa02ab2f5>] mmu_shrink+0x11f/0x1f3 [kvm]
 [ 3190.114844]  [<ffffffffa02ab25d>] ? mmu_shrink+0x87/0x1f3 [kvm]
 [ 3190.116598]  [<ffffffff81150c9d>] ? prune_super+0x142/0x154
 [ 3190.118333]  [<ffffffff8110a4f4>] ? shrink_slab+0x39/0x31e
 [ 3190.120043]  [<ffffffff8110a687>] shrink_slab+0x1cc/0x31e
 [ 3190.121718]  [<ffffffff8110ca1d>] do_try_to_free_pages

This is caused by shrinking page from the empty mmu, although we have
checked n_used_mmu_pages, it is useless since the check is out of mmu-lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24dd43d..cac3408 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3936,6 +3936,9 @@ static void kvm_mmu_remove_some_alloc_mmu_pages(struct kvm *kvm,
 {
 	struct kvm_mmu_page *page;

+	if (list_empty(&kvm->arch.active_mmu_pages))
+		return;
+
 	page = container_of(kvm->arch.active_mmu_pages.prev,
 			    struct kvm_mmu_page, link);
 	kvm_mmu_prepare_zap_page(kvm, page, invalid_list);
-- 
1.7.7.6

