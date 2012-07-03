Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab2GCGcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:32:25 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46965 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432Ab2GCGcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:32:24 -0400
Message-ID: <4FF291EE.7060408@linux.vnet.ibm.com>
Date: Tue, 03 Jul 2012 14:32:14 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/3] KVM: MMU: track the refcount when unmap the page
References: <4FF291A5.5090803@linux.vnet.ibm.com>
In-Reply-To: <4FF291A5.5090803@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12070220-6102-0000-0000-000001CEFC12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will trigger a WARN_ON if the page has been freed but it is still
used in mmu, it can help us to detect mm bug early

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cac3408..af7e076 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -527,6 +527,14 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 		return 0;

 	pfn = spte_to_pfn(old_spte);
+
+	/*
+	 * KVM does not hold the refcount of the page used by
+	 * kvm mmu, before reclaiming the page, we should
+	 * unmap it from mmu first.
+	 */
+	WARN_ON(!page_count(pfn_to_page(pfn)));
+
 	if (!shadow_accessed_mask || old_spte & shadow_accessed_mask)
 		kvm_set_pfn_accessed(pfn);
 	if (!shadow_dirty_mask || (old_spte & shadow_dirty_mask))
-- 
1.7.7.6

