Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2G2IM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 04:12:58 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54683 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2G2IML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 04:12:11 -0400
Message-ID: <5014F053.8020305@linux.vnet.ibm.com>
Date: Sun, 29 Jul 2012 16:12:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/9] KVM: iommu: fix releasing unmapped page
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072908-7014-0000-0000-000001A392ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two bugs:
- the 'error page' is forgot to be released
  [ it is unneeded after commit a2766325cf9f9, for backport, we
    still do kvm_release_pfn_clean for the error pfn ]

- guest pages are always released regardless of the unmapped page
  (e,g, caused by hwpoison)

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/iommu.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index c03f1fb..6a67bea 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -107,6 +107,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		 */
 		pfn = kvm_pin_pages(slot, gfn, page_size);
 		if (is_error_pfn(pfn)) {
+			kvm_release_pfn_clean(pfn);
 			gfn += 1;
 			continue;
 		}
@@ -300,6 +301,12 @@ static void kvm_iommu_put_pages(struct kvm *kvm,

 		/* Get physical address */
 		phys = iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
+
+		if (!phys) {
+			gfn++;
+			continue;
+		}
+
 		pfn  = phys >> PAGE_SHIFT;

 		/* Unmap address from IO address space */
-- 
1.7.7.6

