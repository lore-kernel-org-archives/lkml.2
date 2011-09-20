Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab1ITNHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:07:46 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:59859 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1ITNHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:07:45 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, nhorman@redhat.com,
        jesse.brandeburg@intel.com, alexander.h.duyck@intel.com,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc: reserve iommu page 0
Date: Tue, 20 Sep 2011 10:07:24 -0300
Message-Id: <1316524044-5260-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 11092013-8936-0000-0000-00000480A5A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices have a dma-window that starts at the address 0. This allows
DMA addresses to be mapped to this address and returned to drivers as a
valid DMA address. Some drivers may not behave well in this case, since
the address 0 is considered an error or not allocated.

The solution to avoid this kind of error from happening is reserve the
page addressed as 0 so it cannot be allocated for a DMA mapping.

Ben Herrenschmidt deserves the credit for this patch. He pointed out the
solution and what code would do the job.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/kernel/iommu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 961bb03..53411bc 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -501,6 +501,9 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 	tbl->it_map = page_address(page);
 	memset(tbl->it_map, 0, sz);
 
+	if (tbl->it_offset == 0)
+		set_bit(0, tbl->it_map);
+		
 	tbl->it_hint = 0;
 	tbl->it_largehint = tbl->it_halfpoint;
 	spin_lock_init(&tbl->it_lock);
-- 
1.7.4.4

