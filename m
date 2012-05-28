Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2E1HSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 03:18:53 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37235 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2E1HSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 03:18:52 -0400
Message-ID: <4FC316E3.6080607@linux.vnet.ibm.com>
Date: Mon, 28 May 2012 14:10:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: MMU: fix huge page adapted on non-PAE host
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052719-9264-0000-0000-000001987408
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The huge page size is 4M on non-PAE host, but 2M page size is used in
transparent_hugepage_adjust(), so the page we get after adjust the
mapping level is not the head page, the BUG_ON() will be triggered

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 72102e0..be3cea4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2595,8 +2595,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 			*gfnp = gfn;
 			kvm_release_pfn_clean(pfn);
 			pfn &= ~mask;
-			if (!get_page_unless_zero(pfn_to_page(pfn)))
-				BUG();
+			kvm_get_pfn(pfn);
 			*pfnp = pfn;
 		}
 	}
-- 
1.7.7.6

