Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2GQNx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:53:28 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41566 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab2GQNx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:53:26 -0400
Message-ID: <50056E34.8080505@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 21:52:52 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/9] KVM: MMU: track the refcount when unmap the page
References: <50056DB8.7080702@linux.vnet.ibm.com>
In-Reply-To: <50056DB8.7080702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071704-3568-0000-0000-00000225BA9F
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
index 28c8fbc..28b12e2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -556,6 +556,14 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 		return 0;

 	pfn = spte_to_pfn(old_spte);
+
+	/*
+	 * KVM does not hold the refcount of the page used by
+	 * kvm mmu, before reclaiming the page, we should
+	 * unmap it from mmu first.
+	 */
+	WARN_ON(!kvm_is_mmio_pfn(pfn) && !page_count(pfn_to_page(pfn)));
+
 	if (!shadow_accessed_mask || old_spte & shadow_accessed_mask)
 		kvm_set_pfn_accessed(pfn);
 	if (!shadow_dirty_mask || (old_spte & shadow_dirty_mask))
-- 
1.7.7.6

